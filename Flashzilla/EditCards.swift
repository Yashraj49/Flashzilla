//
//  EditCards.swift
//  Flashzilla
//
//  Created by Yashraj jadhav on 29/05/23.
//

import SwiftUI

struct CardsData {
    static let jsonFileURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("cards.json")
    }()
    
    static func loadCards() -> [Card] {
        do {
            let jsonData = try Data(contentsOf: jsonFileURL)
            let decodedCards = try JSONDecoder().decode([Card].self, from: jsonData)
            return decodedCards
        } catch {
            print("Error loading JSON data: \(error)")
            return []
        }
    }
    
    static func saveCards(_ cards: [Card]) {
        do {
            let jsonData = try JSONEncoder().encode(cards)
            try jsonData.write(to: jsonFileURL)
        } catch {
            print("Error saving JSON data: \(error)")
        }
    }
}



struct EditCards: View {
    @Environment(\.dismiss) var dismiss
   
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    static let jsonFileURL: URL = {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return documentsDirectory.appendingPathComponent("cards.json")
        }()
    
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                    
                    
                    
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
            .onAppear(perform: loadData)
        }
    }
    
    
    func done() {
        dismiss()
    }
    
    func getJsonFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let jsonFileUrl = paths.appendingPathComponent("cards.json")
        
        return jsonFileUrl
    }
    
    func loadData() {
        cards = CardsData.loadCards()
        
        
    }
    
    func saveData() {
     CardsData.saveCards(cards)
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        saveData()
        newPrompt = ""
        newAnswer = ""
        
    }
    
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
    
    
    
}





struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards()
    }
}
