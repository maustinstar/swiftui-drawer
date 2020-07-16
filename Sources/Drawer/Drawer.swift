//
//  Drawer.swift
//
//
//  Created by Michael Verges on 7/14/20.
//

import SwiftUI

/// A bottom-up view that conforms to multiple heights
public struct Drawer<Content>: View where Content: View {
    
    // MARK: Public Init
    
    /// A bottom-up view that conforms to multiple heights
    /// - Parameters:
    ///   - heights: The possible resting heights of the drawer
    ///   - startingHeight: The starting height of the drawer. Defaults to the first height marker if not specified
    ///   - content: The view that defines the drawer
    public init(
        heights: [CGFloat],
        startingHeight: CGFloat? = nil,
        @ViewBuilder _ content: () -> Content
    ) {
        self.heights = heights
        self._height = .init(initialValue: startingHeight ?? heights.first!)
        self._restingHeight = .init(initialValue: startingHeight ?? heights.first!)
        self.content = content()
        self._locked = .constant(false)
        self.lockedHeight = { _ in return CGFloat.zero }
    }
    
    // MARK: Public Init
    
    /// A bottom-up view that conforms to multiple heights
    /// - Parameters:
    ///   - heights: The possible resting heights of the drawer
    ///   - startingHeight: The starting height of the drawer. Defaults to the first height marker if not specified
    ///   - content: The view that defines the drawer
    @available(*, deprecated)
    public init(
        heights: [CGFloat],
        startingHeight: CGFloat? = nil,
        impact: UIImpactFeedbackGenerator.FeedbackStyle?,
        @ViewBuilder _ content: () -> Content
    ) {
        self.heights = heights
        self._height = .init(initialValue: startingHeight ?? heights.first!)
        self._restingHeight = .init(initialValue: startingHeight ?? heights.first!)
        self.content = content()
        if let impact = impact {
            self.impactGenerator = UIImpactFeedbackGenerator(style: impact)
        }
        self._locked = .constant(false)
        self.lockedHeight = { _ in return CGFloat.zero }
    }
    
    // MARK: Public Variables
    
    /// The possible resting heights of the drawer
    public var heights: [CGFloat]
    
    /// The current height of the displayed drawer
    @State public var height: CGFloat
    
    // MARK: Height Calculation
    
    /// The height of the drawer to be shown at maximum spring height
    internal var fullHeight: CGFloat {
        return heights.max()! + springHeight
    }
    
    internal var activeBound: ClosedRange<CGFloat> {
        let height = lockedHeight(restingHeight)
        return locked
            ? height...height
            : heights.min()!...heights.max()!
    }
    
    /// The current height marker the drawer is conformed to. Change triggers `onRest`
    @State internal var restingHeight: CGFloat {
        didSet {
            didRest?(restingHeight)
        }
    }
    
    internal var didRest: ((_ height: CGFloat) -> ())? = nil
    
    @Binding internal var locked: Bool
    
    internal var lockedHeight: (_ restingHeight: CGFloat) -> CGFloat
    
    // MARK: Gestures
    
    @State internal var dragging: Bool = false
    
    private var dragGesture: some Gesture {
        return DragGesture().onChanged({ (value) in
            self.dragChanged(value)
        }).onEnded({ (value) in
            self.dragEnded(value)
        })
    }
    
    // MARK: Animation
    
    /// Additional height to spring past the last height marker
    internal var springHeight: CGFloat = 12
    
    @State internal var animation: Animation? = Animation.spring()
    
    // MARK: Haptics
    
    internal var impactGenerator: UIImpactFeedbackGenerator?
    
    // MARK: View
    
    internal var content: Content
    
    public var body: some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.main.bounds.height + fullHeight)
                
            content
                .frame(height: self.fullHeight)
                .offset(y: {
                    if $locked.wrappedValue
                        && !$dragging.wrappedValue {
                        DispatchQueue.main.async {
                            let newHeight = self.lockedHeight(self.restingHeight)
                            self.restingHeight = newHeight
                            self.height = newHeight
                        }
                    }
                    return -$height.wrappedValue
                }())
                .animation(animation)
                .gesture(dragGesture)
        }
        .frame(height: UIScreen.main.bounds.height)
    }
}

// MARK: Internal init

internal extension Drawer {
    init(
        heights: [CGFloat],
        height: CGFloat,
        restingHeight: CGFloat,
        springHeight: CGFloat,
        didRest: ((_ height: CGFloat) -> ())?,
        impactGenerator: UIImpactFeedbackGenerator?,
        locked: Binding<Bool>,
        lockedHeight: @escaping (CGFloat) -> CGFloat,
        content: Content
    ) {
        self.heights = heights
        self._height = .init(initialValue: height)
        self._restingHeight = .init(initialValue: restingHeight)
        self.springHeight = springHeight
        self.didRest = didRest
        self.content = content
        self.impactGenerator = impactGenerator
        self.lockedHeight = lockedHeight
        self._locked = locked
        
    }
}
