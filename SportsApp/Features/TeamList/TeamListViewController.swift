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
import SVProgressHUD

enum Leagues: Int, CaseIterable {
    case laLiga = 0
    case premier = 1
    case bundesliga = 2
    
    var identifier: String {
        switch self {
        case .premier:
            return "4328"
        case .bundesliga:
            return "4331"
        case .laLiga:
            return "4335"
        }
    }
    
    var name: String {
        switch self {
        case .premier:
            return "Premier"
        case .bundesliga:
            return "Bundesliga"
        case .laLiga:
            return "La Liga"
        }
    }
}

class TeamListViewController: UIViewController {
    
    // MARK: - Properties
    
    // Dependencies
    var viewModel: TeamListViewOutput?
    
    // Public
    var bag = DisposeBag()
    
    // Private
    private let viewAppearState = PublishSubject<ViewAppearState>()
    private lazy var tableView: BaseTableView = {
        let tableView = BaseTableView(frame: CGRect.zero, style: .plain)
        tableView.register(TeamListTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    private lazy var searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        return button
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: Leagues.allCases.map { $0.name })
        segment.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0),
            NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .normal)
        return segment
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
//        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppearState.onNext(.didAppear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewAppearState.onNext(.willDisappear)
//        self.navigationController?.navigationBar.prefersLargeTitles = false
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
        
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        //swiftlint:disable line_length
        let input = TeamListViewModel.Input(appearState: viewAppearState,
                                            teamDidSelectedAtIndex: tableView.rx.itemSelected.asDriver(),
                                            segmentedItemSelectedAtIndex: segmentedControl.rx.selectedSegmentIndex.asDriver())
        let output = model.configure(input: input)
        
        output.title.subscribe(onNext: { [weak self] str in
            self?.navigationItem.title = str
        }).disposed(by: bag)
        
        output.state.subscribe(onNext: { [unowned self] state in
            switch state {
            case .networkActivity:
                self.tableView.isLoadingContent = true
                //Block segmentedControl while is loading content
                self.segmentedControl.isUserInteractionEnabled = false
            case .error(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.tableView.isLoadingContent = false
                self.segmentedControl.isUserInteractionEnabled = true
            default:
                self.tableView.isLoadingContent = false
                self.segmentedControl.isUserInteractionEnabled = true
            }
        }).disposed(by: bag)

        //swiftlint:disable line_length
        output.teamsWrapper
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: TeamListTableViewCell.self)) { (_, item, cell) in
                cell.setupWith(model: item)
            }
            .disposed(by: bag)
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = 0
        self.prepareConstraints()
    }
    
    /// Setup all constraints for all views
    private func prepareConstraints() {
        
        segmentedControl.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(30.0)
        }
        
        tableView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(segmentedControl.snp.bottom).offset(10.0)
        }
    }
    
    // MARK: - Additional
    
    deinit {
        print("TeamListViewController deinit")
    }
}

extension TeamListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
