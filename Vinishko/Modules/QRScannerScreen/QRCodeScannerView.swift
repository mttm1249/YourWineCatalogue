//
//  QRCodeScannerView.swift
//  Vinishko
//
//  Created by mttm on 07.11.2023.
//

import SwiftUI
import AVFoundation

protocol UpdateFromQR: AnyObject {
    func updateBottleInfo(string: String)
}

struct QRCodeScannerView: View {
    @ObservedObject var viewModel: NewBottleViewModel
    
    var body: some View {
        QRCodeScanner(viewModel: viewModel)
    }
}

struct QRCodeScanner: UIViewControllerRepresentable {
    @ObservedObject var viewModel: NewBottleViewModel
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: viewModel)
    }
    
    func makeUIViewController(context: Context) -> QRCodeScannerViewController {
        let scannerViewController = QRCodeScannerViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: QRCodeScannerViewController, context: Context) {}
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate, UpdateFromQR {
        var viewModel: NewBottleViewModel
        
        init(viewModel: NewBottleViewModel) {
            self.viewModel = viewModel
        }
        
        func updateBottleInfo(string: String) {
            if let result = try? JSONDecoder().decode(QRModel.self, from: Data(string.utf8)) {
                DispatchQueue.main.async {
                    
                    //Проверяем можно ли делиться изображением
                    let userDefaults = UserDefaults.standard
                    if userDefaults.bool(forKey: UserDefaultsKey.photoShare.rawValue) {
                        // Начало загрузки изображения
                        self.viewModel.isImageLoading = true
                        
                        _ = NetworkService.shared.downloadImage(url: result.imageURL ?? "",
                                                                onProgress: { progress in
                            self.viewModel.downloadProgress = progress
                            
                        }, onCompletion: { result in
                            switch result {
                            case .success(let image):
                                self.viewModel.image = image
                            case .failure(let error):
                                self.viewModel.alertMessage = "\(Localizable.QRCodeScannerModule.imageError) \(error.localizedDescription)"
                                self.viewModel.showAlert = true
                            }
                            // Завершение загрузки изображения
                            self.viewModel.isImageLoading = false
                        })
                    }
                   
                    // Обновление остальной информации о бутылке
                    self.viewModel.rating = result.rating ?? 0
                    self.viewModel.bottleName = result.name
                    self.viewModel.colorSelectedSegment = result.wineColor
                    self.viewModel.sugarSelectedSegment = result.wineSugar
                    self.viewModel.typeSelectedSegment = result.wineType
                    self.viewModel.selectedGrapeVarieties = [result.wineSort]
                    let country = Country(code: result.wineCountry, regions: [result.wineRegion])
                    self.viewModel.selectedCountry = country
                    self.viewModel.selectedRegion = result.wineRegion
                    self.viewModel.placeOfPurchase = result.placeOfPurchase
                    self.viewModel.price = result.price
                    self.viewModel.bottleDescription = result.bottleDescription ?? ""
                }
            }
        }
        
    }
}

class SemiTransparentOverlayView: UIView {
    var transparentRect: CGRect?
    var cornerRadius: CGFloat = 8
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Draw a semi-transparent layer over the whole view
        context.setFillColor(UIColor.black.withAlphaComponent(0.5).cgColor)
        context.fill(rect)
        
        // Clear the rounded square in the middle
        if let transparentRect = transparentRect {
            let clearPath = UIBezierPath(roundedRect: transparentRect, cornerRadius: cornerRadius)
            context.addPath(clearPath.cgPath)
            context.setBlendMode(.clear)
            context.fillPath()
        }
    }
}


class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView?
    var overlayView: SemiTransparentOverlayView!
    let capsuleView = UIView()
    let questionButton = UIButton(type: .system)
    
    weak var delegate: UpdateFromQR?
    
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
        videoPreviewLayer.frame = view.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer)
        
        // Initialize the overlay view
        overlayView = SemiTransparentOverlayView()
        overlayView.backgroundColor = .clear
        view.addSubview(overlayView)
        view.bringSubviewToFront(overlayView)
        
        // Initialize QR Code Frame to highlight QR codes
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.redWineColor.cgColor
            qrCodeFrameView.layer.borderWidth = 3
            qrCodeFrameView.layer.cornerRadius = 8
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
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
        
        // Start the capture session
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
        
        // Configure the capsule view
        capsuleView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        capsuleView.layer.cornerRadius = 2.5
        view.addSubview(capsuleView)
        
        // Configure the question mark button
        let questionImage = UIImage(systemName: Images.questionmark)
        questionButton.setImage(questionImage, for: .normal)
        questionButton.addTarget(self, action: #selector(questionButtonTapped), for: .touchUpInside)
        view.addSubview(questionButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewLayer.frame = view.layer.bounds
        overlayView.frame = view.bounds
        
        // Update frame size and position for qrCodeFrameView and overlayView
        let screenSize = view.bounds.size
        let scanSize = CGSize(width: screenSize.width * 0.6, height: screenSize.width * 0.6)
        let scanRect = CGRect(x: (screenSize.width - scanSize.width) / 2, y: (screenSize.height - scanSize.height) / 2, width: scanSize.width, height: scanSize.height)
        
        qrCodeFrameView?.frame = scanRect
        overlayView.transparentRect = scanRect
        overlayView.setNeedsDisplay()
        
        // Layout the capsule view
        capsuleView.frame = CGRect(x: (view.bounds.width - 40) / 2, y: 20, width: 40, height: 5)
        
        // Layout the question mark button
        questionButton.frame = CGRect(x: view.bounds.width - 50, y: 20, width: 40, height: 40)
    }
    
    @objc func questionButtonTapped() {
        let alert = UIAlertController(title: Localizable.QRCodeScannerModule.information, message: Localizable.QRCodeScannerModule.messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localizable.QRCodeScannerModule.ok, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func startRunningСaptureSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    private func extractName(from string: String) -> String {
        let decoder = JSONDecoder()
        if let data = string.data(using: .utf8) {
            do {
                let decodedData = try decoder.decode(QRModel.self, from: data)
                return decodedData.name
            } catch {
                print("Ошибка декодирования: \(error)")
            }
        }
        return ""
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject, metadataObj.type == .qr {
            if let stringValue = metadataObj.stringValue {
                DispatchQueue.main.async { [weak self] in
                    let alert = UIAlertController(title: Localizable.QRCodeScannerModule.add, message: self?.extractName(from: stringValue), preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: Localizable.QRCodeScannerModule.cancel, style: .cancel, handler: { _ in
                        self?.startRunningСaptureSession()
                    }))
                    
                    alert.addAction(UIAlertAction(title: Localizable.QRCodeScannerModule.yes, style: .default, handler: { _ in
                        self?.delegate?.updateBottleInfo(string: stringValue)
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
