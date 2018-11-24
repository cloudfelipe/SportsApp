//
//  TeamListViewController.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TeamListViewController: UIViewController {
    
    // MARK: - Properties
    
    // Dependencies
    var viewModel: TeamListViewOutput?
    
    // Public
    var bag = DisposeBag()
    
    // Private
    private let viewAppearState = PublishSubject<ViewAppearState>()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(TeamListTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    private lazy var searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        return button
    }()
    // IBOutlet & UI
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureRx()
        viewAppearState.onNext(.didLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewAppearState.onNext(.willAppear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppearState.onNext(.didAppear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewAppearState.onNext(.willDisappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewAppearState.onNext(.didDisappear)
    }
    
    // MARK: - Configuration
    private func configureRx() {
        guard let model = viewModel else {
            assertionFailure("Please, set ViewModel as dependency for TeamList")
            return
        }
        
        let input = TeamListViewModel.Input(appearState: viewAppearState)
        let output = model.configure(input: input)
        
        output.title.subscribe(onNext: { [weak self] str in
            self?.navigationItem.title = str
        }).disposed(by: bag)
        
        output.state.subscribe(onNext: { [weak self] state in
            // state handler
        }).disposed(by: bag)
        
        output.teamsWrapper
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: TeamListTableViewCell.self)) { (index, item, cell) in
                cell.setupWith(model: item)
            }
            .disposed(by: bag)
    }
    
    private func configureUI() {
        self.view.addSubview(tableView)
        self.navigationItem.rightBarButtonItem = self.searchButton
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.prepareConstraints()
    }
    
    /// Setup all constraints for all views
    private func prepareConstraints() {
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    // MARK: - Additional
    
    deinit {
        print("TeamListViewController deinit")
    }
}
