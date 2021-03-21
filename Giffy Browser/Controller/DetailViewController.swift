//
//  DetailViewController.swift
//  Giffy Browser
//
//  Created by Vineet Rai on 19/03/21.
//

import UIKit

class DetailViewController: UIViewController {
    var gifURL:String = ""
    var slug:String?

    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var gifName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: gifURL)
        gifImage.sd_setImage(with: url)
        if slug != nil {
            gifName.text = slug
        }
       
    }
    
    @IBAction func share(_ sender: Any) {
        let image = gifImage.image
        let imageShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    

}
