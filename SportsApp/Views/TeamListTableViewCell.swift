//
//  TeamListTableViewCell.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

struct TeamListTableViewCellModel {
    let teamName: String
    let teamStadium: String
    let teamBadge: String
}

final class TeamListTableViewCell: UITableViewCell {
    init(reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    /// NO IMPLEMENTED IN THIS TEST
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Method to do a custom setup
    private func customInit() {
        self.accessoryType = .disclosureIndicator
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
            imageView.layer.cornerRadius = imageView.frame.height / 2
        }
    }
    
    func setupWith(model: TeamListTableViewCellModel) {
        self.textLabel?.text = model.teamName
        self.detailTextLabel?.text = model.teamStadium
        //TODO: URL unwrapping
        self.imageView?.af_setImage(withURL: URL(string: model.teamBadge)!,
                                    placeholderImage: UIImage(named: "template_icon"))
    }
}
