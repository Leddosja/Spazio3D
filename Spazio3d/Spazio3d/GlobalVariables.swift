//
//  GlobalVariables.swift
//  Spazio3d
//
//  Created by Edis on 08/06/22.
//

import Foundation
import SwiftUI
import ProductionMonitorFrameworkiOS2

class NetworkState: ObservableObject
{
    static let shared = NetworkState()
    
    @Published var noNetworkAvail: Bool
    @Published var first: Bool
    
    init() {
        self.noNetworkAvail = false
        self.first = true
    }
}

struct GlobalVariables
{
    static var appLanguageCurrent: String = ""
    static var deviceLanguageCurrent: String = ""
    
    static var shortTemplate: String = ""
    static var fullTemplate: String = ""
    static var baseUrl: String = "" //http://192.168.0.16/app/channel/it/"
    static var baseUrlAddress: String = "http://192.168.0.16/app/channel/"
    static var baseUrlRootDir = "offline/"

    static var qrCode:String  = ""
    static var qrCodeBaseUrl:String = "https://www.spazio3d.com/get_otp_a.php?"
    static var OTPCodeBaseUrl:String = "https://www.spazio3d.com/get_otp_a.php?otp-q="
    static var OTPCode:String = ""
    
    static var isNetworkConnected = false
    
    @AppStorage("isDarkMode") static var isDarkMode = false
    
    static let client = WorkOrderClientV1()
    static var valoreTrim: String = ""
    
    func getNewsTemplatesBody()
    {
        
        var urlToCall = "https://www.spazio3d.com/app/channel/it/news/newsTemplateIntro.html"
        // recupera la template per le short news
        URLSession.shared.dataTask(with: URLComponents(string: urlToCall)!.url!) //dataTask(with: urlToCall)
        {
            data, response, error in
            let dataString = String(data: data!, encoding: String.Encoding.utf8)
            GlobalVariables.shortTemplate = dataString!
        }
        .resume()
        // recupera la template per le full news
        urlToCall = "https://www.spazio3d.com/app/channel/it/news/newsTemplateFull.html"
        URLSession.shared.dataTask(with: URLComponents(string: urlToCall)!.url!) //dataTask(with: urlToCall)
        {
            data, response, error in
            let dataString = String(data: data!, encoding: String.Encoding.utf8)
            GlobalVariables.fullTemplate = dataString!
        }
        .resume()
    }
}



func isOnLine() -> Bool
{
    let group = DispatchGroup()

    
    group.enter()
    // attenzione alla cache maledetta
    DispatchQueue.global(qos: .background).async {
        let urlsessionConfig = URLSessionConfiguration.default
        urlsessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        // svolgo il lavoro necessario
        let result = Task{ () -> Bool in
            do {
                //let (data, _) = try await URLSession.shared.data(from: URL(string:"https://www.spazio3d.com/app/channel/check.html")!)
                let (data, _) = try await URLSession.init(configuration: urlsessionConfig).data(from: URL(string:"https://www.spazio3d.com/app/channel/check.html")!)
                let jsonString = String(data:  data, encoding: .utf8)
                
                print("From inOnLine(): jsonString returned ", jsonString!)
                
                if jsonString == "ok" {
                    GlobalVariables.isNetworkConnected = true
                    NetworkState().noNetworkAvail = false
                    group.leave()
                    return true
                }
                else
                {
                    print("No network connection!")
                    GlobalVariables.isNetworkConnected = false
                    NetworkState().noNetworkAvail = true
                    GlobalVariables.baseUrl = GlobalVariables.baseUrlRootDir + GlobalVariables.appLanguageCurrent + "/"
                    group.leave()
                    return false
                }
            }
            catch {
                print("Error catched in isOnLine()")
                GlobalVariables.isNetworkConnected = false
                NetworkState().noNetworkAvail = true
                GlobalVariables.baseUrl = GlobalVariables.baseUrlRootDir + GlobalVariables.appLanguageCurrent + "/"
                group.leave()
                return false
            }
            
        }
        
        //group.leave()

    }
    
    // wait....
    group.wait()
    print("isOnLine() done!",GlobalVariables.isNetworkConnected)
    return GlobalVariables.isNetworkConnected
}
