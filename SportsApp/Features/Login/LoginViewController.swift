//
//  LoginViewController.swift
//  SportsApp
//
//  Created by Felipe Correa on 5/15/19.
//  Copyright © 2019 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    // Dependencies
    var viewModel: LoginViewModelOutput?
    
    // Public
    var bag = DisposeBag()
    
    // Private
    private let viewAppearState = PublishSubject<ViewAppearState>()
    
    // IBOutlet & UI
    @IBOutlet weak var loginButton: UIButton!
    
    
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
        
        let input = LoginViewModel.Input(appearState: viewAppearState,
                                         loginAction: loginButton.rx.tap.asDriver())
        _ = model.configure(input: input)
    }
    
    private func configureUI() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Additional
    
    deinit {
        print("TeamDetailViewController deinit")
    }
}
