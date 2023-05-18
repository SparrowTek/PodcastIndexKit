func append(_ any: Any?, toQuery query: inout [(String, String?)]?, withKey key: String) {
	guard let any else { return }
	updateQuery(&query, with: (key, "\(any)"))
}

func append(_ string: String?, toQuery query: inout [(String, String?)]?, withKey key: String) {
	guard let string else { return }
	updateQuery(&query, with: (key, string))
}

func appendNil(toQuery query: inout [(String, String?)]?, withKey key: String, forBool bool: Bool) {
	guard bool else { return }
	updateQuery(&query, with: (key, nil))
}

fileprivate func updateQuery(_ query: inout [(String, String?)]?, with dataToAppend: (String, String?)) {
	if query == nil {
		query = [dataToAppend]
	} else {
		query?.append(dataToAppend)	
	}	
}