//
//  ProductsTableViewCell.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 17.05.2021.
//

import UIKit
import RxSwift
import Nuke
import RxNuke

class ProductsTableViewCell: UITableViewCell, BindableType, NibIdentifiable & ClassIdentifiable {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
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
    
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.layer.cornerRadius = 8
            backView.layer.borderWidth = 1
            backView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var productImageView: UIImageView!
    
    private static let imagePipeline = Nuke.ImagePipeline.shared
    private var disposeBag = DisposeBag()
    
    var viewModel: ProductsTableViewCellModelType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        let this = ProductsTableViewCell.self
        
        cartButton.rx.action = inputs.plusAction
        cartPlusButton.rx.action = inputs.plusAction
        cartMinusButton.rx.action = inputs.minusAction

        outputs.hideCartButton
            .bind(to: cartButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        outputs.hideCartSelector
            .bind(to: cartSelectorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        outputs.name
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.category
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.producer
            .bind(to: producerLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.price
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.cartText
            .bind(to: cartLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.productPhotoURL
            .flatMap { this.imagePipeline.rx.loadImage(with: $0) }
            .orEmpty()
            .map { $0.image }
            .bind(to: productImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
}
