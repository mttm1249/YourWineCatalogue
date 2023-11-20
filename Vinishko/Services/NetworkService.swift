//
//  NetworkService.swift
//  Vinishko
//
//  Created by mttm on 15.11.2023.
//

import UIKit

class NetworkService: NSObject, URLSessionDownloadDelegate {
    
    static let shared = NetworkService()
    var onProgress: ((Double) -> Void)?
    var onCompletion: ((Result<UIImage, Error>) -> Void)?

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    func downloadImage(url: String, onProgress: @escaping (Double) -> Void, onCompletion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDownloadTask? {
        guard let url = URL(string: url) else {
            onCompletion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return nil
        }
        
        self.onProgress = onProgress
        self.onCompletion = onCompletion

        let task = session.downloadTask(with: url)
        task.resume()
        return task
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.onCompletion?(.success(image))
                }
            } else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image data could not be decoded"])
                DispatchQueue.main.async {
                    self.onCompletion?(.failure(error))
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.onCompletion?(.failure(error))
            }
        }
    }
}
