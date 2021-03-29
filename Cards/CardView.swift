//
//  Card.swift
//  Cards
//
//  Created by Kaleb Page on 3/21/21.
//

import SwiftUI

struct CardView: View {
    
    @Binding var image: String
    
    var body: some View {
//        Image(uiImage: image)
//            .resizable()
//            .frame(width: 75, height: 100, alignment: .center)
        ImageView(withURL: image)
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
