//
//  TeamDetailViewController.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

class TeamDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    // Dependencies
    var viewModel: TeamDetailViewOutput?
    
    // Public
    var bag = DisposeBag()
    
    // Private
    private let viewAppearState = PublishSubject<ViewAppearState>()
    
    // IBOutlet & UI
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stadiumImageView: UIImageView!
    @IBOutlet weak var stadiumNameLabel: UILabel!
    @IBOutlet weak var jerseyImageView: UIImageView!
    @IBOutlet weak var jerseyNameLabel: UILabel!
    
    @IBOutlet weak var nextEventsTableView: BaseTableView!
    @IBOutlet weak var socialTableView: UITableView!
    
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
            assertionFailure("Please, set ViewModel as dependency for TeamDetail")
            return
        }
        
        let input = TeamDetailViewModel.Input(appearState: viewAppearState,
                                              socialNetworkDidSelectedAtIndex: socialTableView.rx.itemSelected.asDriver())
        let output = model.configure(input: input)
        
        output.title.subscribe(onNext: { [weak self] str in
            self?.navigationItem.title = str
        }).disposed(by: bag)
        
        output.state.subscribe(onNext: { [unowned self] state in
            switch state {
            case .networkActivity:
                self.nextEventsTableView.isLoadingContent = true
            default:
                self.nextEventsTableView.isLoadingContent = false
            }
        }).disposed(by: bag)
        
        output.socialNetworks
            .bind(to: socialTableView.rx.items(cellIdentifier: "Cell")) { (index, item, cell) in
                cell.textLabel?.text = item.type.rawValue
            }
            .disposed(by: bag)
        
        output.nextEvents
            .bind(to: nextEventsTableView.rx.items(cellIdentifier: "Cell")) { (index, item, cell) in
                cell.textLabel?.text = item.title
            }
            .disposed(by: bag)
        
        output.viewInfo
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (viewInfo) in
                self.updateViewInfo(with: viewInfo)
            }).disposed(by: bag)
    }
    
    private func configureUI() {
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .center
        
        socialTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        nextEventsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func updateViewInfo(with model: TeamDetailViewInfo?) {
        
        guard let model = model else { return }
        
        self.descriptionLabel.text = model.description
        self.stadiumNameLabel.text = model.stadiumName
        self.jerseyNameLabel.text = model.jerse
        if let stadiumUrl = model.stadiumImageUrl, let url = URL(string: stadiumUrl) {
            self.stadiumImageView.af_setImage(withURL: url)
        }
        if let jerseUrl = model.jerseImageUrl, let url = URL(string: jerseUrl) {
            self.jerseyImageView.af_setImage(withURL: url)
        }
    }
    
    // MARK: - Additional
    
    deinit {
        print("TeamDetailViewController deinit")
    }
}
