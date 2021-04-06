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
        
        ImageView(withURL: image)
    }
}


