//
//  SwiftUIView.swift
//  student-apartment-management-system-ios
//
//  Created by BetaCat on 2024/6/20.
//

import SwiftUI
import CoreNFC

struct MyApartmentView: View {
    @State private var nfcContent = ""
    @State private var isWriting = false
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 80 ,maximum: 300), spacing: nil, alignment: nil)//可以根据设定的最大大小和最小大小，在每行自动排列足够多的项目，在多平台适配中很有用
    ]
    
    var body: some View {
        ScrollView {
            Image("picture-gate-east")
                .resizable()
                .scaledToFill()
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                .shadow(radius: 10)
                .padding(10)
                .onTapGesture {
                    startNFCReading()
                }
                                
            ZStack {
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(Color("TextFieldColor"))
                    .shadow(radius: 2.5)
                    .frame(height: 50)
                    
                HStack() {
                    Image(systemName: "bell.and.waves.left.and.right")
                        .padding(.leading, 10)
                    Text("公告")
                    Spacer()
                }
            }
            .padding(10)
            .padding(.horizontal, 10)
            
            LazyVGrid(columns: columns,
                      alignment: .center,
                      spacing: 5) {
                Section(){
                    ButtonCell(image: "drop.fill", text: "水费")
                    ButtonCell(image: "bolt.fill", text: "电费")
                    ButtonCell(image: "door.right.hand.open", text: "门禁")
                    ButtonCell(image: "house.fill", text: "智能家居")
                }
            }
                      .padding(.horizontal, 15)
        }
    }
    
    
    private func startNFCReading() {
        let nfcSession = NFCNDEFReaderSession(
            delegate: NFCReaderDelegate(
                contentCallback: { content in
                    DispatchQueue.main.async {
                        self.nfcContent = content
                        self.isWriting = false
                    }
                }
            ),
            queue: nil,
            invalidateAfterFirstRead: false
        )
        nfcSession.begin()
    }

    private func startNFCWriting() {
        isWriting = true

        let vCardPayload = """
            BEGIN:VCARD
            FN:John Doe
            ORG:ABC Corporation
            TEL:+123456789
            EMAIL:john.doe@example.com
            END:VCARD
            """
        
        let nfcSession = NFCNDEFReaderSession(
            delegate: NFCWriterDelegate(
                content: vCardPayload
            ),
            queue: nil,
            invalidateAfterFirstRead: false
        )
        nfcSession.begin()
    }
}

#Preview {
    MyApartmentView()
}

struct ButtonCell: View {
    private var image: String
    private var text: String
    
    init(image: String, text: String) {
        self.image = image
        self.text = text
    }
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 15.0)
                    .foregroundStyle(Color.blue)
                    .frame(width: 80, height: 80)
                Image(systemName: image)
                    .foregroundStyle(Color.white)
                    .font(.title)
            }
            
            Text(text)
        }
    }
}
