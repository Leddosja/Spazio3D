//
//  CardView.swift
//  Scrumdinger
//
//  Created by bspc270 on 13/09/21.
//

import SwiftUI

struct CardView: View
{
    let cardName: String
    let cardImage: String
    let backColor: Color
    let cornerRadius: CGFloat
    
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .fill(backColor)
                .frame(width: 180, height: 180, alignment: .top).cornerRadius(cornerRadius)
            VStack
            {
                Spacer()
                Image("\(cardImage)").resizable().aspectRatio(contentMode: .fit).frame(width: 130, height: 130, alignment:.top)
                Spacer()
                Text("\(cardName)").font(.system(size: 20)).foregroundColor(.white)
                Spacer()
            }.frame(width: 180, height: 180, alignment: .top)
        }
    }
}

struct CardView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CardViewNoLabel(cardName: "Cabinet", cardImage: "menuIcon",backColor: .purple,cornerRadius: 20).previewLayout(.sizeThatFits)
    }
}

struct CardViewNoLabel: View
{
    let cardName: String
    let cardImage: String
    let backColor: Color
    let cornerRadius: CGFloat
    
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .fill(backColor)
                .frame(width: 150, height: 150, alignment: .top).cornerRadius(cornerRadius)
            VStack
            {
                Spacer()
                Image("\(cardImage)").resizable().aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100, alignment:.center)

                Spacer()
            }.frame(width: 120, height: 120, alignment: .top)
        }
        
    }
}
