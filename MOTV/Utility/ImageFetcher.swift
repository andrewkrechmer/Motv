//
//  ImageFetcher.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-10-21.
//

import Foundation
import UIKit

class ImageFetcher {
    
    func fetchImage(with url: String, completion: @escaping (UIImage) -> Void) {
        
        //        if let image = CacheManager.shared.getFromCache(key: url) as? UIImage {
        //            completion(image)
        //        } else {
        
        if let url = URL(string: url) {
            
            let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                guard let imageData = data else { return }
                
                OperationQueue.main.addOperation {
                    guard let image = UIImage(data: imageData) else { return }
                    
                    completion(image)
                    
                    // Add the downloaded image to cache
                    // CacheManager.shared.cache(object: image, key: post.imageFileURL)
                    
                }
                
            })
            
            downloadTask.resume()
        }
        //        }
        
    }
    
    
}
