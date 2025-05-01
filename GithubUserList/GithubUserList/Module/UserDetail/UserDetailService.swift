//
//  UserDetailService.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 26/04/25.
//

import Foundation

protocol UserDetailProtocol {
    func fetchUserDetail(withUserId id: Int) async throws -> GHUserDetailResponseModel
}

class UserDetailService: UserDetailProtocol {
    
    func fetchUserDetail(withUserId id: Int) async throws -> GHUserDetailResponseModel {
        try await APIManager.shared.request(APIEndPoint.getUserDetails(id: id))
    }
}
