//
//  UILabel+AttrText.swift
//  Water
//
//  Created by Prudhvi Gadiraju on 4/15/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit

extension UILabel {
    func setAttributedText(with mainText: String, and subText: String) {
        let attributedString = NSMutableAttributedString(
            string: "\(mainText)\n",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
            ])
        
        attributedString.append(NSAttributedString(
            string: "\(subText)",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ]))
        
        attributedText = attributedString
    }
}
