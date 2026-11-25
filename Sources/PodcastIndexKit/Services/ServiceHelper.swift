import Foundation

/// Adds `any` as the value of `key`, unless it is `nil`.
///
/// A date goes out as a Unix timestamp in whole seconds, which is how Podcast
/// Index takes every moment in time (`since`, `before`). Its description
/// ("2026-11-24 20:00:00 +0000") is not something the API reads.
func append(_ any: Any?, toParameters parameters: inout Parameters, withKey key: String) {
    guard let any else { return }
    if let date = any as? Date {
        updateParamters(&parameters, with: (key, String(Int(date.timeIntervalSince1970))))
    } else {
        updateParamters(&parameters, with: (key, "\(any)"))
    }
}

func appendNil(toParameters paramters: inout Parameters, withKey key: String, forBool bool: Bool) {
    guard bool else { return }
    updateParamters(&paramters, with: (key, nil))
}

fileprivate func updateParamters(_ paramters: inout Parameters, with dataToAppend: (String, String?)) {
    paramters.append(URLQueryItem(name: dataToAppend.0, value: dataToAppend.1))
}
