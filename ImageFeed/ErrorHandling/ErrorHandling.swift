//
//  ErrorHandling.swift
//  ImageFeed
//
//  Created by Вадим on 18.06.2024.
//

import Foundation

// MARK: - NetworkErrorProtocol

protocol NetworkErrorProtocol {
    static func errorMessage(from error: Error) -> String
}

// MARK: - NetworkError

enum NetworkError: Error {
    case invalidURL
    case invalidRequest
    case authorizationError
    case forbidden
    case notFound
    case emptyData
    case serverError
    case invalidURLComponents
    case unknownError
}

// MARK: - NetworkErrorHandler

struct NetworkErrorHandler: NetworkErrorProtocol {
    
    static func errorMessage(from error: Error) -> String {
        var errorMessage = "Произошла ошибка при загрузке данных"
        
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidRequest:
                errorMessage = "Неверный запрос: возможно, отсутствует необходимый параметр."
            case .authorizationError:
                errorMessage = "Ошибка авторизации: неверный токен доступа."
            case .forbidden:
                errorMessage = "Доступ запрещен: отсутствуют разрешения для выполнения запроса."
            case .notFound:
                errorMessage = "Ресурс не найден."
            case .serverError:
                errorMessage = "Ошибка на сервере."
            case .invalidURLComponents:
                errorMessage = "Неверные компоненты URL."
            case .unknownError:
                errorMessage = "Неизвестная ошибка."
            case .emptyData:
                errorMessage = "Не удалось получить данные."
            case .invalidURL:
                errorMessage = "Неверный URL профиля."
            }
        }
        return errorMessage
    }
    
    static func handleInvalidURLComponents() -> NetworkError {
        return .invalidURLComponents
    }
    
    static func handleErrorResponse(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400:
            return .invalidRequest
        case 401:
            return .authorizationError
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500, 503:
            return .serverError
        default:
            return .unknownError
        }
    }
}
