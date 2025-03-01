//
//  ContentView.swift
//  Swift UI Slots
//
//  Created by Andrew Betancourt on 8/16/22.
//

import SwiftUI

struct ContentView: View
{
    
    @State private var credits = 100
    @State private var symbols = ["apple", "star", "cherry"]
    @State private var numbers = Array(repeating: 0, count: 9)
    @State private var backgrounds = Array(repeating: Color.white, count: 9)
    private var betAmount = 25
    private var maxSpinBetAmount = 50
    
    var body: some View
    {
        ZStack
        {
            //Background
            Rectangle()
            .foregroundColor(Color(red: 200/255, green: 143/255, blue: 32/255))
            .ignoresSafeArea(.all)
            
            Rectangle()
            .foregroundColor(Color(red: 228/255, green: 195/256, blue: 76/255))
            .rotationEffect(Angle(degrees: 45))
            .edgesIgnoringSafeArea(.all)
            
            VStack
            {
                Spacer()
                
                HStack
                {
                    Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    
                    Text("Swift UI Slots")
                    .bold()
                    .foregroundColor(.white)
                    
                    Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    
                }.scaleEffect(2)
                
                Spacer()
                
                //Cresits counter
                Text("Credits: " + String(credits))
                .foregroundColor(.black)
                .padding(.all, 10)
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                
                Spacer()
                
                //Cards
                
                VStack
                {
                
                    HStack
                    {
                        Spacer()
                        CardView(symbol: $symbols[numbers[0]], backgrounds: $backgrounds[0])
                        CardView(symbol: $symbols[numbers[1]], backgrounds: $backgrounds[1])
                        CardView(symbol: $symbols[numbers[2]], backgrounds: $backgrounds[2])
                        Spacer()
                    }
                    HStack
                    {
                        Spacer()
                        CardView(symbol: $symbols[numbers[3]], backgrounds: $backgrounds[3])
                        CardView(symbol: $symbols[numbers[4]], backgrounds: $backgrounds[4])
                        CardView(symbol: $symbols[numbers[5]], backgrounds: $backgrounds[5])
                        Spacer()
                    }
                    HStack
                    {
                        Spacer()
                        CardView(symbol: $symbols[numbers[6]], backgrounds: $backgrounds[6])
                        CardView(symbol: $symbols[numbers[7]], backgrounds: $backgrounds[7])
                        CardView(symbol: $symbols[numbers[8]], backgrounds: $backgrounds[8])
                        Spacer()
                    }
                
                }
                
                Spacer()
                
                //Buttons
                
                HStack (spacing: 20)
                {
                    VStack
                    {
                        Button(action: {
                            
                            //Process a single spin
                            processResults()
                            
                        },
                            label: {
                            
                            Text("Spin")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.all, 10)
                            .padding([.leading, .trailing], 30)
                            .background(.pink)
                            .cornerRadius(20)
                        })
                        
                            Text("\(betAmount) Credits")
                            .padding(.top, 10)
                            .font(.footnote)
                        
                    }
                    .disabled(credits < betAmount)
                    VStack
                    {
                        Button(action: {
                            
                            //Process all spins
                            processResults(true)
                            
                        },
                            label: {
                            
                            Text("Max Spin")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.all, 10)
                            .padding([.leading, .trailing], 30)
                            .background(.pink)
                            .cornerRadius(20)
                            .disabled(credits <= 0)
                        })
                        
                            Text("\(maxSpinBetAmount) Credits")
                            .padding(.top, 10)
                            .font(.footnote)
                        
                    }
                    .disabled(credits < betAmount)
                }
                
                
                Spacer()
            }
        }
        .overlay {
            if credits <= 0 {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.7))
                        .frame(width: 200, height: 100)
                    
                    VStack {
                        if #available(iOS 16.0, *) {
                            Text("Game Over")
                                .font(.largeTitle)
                                .foregroundStyle(Gradient(colors: [.white, .yellow]))
                                .bold()
                                .padding(.bottom)
                        } else {
                            // Fallback on earlier versions
                            Text("Game Over")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(.bottom)
                        }
                        
                        Button {
                            credits = 100
                        }label: {
                            if #available(iOS 16.0, *) {
                                Text("Play Again")
                                    .font(.headline)
                                    .foregroundStyle(Gradient(colors: [.yellow, .white, .orange]))
                            } else {
                                // Fallback on earlier versions
                                Text("Play Again")
                                    .font(.headline)
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                        
                }
            }
        }
    }
    
    func processResults(_ isMax:Bool = false)
    {
        //Set backgrounds back to white
       
        self.backgrounds = self.backgrounds.map{_ in Color.white}
        
        if isMax
        {
            //Spin all cards
            self.numbers = self.numbers.map{_ in Int.random(in: 0...2)}
        }
        else
        {
            //Spin middle row
            
            self.numbers[3] = Int.random(in: 0...2)
            self.numbers[4] = Int.random(in: 0...2)
            self.numbers[5] = Int.random(in: 0...2)
            
        }
        
        //Check winnings
        processWin(isMax)
    
    }
    func processWin(_ isMax:Bool = false)
    {
        var matches = 0
        
        if !isMax
        {
            //Processing for single spin
            if isMatch(3, 4, 5) {matches += 1}
        }
        else
        {
            //Process for max spin
            
            //Top Row
            if isMatch(0, 1, 2) {matches += 1}
            
            //Middle Row
            if isMatch(3, 4, 5) {matches += 1}
            
            //Bottom Row
            if isMatch(6, 7, 8) {matches += 1}
            
            //Diagonal top left to bottom right
            if isMatch(0, 4, 8) {matches += 1}
            
            //Diagonal top right to bottom left
            if isMatch(2, 4, 6) {matches += 1}
            
            //Vertical matches
            
            //Left Column
            if isMatch(0, 3, 6) {matches += 1}
            
            //Middle Column
            if isMatch(1, 4, 7) {matches += 1}
            
            //Right Column
            if isMatch(2, 5, 8) {matches += 1}
            
        }
        
        //Check matches and distrabute credits
        
        if matches > 0
        {
            //At least 1 win
            self.credits += matches * betAmount * 2
        }
        else if !isMax
        {
            //0 wins single spin
            self.credits -= betAmount
        }
        else
        {
            //0 wins max spin
            self.credits -= betAmount * 5
        }
    }
    
    func isMatch(_ index1:Int, _ index2:Int, _ index3:Int) -> Bool
    {
        //Process for max spin
        
        //Top Row
        if self.numbers[index1] == self.numbers[index2] && self.numbers[index2] == self.numbers[index3]
        {
            //Update backgrounds to green
            self.backgrounds[index1] = Color.green
            self.backgrounds[index2] = Color.green
            self.backgrounds[index3] = Color.green
            
            return true
        }
        
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
