//
//  DetailsViewController.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 23.05.2021.
//

import UIKit
import RxSwift
import Nuke
import RxNuke

class DetailsViewController: UIViewController, BindableType {

    var viewModel: DetailsViewModelType!
    
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var cartButton: UIButton! {
        didSet {
            cartButton.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var cartMinusButton: UIButton!
    @IBOutlet weak var cartPlusButton: UIButton!
    
    @IBOutlet weak var cartSelectorView: UIView! {
        didSet {
            cartSelectorView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var cartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        backButton.rx.action = inputs.backAction
        
        let this = DetailsViewController.self
        
        cartButton.rx.action = inputs.plusAction
        cartPlusButton.rx.action = inputs.plusAction
        cartMinusButton.rx.action = inputs.minusAction

        outputs.hideCartButton
            .bind(to: cartButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        outputs.hideCartSelector
            .bind(to: cartSelectorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        outputs.cartText
            .bind(to: cartLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.name
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.shortDescription
            .bind(to: shortDescription.rx.text)
            .disposed(by: disposeBag)
        
        outputs.producer
            .bind(to: producerLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.price
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.productPhotoURL
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .orEmpty()
            .map { $0.image }
            .bind(to: productImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
