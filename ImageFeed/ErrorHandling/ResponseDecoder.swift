//
//  ResponseDecoder.swift
//  ImageFeed
//
//  Created by Вадим on 11.07.2024.
//

import Foundation

class ResponseDecoder {
    static let shared = ResponseDecoder()
    
    private init() {}
    
    func decode<T: Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        decodingType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let error = error {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        guard let httpResponse = response as? HTTPURLResponse,
              let data = data else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.unknownError))
            }
            return
        }
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedObject = try decoder.decode(decodingType, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        default:
            let error = NetworkErrorHandler.handleErrorResponse(statusCode: httpResponse.statusCode)
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
