//
//  ImageLoader.swift
//  Cards
//
//  Created by Kaleb Page on 3/27/21.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image: UIImage = UIImage()
    @State var showBack: Bool = true
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        
        VStack {
            if showBack {
                Image("DC")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75, height: 100)
            } else {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75, height: 100)
            }
        }
        .onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
            self.showBack = false
        }
    }
}
