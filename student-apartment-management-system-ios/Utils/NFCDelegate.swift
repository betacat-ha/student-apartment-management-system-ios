//
//  NFC.swift
//  student-apartment-management-system-ios
//
//  Created by BetaCat on 2024/6/22.
//

import CoreNFC

class NFCReaderDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    private var contentCallback: ((String) -> Void)?

    init(contentCallback: @escaping (String) -> Void) {
        self.contentCallback = contentCallback
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let payloadString = String(data: record.payload, encoding: .utf8) {
                    contentCallback?(payloadString)
                }
            }
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error reading NFC: \(error.localizedDescription)")
    }
}

class NFCWriterDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    private let content: String

    init(content: String) {
        self.content = content
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Writing is not implemented for reader, but this method is required
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error writing NFC: \(error.localizedDescription)")
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        // Implement writing functionality here if needed
        print("Writing NFC...")
    }
}
