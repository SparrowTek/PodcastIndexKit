enum HTTPTask {
    case request
    
    case requestParameters(encoding: ParameterEncoding)
    
    // case download, upload...etc
}
