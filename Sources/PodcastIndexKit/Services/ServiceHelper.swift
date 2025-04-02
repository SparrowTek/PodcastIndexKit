import Foundation

func append(_ any: Any?, toParameters parameters: inout Parameters, withKey key: String) {
    guard let any else { return }
    updateParamters(&parameters, with: (key, "\(any)"))
}

func appendNil(toParameters paramters: inout Parameters, withKey key: String, forBool bool: Bool) {
    guard bool else { return }
    updateParamters(&paramters, with: (key, nil))
}

fileprivate func updateParamters(_ paramters: inout Parameters, with dataToAppend: (String, String?)) {
    paramters.append(URLQueryItem(name: dataToAppend.0, value: dataToAppend.1))
}
