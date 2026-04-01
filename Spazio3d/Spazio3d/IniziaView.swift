//
//  IniziaView.swift
//  Spazio3d
//
//  Created by Edis on 30/05/22.
//

import SwiftUI
import Foundation
import AVFoundation
import ProductionMonitorFrameworkiOS2

struct IniziaView: View {
    
    @State private var solaLettura: Bool = false
    @State private var torciaOnOff: Bool = false
    @State private var pezzirotti: Bool = false
    
    let screenSize = UIScreen.main.bounds
    
    @State private var editTextPopupIsShown: Bool = false
    @State private var enteredTextFromPopup: String = ""
    @State private var showButton: Bool = true
    
    @State private var webPopupIsShown: Bool = false
    @State private var  urlForPopup: String  = "" //GlobalVariables.OTPCodeBaseUrl + "3RRSK-YXCCJ"
    @State var popupHeight: CGFloat = 400
    
    @FocusState var focusedField: Bool
    
    @State private var showingAlert = false

    @State private var operatore = "Operatore:"
    @State private var postazione = "Postazione:"
    @State private var fase = "Fase:"
    
    var body: some View {
        ZStack {
            CBScanner(
                supportBarcode: .constant([.qr, .code128]), //Set type of barcode you want to scan
                scanInterval: .constant(5.0) /* Event will trigger every 5 seconds */ ) {
                    //When the scanner found a barcode
                    print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                    let valore = String($0.value)
                    //print("0" + valore)
                    if ($0.value.contains("otp-q") == true)
                    {
                        // qr code sconosciuto
                        print("Not a valid otp-q code.")
                        showingAlert = true
                    }
                    else {
                        Task {
                            //Controllo delle prime due cifre del codice letto
                            if valore.prefix(2) == "01" {
                                let valoreN = valore.dropFirst(2)
                                var valoreTrim = valoreN
                                switch valoreN.prefix(2) {
                                //Operatore
                                case "01":
                                    valoreTrim = valoreN.dropFirst(2)   //valoreO è il valore che identifica l'operatore
                                    //Controllo OperatorExist
                                    if await GlobalVariables.client.OperatorExists(Int(valoreTrim)!).Result! {
                                        let operatoreResponse = await GlobalVariables.client.GetOperatorName(Int(valoreTrim)!)
                                        operatore = "Operatore: " + operatoreResponse.operatorName!
                                    }
                                //Fase
                                case "02":
                                    valoreTrim = valoreN.dropFirst(2)
                                    let phaseResponse = await GlobalVariables.client.GetPhaseByID(Int(valoreTrim)!).Message //"CUTTING"
                                //Pezzo
                                case "03":
                                    valoreTrim = valoreN.dropFirst(2)
                                    let pieceResponse = await GlobalVariables.client
                                //Macchine
                                case "04":
                                    valoreTrim = valoreN.dropFirst(2)
                                default:
                                    break
                                }
                            }
                        }
                    }
                }
            onDraw: {
                print("Preview View Size = \($0.cameraPreviewView.bounds)")
                print("Barcode Corners = \($0.corners)")
                
                //line width
                let lineWidth: CGFloat = 2
            
                //line color
                let lineColor = UIColor.red
            
                //Fill color with opacity
                //You also can use UIColor.clear if you don't want to draw fill color
                let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
            
                //Draw box
                $0.draw(lineWidth: lineWidth, lineColor: lineColor, fillColor: fillColor)
            }
            .onTapGesture {
                if operatore == "Operatore:" {
                    operatore = "Operatore: Mario Rossi"
                }
                else if postazione == "Postazione:" {
                    postazione = "Postazione: CNC 6"
                }
                else if fase == "Fase:" {
                    fase = "Fase: Foratura e fresatura"
                }
                else {
                    
                }
            }
            VStack {
                Form {
                    Toggle(isOn: $solaLettura) {
                    Text("Sola lettura")
                            .foregroundColor(.black)
                    }
                        Toggle(isOn: $torciaOnOff) {
                            Text("Torcia on/off")
                        .foregroundColor(.black)
                    }
                    .onTapGesture {
                    if torciaOnOff {
                        toggleTorch(on: false)
                    }
                    else {
                        toggleTorch(on: true)
                    }
                    }
                        Toggle(isOn: $pezzirotti) {
                            Text("Pezzi rotti")
                        .foregroundColor(.black)
                    }
                }.padding(.bottom, -20).moveDisabled(true)
                Spacer()
                PopupEdit(isShown: $editTextPopupIsShown, text: $enteredTextFromPopup, focusedField: $focusedField)
                    .onSubmit {
                        print("Digited text from ManualOTP-Q Popup: \($enteredTextFromPopup)")
                        if(urlForPopup != "") { webPopupIsShown = true }
                }
                Spacer()
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 400, height: 1, alignment: .center)
                Spacer()
                    .frame(width: 0, height: 40, alignment: .center)
                Text("DEMO")
                    .foregroundColor(.red)
                    .font(.system(size: 40))
                Button("Premi per inserire manualmente")
                {
                    editTextPopupIsShown.toggle()
                    focusedField = true
                }
                .padding(.all, 10.0).background(Color.white)
                .cornerRadius(20)
                .opacity(editTextPopupIsShown ? 0 : 1)
                .disabled(editTextPopupIsShown ? true : false)
                Spacer().frame(height: 20)
                Form {
                    Text(operatore)
                    Text(postazione)
                    Text(fase)
                }
                .padding(.top, 0)
            }
        } // ZStack
        .webpopup(isPresented: $webPopupIsShown, alignment: .center, content: {
            Webview2(urlDelSito: $urlForPopup, htmlString: "",$popupHeight )
                .frame(width: 300, height: 600, alignment: .topLeading)
                .background(Color.black)
                .onTapGesture {
                    webPopupIsShown.toggle()
                }   })
        .alert("Not a valid otp-q code.",isPresented: $showingAlert) {
            Button("OK",role: .cancel) {}
        }
        .navigationTitle("Scansione codici a barre")
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            Task {
//                var operatoreResponse = wocOperatorResponse()
////                var postazioneResponse = woocMachineDataResponse()
////                var faseResponse = wocPhaseDataResponde()
//
//                let existOperator = await GlobalVariables.client.OperatorExists(Int(valueScanned) ?? 0)
//                if existOperator.Result! {
//                    operatoreResponse = await GlobalVariables.client.GetOperatorName(Int(valueScanned) ?? 0)
////                    postazioneResponse = await GlobalVariables.client.GetMachineByID(Int(valueScanned) ?? 0)
////                    faseResponse = await GlobalStatisticsView.client.
//
//                    operatore = "Operatore: " + operatoreResponse.operatorName!
////                    postazione = "Postaazione: " + postazioneResponse.description
//
//                }
//
//            }
//        }
    }
}
    


struct IniziaView_Previews: PreviewProvider {
    static var previews: some View {
        IniziaView()
    }
}

//Funzione che attiva/disattiva la torcia
func toggleTorch(on: Bool) {
    guard
        let device = AVCaptureDevice.default(for: AVMediaType.video),
        device.hasTorch
    else {
        return
    }
    do {
        try device.lockForConfiguration()
        device.torchMode = on ? .on : .off
        device.unlockForConfiguration()
    } catch {
        print("Torch could not be used")
    }
}

extension StringProtocol
{
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
                .range(of: string, options: options) {
            result.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
            index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
