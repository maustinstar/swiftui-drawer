//
//  Drawer+Modifiers.swift
//
//
//  Created by Michael Verges on 7/15/20.
//

import SwiftUI

public extension Drawer {
    
    /// Sets the resting heights of the drawer
    /// - Parameter heights: Possible resting heights for the drawer
    /// - Returns: Drawer
    func rest(at heights: Binding<[CGFloat]>) -> Drawer {
        return Drawer(
            heights: heights,
            height: height,
            restingHeight: restingHeight,
            springHeight: springHeight,
            didRest: didRest,
            didLayoutForSizeClass: didLayoutForSizeClass,
            impactGenerator: impactGenerator,
            content: content)
    }
    
    /// Sets the springiness of the drawer when pulled past boundaries
    /// - Parameter spring: A positive number, in pixels, to define how far the drawer can be streched beyond bounds
    /// - Returns: Drawer with specified spring level
    func spring(_ spring: CGFloat) -> Drawer {
        return Drawer(
            heights: $heights,
            height: self.height,
            restingHeight: restingHeight,
            springHeight: max(spring, 0),
            didRest: didRest,
            didLayoutForSizeClass: didLayoutForSizeClass,
            impactGenerator: impactGenerator,
            content: content)
    }
    
    /// Sets the haptic impact of the drawer when resting
    /// - Parameter impact: `FeedbackStyle` for impact level
    /// - Returns: Drawer with specified impact level
    func impact(_ impact: UIImpactFeedbackGenerator.FeedbackStyle) -> Drawer {
        let impactGenerator = UIImpactFeedbackGenerator(style: impact)
        return Drawer(
            heights: $heights,
            height: height,
            restingHeight: restingHeight,
            springHeight: springHeight,
            didRest: didRest,
            didLayoutForSizeClass: didLayoutForSizeClass,
            impactGenerator: impactGenerator,
            content: content)
    }
    
    /// A callback to receive updates when the drawer reaches a new resting level
    /// - Parameter didRest: The callback to handle updates
    /// - Returns: Drawer
    func onRest(_ didRest: @escaping (_ height: CGFloat) -> ()) -> Drawer {
        return Drawer(
            heights: $heights,
            height: height,
            restingHeight: restingHeight,
            springHeight: springHeight,
            didRest: didRest,
            didLayoutForSizeClass: didLayoutForSizeClass,
            impactGenerator: impactGenerator,
            content: content)
    }
    
    
    /// A callback to receive updates when the drawer is layed out for a new size class
    /// - Parameter didLayoutForSizeClass: The callback to handle size-class updates
    /// - Returns: Drawer
    func onLayoutForSizeClass(_ didLayoutForSizeClass: @escaping (SizeClass) -> ()) -> Drawer {
        return Drawer(
            heights: $heights,
            height: height,
            restingHeight: restingHeight,
            springHeight: springHeight,
            didRest: didRest,
            didLayoutForSizeClass: didLayoutForSizeClass,
            impactGenerator: impactGenerator,
            content: content)
    }
}
