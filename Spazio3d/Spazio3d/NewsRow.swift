//
//  NewsRow.swift
//  Spazio3d
//
//  Created by Edis on 08/06/22.
//

import SwiftUI
import WebKit


struct NewsRow: View
{
    @State var title: Text
    @State var title2: Text
    @State var htmlBody: String?
    @State var htmlBodyFull: String?
    @State private var webViewHeight: CGFloat = .zero
    @Binding var bkColor : Color
    @State var isPresented = false
    @State var nullo : String = ""
    
    init(_ bkc: Binding<Color>, title tit: String, title2 tit2: String, htmlBody htm: String?, htmlBodyFull htmfull: String?)
    {
        _bkColor = bkc
        _title = State(initialValue: Text(tit).font(.system(size: 32)) )
        _title2 = State(initialValue: Text(tit2).font(.system(size: 32)) )
        _htmlBody = State(initialValue: htm)
        _htmlBodyFull = State(initialValue: htmfull)
   }
    
    var body: some View
    {
        VStack
        {
            title
            //Spacer().frame(height: 30)
            //Webview(url: URL(string: "https://www.spazio3d.com/api/get_news.php?lang=ITA&start=0&qty=5")!)
            //Webview(url: URL(string: "https://www.spazio3d.com/site/en/news-events")!, htmlBody: "")
            //Webview(url: URL(string: "https://www.spazio3d.com")!)
            //Webview(url: nil,htmlBody: self.htmlBody).frame(height: 100)
            
            Webview2(urlDelSito: $nullo , htmlString: htmlBody!,/*dynamicHeight: */$webViewHeight)
                .padding(.horizontal)
                .frame(height: 250 /*webViewHeight*/ )
            
            Button(action:{
                print("Good grief!")
                isPresented.toggle()
            }) {
                Text("See more...")
                    .font(.title)
                    //.padding()
                    .background(Color(UIColor.orange))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    //.frame(width: 300, height: 50)
                    .border(Color(UIColor.orange),width: 5)
            }
            .background(Color(UIColor.orange))
            //.popover(isPresented: self.$isPresented){ Text(lorem).background(Color.red).padding()}
            .popover(isPresented: self.$isPresented){
                //Webview2(url: URL(string: "https://www.electroyou.it"),htmlString: "", $webViewHeight).background(Color.clear)
                Webview2(urlDelSito: $nullo, htmlString: htmlBodyFull!, $webViewHeight).background(Color.clear)
            }
            
            
            //Divider()
            //.frame(maxWidth: .infinity)
            //.background(bkColor)
        }
        .buttonStyle(PlainButtonStyle())
        
        //    func setBkColor(_ bkColor:Color) -> NewsRow {
        //        self.bkColor = bkColor;
        //        return self }
        
    }
}


/* *******************************  ************************************* ******************************************/

struct Webview: UIViewRepresentable
{
    var url: URL? = nil
    var htmlBody: String? = nil
    
    init(url: URL?,htmlBody: String?)
    {
        self.url = url
        self.htmlBody = htmlBody
    }
    // cyan background html
    let myHTMLString = "<html><head></head><body bgcolor=#00ffff><p>This is a test</p></body></html>"

    // funzione obbligatoria
    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView
    {
        let webview = WKWebView()
        
        if(url != nil)
        {
            let request = URLRequest(url: self.url!, cachePolicy: .returnCacheDataElseLoad)
            webview.load(request)
        }
        else
        {
            
            //webview.loadHTMLString("<html><body><p>Hello!</p></body></html>", baseURL: nil)
            let htmlstring = GlobalVariables.shortTemplate
            var htmlstring2 = htmlstring.replacingOccurrences(of: "@@TESTONEWS@@", with: "<html><body><p>Hello!</p></body></html>")
            let headerStringToCorrectFontsize = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0,user-scalable=no'></head>"
            //webview.loadHTMLString(htmlstring2, baseURL: nil)
            webview.loadHTMLString(headerStringToCorrectFontsize + myHTMLString, baseURL: nil)
        }
        
        return webview
    }

    // funzione obbligatoria
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<Webview>)
    {
        if(url != nil)
        {
            let request = URLRequest(url: self.url!, cachePolicy: .returnCacheDataElseLoad)
            webview.load(request)
        }
        else
        {
            //webview.loadHTMLString("<html><body><p>Hello!</p></body></html>", baseURL: nil)
            //var htmlstring = GlobalVariables.shortTemplate
            //webview.loadHTMLString(htmlstring.replacingOccurrences(of: "@@TESTONEWS@@", with: "<html><body><p>Hello!</p></body></html>"), baseURL: nil)
            webview.loadHTMLString(myHTMLString, baseURL: nil)
        }

    }
}



