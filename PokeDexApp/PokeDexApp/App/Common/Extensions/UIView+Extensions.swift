//
//  UIView+Extensions.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 06/03/21.
//

import UIKit

extension UIView{
    func roundCorners(_ corners: UIRectCorner, bounds: CGRect, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
