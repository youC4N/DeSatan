import Vapor

func routes(_ app: Application) throws {
    app.post("otp", use: requestOTPRoute)
}
