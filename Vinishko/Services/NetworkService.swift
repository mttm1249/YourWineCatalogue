//
//  NetworkService.swift
//  Vinishko
//
//  Created by mttm on 15.11.2023.
//

import UIKit

class NetworkService {
    
    @discardableResult
    static func downloadImage(url: String, completion: @escaping (Result<UIImage, Error>) -> ()) -> URLSessionDataTask? {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return nil
        }
        
        print("IMAGE URL HERE: \(url)")
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"])))
                }
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image data could not be decoded"])))
                }
            }
        }
        task.resume()
        return task
    }
}
