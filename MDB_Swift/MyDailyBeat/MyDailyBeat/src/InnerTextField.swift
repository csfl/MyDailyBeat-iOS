//
//  InnerTextField.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/30/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

class InnerTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
        UIColor.white.setStroke()
        path.lineWidth = 2
        path.stroke()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

}
