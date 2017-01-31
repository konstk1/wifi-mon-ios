//
//  TodayViewController.swift
//  Wifi Mon Ext
//
//  Created by Konstantin Klitenik on 1/31/17.
//  Copyright © 2017 Kon. All rights reserved.
//

import UIKit
import NotificationCenter
import SystemConfiguration.CaptiveNetwork

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var wifiSsidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        wifiSsidLabel.text = "Not connected"
        
        guard let interfaces = CNCopySupportedInterfaces() as? [CFString] else {
            print("Error getting supported interfaces")
            return
        }
        
        guard let interface = interfaces.first else {
            print("No interfaces found")
            return
        }
        
        guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface) as? [String:AnyObject] else {
            print("Failed to get \(interface) info")
            return
        }
        
        guard let wifiSsid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String else {
            print("Failed to get SSID")
            return
        }
        
        wifiSsidLabel.text = wifiSsid
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
