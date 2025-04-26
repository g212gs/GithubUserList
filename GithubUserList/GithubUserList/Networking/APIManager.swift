//
//  APIManager.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 22/04/25.
//

import Foundation

protocol APIManagerProtocol {
    func request<T: Decodable>(_ apiEndPoint: APIEndPointProtocol) async throws -> T
}

final class APIManager: APIManagerProtocol {
    
    static let shared = APIManager()
    
    private init() { }
    
    func request<T: Decodable>(_ apiEndPoint: APIEndPointProtocol) async throws -> T {
        
        guard let url = apiEndPoint.url else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiEndPoint.httpMethod
        urlRequest.allHTTPHeaderFields = apiEndPoint.headers
        
        debugPrint("[API] - url: \(url)")
        debugPrint("[API] - httpMethod: \(apiEndPoint.httpMethod)")
        debugPrint("[API] - headers: \(apiEndPoint.headers)")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
