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
    @IBOutlet weak var wifiBssidLabel: UILabel!
    @IBOutlet weak var wifiIconImageView: UIImageView!
    
    var interface: CFString?
    var isWifiConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        print("View loaded")
        wifiSsidLabel.text = "Not connected"
        
        guard let interfaces = CNCopySupportedInterfaces() as? [CFString] else {
            print("Error getting supported interfaces")
            return
        }
        
        guard let interface = interfaces.first else {
            print("No interfaces found")
            return
        }
        
        self.interface = interface
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
        
        print("Perform update")
        
        let (ssid, bssid) = getWifiInfo()
        
        if isWifiConnected {
            wifiSsidLabel.text = ssid
            wifiBssidLabel.text = bssid
            wifiIconImageView.image = UIImage(named: "wifi")
        } else {
            wifiSsidLabel.text = "Not connected"
            wifiBssidLabel.text = ""
            wifiIconImageView.image = UIImage(named: "wifi none")
        }
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func getWifiInfo() -> (ssid: String?, bssid: String?) {
        guard let interface = interface, let interfaceInfo = CNCopyCurrentNetworkInfo(interface) as? [String:AnyObject] else {
            print("Failed to get interface info")
            isWifiConnected = false
            return (nil, nil)
        }
        
        isWifiConnected = true
        let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
        let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
        
        return (ssid, bssid)

    }
    
}
