//
//  GlobalFunc.swift
//  COSMOTV
//
//  Created by Maxim Pyatovky on 11.12.2020.
//

import UIKit

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, id: String) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                GlobalVars.imageCache.setObject(image, forKey: id as NSString)
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, id: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, id: id)
    }
}
