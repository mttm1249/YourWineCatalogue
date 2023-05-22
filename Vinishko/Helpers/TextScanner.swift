//
//  TextScanner.swift
//  Vinishko
//
//  Created by mttm on 21.05.2023.
//


import UIKit
import Vision

class TextScanner {
    
    func recognizeText(from image: UIImage, completion: @escaping (String?) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion(nil)
            return
        }
        
        let textRecognitionRequest = VNRecognizeTextRequest { request, error in
            if error != nil {
                // Handling text recognition error
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                // Failed to get OCR results
                completion(nil)
                return
            }
            
            // Handling text recognition results
            var recognizedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else {
                    continue
                }
                
                recognizedText += topCandidate.string + "\n"
            }
            
            completion(recognizedText)
        }
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try imageRequestHandler.perform([textRecognitionRequest])
        } catch {
            // Image Processing Error Handling
            completion(nil)
        }
    }
}

