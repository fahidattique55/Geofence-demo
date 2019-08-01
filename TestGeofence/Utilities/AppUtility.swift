//
//  Wifi.swift
//  TestGeofence
//
//  Created by Fahad Attique on 01/08/2019.
//  Copyright © 2019 UMAI. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork

let appUtility = AppUtility.shared

class AppUtility {
    
    // MARK: - Static
    
    static let shared = AppUtility()
    
    // MARK: - Life Cycle

    private init() { }

    // MARK: - Coordinates

    let randomCoordinates = [CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(33.1579, 10.7120),
                             CLLocationCoordinate2DMake(53.1579, 90.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(83.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(9.1579, 101.7120),
                             CLLocationCoordinate2DMake(92.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(87.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(50.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(14.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(3.1579, 101.7120),
                             CLLocationCoordinate2DMake(80.1579, 101.7120),
                             CLLocationCoordinate2DMake(70.1579, 101.7120),
                             CLLocationCoordinate2DMake(30.1579, 101.7120),
                             CLLocationCoordinate2DMake(12.1579, 101.7120),
                             CLLocationCoordinate2DMake(2.1579, 101.7120),
                             CLLocationCoordinate2DMake(4.1579, 101.7120),
                             CLLocationCoordinate2DMake(53.1579, 101.7120),
                             CLLocationCoordinate2DMake(66.1579, 101.7120)
    ]
    
    
    // MARK: - Wifi

    struct WifiInfo {
        public let interface:String
        public let ssid:String
        public let bssid:String
        init(_ interface:String, _ ssid:String,_ bssid:String) {
            self.interface = interface
            self.ssid = ssid
            self.bssid = bssid
        }
    }
    
    func getWifiInfo() -> Array<WifiInfo> {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }
        let wifiInfo:[WifiInfo] = interfaceNames.compactMap{ name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                return nil
            }
            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            guard let bssid = info[kCNNetworkInfoKeyBSSID as String] as? String else {
                return nil
            }
            return WifiInfo(name, ssid,bssid)
        }
        return wifiInfo
    }
    
    func currentSSIDs() -> [String] {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }
        return interfaceNames.compactMap { name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                return nil
            }
            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            return ssid
        }
    }
    
    func getConnectedWifiInfo() -> [AnyHashable: Any]? {
        
        if let ifs = CFBridgingRetain( CNCopySupportedInterfaces()) as? [String],
            let ifName = ifs.first as CFString?,
            let info = CFBridgingRetain( CNCopyCurrentNetworkInfo((ifName))) as? [AnyHashable: Any] {
            
            return info
        }
        return nil
        
    }
}

