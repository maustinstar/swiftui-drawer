//
//  Drawer.swift
//
//
//  Created by Michael Verges on 7/14/20.
//

import SwiftUI

/// A bottom-up view that conforms to multiple heights
public struct Drawer<Content>: View where Content: View {
    
    // MARK: Public Variables
    
    /// The possible resting heights of the drawer
    @Binding public var heights: [CGFloat]
    
    /// The current height of the displayed drawer
    @State public var height: CGFloat
    
    /// The current height marker the drawer is conformed to. Change triggers `onRest`
    @State internal var restingHeight: CGFloat {
        didSet {
            didRest?(restingHeight)
        }
    }
    
    /// A callback executed when the drawer reaches a restingHeight
    internal var didRest: ((_ height: CGFloat) -> ())? = nil
    
    // MARK: Orientation
    
    public struct SizeClass: Equatable {
        var horizontal: UserInterfaceSizeClass?
        var vertical: UserInterfaceSizeClass?
    }
    
    @Environment(\.verticalSizeClass) internal var verticalSizeClass
    @Environment(\.horizontalSizeClass) internal var horizontalSizeClass
    @State internal var sizeClass: SizeClass = SizeClass(
        horizontal: nil,
        vertical: nil) {
        didSet { didLayoutForSizeClass?(sizeClass) }
    }
    
    /// A callback executed when the drawer is layed out for a new size class
    internal var didLayoutForSizeClass: ((SizeClass) -> ())? = nil
    
    // MARK: Gestures
    
    @State internal var dragging: Bool = false
    
    // MARK: Animation
    
    /// Additional height to spring past the last height marker
    internal var springHeight: CGFloat = 12
    
    @State internal var animation: Animation? = Animation.spring()
    
    // MARK: Haptics
    
    internal var impactGenerator: UIImpactFeedbackGenerator?
    
    // MARK: View
    
    internal var content: Content
}

// MARK: Public init

public extension Drawer {
    
    /// A bottom-up view that conforms to multiple heights
    /// - Parameters:
    ///   - heights: The possible resting heights of the drawer
    ///   - startingHeight: The starting height of the drawer. Defaults to the first height marker if not specified
    ///   - content: The view that defines the drawer
    init(
        heights: Binding<[CGFloat]> = .constant([0]),
        startingHeight: CGFloat? = nil,
        @ViewBuilder _ content: () -> Content
    ) {
        self._heights = heights
        self._height = .init(initialValue: startingHeight ?? heights.wrappedValue.first!)
        self._restingHeight = .init(initialValue: startingHeight ?? heights.wrappedValue.first!)
        self.content = content()
    }
}

// MARK: Internal Init

internal extension Drawer {
    init(
        heights: Binding<[CGFloat]>,
        height: CGFloat,
        restingHeight: CGFloat,
        springHeight: CGFloat,
        didRest: ((_ height: CGFloat) -> ())?,
        didLayoutForSizeClass: ((SizeClass) -> ())?,
        impactGenerator: UIImpactFeedbackGenerator?,
        content: Content
    ) {
        self._heights = heights
        self._height = .init(initialValue: height)
        self._restingHeight = .init(initialValue: restingHeight)
        self.springHeight = springHeight
        self.didRest = didRest
        self.didLayoutForSizeClass = didLayoutForSizeClass
        self.content = content
        self.impactGenerator = impactGenerator
    }
}

public enum DrawerAlignment {
    case leading, center, trailing, fullscreen
}
