//
//  Extensions.swift
//  Spazio3d
//
//  Created by Edis on 14/06/22.
//

import SwiftUI

extension View {
    
    func setNavbarColor(color: Color) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            NotificationCenter.default.post(name: NSNotification.Name("UPDATENAVBAR"), object: nil, userInfo: [
                "color": color
            ])
        }
    }
    
    func setNavbarTitleColor(color: Color) {
        
    }
}

extension UINavigationController {
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateNavBar(notification:)), name:
                                                NSNotification.Name("UPDATENAVBAR"), object: nil)
    }
    
    @objc
    func updateNavBar(notification: Notification) {
        
        if let info = notification.userInfo {
            
            let color = info["color"] as! Color
            
            let apperance = UINavigationBarAppearance()
            apperance.backgroundColor = UIColor(.white)
            
            navigationBar.standardAppearance = apperance
            navigationBar.scrollEdgeAppearance = apperance
            navigationBar.compactAppearance = apperance
        }
        else {
            
        }
        
    }
}
