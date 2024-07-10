//
//  LoginView.swift
//  student-apartment-management-system-ios
//
//  Created by BetaCat on 2024/6/23.
//

import SwiftUI

struct LoginView: View {
    @State var userName:String = ""
    @State var password:String = ""
    
    @Environment(\.presentationMode) var presentationMode //声明一个显示模式
    
    @ObservedObject private var viewModel = AccountController()
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("掌上广师大")
                .font(.title3)
            
            VStack {
                TextField(text: $userName) {
                    Text("用户名")
                }
                
                Spacer()
                Divider()
                    .padding(.horizontal, -15)
                Spacer()
                
                SecureField(text: $password) {
                    Text("密码")
                }
            }

            .padding(15)
            .frame(height: 100)
            .background(Color("TextFieldColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if !viewModel.result.msg.isEmpty {
                Text("\(viewModel.result.msg)")
                    .foregroundStyle(.red)
            }
            
            Button {
                viewModel.login(phone: userName, password: password) { result in
                    if result.code == 200 {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
            } label: {
                Text("登录")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(false)
            Spacer()
            Spacer()
            
        }
        .padding(.horizontal, 15)
    }
}

#Preview {
    LoginView()
}
