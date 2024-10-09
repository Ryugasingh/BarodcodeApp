//
//  ContentView.swift
//  BarodcodeApp
//
//  Created by Sambhav Singh on 01/10/24.
//

import SwiftUI
struct BarCode: View {
    @State private var scannedCode = ""
    var body: some View {
        NavigationView(){
            VStack{
                ScannerView(scannedCode: $scannedCode)
                    .frame(width : .infinity , height: 300)
                Spacer().frame(height : 60)
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                Text(scannedCode.isEmpty ? "Not yet Scanned" : scannedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(scannedCode.isEmpty ? .red : .green)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
        }
    }
}

#Preview {
    BarCode()
}
