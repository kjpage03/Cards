//
//  CardFlipper.swift
//  Cards
//
//  Created by Kaleb Page on 3/30/21.
//

import SwiftUI

struct CardFlipper: View {
    @State var flipped = false
    
    var body: some View {
        Image(flipped ? "KH" : "DC")
            .resizable()
            .frame(width: 75, height: 100, alignment: .center)
            .rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
            .animation(.default)
            .onTapGesture {
                self.flipped.toggle()
            }
    }
}

struct CardFlipper_Previews: PreviewProvider {
    static var previews: some View {
        CardFlipper()
    }
}
