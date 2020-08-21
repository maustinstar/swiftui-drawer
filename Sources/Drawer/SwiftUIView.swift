//
//  SwiftUIView.swift
//  
//
//  Created by Michael Verges on 7/20/20.
//

import SwiftUI

#if DEBUG
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Drawer {
            Color.blue
        }
        .rest(at: .constant([100, 340]))
        .edgesIgnoringSafeArea(.vertical)
    }
}
#endif
