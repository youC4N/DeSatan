//
//  RequestOTP.swift
//  Server
//
//  Created by Heorhii Malyhin on 04/11/2026.
//
public import Vapor
import Algorithms
import NIOHTTP1



public struct ErrorResponse<Code>: Codable
where Code: RawRepresentable, Code.RawValue == String, Code: Codable {
    /// Always `true` to indicate this is a non-typical JSON response.
    public let error: Bool = true

    /// Human readable, and end-user presentable description of the error
    public var reason: String

    /// Developer-facing, machine identifiable identifier that specifies concrete kind of error
    public var code: Code

    public init(_ code: Code, reason: String) {
        self.code = code
        self.reason = reason
    }

    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<ErrorResponse<Code>.CodingKeys> =
            try decoder.container(keyedBy: ErrorResponse<Code>.CodingKeys.self)
        self.reason = try container.decode(
            String.self, forKey: ErrorResponse<Code>.CodingKeys.reason)
        self.code = try container.decode(Code.self, forKey: ErrorResponse<Code>.CodingKeys.code)
    }
}
extension ErrorResponse: Sendable where Code: Sendable {}

public struct OTPRequest: Codable {
    public let phone: String

    public init(phone: String) {
        self.phone = phone
    }
}

public enum OTPResponse {
    case invalidPhoneNumber(
        reason: String = "Provided phone number doesn't follow the expected format.")
    case success(Success)

    public enum ErrorKind: String, RawRepresentable, Codable {
        case invalidPhoneNumber
    }

    public struct Success: Codable, Hashable {
        public var otpToken: OTPToken

        public init(otpToken: OTPToken) {
            self.otpToken = otpToken
        }
    }
}

public struct OTPToken: Codable, Equatable, Hashable, Sendable {
    public typealias StringLiteralType = String
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}




extension OTPResponse.Success: Content {}
extension ErrorResponse: Content {}
extension OTPResponse: AsyncResponseEncodable {
    public func encodeResponse(for request: Request) async throws -> Response {
        switch self {
        case .invalidPhoneNumber(let reason):
            try await ErrorResponse(Self.ErrorKind.invalidPhoneNumber, reason: reason).encodeResponse(status: HTTPResponseStatus.badRequest, for: request)
        case .success(let success):
            try await success.encodeResponse(for: request)
        }
    }
}

@Sendable
func requestOTPRoute(req: Request) async throws -> OTPResponse {
    let otpReq = try req.content.decode(OTPRequest.self)
    let code = generateOTPCode()
    req.logger.info("Here is your code = \(code)", metadata: ["phoneNumber": "\(otpReq.phone)"])
    let token = OTPToken(rawValue: nanoid())
//    guard let normalisedNumber = PhoneNumber(rawValue: otpReq.phone) else {
//        return .invalidPhoneNumber()
//    }
//    try await saveOTP(code: code, token: token, phone: normalisedNumber, in: req.db)
    return .success(.init(otpToken: token))
}

private let otpAlphabet = "0123456789"

private func generateOTPCode(size: Int = 6) -> String {
    String(otpAlphabet.randomSample(count: size))
}

//private func saveOTP(code: String, token: OTPToken, phone: PhoneNumber, in db: SharedConnection)
//    async throws
//{
//    try await withContext("Inserting otp password") {
//        try await db.prepare(
//            """
//            insert into one_time_passwords (phone, code, token, expires_at)
//            values (\(phone), \(code), \(token), datetime('now', 'utc', 'subsecond', '+5 minutes'));
//            """
//        ).run()
//    }
//}

