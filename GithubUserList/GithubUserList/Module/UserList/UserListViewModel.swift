//
//  UserListViewModel.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 22/04/25.
//

import SwiftUI

class UserListViewModel: ObservableObject {
    
    let userService: UserListProtocol
    var pageNumber = 1
    var pageSize: Int = 10
    var isEndOfData: Bool = false
    @Published var isLoading: Bool = false
    @Published var query: String = ""
    
    @Published var users: [GHUser] = []
    
    init(userService: UserListProtocol = UserListService()) {
        self.userService = userService
    }

    @MainActor
    func fetchUsers() {
        debugPrint(#function)
        guard !isLoading else {
            debugPrint("please wait... for next api call")
            return
        }
        
        isLoading = true
        Task {
            do {
                let userListResponse = try await self.userService.fetchUsers(forQuery: query, pageNumber: pageNumber, pageSize: pageSize)
                let userList = userListResponse.userList
                debugPrint("userList id: \( userList.map { "\($0.id)" })")
                isLoading = false
                self.users += userList
                self.isEndOfData = (self.users.count < (self.pageNumber * self.pageSize))
                debugPrint("isEndOfData: \(self.isEndOfData)")
                self.pageNumber += 1
                debugPrint("total users count: \(self.users.count) - pageNo: \(pageNumber)")
            } catch {
                print("API failed with error: \(error)")
                isLoading = false
            }
        }
    }
    
    
    @MainActor
    func pullToRefresh() {
        debugPrint(#function)
        pageNumber = 1
        Task {
            self.users = []
            fetchUsers()
        }
    }
    
    @MainActor
    func checkPagination(forUser user: GHUser) {
        guard isEndOfData == false else {
            return
        }
        debugPrint(#function)
        if users.last?.id == user.id {
            guard !isLoading else {
                debugPrint("please wait... api call is ongoing")
                return
            }
            debugPrint("fetching more users...")
            Task {
                debugPrint("fetching more users...")
                fetchUsers()
            }
        }
    }
    
    @MainActor
    func searchUserName() {
        debugPrint(#function)
        guard !isLoading else {
            debugPrint("please wait... for next api call")
            return
        }
        self.pageNumber = 1
        Task {
            self.users = []
            fetchUsers()
        }
    }
}
