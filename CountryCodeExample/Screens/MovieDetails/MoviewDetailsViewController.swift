//
//  MoviewDetailsViewController.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/22/24.
//

import UIKit

class MoviewDetailsViewController: UIViewController, StoryboardInstantiable, AlertableWithAsync {
    var posterImage: Observable<Data?> = Observable(item: nil)

    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var imageView: UIImageView!
    private var viewModel: MoviewDetailsViewModel!
    @IBOutlet weak var releaseDate: UILabel!
    
    static func create(with viewModel: MoviewDetailsViewModel) -> MoviewDetailsViewController {
        let vc = MoviewDetailsViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindData(to: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updatePosterImage(width: Int(imageView.bounds.width))
    }

    func bindData(to viewModel: MoviewDetailsViewModel) {
        viewModel.posterImage.addObserver(observer: self) { [weak self] _ in
            guard let self else { return }

            guard let image = viewModel.posterImage.item else {
                imageView.isHidden = true
                return
            }

            imageView.image = image
        }
    }

    func setupView() {
        title = viewModel.title
        descriptionTextView.text = viewModel.overview
        releaseDate.text = viewModel.releasedDate
    }
}
