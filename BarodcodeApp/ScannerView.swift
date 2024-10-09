//
//  ScannerView.swift
//  BarodcodeApp
//
//  Created by Sambhav Singh on 07/10/24.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode : String
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {
    }
    
    final class Coordinator: NSObject, ScannerVCDelegate {
        
        private let scannerView : ScannerView
        init(scannerView : ScannerView){
            self.scannerView = scannerView
        }
        func didFind(barcode: String) {
            print(barcode)
            scannerView.scannedCode = barcode
        }
        
        func didSurfaceError(error: CameraError) {
            print(error.rawValue)
        }
    }
}

#Preview {
    ScannerView(scannedCode: .constant("1234"))
}
