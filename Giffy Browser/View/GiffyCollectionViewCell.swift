//
//  GiffyCollectionViewCell.swift
//  Giffy Browser
//
//  Created by Vineet Rai on 20/03/21.
//

import UIKit
import FLAnimatedImage

class GiffyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gifImage: FLAnimatedImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImage.image = UIImage()
    }

}
