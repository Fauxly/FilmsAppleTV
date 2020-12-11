//
//  ViewController.swift
//  COSMOTV
//
//  Created by Maxim Pyatovky on 11.12.2020.
//

import UIKit

var films: Films!,
    numberOfRows = 0

class collectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameFilms: UILabel!
    
}

class FilmsViewController: UIViewController {
    
    @IBOutlet var imageViewMain: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var request = URLRequest(url: URL(string: GlobalVars.urlString + "short" + GlobalVars.token)!)
        request.httpMethod = "GET"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            do {
                films = try JSONDecoder().decode(Films.self, from: data!)
                numberOfRows = films!.data.count
                print(films)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("error: ", error)
            }
        }.resume()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
}

extension FilmsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionViewMain: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("You tapped me")
    }
}

extension FilmsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionCell", for: indexPath)
        
        cell.imag
        
        return cell
    }
}

//extension FilmsViewController: UICollectionViewDelegateFlowLayout {
//    
//}

