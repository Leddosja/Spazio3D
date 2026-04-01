//
//  InfoView.swift
//  Spazio3d
//
//  Created by Edis on 30/05/22.
//

import SwiftUI

struct InfoView: View {
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            VStack {
                Form {
                    Section("Posizione") {
                        Text("BrainSoftware srl")
                        Text("Via Roma 25/a")
                        Text("31010 Fonte (TV)")
                        Text("ITALIA")
                    }
                    
                    
                    Section("Per informazioni:") {
                        Text("www.spazio3d.com")
                            .foregroundColor(.blue)
                            .underline()
                        Text("info@spazio3d.com")
                            .foregroundColor(.blue)
                            .underline()
                        Text("Tel. + 39 0423 946228")
                    }
                    
                    
                    Section("Per assistenza:") {
                        Text("support@spazio3d.com")
                            .foregroundColor(.blue)
                            .underline()
                        Text("Skype: spazio3d-support")
                    }
                    
                    
                    Section {
                        Text("Copyright © BrainSoftware")
                    }
                }
            }
        }
        .navigationTitle("Spazio3D IoT 4.0")
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
