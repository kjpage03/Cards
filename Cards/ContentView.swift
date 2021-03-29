//
//  ContentView.swift
//  Cards
//
//  Created by Kaleb Page on 3/21/21.
//

import SwiftUI

struct ContentView: View {
    @State var buttonText = "Draw"
//    @State var cardImages: [UIImage] = [UIImage(named: "DC")!, UIImage(named: "DC")!, UIImage(named: "DC")!, UIImage(named: "DC")!, UIImage(named: "DC")!]
    @State var cardImageURLs: [String] = ["https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg", "https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg", "https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg", "https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg", "https://s3.amazonaws.com/images.penguinmagic.com/images/products/original/5075a.jpg"]
    @State var currentCards: [Card] = []
    @State var currentHandText: String = "Hand - "
    @State var highestCard: Card?
    
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                CardView(image: $cardImageURLs[0])
                Spacer()
                CardView(image: $cardImageURLs[1])
                Spacer()
                CardView(image: $cardImageURLs[2])
                Spacer()
            }
            .padding()
            HStack {
                Spacer()
                CardView(image: $cardImageURLs[3])
                Spacer()
                CardView(image: $cardImageURLs[4])
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
            Button(action: {
                self.currentHandText = "Hand - \(getHand())"
                
            }, label: {
                Text(currentHandText)
            })
            Spacer()
        }
    }
    
    func getHand() -> String {
        
        //Check for a royal flush
        
        //1 - CHECK FOR A FLUSH
        
        let firstSuit = currentCards.first!.suit
        var numberOfMatchingSuits: Int = 0
        
        for (index, card) in currentCards.enumerated() {
            if card.suit == firstSuit {
                numberOfMatchingSuits += 1
            }
            //            print(index)
            //            print(numberOfMatchingSuits)
        }
        
        let cards = getMatches()
        //        var threeMatching: Int = 0
        //        var twoMatching: Int = 0
        var finalDictionary: [String: Int] = [:]
        
        //filter data into a final dictionary
        
        for (value, amount) in cards {
            if amount > 0 {
//                print("\(value) - \(amount)")
                finalDictionary.updateValue(amount, forKey: value)
            }
        }
        
        //DETERMINE WHAT HAND WAS DRAWN
                
        //ROYAL FLUSH
        
        if finalDictionary["ACE"] == 1, finalDictionary["KING"] == 1, finalDictionary["QUEEN"] == 1, finalDictionary["JACK"] == 1, finalDictionary["10"] == 1 {
            
            if numberOfMatchingSuits == 5 {
            return "Royal Flush"
            } else {
            return "Straight"
            }
            
        //CHECK FOR STRAIGHT FLUSH AND STRAIGHT
            
        } else {
            var list: [Int] = []
            //FIX THIS
            for (value, _) in finalDictionary {
            
                switch value {
                case "ACE": list.append(Int("14")!)
                    
                case "KING": list.append(Int("13")!)
                    
                case "QUEEN": list.append(Int("12")!)
                    
                case "JACK": list.append(Int("11")!)
                    
                default:
                    list.append(Int("\(value)")!)
                }
            }
            let sortedList = list.sorted()
            let consecutives = sortedList.map { $0 - 1 }.dropFirst() == sortedList.dropLast()
//            print(sortedList)
//            print(consecutives)
            if consecutives == true && sortedList.count == 5 {
                if numberOfMatchingSuits == 5 {
                    return "Straight Flush"
                } else {
                    return "Straight"
                }
                
            } else {
                
                var foundPairsNames: [String] = []
                var foundTriplesNames: [String] = []
                var foundPairs: Int = 0
                var foundTriples: Int = 0
                for (value, amount) in finalDictionary {
                    
                    
                    //FOUR OF A KIND
                    if amount == 4 {
                        return "Four of a kind - \(value.lowercased())s"
                    }
                    
                    //FLUSH
                    if numberOfMatchingSuits == 5 {
                        return "Flush"
                    }
                    
                    
                    if amount == 3 {
//                        return "3 \(value.lowercased())s"
                        foundTriplesNames.append(value)
                        foundTriples += 1
                    }
                    
                    
                    if amount == 2 {
        //                return "Pair of \(value.lowercased())s"
                        foundPairsNames.append(value)
                        foundPairs += 1
                    }

                }
                if foundPairs == 1 && foundTriples == 1 {
                    return "Full House - 2 \(foundPairsNames.first!)s and 3 \(foundTriplesNames.first!)s"
                }
                if foundPairs == 2 {
                    return "Two Pairs - \(foundPairsNames.first!)s and \(foundPairsNames[1])s "
                }
                if foundTriples == 1 && foundPairs == 0 {
                    return "Three of a kind - \(foundTriplesNames.first!)s"
                }
                if foundPairs == 1 && foundTriples == 0 {
                    return "Two of a kind - \(foundPairsNames.first!)s"
                }
                if foundPairs == 0 && foundTriples == 0 {
                    return "find the highest card"
                }
                
            }
            
        }
        
        return ""
        
    }
    
    func getMatches() -> [String: Int] {
        
        var dictionary: [String: Int] = ["ACE" : 0, "KING" : 0, "QUEEN" : 0, "JACK" : 0, "10" : 0, "9" : 0, "8" : 0, "7" : 0, "6" : 0, "5" : 0, "4" : 0, "3" : 0, "2" : 0]
        
        //make sure the array runs only once for each card
        var previousMatchedCards: [String] = []
//        print(currentCards)
        for currentCard in currentCards {
            if !previousMatchedCards.contains(currentCard.value){
                for card in currentCards {
                    if card.value == currentCard.value {
                        previousMatchedCards.append(card.value)
                        if let int = dictionary[card.value] {
                            dictionary.updateValue(int + 1, forKey: card.value)
                        }
                    }
                }
            }
        }
//        print(dictionary)
        return dictionary
    }
    
    
    
    func fetchData() {
        print("\u{001B}[2J")
        let decoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with: URL(string: "https://deckofcardsapi.com/api/deck/new/draw/?count=5")!) { (data, response, error) in
            if let newData = data {
                
                let response = try? decoder.decode(ResponseObject.self, from: newData)
                currentCards = response!.cards

                for (index, card) in currentCards.enumerated() {
//                    let task = URLSession.shared.dataTask(with: URL(string: card.image)!) { (data, response, error) in
                        //do some investigating in here
//                        print("START")
//                        print(card)
                        cardImageURLs.insert(card.image, at: index)
                        //                            cardImages.append(UIImage(data: data!)!)
//                        cardImages.insert(UIImage(data: data!)!, at: index)
//                        print(card.image)
//                        print("END")
//                    }
//                    task.resume()
                }
//                print("START CARDS")
//                print(response?.cards)
//                print("END CARDS")
//                print(response?.cards.count)
//                print(cardImages)
                
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
