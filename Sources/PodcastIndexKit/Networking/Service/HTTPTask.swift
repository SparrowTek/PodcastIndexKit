enum HTTPTask: Sendable {
    case request
    
    case requestParameters(encoding: ParameterEncoding)
    
    // case download, upload...etc
}
