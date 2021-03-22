//
//  ContentView.swift
//  Cards
//
//  Created by Kaleb Page on 3/21/21.
//

import SwiftUI

struct ContentView: View {
    @State var buttonText = "Draw"
    @State var cardImages: [UIImage] = [UIImage(named: "DC")!, UIImage(named: "DC")!, UIImage(named: "DC")!, UIImage(named: "DC")!, UIImage(named: "DC")!]
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                CardView(image: $cardImages[0])
                Spacer()
                CardView(image: $cardImages[1])
                Spacer()
                CardView(image: $cardImages[2])
                Spacer()
            }
            .padding()
            HStack {
                Spacer()
                CardView(image: $cardImages[3])
                Spacer()
                CardView(image: $cardImages[4])
                Spacer()
            }
            .padding()
            
            Spacer()
            
        Button(action: {
            buttonText = "Redraw"
            
            fetchData()
            
            
        }, label: {
            Text(buttonText)
        })
        .padding()
        .accentColor(.white)
        .background(Color.blue)
        .cornerRadius(10.0)
            
            Spacer()
        }
    }
    
    func fetchData() {
        let decoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with: URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=5")!) { (data, response, error) in
            if let newData = data {

                let response = try? decoder.decode(ResponseObject.self, from: newData)
                
                for (index, card) in response!.cards.enumerated() {
                    let task = URLSession.shared.dataTask(with: URL(string: card.image)!) { (data, response, error) in
//                            cardImages.append(UIImage(data: data!)!)
                        cardImages.insert(UIImage(data: data!)!, at: index)
                    }
                    task.resume()
                }
                
                print(cardImages)

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
