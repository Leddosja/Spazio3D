//
//  ContentView.swift
//  Spazio3d
//
//  Created by Edis on 30/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var ShowingSheet = false
    @State private var ShowInizia = false
    @Environment (\.scenePhase) var appScenePhase
    
    var body: some View {
        NavigationView {
            ExecuteCode {
                GlobalVariables.client.SetServiceParameters("http", "192.168.0.16", "8000", "wocApp", 10000, "it-it")
//                Task{
//                    var response = await GlobalVariables.client.Halo2()
//                    if (response.Result){
//                        Task{
//                            while (true){
//                                var response = await GlobalVariables.client.Ping(1,"") //Prendre da quello letto da barcode (se c'è), altrimenti -1
//                                Task.sleep(2000) //Prendere dai settings
//
//                            }
//                        }
//                    }
//                }
            }
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                NavigationLink(destination: InfoView()) {
                    VStack {
                        Spacer()
                            .frame(width: 0, height: 600, alignment: .center)
                        Text("Informazioni su Spazio3D IoT 4.0 v2.0.2.1")
                            .foregroundColor(Color.white)
                            .underline()
                            .font(.system(size: 16))
                            .fullScreenCover(isPresented: $ShowingSheet, content: { InfoView() })
                    }
                }
                VStack {
                    Spacer()
                        .frame(width: 0, height: 60, alignment: .center)
                    Image("icon")
                        .resizable()
                        .frame(width: 200.0, height: 250.0, alignment: .center)
                        .cornerRadius(30)
                    Spacer()
                        .padding()
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack{
                            Group {
                                Spacer(minLength: 80)
                                NavigationLink(destination: IniziaView()) {
                                CardView(cardName: "Inizia", cardImage: "menuIcon",backColor: .purple,cornerRadius: 30)
                                }
                            }
                            Spacer(minLength: 80)
                            NavigationLink(destination: ProductionOrdersView()) {
                                CardView(cardName: "Production orders", cardImage: "menuIcon",backColor: .blue,cornerRadius: 30)
                            }
                            
                            Spacer(minLength: 80)
                            NavigationLink(destination: GlobalStatisticsView()) {
                                CardView(cardName: "Global Statistics", cardImage: "menuIcon",backColor: .green,cornerRadius: 30)
                            }
                            
                            Spacer(minLength: 80)
                            NavigationLink(destination: MachineStatesView()) {
                                CardView(cardName: "Machine states", cardImage: "menuIcon",backColor: .gray,cornerRadius: 30)
                            }
                            
                            Spacer(minLength: 80)
                            NavigationLink(destination: SettingsView()) {
                                CardView(cardName: "Settings", cardImage: "menuIcon",backColor: .orange,cornerRadius: 30)
                            }
                            Spacer(minLength: 80)
                        }
                    })
                    Spacer()
                        .frame(width: 0, height: 300, alignment: .center)
                }
                
            }
        }
        .accentColor(.black)
        .onChange(of: appScenePhase) { newphase in
            if (newphase == .inactive) {
                print("Inactive")
                Task{
                    var response = await GlobalVariables.client.Bye2()
                }
            }
            else if newphase == .active {
                print("Active")
                Task{
                    var response = await GlobalVariables.client.Halo2()
                    if (response.Result!){
                        Task{
                            while (true){
                                var response = await GlobalVariables.client.Ping(1,"") //Prendre da quello letto da barcode (se c'è), altrimenti -1
                                await Task.sleep(2000) //Prendere dai setting
                            }
                        }
                    }
                }
            }
//            else if newphase == .background {
//                print("Background")
//            }
        }
//        .onAppear(){
////            var response = await GlobalVariables.client.Halo2()
//
//            //codice da implementare
//            //response = await GlobalVariables.client.Bye2()
//        }
//        .applicationDidBecomeActive(.self){
//            Task{
//                //Halo
//            }
//        }
//        .applicationDidEnterBackground{
//            //Bye
//        }
//        .applicationWillTerminate{
//            //bye
//        }
            
            
    }
        
}


//let settingService = AppServiceParameters()

struct ContentView_Previews: PreviewProvider {
    
//    @StateObject var appState = settingService
    
    static var previews: some View {
        ContentView()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


//class AppServiceParameters: ObservableObject {
//
//    @Published var message: String
//
//    init() {
//        self.message = "Configuring setting service parameters"
//        print(message)
//        GlobalVariables.client.SetServiceParameters("http", "192.168.0.16", "8000", "wocApp", 10000, "it-it")
//    }
//}

//Background threading
extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
//        DispatchQueue.global(qos: .background).async {
//            background?()
//            if let completion = completion {
//                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
//                    completion()
//                    Task {
//                        await GlobalVariables.client.Ping(IDMachine: Int(GlobalVariables.valoreTrim)!, IPAddress: "") //NO IPAddress
//                    }
//                }())
//            }
//        }
    }
}

struct ExecuteCode : View {
    init( _ codeToExec: () -> () ) {
        codeToExec()
    }
    
    var body: some View {
        return EmptyView()
    }
}
