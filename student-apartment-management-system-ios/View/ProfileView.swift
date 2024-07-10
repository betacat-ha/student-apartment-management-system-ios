//
//  ProfileView.swift
//  student-apartment-management-system-ios
//
//  Created by BetaCat on 2024/6/22.
//

import SwiftUI

struct ProfileView: View {
    @State var nfcSwitch:Bool = true
    @State var showLoginView:Bool = false
    
    @AppStorage(AppStoreKeys.IS_LOGIN) private var isLogin: Bool?
    
    @ObservedObject var viewModel: AccountController = AccountController.singleton
    
    var body: some View {
        profileView
    }
    
    var profileView: some View {
        NavigationView {
            List {
                Section {
                    
                    if isLogin ?? false {
                        HStack {
                            Image("avator-default")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .frame(width: 100,height: 100)
                            VStack(alignment: .leading,spacing: 5) {
                                Text(viewModel.profileDetail.name)
                                    .font(.title3)
                                Text(viewModel.profileDetail.id)
                            }
                        }.onAppear {
                            viewModel.fecthProfile()
                        }
                    } else {
                        Button {
                            showLoginView = true
                        } label: {
                            Text("登录")
                        }
                        .sheet(isPresented: $showLoginView, content: {
                            LoginView()
                        })
                    }
                }
                
                generalSettingView
                
                if isLogin ?? false {
                    Section {
                        Toggle("手机NFC", isOn: $nfcSwitch)
                        
                        NavigationLink {
                            MyOtherScreen()
                        } label: {
                            Text("挂失与解挂")
                        }
                        
                        NavigationLink {
                            MyOtherScreen()
                        } label: {
                            Text("修改密码")
                        }
                    } header: {
                        HStack {
                            Image(systemName: "creditcard")
                            Text("校园卡")
                        }
                        .font(.headline)
                    }
                    
                    Section {
                        Button {
                            isLogin = false
                        } label: {
                            Text("退出登录")
                        }
                    }
                }
            }
        }
    }
    
    var generalSettingView: some View {
        Section {
            NavigationLink {
                MyOtherScreen()
            } label: {
                Text("通知")
            }
            
            NavigationLink {
                MyOtherScreen()
            } label: {
                Text("多语言")
            }
            
        } header: {
            HStack {
                Image(systemName: "gear")
                Text("通用")
            }
            .font(.headline)
        }
    }
    
    struct MyOtherScreen: View {
        
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            ZStack {
                Color.orange
                    .ignoresSafeArea()
                    .navigationTitle("Green Screen!")
                    .navigationBarHidden(true)
                
                VStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                    }
                    
                    NavigationLink("Click here") {
                        Text("Third screen!")
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
