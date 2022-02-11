//
//  CollectionDetailsViewController.swift
//  Rijksmuseum
//
//  Created by Kadircan Türker on 2.07.2021.
//

import UIKit

class CollectionDetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    
    let viewModel: CollectionDetailsViewModel
    let objectNumber: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchDetails(with: objectNumber) { [weak self] (details, error) in
            guard let self = self else { return }
            if error == nil {
                guard let details = details else { return }
                self.bind(details: details)
            } else {
                guard let error = error else { return }
                self.showError(with: error)
            }
            
        }
    }
    
    init(viewModel: CollectionDetailsViewModel, objectNumber: String) {
        self.viewModel = viewModel
        self.objectNumber = objectNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CollectionDetailsViewController {
    func bind(details: FetchDetails.Response) {
        DispatchQueue.main.async {
            self.titleLabel.text = details.artObject.longTitle
            self.descriptionLabel.text  = details.artObject.plaqueDescriptionEnglish
            guard let url = URL(string: details.artObject.webImage.url) else { return }
            self.detailImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeHolder"))
        }
    }
    
    func showError(with error: NetworkError) {
        DispatchQueue.main.async {
            self.noDataLabel.isHidden = false
            self.noDataLabel.text = error.localizedDescription
        }
    }
}
