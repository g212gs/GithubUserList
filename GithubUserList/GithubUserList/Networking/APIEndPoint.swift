//
//  APIEndPoint.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 23/04/25.
//

import Foundation

protocol APIEndPointProtocol {
    var url: URL? { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
}

enum APIEndPoint: APIEndPointProtocol {
    case getUsers(query: String? = nil, pageNumber: Int, pageSize: Int)
    case getUserDetails(id: Int)
}

extension APIEndPoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        
        switch self {
        case .getUsers(let query, let pageNumber, let pageSize):
            components.path = "/search/users"
            let queryValue = (query ?? "") + "+type:user"
            components.queryItems = [
                URLQueryItem(name: "q", value: queryValue),
                URLQueryItem(name: "page", value: "\(pageNumber)"),
                URLQueryItem(name: "per_page", value: "\(pageSize)")
            ]
            return components.url
        case .getUserDetails(let id):
            components.path = "/user/\(id)"
            return components.url
        }
    }
    
    var httpMethod: String {
        switch self {
        case .getUsers:
            return "GET"
        case .getUserDetails:
            return "GET"
        }
    }
    
    var headers: [String: String] {
        return [
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
    }
}
