//
//  QRScannerViewController.swift
//  Vinishko
//
//  Created by Денис on 27.01.2023.
//


import UIKit
import AVFoundation

protocol UpdateFromQR: AnyObject {
    func updateBottleInfo(string: String)
}

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    private var overlay = UIView()
    private var video = AVCaptureVideoPreviewLayer()
    private let session = AVCaptureSession()
    weak var delegate: UpdateFromQR?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPreviewLayer()
    }
            
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    
    func createOverlay() -> UIView {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let path = CGMutablePath()
        path.addRoundedRect(in: CGRect(x: screenWidth / 2 - 125, y: screenHeight / 2 - 125, width: 250, height: 250), cornerWidth: 5, cornerHeight: 5)
        path.closeSubpath()
        let shape = CAShapeLayer()
        shape.path = path
        shape.lineWidth = 6.0
        shape.strokeColor = UIColor.redWineColor.cgColor
        shape.fillColor = UIColor.redWineColor.cgColor
        overlayView.layer.addSublayer(shape)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        return overlayView
    }

    func setupPreviewLayer() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            // Handle case when video capture device is not available
            showCameraUnavailableAlert()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            // Handle error gracefully and inform the user
            showErrorAlert(message: error.localizedDescription)
            return
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        video.videoGravity = .resizeAspectFill
        view.layer.addSublayer(video)
        let overlay = createOverlay()
        view.addSubview(overlay)
        startRunning()
    }
    
    func startRunning() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }
        
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject, object.type == .qr, let stringValue = object.stringValue {
            let alert = UIAlertController(title: LocalizableText.wantAddText, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizableText.backText, style: .default, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: LocalizableText.yesText, style: .default, handler: { [weak self] _ in
                self?.delegate?.updateBottleInfo(string: stringValue)
                self?.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // Helper methods for displaying alerts
    func showCameraUnavailableAlert() {
        let alert = UIAlertController(title: LocalizableText.cameraNotAvailable, message: LocalizableText.cameraNotAvailableMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: LocalizableText.errorText, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}
