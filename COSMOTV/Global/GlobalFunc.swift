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


extension NSMutableAttributedString {
    var fontSize:CGFloat { return 24 }
        var lightFont:UIFont { return UIFont(name: "AppleSDGothicNeo-Light", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
        var thinFont:UIFont { return UIFont(name: "AppleSDGothicNeo-Thin", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : lightFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : lightFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  lightFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  lightFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  lightFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
