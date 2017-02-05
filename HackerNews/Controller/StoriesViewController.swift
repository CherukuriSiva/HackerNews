//
//  ViewController.swift
//  HackerNews
//
//  Created by DucereTech on 01/02/17.
//  Copyright © 2017 Ducere. All rights reserved.
//

import UIKit

/*!
 * @discussion StoriesViewController class to display Top stories data on UI
 */
class StoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIRequestManagerDelegate
{

    // MARK: Variables Declaration

    //Variables Declaration - Scope(Class scope)
    
    @IBOutlet weak var storiesTableView: UITableView!
    
    /// Top stories array to store Top stories JSON response
    var topStoriesArray: NSArray = []
    
    /// UIRefreshControl shown to fetch latest data from server
    let refreshControl = UIRefreshControl()

    /// Util class Object - To check internet connection, to show loading view etc..
    var utilObj = UtilClass()

    // MARK: View Controller Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Hacker News"
        
        /// Get top hacker news top stories from server
        self.getHackerStoriesFromServer()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: API Calls

    func getHackerStoriesFromServer()
    {
        
        // Check internet status
        
        if UtilClass.isConnectedToNetwork()
        {
            // Dispose of any resources that can be recreated.
            
            self.addRefreshControltoTableview()
            
            // Show activity indicator on the table view
            self.storiesTableView.addSubview(utilObj.showLoadingViewOn(tableView: self.storiesTableView))
            
            var resultString = kBaseUrl
            resultString += "topstories.json"
            
            let apiManager = APIRequestManager();
            apiManager.delegate = self
            
            /// Delegate call backs  
            /// 1.func didgetResponseSuccessfully(jsonData: Any)
            /// 2. func didgetResponseFail(error: NSString)
            
            apiManager.getJsonResponseFromUrl(urlString: resultString)
            
        }
        else
        {
            self.displayAlertView(alertMessage: "Please connect to internet")
        }
        
    }
    
    // MARK: APIRequestManager delegate funtions

    func didgetResponseSuccessfully(jsonData: Any)
    {
        self.topStoriesArray = (jsonData as? NSArray)!
        
        DispatchQueue.main.sync {
            
            self.storiesTableView.reloadData()
            
            // Hides and stops the text and the spinner
            utilObj.removeLoadingView()
        }
    }
    
    func didgetResponseFail(error: NSString)
    {
        self.displayAlertView(alertMessage: error as String)
        
    }

    // MARK: UIRefreshControl handling

    func addRefreshControltoTableview()
    {
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.backgroundColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        storiesTableView.backgroundView = refreshControl
        storiesTableView.addSubview(refreshControl)
        
    }
    
    func refresh(refreshControl: UIRefreshControl)
    {
        self.getHackerStoriesFromServer()
        
        refreshControl.endRefreshing()
        refreshControl.removeFromSuperview()

    }
    
    // MARK: UITableView funtions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.topStoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text =  "\(self.topStoriesArray[indexPath.row])"
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        
        let commentId:NSNumber = self.topStoriesArray[indexPath.row] as! NSNumber
        
        if commentId.boolValue {
            let storiesViewControllerObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
            storiesViewControllerObj.commentId = "\(commentId)"
            self.navigationController?.pushViewController(storiesViewControllerObj, animated: true)
        }
    }
        
    // MARK: Alert View
    func displayAlertView(alertMessage:String)
    {
        
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            switch action.style{
                
            case .default:
                //Check internet status
                if UtilClass.isConnectedToNetwork()
                {
                    //Get data from server, if user connects to internet
                    self.getHackerStoriesFromServer()
                }
                else
                {
                    self.displayAlertView(alertMessage: "Please connect to internet")

                }

                
            case .cancel: break
                
            case .destructive: break
                                
            }
            
        }))
    }


}
