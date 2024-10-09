//
//  ScanView.swift
//  Flashback
//
//  Created by Connie Waffles on 09/10/2024.
//

import SwiftUI
import CodeScanner

struct ScanView: View {
    @State private var isShowingScanner = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false

        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            print(details)

        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ScanView()
}
