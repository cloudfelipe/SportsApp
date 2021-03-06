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
import RxDataSources

class TeamDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    // Dependencies
    var viewModel: TeamDetailViewOutput?
    
    // Public
    var bag = DisposeBag()
    
    // Private
    private let viewAppearState = PublishSubject<ViewAppearState>()
    
    // IBOutlet & UI
    @IBOutlet weak var foundedLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var stadiumImageView: UIImageView!
    @IBOutlet weak var stadiumNameLabel: UILabel!
    @IBOutlet weak var jerseyImageView: UIImageView!
    @IBOutlet weak var jerseyNameLabel: UILabel!
    
    @IBOutlet weak var footerInfoTableView: BaseTableView!
    
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
        
        footerInfoTableView.rx.setDelegate(self).disposed(by: bag)
        
        //swiftlint:disable line_length
        let input = TeamDetailViewModel.Input(appearState: viewAppearState,
                                              footerItemDidSelectedAtIndex: footerInfoTableView.rx.itemSelected.asDriver())
        let output = model.configure(input: input)
        
        output.title.subscribe(onNext: { [weak self] str in
            self?.navigationItem.title = str
        }).disposed(by: bag)
        
        output.state.subscribe(onNext: { [unowned self] state in
            switch state {
            case .networkActivity:
                self.footerInfoTableView.isLoadingContent = true
            default:
                self.footerInfoTableView.isLoadingContent = false
            }
        }).disposed(by: bag)
        
        output.footerSections
            .bind(to: footerInfoTableView.rx.items(dataSource: model.footerTablewDataSource()))
            .disposed(by: bag)
        
        output.viewInfo
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (viewInfo) in
                self.updateViewInfo(with: viewInfo)
            }).disposed(by: bag)
    }
    
    private func configureUI() {
        footerInfoTableView.register(TeamListTableViewCell.self, forCellReuseIdentifier: "Cell")
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
        foundedLabel.font = UIFont.systemFont(ofSize: 15.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToTop(textView: descriptionTextView)
    }
    //Litle hack that scrolls to a textview's top
    public func scrollToTop(textView: UITextView) {
        // swiftlint:disable next legacy_constructor
        let range = NSMakeRange(0, 1)
        textView.scrollRangeToVisible(range)
    }
    
    private func updateViewInfo(with model: TeamDetailViewInfo?) {
        
        guard let model = model else { return }
        
        self.descriptionTextView.text = model.description
        self.stadiumNameLabel.text = model.stadiumName
        self.jerseyNameLabel.text = model.jersey
        self.foundedLabel.text = model.founded
        if let stadiumUrl = model.stadiumImageUrl, let url = URL(string: stadiumUrl) {
            self.stadiumImageView.af_setImage(withURL: url)
        }
        if let jerseUrl = model.jerseyImageUrl, let url = URL(string: jerseUrl) {
            self.jerseyImageView.af_setImage(withURL: url)
        }
    }
    
    // MARK: - Additional
    
    deinit {
        print("TeamDetailViewController deinit")
    }
}

extension TeamDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
