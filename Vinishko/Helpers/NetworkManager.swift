//
//  NetworkManager.swift
//  Vinishko
//
//  Created by mttm on 06.02.2023.
//

import UIKit

class NetworkManager {
    
    static func downloadImage(url: String, comletion: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    comletion(image)
                }
            }
        } .resume()
    }
    
}
