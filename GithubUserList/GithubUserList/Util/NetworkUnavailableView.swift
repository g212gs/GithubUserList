//
//  NetworkUnavailableView.swift
//  GithubUserList
//
//  Created by Gaurang Lathiya on 01/05/25.
//

import SwiftUI

struct NetworkUnavailableView: View {
    var body: some View {
        ContentUnavailableView("No Internet Connection",
                               systemImage: "wifi.slash",
                               description: Text("Your iPhone is not connected to the internet. To connect, turn off Airplane Mode or connect to a Wi-Fi network.").font(.footnote))
    }
}

#Preview {
    NetworkUnavailableView()
}
