//
//  PopupEdit.swift
//  Spazio3d
//
//  Created by Edis on 08/06/22.
//

import SwiftUI


enum FocusField: Hashable {
    case field
  }

struct PopupEdit: View {
    
    let screenSize = UIScreen.main.bounds
    @Binding var isShown : Bool
    @Binding var text: String
    var title: String = "OTP CODE"
    var focusedField: FocusState<Bool>.Binding
    
    var body: some View {
        VStack {
            Text(title).foregroundColor(Color(UIColor.black))
            TextField("",text: $text, onCommit: { print("COMMITTED!")} )
                .focused(focusedField)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.done)
                .padding()
                .cornerRadius(10)
                .onSubmit {
                    isShown = false
                }
            Spacer().frame(height: 25)
                
                Button("Cancella")
                {
                    isShown = false
                    hideKeyboard()
                }
                .frame(width: screenSize.width*0.4)
                .padding(4)
                .foregroundColor(Color.white)
                .background(Color(UIColor.red)).cornerRadius(20)
        }
        .padding()
        .frame(width: screenSize.width*0.7, height: screenSize.height*0.25)
        .background(Color(UIColor.white))

        .clipShape(RoundedRectangle(cornerRadius: 20,style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.easeInOut)
    }
}




#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
