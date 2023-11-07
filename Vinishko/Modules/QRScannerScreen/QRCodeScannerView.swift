//
//  QRCodeScannerView.swift
//  Vinishko
//
//  Created by mttm on 07.11.2023.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: View {
    var body: some View {
        // Create a QR code scanner view
        QRCodeScanner()
    }
}

struct QRCodeScanner: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<QRCodeScanner>) -> UIViewController {
        // Create a QR code scanner
        let scannerViewController = QRCodeScannerViewController()
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<QRCodeScanner>) {
        // Update the view controller
    }
}

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the capture session
        captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            print("Error obtaining camera input: \(error)")
            return
        }
        
        // Initialize the video preview layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // Set up the metadata output
        let captureMetadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(captureMetadataOutput) {
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Could not add metadata output")
            return
        }
        
        // Add video preview layer to the view's layer
        videoPreviewLayer.frame = view.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer)
        
        // Start the capture session
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject, metadataObj.type == .qr {
            if let stringValue = metadataObj.stringValue {
                DispatchQueue.main.async { [weak self] in
                    let alert = UIAlertController(title: "Добавить?", message: stringValue, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
                        self?.captureSession.startRunning()
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Да!", style: .default, handler: { _ in
                        // TODO: Handle the confirmation action
                        print(stringValue)
                        self?.dismiss(animated: true, completion: nil)
                    }))
                    
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            captureSession.startRunning()
        }
    }

}
