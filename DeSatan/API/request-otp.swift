//
//  OTP.swift
//  DeSatan
//
//  Created by Heorhii Malyhin on 25/10/2026.
//

import Foundation

import Foundation


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

public struct PhoneNumber: RawRepresentable, Codable, Equatable, Hashable, Comparable, Sendable,
    CustomStringConvertible
{
    public var rawValue: String

    public var urlEncoded: String {
        self.rawValue.replacingOccurrences(of: "+", with: "%2B")
    }

    public init?(percentEncoded: String) {
        guard let decoded = percentEncoded.removingPercentEncoding else {
            return nil
        }
        self.init(rawValue: decoded)
    }

    public init?(rawValue: RawValue) {
        let rgReplacingPattern = "[^0-9\\+]"
        let rgPhoneMatchingPattern = "\\+\\d{12,15}"
        var regex = try! NSRegularExpression(pattern: rgReplacingPattern, options: .caseInsensitive)
        let numberRange = NSMakeRange(0, rawValue.count)
        let rawNumber = regex.stringByReplacingMatches(
            in: rawValue, range: numberRange, withTemplate: "")
        regex = try! NSRegularExpression(pattern: rgPhoneMatchingPattern, options: .caseInsensitive)
        let rawNumberRange = NSMakeRange(0, rawNumber.count)
        let a = regex.firstMatch(in: rawNumber, range: rawNumberRange)
        if a != nil {
            self.rawValue = rawValue
        } else {
            return nil
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let phone = PhoneNumber(rawValue: try container.decode(RawValue.self)) else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "Invalid phone number")
        }
        self = phone
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

    public var description: String {
        self.rawValue.description
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

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

extension API {
    func requestOTP(forPhoneNumber phone: String) async throws -> OTPResponse {
        var request = URLRequest(url: endpoint.appending(component: "otp"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(OTPRequest(phone: phone))
        let (body, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServerRequestError.nonHTTPResponse(got: type(of: response))
        }

        API.logger.info("POST /otp response: \(httpResponse.statusCode, privacy: .public)")
        guard httpResponse.statusCode != 400 else {
            let errorResponse = try JSONDecoder().decode(
                ErrorResponse<OTPResponse.ErrorKind>.self, from: body)
            return .invalidPhoneNumber(reason: errorResponse.reason)
        }
        guard httpResponse.statusCode == 200 else {
            let error = ServerRequestError(fromResponse: httpResponse, data: body)

            API.logger.error("Server error occurred for POST /login \(error, privacy: .public)")
            throw error
        }

        let decoded = try JSONDecoder().decode(OTPResponse.Success.self, from: body)
        return .success(decoded)
    }
}

