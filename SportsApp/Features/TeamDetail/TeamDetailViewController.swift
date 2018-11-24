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
    
    @IBOutlet weak var nextEventsTableView: UITableView!
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
        
        let input = TeamDetailViewModel.Input(appearState: viewAppearState)
        let output = model.configure(input: input)
        
        output.title.subscribe(onNext: { [weak self] str in
            self?.navigationItem.title = str
        }).disposed(by: bag)
        
        output.state.subscribe(onNext: { [weak self] state in
            // state handler
        }).disposed(by: bag)
    }
    
    private func configureUI() {
    }
    
    // MARK: - Additional
    
    deinit {
        print("TeamDetailViewController deinit")
    }
}