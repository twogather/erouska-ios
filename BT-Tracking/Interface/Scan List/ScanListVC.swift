//
//  ScanListVC.swift
//  BT-Tracking
//
//  Created by Tomas Svoboda on 18/03/2020.
//  Copyright © 2020 Covid19CZ. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class ScanListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<ScanListVM.SectionModel>!
    private let bag = DisposeBag()
    private let viewModel = ScanListVM()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
//        bindClearButton()
    }
    
    // MARK: - TableView
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.rowHeight = 59

        dataSource = RxTableViewSectionedAnimatedDataSource<ScanListVM.SectionModel>(configureCell: { datasource, tableView, indexPath, row in
            
            switch row {
            case .scan(let scan):
                let cell = tableView.dequeueReusableCell(withIdentifier: ScanCell.identifier, for: indexPath) as! ScanCell
                cell.configure(for: scan)
                return cell
            }
        })
        
        viewModel.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .fade)
    }
}