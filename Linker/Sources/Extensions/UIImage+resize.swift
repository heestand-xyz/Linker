//
//  UIImage+resize.swift
//  Linker
//
//  Created by Anton Heestand on 2022-07-30.
//

import UIKit

public enum ImagePlacement: String, Equatable, Codable {
    case fill
    case fit
    case stretch
    case crop
}

extension UIImage {
    
    public func square() -> UIImage {
        
        guard size.width != size.height else {
            return self
        }
        
        let length = min(size.width, size.height)
        let size = CGSize(width: length, height: length)
        
        return resize(to: size, placement: .fill)
    }

    public func resize(to size: CGSize, placement: ImagePlacement = .fill) -> UIImage {
        
        let image: UIImage = self
        
        var destinationFrame: CGRect
        switch placement {
        case .fit:
            destinationFrame = CGRect(
                x: image.size.width / size.width > image.size.height / size.height ?
                0 : (size.width - image.size.width * (size.height / image.size.height)) / 2,
                y: image.size.width / size.width < image.size.height / size.height ?
                0 : (size.height - image.size.height * (size.width / image.size.width)) / 2,
                width: image.size.width / size.width > image.size.height / size.height ?
                size.width : image.size.width * (size.height / image.size.height),
                height: image.size.width / size.width < image.size.height / size.height ?
                size.height : image.size.height * (size.width / image.size.width)
            )
        case .fill:
            destinationFrame = CGRect(
                x: image.size.width / size.width < image.size.height / size.height ?
                0 : (size.width - image.size.width * (size.height / image.size.height)) / 2,
                y: image.size.width / size.width > image.size.height / size.height ?
                0 : (size.height - image.size.height * (size.width / image.size.width)) / 2,
                width: image.size.width / size.width < image.size.height / size.height ?
                size.width : image.size.width * (size.height / image.size.height),
                height: image.size.width / size.width > image.size.height / size.height ?
                size.height : image.size.height * (size.width / image.size.width)
            )
        case .stretch:
            
            destinationFrame = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
            
        case .crop:
            
            destinationFrame = CGRect(
                x: image.size.width / size.width < image.size.height / size.height ?
                0 : (size.width - image.size.width * (size.height / image.size.height)) / 2,
                y: image.size.width / size.width > image.size.height / size.height ?
                0 : (size.height - image.size.height * (size.width / image.size.width)) / 2,
                width: image.size.width / size.width < image.size.height / size.height ?
                size.width : image.size.width * (size.height / image.size.height),
                height: image.size.width / size.width > image.size.height / size.height ?
                size.height : image.size.height * (size.width / image.size.width)
            )
        }
        
        UIGraphicsBeginImageContext(size)
        image.draw(in: destinationFrame)
        let resized_image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resized_image
    }
}
