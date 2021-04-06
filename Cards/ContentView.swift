//
//  ContentView.swift
//  Cards
//
//  Created by Kaleb Page on 3/21/21.
//

import SwiftUI

struct ContentView: View {
    
    //Default Images
    @State var cardImageURLs: [String] = ["https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg", "https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg", "https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg", "https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg", "https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg"]
    
    @State var buttonText = "Draw"
    @State var currentCards: [Card] = []
    @State var currentHandText: String = ""
    @State var rating: String = ""
    @State var highestCard: Card?
    @State var flipped: Bool = false
    
    
    //MARK: Views
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                CardView(image: $cardImageURLs[0])
                    .rotation3DEffect(self.flipped ? Angle(degrees: 360): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                    .animation(.default)
                Spacer()
                CardView(image: $cardImageURLs[1])
                    .rotation3DEffect(self.flipped ? Angle(degrees: 360): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                    .animation(.default)
                Spacer()
                CardView(image: $cardImageURLs[2])
                    .rotation3DEffect(self.flipped ? Angle(degrees: 360): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                    .animation(.default)
                Spacer()
            }
            .padding()
            HStack {
                Spacer()
                CardView(image: $cardImageURLs[3])
                    .rotation3DEffect(self.flipped ? Angle(degrees: 360): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                    .animation(.default)
                Spacer()
                CardView(image: $cardImageURLs[4])
                    .rotation3DEffect(self.flipped ? Angle(degrees: 360): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                    .animation(.default)
                Spacer()
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                currentHandText = ""
                rating = ""
                buttonText = "Redraw"
                flipped.toggle()
                fetchData()
                
            }, label: {
                Text(buttonText)
            })
            .padding()
            .accentColor(.white)
            .background(Color.blue)
            .cornerRadius(10.0)
            
            Spacer()
            VStack {
                Button(action: {
                    let result = HandIdentifier(currentCards:
                                                    $currentCards).getHand()
                    self.currentHandText = "\(result.0)"
                    self.rating = "\(result.1)"
                    
                }, label: {
                    Text("Evaluate Hand")
                })
                .padding()
                
                Text(currentHandText)
                    .padding()
                
                Text(rating)
                    .bold()
            }
            Spacer()
        }
    }
    
    //MARK: API Call and JSON Decoding
    
    func fetchData() {
        let decoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with: URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=5")!) { (data, response, error) in
            if let newData = data {
                
                let response = try? decoder.decode(ResponseObject.self, from: newData)
                currentCards = response!.cards
                
                for (index, card) in currentCards.enumerated() {
                    print(card)
                    cardImageURLs.insert(card.image, at: index)
                }
            }
        }
        task.resume()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