/* **********************  WEBVIEW2   ************************************************************************** */

// https://stackoverflow.com/questions/59789950/swiftui-wkwebview-content-height-issue

struct Webview2 : UIViewRepresentable
{
    @Binding var siteUrl : String
    //var url: URL? = nil
    @Binding var dynamicHeight: CGFloat
    var webview: WKWebView //= WKWebView()
    var htmlNews: String
    @State var isInjected: Bool = false
    
    
    init(urlDelSito urlSito : Binding<String> ,htmlString shortNew: String, _ dynheight: Binding<CGFloat>)
    {
        _siteUrl = urlSito
        //self.url = URL(string: siteUrl)
        _dynamicHeight = dynheight
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.dataDetectorTypes = []
        webview = WKWebView(frame: .zero, configuration: webViewConfig)
        webview.isOpaque = false
        webview.backgroundColor = UIColor.clear
        webview.scrollView.backgroundColor = UIColor.clear
        //webview.layoutMargins = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 100)
        self.htmlNews = shortNew
    }
    

    class Coordinator: NSObject, WKNavigationDelegate
    {
        var parent: Webview2

        init(_ parent: Webview2)
        {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
        {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            //webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                }
            })
            
            if parent.isInjected == true
            {
                return
            }
            parent.isInjected = true
            // get HTML text
//            let js = "document.body.outerHTML"
//            parent.webview.evaluateJavaScript(js) { (html, error) in
//                    let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
//                    webView.loadHTMLString(headerString + (html as! String), baseURL: nil)
//                }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView
    {
        return webview
        
        let url = URL(string: siteUrl)
        if(url != nil)
        {
            let request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad)
            webview.load(request)
            return webview
        }

        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let dummy_html = """
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut venenatis risus. Fusce eget orci quis odio lobortis hendrerit. Vivamus in sollicitudin arcu. Integer nisi eros, hendrerit eget mollis et, fringilla et libero. Duis tempor interdum velit. Curabitur</p>
                        <p>ullamcorper, nulla nec elementum sagittis, diam odio tempus erat, at egestas nibh dui nec purus. Suspendisse at risus nibh. Mauris lacinia rutrum sapien non faucibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec interdum enim et augue suscipit, vitae mollis enim maximus.</p>
                        <p>Fusce et convallis ligula. Ut rutrum ipsum laoreet turpis sodales, nec gravida nisi molestie. Ut convallis aliquet metus, sit amet vestibulum risus dictum mattis. Sed nec leo vel mauris pharetra ornare quis non lorem. Aliquam sed justo</p>
                        """
        
        // cyan background html
        let myHTMLString = "<html><head></head><body bgcolor=#00ffff><p>This is a test</p></body></html>"

        let htmlString = "\(htmlStart)\(dummy_html)\(htmlEnd)"
        
        //webview.loadHTMLString(myHTMLString/*htmlString*/, baseURL:  nil)
        print(htmlNews)
        webview.loadHTMLString(htmlNews, baseURL:  nil)
        return webview
    }
    
    
    

    func updateUIView(_ uiView: WKWebView, context: Context)
    {
        uiView.navigationDelegate = context.coordinator
        
        print("From updateUIView():->>>>>> " + siteUrl)
        print("From updateUIView():->>>>>> " + htmlNews)
        
        let url = URL(string: siteUrl)
        if(url != nil)
        {
            let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData)
            webview.load(request)
        
        }
        else {
            webview.scrollView.bounces = false
            webview.navigationDelegate = context.coordinator
            let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
            let htmlEnd = "</BODY></HTML>"
            let dummy_html = """
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut venenatis risus. Fusce eget orci quis odio lobortis hendrerit. Vivamus in sollicitudin arcu. Integer nisi eros, hendrerit eget mollis et, fringilla et libero. Duis tempor interdum velit. Curabitur</p>
                        <p>ullamcorper, nulla nec elementum sagittis, diam odio tempus erat, at egestas nibh dui nec purus. Suspendisse at risus nibh. Mauris lacinia rutrum sapien non faucibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec interdum enim et augue suscipit, vitae mollis enim maximus.</p>
                        <p>Fusce et convallis ligula. Ut rutrum ipsum laoreet turpis sodales, nec gravida nisi molestie. Ut convallis aliquet metus, sit amet vestibulum risus dictum mattis. Sed nec leo vel mauris pharetra ornare quis non lorem. Aliquam sed justo</p>
                        """
            
            // cyan background html
            let myHTMLString = "<html><head></head><body bgcolor=#00ffff><p>This is a test</p></body></html>"
            
            let htmlString = "\(htmlStart)\(dummy_html)\(htmlEnd)"
/*
            //webview.loadHTMLString(myHTMLString/*htmlString*/, baseURL:  nil)
            print(htmlNews)
            let filedelcaz = Bundle.main.path(forResource: "offline/it/modules/index", ofType: "html")
            let folderPath = Bundle.main.bundlePath
            let baseurl = URL(fileURLWithPath: folderPath, isDirectory:  true)
            do {
                let stringaHtmlDelCaz = try NSString(contentsOfFile: filedelcaz!, encoding: String.Encoding.utf8.rawValue)
                webview.loadHTMLString(stringaHtmlDelCaz as String, baseURL: nil)
                //webview.loadHTMLString(filedelcaz! as String, baseURL: nil)
            }
            catch {
                
            }
*/
            let indexURL = Bundle.main.url(forResource: "offline/it/modules/index.html", withExtension: "")
            webview.loadFileURL(indexURL!, allowingReadAccessTo: indexURL!)
            
