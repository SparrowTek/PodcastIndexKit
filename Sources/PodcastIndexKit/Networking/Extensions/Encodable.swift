import Foundation

extension Encodable {
    func toJSONData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}
