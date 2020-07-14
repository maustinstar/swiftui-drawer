//
//  Drawer.swift
//
//
//  Created by Michael Verges on 7/14/20.
//  Copyright © 2020 littlnotes. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

/// A bottom-up view that conforms to multiple heights
public struct Drawer<Content>: View where Content: View {
    
    private var content: Content
    
    /// A bottom-up view that conforms to multiple heights
    /// - Parameters:
    ///   - heights: The possible resting heights of the drawer
    ///   - startingHeight: The starting height of the drawer. Defaults to the first height marker if not specified
    ///   - content: The view that defines the drawer
    public init(heights: [CGFloat], startingHeight: CGFloat? = nil, @ViewBuilder _ content: () -> Content) {
        self.heights = heights
        self._height = .init(initialValue: startingHeight ?? heights.first!)
        self._restingHeight = .init(initialValue: startingHeight ?? heights.first!)
        self.content = content()
    }
    
    /// Additional height to spring past the last height marker
    private let springHeight: CGFloat = 12
    
    /// The height of the drawer to be shown at maximum spring height
    private var fullHeight: CGFloat {
        return heights.max()! + springHeight
    }
    
    /// The current height of the displayed drawer
    @State public var height: CGFloat
    
    /// The current height marker the drawer is conformed to
    @State private var restingHeight: CGFloat
    
    /// The possible resting heights of the drawer
    public var heights: [CGFloat]
    
    private var dragGesture: some Gesture {
        return DragGesture().onChanged({ (value) in
            self.height = min(
                -value.location.y + value.startLocation.y + self.restingHeight,
                self.fullHeight)
        }).onEnded({ (value) in
            let change = value.startLocation.y - value.predictedEndLocation.y + self.restingHeight
            let first = self.heights.first!
            self.height = self.heights.reduce(
                (first, abs(first - change))
            ) { (current, value) -> (CGFloat, CGFloat) in
                if current.1 > abs(value - change) {
                    return (value, abs(value - change))
                }
                return current
            }.0
            self.restingHeight = self.height
        })
    }
    
    public var body: some View {
        
        VStack {
            Spacer()
                .frame(width: 20.0)
                .frame(width: 20.0)
                .frame(height: UIScreen.main.bounds.height + fullHeight)
            content
                .frame(height: self.fullHeight)
                .offset(y: -$height.wrappedValue)
                .animation(.default)
                .gesture(dragGesture)
        }
        .frame(height: UIScreen.main.bounds.height)
    }
}

struct Drawer_Previews: PreviewProvider {
    
    @State static var query = ""
    
    static var previews: some View {
        Group {
            Drawer(heights: [100, 340, UIScreen.main.bounds.height - 40]) {
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.white)
                        .shadow(radius: 100)
                    
                    VStack(alignment: .center) {
                        Spacer().frame(height: 4.0)
                        RoundedRectangle(cornerRadius: 3.0)
                            .foregroundColor(.gray)
                            .frame(width: 30.0, height: 6.0)
                        Spacer()
                    }
                }
            }
            
            Drawer(heights: [100, 340]) {
                Color.blue
            }
        }
    }
}

#endif
