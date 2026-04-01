//
//  SettingsView.swift
//  Spazio3d
//
//  Created by Edis on 07/06/22.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var solaLettura: Bool = false
    @State private var modalitaLettura = 1
    @State private var lingua = 1
    @State private var unitaMisura = 2
    @State private var precisioneDecimali = 1
    @State private var precisioneFrazionaria = 4
    
    @State private var colorDaFare = Color.red
    @State private var colorInEsecuzione = Color.yellow
    @State private var colorFatto = Color.green
    
    @State private var modoDemo: Bool = true
    @State private var suonoScansione: Bool = false
    @State private var vibrazioneScansione: Bool = false
    
    @State private var cancellaUtente = false
    @State private var cancellaPostazione = false
    
    var body: some View {
        VStack {
            
            Form {
                Section("Preferenze") {
                    //Toggle della sola lettura
                    Toggle(isOn: $solaLettura) {
                        Text("Sola lettura")
                    }
                    
                    //Scelta della modalità di lettura
                    Picker(selection: $modalitaLettura, label: Text("Modalità lettura:")) {
                        Text("Automatico").tag(1)
                        Text("Iniziato").tag(2)
                        Text("Completato").tag(3)
                        Text("Iniziato e completato").tag(4)
                    }
                    
                    //Scelta della lingua
                    Picker(selection: $lingua, label: Text("Lingua:")) {
                        Text("Italiano").tag(1)
                        Text("English").tag(2)
                        Text("Español").tag(3)
                    }
                }
                
                //Sezione scelta del tema
                Section("Tema preferito") {
                    Picker("Color Scheme", selection: GlobalVariables.$isDarkMode) {
                        Text("Predefinito").tag(false)
                        Text("Chiaro").tag(false)
                        Text("Scuro").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                
                //Sezione informazioni
                Section("Indirizzo server") {
                    Text("192.168.0.16")
                }
                Section("Porta server") {
                    Text("8000")
                }
                
                //Sezione misure
                Section("Preferenze misure") {
                    //Scelta unità di misura
                    Picker(selection: $unitaMisura, label: Text("Unità di misura")) {
                        Text("Millimetro").tag(1)
                        Text("Centimetro").tag(2)
                        Text("Metro").tag(3)
                        Text("Pollice decimale").tag(4)
                        Text("Pollice frazionario").tag(5)
                    }
                    
                    
                    //Scelta numero di cifre decimali
                    Picker(selection: $precisioneDecimali, label: Text("Precisione (decimali)")) {
                        Text(".1").tag(1)
                        Text(".12").tag(2)
                        Text(".123").tag(3)
                        Text(".1234").tag(4)
                    }
                    
                    //Scelta numero di cifre frazionarie
                    Picker(selection: $precisioneFrazionaria, label: Text("Precisione frazionaria (pollici)")) {
                        Text("1/2 in").tag(1)
                        Text("1/4 in").tag(2)
                        Text("1/8 in").tag(3)
                        Text("1/16 in").tag(4)
                        Text("1/32 in").tag(5)
                        Text("1/64 in").tag(6)
                    }
                }
                
                //Sezione preferenze colori
                Section("Preferenze colori") {
                    ColorPicker("Da fare", selection: $colorDaFare)
                    ColorPicker("In esecuzione", selection: $colorInEsecuzione)
                    ColorPicker("Fatto", selection: $colorFatto)
                }
                
                //Sezione vibrazione/suono
                Section("Altre preferenze") {
                    Toggle(isOn: $modoDemo) {
                        Text("Modo demo")
                    }
                    Toggle(isOn: $suonoScansione) {
                        Text("Suono in scansione")
                    }
                    Toggle(isOn: $vibrazioneScansione) {
                        Text("Vibrazione in scansione")
                    }
                }
                
                //Sezione cancella dati utente
                Section("Tocca qui per cancellare i dati utenti") {
                    Button("Cancella dati utente") {
                        cancellaUtente = true
                    }
                    .alert(isPresented: $cancellaUtente) {
                        Alert(title: Text("I dati utente e la password corrente verranno eliminate. Continuare?"))
                    }
                }
                
                //Sezione cancella dati postazione
                Section("Tocca qui per cancellare i dati macchina") {
                    Button("Cancella dati postazione") {
                        cancellaPostazione = true
                    }
                    .alert(isPresented: $cancellaPostazione) {
                        Alert(title: Text("La stazione di lavoro e la fase correnti saranno eliminate. Continuare?"))
                    }
                }
            }
            .navigationBarTitle(Text("Impostazioni"), displayMode: .inline).navigationBarHidden(false)
            .environment(\.colorScheme, GlobalVariables.isDarkMode ? .dark : .light)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
