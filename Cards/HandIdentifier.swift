//
//  HandIdentifier.swift
//  Cards
//
//  Created by Kaleb Page on 4/5/21.
//

import Foundation
import SwiftUI

struct HandIdentifier {
    
    @Binding var currentCards: [Card]
    
    //MARK: Finding the hand
    
    func getMatches() -> [String: Int] {
        
        var dictionary: [String: Int] = ["ACE" : 0, "KING" : 0, "QUEEN" : 0, "JACK" : 0, "10" : 0, "9" : 0, "8" : 0, "7" : 0, "6" : 0, "5" : 0, "4" : 0, "3" : 0, "2" : 0]
        
        //make sure the array runs only once for each card
        var previousMatchedCards: [String] = []
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
        return dictionary
    }
    
    func getHand() -> (String, String) {
        var sortedList: [Int] = []
        
        //1 - CHECK FOR A FLUSH
        
        if let firstCard = currentCards.first {
            var numberOfMatchingSuits: Int = 0
            
            for (_, card) in currentCards.enumerated() {
                if card.suit == firstCard.suit {
                    numberOfMatchingSuits += 1
                }
                
            }
            
            
            let cards = getMatches()
            
            var finalDictionary: [String: Int] = [:]
            
            //filter data into a final dictionary
            
            for (value, amount) in cards {
                if amount > 0 {
                    finalDictionary.updateValue(amount, forKey: value)
                }
            }
            
            //DETERMINE WHAT HAND WAS DRAWN
            
            //ROYAL FLUSH
            
            if finalDictionary["ACE"] == 1, finalDictionary["KING"] == 1, finalDictionary["QUEEN"] == 1, finalDictionary["JACK"] == 1, finalDictionary["10"] == 1 {
                
                if numberOfMatchingSuits == 5 {
                    return ("Royal Flush", "Guaranteed Game Winner!")
                } else {
                    return ("Straight", "Very Good!")
                }
                
                //CHECK FOR STRAIGHT FLUSH AND STRAIGHT
                
            } else {
                var list: [Int] = []
                for (value, amount) in finalDictionary {
                    
                    switch value {
                    case "ACE": list.append(Int("14")!)
                        
                    case "KING": list.append(Int("13")!)
                        
                    case "QUEEN": list.append(Int("12")!)
                        
                    case "JACK": list.append(Int("11")!)
                        
                    default:
                        for _ in 1...amount {
                            list.append(Int("\(value)")!)
                        }
                    }
                }
                sortedList = list.sorted()
                let consecutives = sortedList.map { $0 - 1 }.dropFirst() == sortedList.dropLast()
                print(sortedList)
                print(consecutives)
                if consecutives == true && sortedList.count == 5 {
                    if numberOfMatchingSuits == 5 {
                        return ("Straight Flush", "Awesome! Second-best hand in the game!")
                    } else {
                        return ("Straight", "Very Good!")
                    }
                    
                } else {
                    
                    var foundPairsNames: [String] = []
                    var foundTriplesNames: [String] = []
                    var foundPairs: Int = 0
                    var foundTriples: Int = 0
                    for (value, amount) in finalDictionary {
                        
                        
                        //FOUR OF A KIND
                        if amount == 4 {
                            return ("Four of a kind - \(value.lowercased().capitalizingFirstLetter())s", "Very Excellent Hand!!")
                        }
                        
                        //FLUSH
                        if numberOfMatchingSuits == 5 {
                            return ("Flush", "Great!!")
                        }
                        
                        if amount == 3 {
                            foundTriplesNames.append(value)
                            foundTriples += 1
                        }
                        
                        if amount == 2 {
                            foundPairsNames.append(value)
                            foundPairs += 1
                        }
                        
                    }
                    if foundPairs == 1 && foundTriples == 1 {
                        return ("Full House - 2 \(foundPairsNames.first!.lowercased().capitalizingFirstLetter())s and 3 \(foundTriplesNames.first!.lowercased().capitalizingFirstLetter())s", "Excellent Hand!")
                    }
                    if foundPairs == 2 {
                        return ("Two Pairs - \(foundPairsNames.first!.lowercased().capitalizingFirstLetter())s and \(foundPairsNames[1].lowercased().capitalizingFirstLetter())s", "Not Bad...")
                    }
                    if foundTriples == 1 && foundPairs == 0 {
                        return ("Three of a kind - \(foundTriplesNames.first!.lowercased().capitalizingFirstLetter())s", "Good!")
                    }
                    if foundPairs == 1 && foundTriples == 0 {
                        return ("Two of a kind - \(foundPairsNames.first!.lowercased().capitalizingFirstLetter())s", "Eh...")
                    }
                    if foundPairs == 0 && foundTriples == 0 {
                        var previousCard = Int()
                        for cardNumber in sortedList {
                            if cardNumber > previousCard {
                                previousCard = cardNumber
                            }
                        }
                        let randomInt = Int.random(in: 0...2)
                        var highCardPhrase = ""
                        
                        switch randomInt {
                        case 0:
                            highCardPhrase = "Hope you have a good poker face."
                        case 1: highCardPhrase = "👎"
                            
                        case 2: highCardPhrase = "That's not too good."
                            
                        default:
                            break
                        }
                        switch previousCard {
                        case 14: return ("High Card - Ace", highCardPhrase)
                            
                        case 13: return ("High Card - King", highCardPhrase)
                            
                        case 12: return ("High Card - Queen", highCardPhrase)
                            
                        case 11: return ("High Card - Jack", highCardPhrase)
                            
                        default:
                            return ("High Card - \(previousCard)", highCardPhrase)
                        }
                        
                    }
                    
                }
                
            }
        } else {
            return ("Draw a hand first.", "")
        }
        return ("", "")
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
