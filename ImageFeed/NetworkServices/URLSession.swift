//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Вадим on 18.06.2024.
//

import Foundation

// MARK: - URLSession

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        with type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.unknownError))
                    }
                    return
                }
                if httpResponse.statusCode != 200 {
                    let error = NetworkErrorHandler.handleErrorResponse(statusCode: httpResponse.statusCode)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.unknownError))
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedObject = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedObject))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
            return task
        }
}
