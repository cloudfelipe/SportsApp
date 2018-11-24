//
//  BaseTableView.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import RxSwift
//import DZNEmptyDataSet

class BaseTableView: UITableView {
    
    //EmptyDataSet properties
//    var emptyBackgroundColor: UIColor = .gray
//    var emptyDescriptionText: String = ""
//    var emptyTitleText: String = "No result found"
//    var emptyImage: UIImage = UIImage(name: "no_found_icon")
    
    var loadingIndicator = UIActivityIndicatorView(style: .gray)
    
    var isLoadingContent: Bool = false {
        didSet {
            isLoadingContent ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }
    
    public var isLoading = PublishSubject<Bool>()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
    }
    
    private func customInit() {
        self.addSubview(loadingIndicator)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tableFooterView = UIView()
    }
}
