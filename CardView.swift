//
//  CardView.swift
//  Swift UI Slots
//
//  Created by Andrew Betancourt on 8/16/22.
//

import SwiftUI

struct CardView: View
{
    
    @Binding var symbol:String
    @Binding var backgrounds:Color
    
    var body: some View
    {
        Image(symbol)
        .resizable()
        .aspectRatio(1, contentMode: .fit)
        .background(backgrounds.opacity(0.5))
        .cornerRadius(20)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(symbol: Binding.constant("apple"), backgrounds: Binding.constant(Color.green))
    }
}
