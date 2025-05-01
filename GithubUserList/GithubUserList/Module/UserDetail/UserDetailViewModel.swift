//
//  UserDetailViewModel.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 26/04/25.
//

import Foundation

class UserDetailViewModel: ObservableObject {
    
    let userDetailService: UserDetailProtocol
    var userDetail: GHUserDetailResponseModel? = nil
    
    @Published var isLoading: Bool = false
    
    init(userDetailService: UserDetailProtocol = UserDetailService()) {
        self.userDetailService = userDetailService
    }
    
    @MainActor
    func fetchUsersDetails(forUserId userId: Int) {
        debugPrint(#function)
        guard !isLoading else {
            debugPrint("please wait... for next api call")
            return
        }
        
        isLoading = true
        Task {
            do {
                userDetail = try await self.userDetailService.fetchUserDetail(withUserId: userId)
                isLoading = false
            } catch {
                print("API failed with error: \(error)")
                isLoading = false
            }
        }
    }
}
