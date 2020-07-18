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
        let height = lockedHeight(restingHeight)
        return locked
            ? height...height
            : heights.min()!...heights.max()!
    }
    
    // MARK: View
    
    private var offset: CGFloat {
        if locked && !dragging {
            DispatchQueue.main.async {
                let newHeight = self.lockedHeight(self.restingHeight)
                self.restingHeight = newHeight
                self.height = newHeight
            }
        }
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
        
        return VStack {
            Spacer()
                .frame(height:
                    UIScreen.main.bounds.height + fullHeight
                        /*+ (landscape ? 20 : 0)*/)
            
            HStack {
                if (alignment == .trailing || alignment == .center) {
                    Spacer().animation(.default)
                }
                content
                    .frame(height: fullHeight)
                    .offset(y: offset)
                    .animation(animation)
                    .gesture(dragGesture)
                    .frame(width: alignment == .fullscreen ? nil : fixedWidth)
                if (alignment == .leading || alignment == .center) {
                    Spacer().animation(.default)
                }
            }
        }
    }
}
