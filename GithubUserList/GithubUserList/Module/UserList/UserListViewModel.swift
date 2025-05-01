//
//  UserListViewModel.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 22/04/25.
//

import SwiftUI
import Combine

class UserListViewModel: ObservableObject {
    
    let userService: UserListProtocol
    let networkCheckService: NetworkCheckServiceProtocol
    var pageNumber = 1
    var pageSize: Int = 10
    var isEndOfData: Bool = false
    @Published var isLoading: Bool = false
    @Published var query: String = ""
    @Published var isNetworkAvailable: Bool = true
    
    @Published var users: [GHUserModel] = []
    private var cancellables: Set<AnyCancellable> = []
    
    var dispatchWorkItem: DispatchWorkItem?
    
    
    init(userService: UserListProtocol = UserListService(),
        networkCheckService: NetworkCheckServiceProtocol = NetworkCheckService()) {
        self.userService = userService
        self.networkCheckService = networkCheckService
        self.startMonitorNetworkStatus()
    }
    
    deinit {
        debugPrint("deinit called for UserListViewModel")
        stopMonitorNetworkStatus()
    }

    @MainActor
    func fetchUsers() async throws {
        debugPrint(#function)
        
        guard networkCheckService.isNetworkAvailable() else {
            debugPrint("No internet connection")
            isNetworkAvailable = false
            return
        }
        
        guard !isLoading else {
            debugPrint("please wait... for next api call")
            return
        }
        
        isLoading = true
        
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
    
    @MainActor
    func fetchUserList(withResetData: Bool = true) {
        Task {
            if withResetData {
                pageNumber = 1
                self.users = []
            }
            
            do {
                try await self.fetchUsers()
            } catch {
                print("API failed with error: \(error)")
                isLoading = false
            }
            
        }
    }
    
    @MainActor
    func pullToRefresh() {
        self.fetchUserList(withResetData: true)
    }
    
    @MainActor
    func checkPagination(forUser user: GHUserModel) {
        guard isEndOfData == false else {
            return
        }
        debugPrint(#function)
        if users.last?.id == user.id {
            self.fetchUserList(withResetData: false)
        }
    }
    
    @MainActor
    func searchUserName() {
        guard networkCheckService.isNetworkAvailable() else {
            debugPrint("No internet connection")
            return
        }
        dispatchWorkItem?.cancel()
        dispatchWorkItem = DispatchWorkItem {
            self.fetchUserList(withResetData: true)
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: dispatchWorkItem!)
    }
}

extension UserListViewModel {
    
    func startMonitorNetworkStatus() {
        NetworkReachabilityManager.shared.startMonitoring()
        NetworkReachabilityManager.shared.networkStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] networkStatusModel in
                self?.isNetworkAvailable = networkStatusModel.isReachable
                debugPrint("[Network] - change network status - isReachable: \(networkStatusModel.isReachable) - isExpensive: \(networkStatusModel.isExpensive)")
            }
            .store(in: &cancellables)
    }
    
    func stopMonitorNetworkStatus() {
        NetworkReachabilityManager.shared.stopMonitoring()
    }
}
