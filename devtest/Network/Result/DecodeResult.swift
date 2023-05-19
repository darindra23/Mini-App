//
//  DecodeResult.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

extension Result where Success == Data, Failure == NetworkError {
    public func decodeResult<D: Decodable>(_ type: D.Type) -> Result<D, NetworkError> {
        switch self {
        case let .success(data):
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                return .success(decodedData)
            } catch {
                if let decodingError = error as? DecodingError {
                    let description: String

                    switch decodingError {
                    case let .dataCorrupted(context),
                         let .keyNotFound(_, context),
                         let .typeMismatch(_, context),
                         let .valueNotFound(_, context):
                        description = context.errorLog

                    @unknown default:
                        description = String(describing: decodingError)
                    }

                    return .failure(
                        .decodeFailed(
                            modelName: String(describing: type),
                            description: description
                        )
                    )

                } else {
                    return .failure(.requestFailed)
                }
            }
        case let .failure(networkError):
            return .failure(networkError)
        }
    }
}
