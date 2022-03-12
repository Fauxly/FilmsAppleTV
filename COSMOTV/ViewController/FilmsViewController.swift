import UIKit

var films: Films!,
    numberOfRows = 0,
    tapped = -1


class collectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hoverLabel: UILabel!
    @IBOutlet weak var imageFilms: UIImageView!
    @IBOutlet weak var nameFilms: UILabel!
    
}

class FilmsViewController: UIViewController {
    
    @IBOutlet var imageViewMain: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = URLRequest(url: URL(string: GlobalVars.urlString + "movies" + GlobalVars.token)!)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("You tapped me")
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let pindex  = context.previouslyFocusedIndexPath, let cell = collectionView.cellForItem(at: pindex) {
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.shadowRadius = 0.0
                cell.contentView.layer.shadowOpacity = 0.0
            }

            if let index  = context.nextFocusedIndexPath, let cell = collectionView.cellForItem(at: index) {
                cell.contentView.layer.borderWidth = 8.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                cell.contentView.layer.shadowColor = UIColor.white.cgColor
                cell.contentView.layer.shadowRadius = 10.0
                cell.contentView.layer.shadowOpacity = 0.9
                cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
                collectionView.scrollToItem(at: index, at: [.centeredHorizontally, .centeredVertically], animated: true)
            }
        let index = context.nextFocusedIndexPath?.row ?? 0
        if ((films.data[index].kinopoiskID) != nil) {
            if let cachedImage = GlobalVars.imageCache.object(forKey: films.data[index].kinopoiskID+"main" as NSString) {
                imageViewMain.image = cachedImage
                print("ЖОПА", cachedImage)
            } else {
                var request = URLRequest(url: URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/\(String(describing: films.data[index].kinopoiskID))/frames")!)
                request.httpMethod = "GET"
                request.setValue("e9848d74-bbe0-4679-96f9-37943e4ca745", forHTTPHeaderField: "X-API-KEY")
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: request as URLRequest) { [self] (data, response, error) -> Void in
                    do {
                        let filmsInfo = try JSONDecoder().decode(FramesFilms.self, from: data!)
                        if (filmsInfo.frames?[0].image != nil) {
                            print("Зашел", filmsInfo.frames?[0].image)
                            DispatchQueue.main.async { [self] in
                                imageViewMain.downloaded(from: filmsInfo.frames![0].image!, id: films.data[index].kinopoiskID+"main")
                                imageViewMain.contentMode = .scaleAspectFill
                            }
                        }
                    } catch {
                        print("error: ", error)
                    }
                }.resume()
            }
        }
    }
}


extension FilmsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionCell", for: indexPath) as! collectionViewCell
        
        cell.imageFilms.image = UIImage(named: "default-placeholder")
        
        if (films.data[indexPath.row].tapped == true) {
            cell.hoverLabel.text = "HOVER"
        } else {
            cell.hoverLabel.text = ""
        }
        //Кинопоиск апи для получения кадров и постеров фильмов!
        
        if ((films.data[indexPath.row].kinopoiskID) != nil) {
            if let cachedImage = GlobalVars.imageCache.object(forKey: films.data[indexPath.row].kinopoiskID as NSString) {
                cell.imageFilms.image = cachedImage
            } else {
                var request = URLRequest(url: URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/\(String(describing: films.data[indexPath.row].kinopoiskID))")!)
                request.httpMethod = "GET"
                request.setValue("e9848d74-bbe0-4679-96f9-37943e4ca745", forHTTPHeaderField: "X-API-KEY")
                let session = URLSession(configuration: URLSessionConfiguration.default)
                session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    do {
                        let filmsInfo = try JSONDecoder().decode(FilmsInfo.self, from: data!)
                        print(filmsInfo)
                        if (filmsInfo.data.posterUrlPreview != nil) {
                            DispatchQueue.main.async {
                                cell.imageFilms.downloaded(from: filmsInfo.data.posterUrlPreview!, id: films.data[indexPath.row].kinopoiskID)

                            }
                        } else {
                            cell.imageFilms.image = UIImage(named: "default-placeholder")
                            GlobalVars.imageCache.setObject(UIImage(named: "default-placeholder")!, forKey: films.data[indexPath.row].kinopoiskID as NSString)
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
        cell.nameFilms.attributedText =
            NSMutableAttributedString()
            .blackHighlight(" \(films.data[indexPath.row].ruTitle) ")
        return cell
    }
}

//extension FilmsViewController: UICollectionViewDelegateFlowLayout {
//    
//}

