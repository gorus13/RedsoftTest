//
//  ProductsViewController.swift
//  RedsoftTest
//
//  Created by Dmitry Muravev on 17.05.2021.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class ProductsViewController: UIViewController, BindableType {

    var viewModel: ProductsViewModelType!
    
    typealias CellSectionModel = SectionModel<String, ProductsTableViewCellModelType>
    
    private var dataSource: RxTableViewSectionedReloadDataSource<CellSectionModel>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        outputs.productsViewModel
            .map { [CellSectionModel(model: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        backButton.rx.action = inputs.backAction
        
        tableView.rx.reachedBottom()
            .bind(to: inputs.loadMore)
            .disposed(by: disposeBag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(ProductsTableViewCellModel.self))
            .map { [weak self] (indexPath, model) in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                return model.productModel!
            }
            .subscribe(inputs.productDetailsAction.inputs)
            .disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
            .bind(to: inputs.search)
            .disposed(by: disposeBag)
        
        outputs.searchSet
            .bind(to: searchTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableView.register(cellType: ProductsTableViewCell.self)
        tableView.rowHeight = 180
        dataSource = RxTableViewSectionedReloadDataSource<CellSectionModel>(
            configureCell:  tableViewDataSource
        )
    }
    
    private var tableViewDataSource: RxTableViewSectionedReloadDataSource<CellSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, cellModel in
            var cell = tableView.dequeueResuableCell(withCellType: ProductsTableViewCell.self, forIndexPath: indexPath)
            cell.bind(to: cellModel)
            return cell
        }
    }
}
