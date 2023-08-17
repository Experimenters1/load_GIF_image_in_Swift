//
//  ViewController.swift
//  test1
//
//  Created by Huy Vu on 8/17/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let gifURL = Bundle.main.url(forResource: "7cC", withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifURL) {
            let gifImage = UIImage.gifImageWithData(gifData)
            img.image = gifImage
        }

    }


}

extension UIImage {
    static func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        var images: [UIImage] = []
        let count = CGImageSourceGetCount(source)
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }
        
        if images.isEmpty {
            return nil
        }
        
        return UIImage.animatedImage(with: images, duration: totalDuration(for: source))
    }
    
    private static func totalDuration(for imageSource: CGImageSource) -> TimeInterval {
        let count = CGImageSourceGetCount(imageSource)
        var totalDuration: TimeInterval = 0.0
        
        for i in 0..<count {
            if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? [String: Any],
               let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
               let frameDuration = gifInfo[kCGImagePropertyGIFDelayTime as String] as? TimeInterval {
                totalDuration += frameDuration
            }
        }
        
        return totalDuration
    }
}


