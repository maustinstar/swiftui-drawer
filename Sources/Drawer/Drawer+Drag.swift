//
//  Drawer+Drag.swift
//
//
//  Created by Michael Verges on 7/18/20.
//

import SwiftUI

internal extension Drawer {
    
    // MARK: Drag Gesture
    
    var dragGesture: some Gesture {
        return DragGesture().onChanged({ (value) in
            self.dragChanged(value)
        }).onEnded({ (value) in
            self.dragEnded(value)
        })
    }
    
    func dragChanged(_ value: DragGesture.Value) {
        dragging = true
        
        height = Drawer.dampen(
            value.startLocation.y
            + restingHeight - value.location.y,
            range: activeBound,
            spring: springHeight)

        animation = Animation?.none
    }
    
    func dragEnded(_ value: DragGesture.Value) {
        dragging = false
        
        let change = value.startLocation.y
            - value.predictedEndLocation.y + restingHeight
        height = Drawer.closest(change, markers: heights)
        restingHeight = height
        animation = Animation.spring()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.impactGenerator?.impactOccurred()
        }
    }
    
    // MARK: Height Calculations
    
    static func closest(_ mark: CGFloat, markers: [CGFloat]) -> CGFloat {
        let first = markers.first!
        return markers.reduce(
            (first, abs(first - mark))
        ) { (current, value) -> (CGFloat, CGFloat) in
            if current.1 > abs(value - mark) {
                return (value, abs(value - mark))
            }
            return current
        }.0
    }
    
    static func dampen(_ value: CGFloat, range: ClosedRange<CGFloat>, spring: CGFloat) -> CGFloat {
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
