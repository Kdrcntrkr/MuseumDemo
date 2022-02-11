//
//  CollectionsTableViewCell.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 1.07.2021.
//

import UIKit
import Kingfisher

class CollectionsTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(with model: Model) {
        title.text = model.title
        guard let url = URL(string: model.imageUrl) else { return }
        collectionImage.kf.setImage(with: url, placeholder: UIImage(named: "placeHolder"))
    }
    
    struct Model: Codable {
        let title: String
        let imageUrl: String
    }
}


