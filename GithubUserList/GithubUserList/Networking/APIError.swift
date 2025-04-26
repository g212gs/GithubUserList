//
//  APIError.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 22/04/25.
//

enum APIError: Error {
    case invalidURL
    case decodingFailed
    case invalidResponse(statusCode: Int)
    case noData
    case unknown
}
