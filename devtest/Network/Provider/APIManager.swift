//
//  APIManager.swift
//  devtest
//
//  Created by darindra.khadifa on 17/05/23.
//

import Foundation

public class APIManager {
    public static let shared = APIManager()
    private let baseURL = "https://dummy.restapiexample.com/api/v1"
    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }

    public func request(
        _ target: TargetType,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL + target.path) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.httpBody = encode(target.task)

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error.localizedDescription)")
                completion(.failure(.requestFailed))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }

            guard (200 ... 299).contains(httpResponse.statusCode) else {
                completion(.failure(.underMaintenance))
                return
            }

            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }

    private func encode(_ task: Task) -> Data? {
        if case let .requestData(parameters) = task {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters)
                return data
            } catch {
                return nil
            }
        }
        return nil
    }
}
