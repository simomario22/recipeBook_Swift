//
//  UIImageView+Networking.swift
//  recipeBook
//
//  Created by Michael Jester on 3/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    func downloadImageFromNetworkAtURL(url: String){
        
        
        //show activity spinner
        let activityIndicatorFrame: CGRect = CGRect.init(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView.init(frame: activityIndicatorFrame)
        spinner.color = UIColor.black
        spinner.backgroundColor = UIColor.blue
        spinner.hidesWhenStopped = true
        self.addSubview(spinner)
        spinner.startAnimating()
        
        
        let downloadImageCompletionHandler: ((Data) -> Void) = { [weak self] (imageData:Data) -> Void in
            
            if let imageFromData = UIImage.init(data:imageData){
                //populate the image in the image view and
                //cache the image for next time it is needed
                self?.image = imageFromData
            }
            
            //stop spinner
            spinner.stopAnimating()
        }
        
        NetworkingManager.downloadImageAtURL(urlString: url, downloadCompletionHandler: downloadImageCompletionHandler)
        
    }
    
}

