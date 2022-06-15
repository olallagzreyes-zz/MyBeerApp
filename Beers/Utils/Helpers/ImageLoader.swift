//
//  ImageLoader.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 13/6/22.
//

import UIKit

struct ImageLoader {
    static let shared = ImageLoader()
    
    // Helper to download image from URL
    func downloadImage(url: URL, completion: @escaping(Result<UIImage?, Error>) -> Void) {
      let dataTask =  URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            if let error = error {
                return completion(.failure(NetworkError.generic(error)))
            }else {
                return completion(.success(UIImage(data: data)))
            }
        }
        dataTask.resume()
    }
}
