//
//  ContentView.swift
//  student-apartment-management-system-ios
//
//  Created by BetaCat on 2024/6/20.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab: Int = 1
    var body: some View {
        TabView(selection: $selectedTab) {
            OfficialWebView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("主页")
                }
                .tag(0)
            
            MyApartmentView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("我的公寓")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("个人")
                }
                .tag(2)
        }

    }
}

#Preview {
    ContentView()
}
