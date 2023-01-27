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

    private var overlay: UIView = UIView()
    private var video = AVCaptureVideoPreviewLayer()
    private let session = AVCaptureSession()
    weak var delegate: UpdateFromQR?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPreviewLayer()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.stopRunning()
    }
    
    func createOverlay() -> UIView {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = .black.withAlphaComponent(0.5)
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
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(video)
        let overlay = createOverlay()
        view.addSubview(overlay)
        startRunning()
    }
    
    func startRunning() {
        DispatchQueue.background(delay: 0.5, background: {
            self.session.startRunning()
        })
    }
        
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                let alert = UIAlertController(title: "Хотите добавить?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Назад", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Да!", style: .default, handler: { (action) in
                    if object.stringValue != nil {
                        self.delegate?.updateBottleInfo(string: object.stringValue!)
                    }
                    self.navigationController?.popViewController(animated: true)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
        }
    }
}
