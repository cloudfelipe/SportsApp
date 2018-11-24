//
//  SportListTableViewCell.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit

struct SportListTableViewCellModel {
    let teamName: String
    let teamStadium: String
    let teamBadge: String
}

final class SportListTableViewCell: UITableViewCell {
    init(reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    /// NO IMPLEMENTED IN THIS TEST
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Method to do a custom setup
    private func customInit() {
        
    }
    
    func setupWith(model: SportListTableViewCellModel) {
        self.textLabel?.text = model.teamName
        self.detailTextLabel?.text = model.teamStadium
    }
}
