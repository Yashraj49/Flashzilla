//
//  ContentView.swift
//  Flashzilla
//
//  Created by Yashraj jadhav on 16/05/23.
//
import CoreHaptics
import SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}

struct ContentView: View {
    @State private var showingEditScreen = false
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    @State private var timeRemaining = 100
    @State private var feedback = UINotificationFeedbackGenerator()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    ///   That gives the user 100 seconds to start with, then creates and starts a timer that fires once a second on the main thread.
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var scale = 1.0
    @State private var cards = [Card]()
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        cards = [Card](repeating: Card.example, count: 10)
        timeRemaining = 100
        loadData()
        isActive = true
    }
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            
            VStack {
                
                Text("Time : \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal,20)
                    .padding(.vertical,5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                
                
                
                
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                    
                }
                .allowsHitTesting(timeRemaining > 0)

                VStack {
                    HStack {
                        Spacer()

                        Button {
                            showingEditScreen = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }

                    Spacer()
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                .padding()

                if differentiateWithoutColor || voiceOverEnabled {
                    VStack {
                        Spacer()

                        HStack {
                            Button {
                                withAnimation {
                                    removeCard(at: cards.count - 1)
                                }
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .padding()
                                    .background(.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            .accessibilityLabel("Wrong")
                            .accessibilityHint("Mark your answer as being incorrect")

                            Spacer()

                            Button {
                                withAnimation {
                                    removeCard(at: cards.count - 1)
                                }
                            } label: {
                                Image(systemName: "checkmark.circle")
                                    .padding()
                                    .background(.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            .accessibilityLabel("Correct")
                            .accessibilityHint("Mark your answer is being correct.")
                        }
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding()
                    }
                }
            }
            .onReceive(timer) { time in
                guard isActive else { return }

                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    if cards.isEmpty == false {
                        isActive = true
                    }
                } else {
                    isActive = false
                }
            }

            .onAppear(perform: resetCards)
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
                .onAppear(perform: resetCards)
        }
        
                
                .onReceive(timer) {time in
                    guard isActive else {return}
                    
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                    
                    
                    
                    
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        if cards.isEmpty == false {
                            isActive = true
                        }
                    } else {
                        isActive = false
                    }
                }
            }
        }
    







extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
