//
//  FriendsView.swift
//  Flashback
//
//  Created by Connie Waffles on 04/08/2024.
//

import SwiftUI
import Firebase
import CoreImage.CIFilterBuiltins
import CodeScanner

struct FriendsView: View {
    
    @ObservedObject private var viewModel = DataManager()
    @State private var currentUser = Auth.auth().currentUser
    
    private var db = Firestore.firestore()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State private var isShowingScanner = false
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Get your friends to scan this QR code in the app to add you!")
                
                Image(uiImage: generateQRCode(from: "\(currentUser?.uid)"))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }.navigationTitle("Friends")
                .padding()
            .toolbar {
                Button("Scan", systemImage: "qrcode.viewfinder") {
                    isShowingScanner = true
                }
                
            }
            
            Section {
                List {
                    ForEach(viewModel.friendsNames, id: \.self) { friend in
                        Text(friend)
                    }
                }
            }
            
        }.onAppear() {
            self.viewModel.fetchUsers()
            self.viewModel.fetchFriends()
            
        }.sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Evp4K7uPTTfctcpNITdzVinSUf73", completion: handleScan)
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false

        switch result {
        case .success(let result):
            let details = result.string
//            guard details.count == 1 else { return }

            print(details)
            addFriend(id: details)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func addFriend(id: String) {
        if id != currentUser?.uid {
            let ref = db.collection("users").document(id)
            
            ref.updateData([
                "friends": FieldValue.arrayUnion([currentUser?.uid ?? "0"])
            ])
            
            let userRef = db.collection("users").document(currentUser?.uid ?? "0")
            
            userRef.updateData([
                "friends": FieldValue.arrayUnion([id])
            ])
        }
    }
    
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
