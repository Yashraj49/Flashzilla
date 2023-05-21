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
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    ///   That gives the user 100 seconds to start with, then creates and starts a timer that fires once a second on the main thread.
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var scale = 1.0
    @State private var cards = [Card] (repeating: Card.example, count: 10)
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    func removeCard(at index: Int) {
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        cards = [Card](repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
    }
    
    var body: some View {
        ZStack {
            Image("background")
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
                
                if differentiateWithoutColor {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                            Spacer()
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding()
                        
                        
                        
                        
                    }
                }
                
                
                
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                    }
                    
                }
                .allowsHitTesting(timeRemaining > 0)
                if cards.isEmpty {
                    Button("Start Again" , action: resetCards)
                        .padding()
                        .background()
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
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
