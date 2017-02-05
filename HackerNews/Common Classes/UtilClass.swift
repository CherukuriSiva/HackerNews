//
//  UtilClass.swift
//  HackerNews
//
//  Created by Siva Cherukuri on 04/02/17.
//  Copyright © 2017 Ducere. All rights reserved.
//

import UIKit
import SystemConfiguration

/*!
 * @discussion Utility class to provide common funtions which are used by multiple classes
 */
class UtilClass: NSObject
{

    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()


    static func isConnectedToNetwork() -> Bool
    {
        
        guard let flags = getFlags() else { return false }
        
        let isReachable = flags.contains(.reachable)
        
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
        
    }
    
    static func getFlags() -> SCNetworkReachabilityFlags?
    {
        
        guard let reachability = ipv4Reachability() ?? ipv6Reachability() else {
            
            return nil
            
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(reachability, &flags)
        {
            
            return nil
            
        }
        
        return flags
        
    }
    
    static func ipv6Reachability() -> SCNetworkReachability?
    {
        
        var zeroAddress = sockaddr_in6()
        
        zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
        
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        
        return withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        })
        
    }
    
    static func ipv4Reachability() -> SCNetworkReachability?
    {
        
        var zeroAddress = sockaddr_in()
        
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        return withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        })
        
    }
    
    func showLoadingViewOn(tableView: UITableView) -> UIView
    {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (UIScreen.main.bounds.size.width / 2) - (width / 2)
        let y = (UIScreen.main.bounds.size.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = UIColor.gray
        loadingLabel.textAlignment = NSTextAlignment.center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        return loadingView
        
    }
    
    func removeLoadingView()
    {
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        loadingLabel.isHidden = true
        loadingLabel.removeFromSuperview()
        loadingView.removeFromSuperview()
    }
}
