//
//  ProductionOrdersView.swift
//  Spazio3d
//
//  Created by Edis on 08/06/22.
//

import SwiftUI

struct ProductionOrdersView: View {
    
    @State private var selectOrder = 1
    @State private var brokenPieces = 1
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color.red)]
        let apperance = UINavigationBarAppearance()
        apperance.backgroundColor = UIColor(.red)
    }
    
    
    
    var body: some View {
        VStack {
            Form {
                Section("Select order:") {
                    Picker("Color Scheme", selection: $selectOrder) {
                        Text("Seleziona").tag(1)
                        Text("001 - Factory demo").tag(2)
                        Text("002 - Factory demo 2").tag(3)
                    }
                    .pickerStyle(.menu)
                }
                Section("Progressive:") {
                    Text("")
                }
                Section("Code:") {
                    Text("")
                }
                Section("Description:") {
                    Text("")
                }
                Section("Stato:") {
                    Text("")
                }
                Section("No. of broken pieces:") {
                    Picker("No. of broken pieces:", selection: $brokenPieces) {
                        Text("Lista rotti n. 7").tag(1)
                        Text("Lista rotti n. 6").tag(2)
                        Text("Lista rotti n. 5").tag(3)
                        Text("Lista rotti n. 4").tag(4)
                        Text("Lista rotti n. 3").tag(5)
                        Text("Lista rotti n. 2").tag(6)
                        Text("Lista rotti n. 1").tag(7)
                    }
                }
                Section("Estimated production start:") {
                    Text("")
                }
                Group {
                    Section("Estimated production end:") {
                        Text("")
                    }
                    Section("Production start:") {
                        Text("")
                    }
                    Section("Production end:") {
                        Text("")
                    }
                    Section("Delivery date:") {
                        Text("")
                    }
                }
            }
        }
        .navigationTitle("Production orders")
        .environment(\.colorScheme, GlobalVariables.isDarkMode ? .dark : .light)
    }
}

struct ProductionOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        ProductionOrdersView()
    }
}
