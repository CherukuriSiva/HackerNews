//
//  APIRequestManager.swift
//  HackerNews
//
//  Created by Siva Cherukuri on 03/02/17.
//  Copyright © 2017 Ducere. All rights reserved.
//

import UIKit

/*!
 * @discussion Protocols mainly 1. To maintain uniqueness among classes 2. To act as a interfaces between two classes
 */
protocol APIRequestManagerDelegate
{
    /*!
     * @discussion Delegate call back with JSON Response - When we got response successfully.
     * @param jsonData JSON Response
     */
    func didgetResponseSuccessfully(jsonData: Any)
    
    /*!
     * @discussion Delegate call back with Error - When we failed to get response from server
     * @param error Error info
     */
    func didgetResponseFail(error: NSString)
}

/*!
 * @discussion Common API class to interact with HTTP and HTTPS protocols
 */
class APIRequestManager: NSObject
{

    var delegate: APIRequestManagerDelegate?

    /*!
     * @discussion Function which interacts with HTTP and HTTPS protocols
     * @param URL String Eg: https://hacker-news.firebaseio.com/v0/topstories.json
     */
    func getJsonResponseFromUrl(urlString:String)
    {
        
        let requestURL: NSURL = NSURL(string: urlString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        
        /*!
         * NSUrl's data task to get JSON Response
         */
        let task = session.dataTask(with: urlRequest as URLRequest)
        {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200)
            {
                /*!
                 * Everyone is fine, file downloaded successfully
                 */
                do
                {
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    
                    /*!
                     * Delegate call back with JSON Response
                     */
                    self.delegate?.didgetResponseSuccessfully(jsonData: json)
                    
                }catch
                {
                    /*!
                     * Delegate call back with Error
                     */
                    self.delegate?.didgetResponseFail(error: error.localizedDescription as NSString)
                }
                
            }
        }
        
        task.resume()
        
    }
}