            //webview.loadHTMLString(htmlNews, baseURL:  nil)
        }
        
    }
}


struct TestWebViewInScrollView: View {
    @State private var webViewHeight: CGFloat = .zero
    @State var address:  String = "https://www.spazio3d.com/app/channel/it/cam/index.html"
    var body: some View {
        //ScrollView {
            VStack {
                
                
//                Image(systemName: "doc")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 300)
//                Divider()
        
        Webview2(urlDelSito: $address , htmlString: "Test of WebView2", /*dynamicHeight:*/ $webViewHeight)
                    .padding(.horizontal)
                    .frame(height: 400)
                    .background(Color.black)
        
        
//                Webview(url: URL(string: "https://www.apple.com")!, htmlBody: "")
//                  .background(Color.clear)
//                    //.frame(width: 400, height: 400)
//                    //.frame(height: webViewHeight)
                
            }

        //}
    }
}


/* ********************************************************************************************* */



struct TestWebViewInScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TestWebViewInScrollView()
    }
}




//struct NewsRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsRow(.constant(Color.yellow), title: "Preview",
//                title2: "title2",
//                htmlBody: "htmlBodyPreview")//.previewLayout(.fixed(width: 300, height: 200))
//    }
//}


let headerDiProva  =  "﻿<!DOCTYPE html>\r\n\r\n<html lang=\"it\" xmlns=\"http://www.w3.org/1999/xhtml\">\r\n<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0,user-scalable=no'>\t\r\n    <style>\r\n\t\tbody {\r\n            background-color: rgba(0,0,0,0);\r\n            color: white;\r\n            font-family: Roboto;\r\n            font-size: medium;\r\n        }\r\n\r\n        h1 {\r\n            text-align: center;\r\n        }\r\n\r\n        h2 {\r\n            text-align: left;\r\n            font-size: large;\r\n        }\r\n\r\n        ul {\r\n            list-style-type: none;\r\n            padding-left: 10px;\r\n        }\r\n\r\n        li::marker {\r\n            color: gray;\r\n        }\r\n\t\t\r\n\t\timg {\r\n\t\t  display:none;\t\t  \r\n\t\t}\r\n\t\t\r\n\t\ta{\r\n\t\t\tcolor: rgba(254,77,0,255);\r\n\t\t}\r\n    </style>\r\n    <meta charset=\"utf-8\" />\r\n    <title>News</title>\r\n</head>\r\n<body>\r\n    @@TESTONEWS@@\r\n</body>\r\n</html>"

let headerDiProvaFull = "﻿<!DOCTYPE html>\r\n\r\n<html lang=\"it\" xmlns=\"http://www.w3.org/1999/xhtml\">\r\n<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0,user-scalable=no'>\t\r\n    <style>    \r\n\t\tbody {\r\n            background-color: rgba(0,0,0,0);\r\n            color: white;\r\n            font-family: Roboto;\r\n            font-size: medium;\r\n        }\r\n\r\n        h1 {\r\n            text-align: center;\r\n        }\r\n\r\n        h2 {\r\n            text-align: left;\r\n            font-size: large;\r\n        }\r\n\r\n        ul {\r\n            list-style-type: none;\r\n            padding-left: 10px;\r\n        }\r\n\r\n        li::marker {\r\n            color: gray;\r\n        }\r\n\t\t \r\n\t\timg {\t\t  \r\n\t\t  width: 100%;\r\n\t\t  height: auto;\r\n\t\t  object-fit: cover;\r\n\t\t}\r\n\t\t\r\n\t\ta{\r\n\t\t\tcolor: #fe4d00;\r\n\t\t}\r\n    </style>\r\n    <meta charset=\"utf-8\" />\r\n    <title>News</title>\r\n</head>\r\n<body>\r\n    @@TESTONEWS@@\r\n</body>\r\n</html>"
