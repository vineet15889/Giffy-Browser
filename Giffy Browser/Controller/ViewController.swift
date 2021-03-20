//
//  ViewController.swift
//  Giffy Browser
//
//  Created by Vineet Rai on 19/03/21.
//

import UIKit
import SwiftyGif

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionGrid: UICollectionView!
    
    let query = Query()
    var gifData:[GiffyModel.Record] = []
    var offsset:Int = 0
    var loadingData:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiSetup()
        self.perform(query: "", offset: offsset, pageSize: 25) // initial load
    }
    
    func uiSetup(){
        let flowlayout = UICollectionViewFlowLayout()
        let cellSize = (UIScreen.main.bounds.width - 8) / 2
        flowlayout.itemSize = CGSize(width: cellSize, height: cellSize)
        flowlayout.minimumInteritemSpacing = 2
        flowlayout.minimumLineSpacing = 2
        flowlayout.scrollDirection = .vertical
        collectionGrid.collectionViewLayout = flowlayout
    }
    
    //Tableview Delegate and datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gifData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! GiffyCollectionViewCell
        cell.gifImage.image = nil;
        cell.contentView.backgroundColor = .blue
        let url = URL(string: self.gifData[indexPath.row].images.original.url)
        let loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        cell.gifImage.setGifFromURL(url!, customLoader: loader)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:DetailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.gifURL = self.gifData[indexPath.row].images.original.url
        vc.slug = self.gifData[indexPath.row].slug
        self.navigationController?.pushViewController (vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > self.gifData.count - 4 && !loadingData{
            loadingData = true
            self.perform(query: "", offset: self.offsset, pageSize: 25)
        }
    }
    
    
    

    // Helper method
    
    fileprivate func perform(query: String, offset: Int, pageSize: Int) {
        return self.query.query(query: query, offset: offset, limit: pageSize).send { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.process(data)
                case .error(let error):
                    self.displayError(error)
                }
            }
        }
    }

    fileprivate func process(_ data: (Data)) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.processInBackground(data)
        }
    }
    
    fileprivate func processInBackground(_ data: (Data)) {
        loadingData = true
        let result = GiffyModel.process(data)
        DispatchQueue.main.async {
            self.loadingData = false
            switch result {
            case .success(let gifData):
                guard gifData.data.count >= 1 else {
                    return
                }
                self.offsset = self.offsset + 25
                self.gifData.append(contentsOf: gifData.data)
                if self.gifData.count < 250 {
                    self.perform(query: "", offset: self.offsset, pageSize: 25)
                }
                self.collectionGrid.reloadData()
            case .error(let error):
                self.displayError(error)
            }
        }
    }
    
    fileprivate func displayError(_ error: (Error)) {
        print(error)
        let alert = UIAlertController(title: "NetworkError", message: "Error: \(error.localizedDescription)", preferredStyle: .actionSheet)
        let retryAction = UIAlertAction(title: "Reload", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
                self.perform(query: "", offset: self.offsset, pageSize: 25)
            })
        })
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: {})
    }

}

