//
//  Drawer+Modifiers.swift
//
//
//  Created by Michael Verges on 7/15/20.
//

import SwiftUI

public extension Drawer {
    
    /// Locks the drawer in a controlled position
    /// - Parameters:
    ///   - locked: Indicates if the drawer is locked
    ///   - height: A function reading the current resting height of the drawer and returning the height to lock the drawer
    /// - Returns: Drawer
    func locked(_ locked: Binding<Bool>, to height: @escaping (_ restingHeight: CGFloat) -> CGFloat) -> Drawer<Content> {
        return Drawer(
            heights: heights,
            height: self.height,
            restingHeight: restingHeight,
            springHeight: springHeight,
            didRest: didRest,
            impactGenerator: impactGenerator,
            locked: locked,
            lockedHeight: height,
            content: content)
    }
    
    /// Sets the springiness of the drawer when pulled past boundaries
    /// - Parameter spring: A positive number, in pixels, to define how far the drawer can be streched beyond bounds
    /// - Returns: Drawer with specified spring level
    func spring(_ spring: CGFloat) -> Drawer<Content> {
        return Drawer(
            heights: heights,
            height: self.height,
            restingHeight: restingHeight,
            springHeight: max(spring, 0),
            didRest: didRest,
            impactGenerator: impactGenerator,
            locked: $locked,
            lockedHeight: lockedHeight,
            content: content)
    }
    
    /// Sets the haptic impact of the drawer when resting
    /// - Parameter impact: `FeedbackStyle` for impact level
    /// - Returns: Drawer with specified impact level
    func impact(_ impact: UIImpactFeedbackGenerator.FeedbackStyle) -> Drawer<Content> {
        let impactGenerator = UIImpactFeedbackGenerator(style: impact)
        return Drawer(
            heights: heights,
            height: height,
            restingHeight: restingHeight,
            springHeight: springHeight,
            didRest: didRest,
            impactGenerator: impactGenerator,
            locked: $locked,
            lockedHeight: lockedHeight,
            content: content)
    }
    
    /// A callback to receive updates when the drawer reaches a new resting level
    /// - Parameter didRest: The callback to handle updates
    /// - Returns: Drawer
    func onRest(_ didRest: @escaping (_ height: CGFloat) -> ()) -> Drawer<Content> {
        return Drawer(
            heights: heights,
            height: height,
            restingHeight: restingHeight,
            springHeight: springHeight,
            didRest: didRest,
            impactGenerator: impactGenerator,
            locked: $locked,
            lockedHeight: lockedHeight,
            content: content)
    }
    
}
