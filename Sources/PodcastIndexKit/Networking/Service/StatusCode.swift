import Foundation

public enum StatusCode: Int, Sendable {
    // 1xx
    case continueCode = 100
    case switchingProtocols = 101
    case processing = 102
    case earlyHints = 103
    
    // 2xx
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case mutliStatus = 207
    case alreadyReported = 208
    case IMUsed = 226
    
    // 3xx
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOthers = 303
    case notModified = 304
    case useProxy = 305
    case switchProxy = 306
    case temporaryRedirect = 307
    case permanentRedirect = 308
    
    // 4xx
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case uriTooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case imATeapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case tooEarly = 425
    case upgradeRequire = 426
    case preconditionRequire = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case unavailableForLegalResons = 451
    
    // 5xx
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegatiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511
}
