import Foundation

struct JSONParameterEncoder: ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            encode(urlRequest: &urlRequest, with: jsonAsData)
        } catch {
            throw NetworkError.encodingFailed
        }
    }
    
    func encode(urlRequest: inout URLRequest, with encodable: Encodable) throws {
        do {
            let data = try encodable.toJSONData()
            encode(urlRequest: &urlRequest, with: data)
        } catch {
            throw NetworkError.encodingFailed
        }
    }
    
    func encode(urlRequest: inout URLRequest, with data: Data) {
        urlRequest.httpBody = data
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
