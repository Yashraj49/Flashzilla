//
//  Card.swift
//  Flashzilla
//
//  Created by Yashraj jadhav on 18/05/23.
//

import Foundation
import SwiftUI


struct Card : Codable , Identifiable {
    
    var id  = UUID()
    let prompt : String
    let answer : String
    
    static var example : Card {
        return Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
    
    
    
}
