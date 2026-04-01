//
//  WebPopup.swift
//  Spazio3d
//
//  Created by Edis on 08/06/22.
//

import SwiftUI

struct WebPopup<T: View>: ViewModifier
{
    let popup: T
    let alignment: Alignment
    let direction: Direction
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>, alignment: Alignment, direction: Direction, @ViewBuilder content: () -> T) {
        _isPresented = isPresented
        self.alignment = alignment
        self.direction = direction
        popup = content()
    }
    
    func body(content: Content) -> some View
    {
        content.overlay(popupContent())
    }

    @ViewBuilder private func popupContent() -> some View
    {
        GeometryReader { geometry in
            if isPresented
            {
                popup
                    .animation(.spring())
                    .transition(.offset(x: 0, y: direction.offset(popupFrame: geometry.frame(in: .global))))
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: alignment)
            }
                
        }
    }
}




extension WebPopup
{
    enum Direction
    {
        case top, bottom
        func offset(popupFrame: CGRect) -> CGFloat
        {
            switch self
            {
            case .top:
                let aboveScreenEdge = -popupFrame.maxY
                return aboveScreenEdge
                
            case .bottom:
                let belowScreenEdge = UIScreen.main.bounds.height - popupFrame.minY
                return belowScreenEdge
            }
        }
    }
}



extension View {
    func webpopup<T: View>(
        isPresented: Binding<Bool>,
        alignment: Alignment = .center,
        direction: WebPopup<T>.Direction = .bottom,
        @ViewBuilder content: () -> T
    ) -> some View {
        return modifier(WebPopup(isPresented: isPresented, alignment: alignment, direction: direction, content: content))
    }
}

private extension GeometryProxy
{
    var belowScreenEdge: CGFloat {UIScreen.main.bounds.height - frame(in: .global).minY}
}



/* ************************************************************************* */




// Helper view that shows a popup
struct TestWebPopup: View {
    @State var isPresented = false

//    var body: some View {
//        ZStack {
//            Color.clear
//            VStack {
//                Spacer()
//                Button("Toggle", action: { isPresented.toggle() })
//                //Spacer()
//            }
//        }
//        .modifier(WebPopup(isPresented: isPresented, alignment: .center, direction: .top, content: { Color.yellow.frame(width: 300, height: 300) }))
//    }
    
    var body: some View
    {
        VStack
        {
            HStack{Spacer()}
            //Color.clear
            //Spacer()
        Button("Toggle", action: { isPresented.toggle() })
            Spacer()
            Text("Test for WebPopup").frame(width: nil)

        }
        //.frame(widtcsvfasdgawrsgfzdfxfvdzh: nil)
        //webpopup(isPresented: isPresented, alignment: .center, content: {Text(lorem).background(Color.red).padding()} )
                  //{ Color.yellow.frame(width: 300, height: 300) })
        .webpopup(isPresented: $isPresented, alignment: .center, content: {Text("Ciao io sono una WebPopup\nCiao io sono una WebPopup\nCiao io sono una WebPopup\nCiao io sono una WebPopup").padding(20).background(Color.red)} )
    }
}




struct TestWebPopupWithURL: View {
    @State var isPresented = false
    @State var urlToGo = "http://192.168.0.16/app/channel/it/modules/index.html"
    @State var webheight: CGFloat = 10
    
    var body: some View
    {
        VStack
        {
            HStack{Spacer()}
            //Color.clear
            //Spacer()
        Button("Toggle", action: { isPresented.toggle() })
            Spacer()
            Text("Test for WebPopup").frame(width: nil)

        }
        
        //.frame(width: nil)
        //.webpopup(isPresented: isPresented, alignment: .center, content: {Text(lorem).background(Color.red).padding()} )
                  //{ Color.yellow.frame(width: 300, height: 300) })
        //.webpopup(isPresented: isPresented, alignment: .center, content: {Text("Ciao io sono una WebPopup").background(Color.red).padding()} )

        .webpopup(isPresented: $isPresented, alignment: .center, content: {
            Webview2(urlDelSito: $urlToGo, htmlString: "",$webheight )
                .padding(20)
                .frame(width: 300, height: 200, alignment: .topLeading)
                .background(Color.black)
                .onTapGesture {
                    isPresented.toggle()
                }
        })

    }
}



struct WebPopup_Previews: PreviewProvider
{
    static var previews: some View
    {
        //TestWebPopup()
        TestWebPopupWithURL()
    }
}
