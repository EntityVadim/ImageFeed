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

//extension URLSession {
//    func performRequest<T: Decodable>(
//        with request: URLRequest,
//        decodeType: T.Type,
//        completion: @escaping (Result<T, Error>) -> Void
//    ) {
//        let task = dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                guard let httpResponse = response as? HTTPURLResponse,
//                      httpResponse.statusCode == 200,
//                      let data = data else {
//                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
//                    completion(.failure(NSError(
//                        domain: "",
//                        code: statusCode,
//                        userInfo: [NSLocalizedDescriptionKey: "Ошибка сети или сервера с кодом \(statusCode)."])))
//                    return
//                }
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let decodedObject = try decoder.decode(decodeType, from: data)
//                    completion(.success(decodedObject))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//        }
//        task.resume()
//    }
//}
