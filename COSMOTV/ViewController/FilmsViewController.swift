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
    @IBOutlet weak var imageFilms: UIImageView!
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionCell", for: indexPath) as! collectionViewCell
        
        cell.imageFilms.image = UIImage(named: "default-placeholder")
        
        //Кинопоиск апи для получения кадров и постеров фильмов!
        
        if ((films.data[indexPath.row].kp_id) != nil) {
            if let cachedImage = GlobalVars.imageCache.object(forKey: films.data[indexPath.row].kp_id! as NSString) {
                cell.imageFilms.image = cachedImage
                print("ЖОПА", cachedImage)
            } else {
                var request = URLRequest(url: URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/\(String(describing: films.data[indexPath.row].kp_id!))")!)
                request.httpMethod = "GET"
                request.setValue("e9848d74-bbe0-4679-96f9-37943e4ca745", forHTTPHeaderField: "X-API-KEY")
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    do {
                        let filmsInfo = try JSONDecoder().decode(FilmsInfo.self, from: data!)
                        print(filmsInfo)
                        if (filmsInfo.data.posterUrlPreview != nil) {
                            DispatchQueue.main.async {
                                cell.imageFilms.downloaded(from: filmsInfo.data.posterUrlPreview!, id: films.data[indexPath.row].kp_id!)

                            }
                        } else {
                            cell.imageFilms.image = UIImage(named: "default-placeholder")
                            GlobalVars.imageCache.setObject(UIImage(named: "default-placeholder")!, forKey: films.data[indexPath.row].kp_id! as NSString)
                        }
                        
                    } catch {
                        print("error: ", error)
                    }
                }.resume()
            }
        }
        cell.imageFilms.contentMode = .scaleAspectFill
        cell.imageFilms.layer.cornerRadius = 30.0
        cell.imageFilms.clipsToBounds = true
        cell.nameFilms.text = "\(films.data[indexPath.row].title)"
        return cell
    }
}

//extension FilmsViewController: UICollectionViewDelegateFlowLayout {
//    
//}

