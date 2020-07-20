//
//  Drawer+Computed.swift
//
//
//  Created by Michael Verges on 7/18/20.
//

import SwiftUI

extension Drawer {
    // MARK: Height Calculation
    
    /// The height of the drawer to be shown at maximum spring height
    internal var fullHeight: CGFloat {
        return heights.max()! + springHeight
    }
    
    internal var activeBound: ClosedRange<CGFloat> {
        return heights.min()!...heights.max()!
    }
    
    // MARK: View
    
    private var offset: CGFloat {
        if !dragging && !heights.contains(restingHeight) {
            DispatchQueue.main.async {
                let newHeight = Drawer.closest(self.restingHeight, markers: self.heights)
                self.restingHeight = newHeight
                self.height = newHeight
            }
        }
        return -$height.wrappedValue
    }
    
    public var body: some View {
        
        if (sizeClass != SizeClass(
            horizontal: horizontalSizeClass,
            vertical: verticalSizeClass)) {
            DispatchQueue.main.async {
                self.sizeClass = SizeClass(
                    horizontal: self.horizontalSizeClass,
                    vertical: self.verticalSizeClass)
            }
        }
        
        return GeometryReader { (proxy) in
            VStack {
                Spacer()
                    .frame(height:
                        proxy.frame(in: .global).height + self.fullHeight
                            /*+ (landscape ? 20 : 0)*/)

                self.content
                    .frame(height: self.fullHeight)
                    .offset(y: self.offset)
                    .animation(self.animation)
                    .gesture(self.dragGesture)
            }
        }
    }
}
