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
import FirebaseFirestore

struct FriendsView: View {
    
    @ObservedObject private var viewModel = DataManager()
    @State private var currentUser = Auth.auth().currentUser
    
    private var db = Firestore.firestore()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State private var isShowingScanner = false
    
    @State private var searchText = ""
    
    @State var friendAdded = false
    
    @State private var confirmDelete = false
    
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
                if viewModel.friendsDictionary.isEmpty {
                    List {
                        Text("No friends to display.")
                    }
                } else {
                    List {
                        ForEach(viewModel.friendsDictionary.keys.sorted(), id: \.self) { friend in
                            Button {
                                confirmDelete = true
                            } label: {
                                Text(viewModel.friendsDictionary[friend] ?? "Unknown")
                            }.alert("Friend Removal", isPresented: $confirmDelete) {
                                Button("Yes, remove") {
                                    removeFriend(id: friend)
                                }
                                Button("No", role: .cancel) { }
                            } message: {
                                Text("Are you sure you wish to remove this friend?")
                            }
                        }
                    }
                }
            }
        }.onAppear() {
            self.viewModel.fetchFriends()
            
            print(viewModel.friendsDictionary)
            
        }.sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Evp4K7uPTTfctcpNITdzVinSUf73", completion: handleScan)
        }.alert(isPresented: $friendAdded) { () -> Alert in
            Alert(title: Text("New Friend"), message: Text("Friend successfully added!"), dismissButton: .cancel())
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false

        switch result {
        case .success(let result):
            let details = result.string
//            guard details.count == 1 else { return }
            
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
        print(id)
        
        let pattern = #"\bOptional\(\"([^\"]*)\"\)"#

        let friendId = id.replacingOccurrences(of: pattern, with: "$1", options: .regularExpression)
        
        if friendId != currentUser?.uid {
            let ref = db.collection("users").document(friendId)
            
            ref.updateData([
                "friends": FieldValue.arrayUnion([currentUser?.uid ?? "0"])
            ])
            
            let userRef = db.collection("users").document(currentUser?.uid ?? "0")
            
            userRef.updateData([
                "friends": FieldValue.arrayUnion([friendId])
            ])
            
            friendAdded = true
            
            self.viewModel.fetchFriends()
        }
    }
    
    func removeFriend(id: String) {
        if id != currentUser?.uid {
            let ref = db.collection("users").document(id)
            
            ref.updateData([
                "friends": FieldValue.arrayRemove([currentUser?.uid ?? "0"])
            ])
            
            let userRef = db.collection("users").document(currentUser?.uid ?? "0")
            
            userRef.updateData([
                "friends": FieldValue.arrayRemove([id])
            ])
            
            self.viewModel.fetchFriends()
        }
    }
    
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
