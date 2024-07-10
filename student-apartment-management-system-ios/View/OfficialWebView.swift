//
//  officialWebView.swift
//  student-apartment-management-system-ios
//
//  Created by BetaCat on 2024/6/21.
//

import SwiftUI
import WebKit

struct OfficialWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let url = URL(string: "https://www.gpnu.edu.cn")!
        uiView.load(URLRequest(url: url))
    }
}

#Preview {
    OfficialWebView()
}
