import AnyCodable
import Foundation

public class MarvelJSONDecoder: JSONDecoder {
    let encoder: JSONEncoder

    public override init() {
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        super.init()
        dateDecodingStrategy = .iso8601
    }

    public func decodeAll<T>(_ type: [T].Type, from data: Data) throws -> [T] where T : Decodable {
        let output = try decode([String: AnyDecodable].self, from: data)
        let outputData = output["data"]?.value as? [String: Any]
        let outputResults = try encoder.encode(AnyEncodable(outputData?["results"]))
        return try decode([T].self, from: outputResults)
    }

    public func decodeAll<T>(_ type: [T].Type, from dict: [AnyHashable: Any]) throws -> [T] where T : Decodable {
        guard let output = dict as? [String: Any] else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode JSON. The keys are expected to be string"))
        }
        let outputData = output["data"] as? [String: Any]
        let outputResults = try encoder.encode(AnyEncodable(outputData?["results"]))
        return try decode([T].self, from: outputResults)
    }
}
