//
//  Drawer+Height.swift
//
//
//  Copyright © 2020 littlnotes. All rights reserved.
//

import SwiftUI

internal extension Drawer {
    
    func dragChanged(_ value: DragGesture.Value) {
        dragging = true
        
        height = dampen(
            value.startLocation.y
            + restingHeight - value.location.y,
            range: activeBound,
            spring: springHeight)

        animation = Animation?.none
    }
    
    func dragEnded(_ value: DragGesture.Value) {
        dragging = false
        if locked {
            height = restingHeight
            animation = Animation.spring()
            return
        }
        
        let change = value.startLocation.y
            - value.predictedEndLocation.y + restingHeight
        let first = heights.first!
        height = heights.reduce(
            (first, abs(first - change))
        ) { (current, value) -> (CGFloat, CGFloat) in
            if current.1 > abs(value - change) {
                return (value, abs(value - change))
            }
            return current
        }.0
        restingHeight = height
        animation = Animation.spring()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.impactGenerator?.impactOccurred()
        }
    }
    
    func dampen(_ value: CGFloat, range: ClosedRange<CGFloat>, spring: CGFloat) -> CGFloat {
        if range.contains(value) {
            return value
        } else if value > range.upperBound {
            let change = value - range.upperBound
            let x = pow(M_E, Double(change) / Double(spring))
            return -(2 * spring) / CGFloat(1 + x) + spring + range.upperBound
        } else {
            let change = value - range.lowerBound
            let x = pow(M_E, Double(change) / Double(spring))
            return -(2 * spring) / CGFloat(1 + x) + spring + range.lowerBound
        }
    }
}
