//
//  ClockInOutButton.swift
//  Workmate
//
//  Created by gsiva on 25/2/20.
//  Copyright © 2020 gsiva. All rights reserved.
//

import UIKit

class ClockInOutButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1).cgColor
        self.layer.borderWidth = 15
    }
}
