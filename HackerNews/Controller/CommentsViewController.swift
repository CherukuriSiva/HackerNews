//
//  CommentsViewController.swift
//  HackerNews
//
//  Created by DucereTech on 01/02/17.
//  Copyright © 2017 Ducere. All rights reserved.
//

import UIKit

/*!
 * @discussion CommentsViewController class to display list of comments
 */
class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIRequestManagerDelegate
{

    // MARK: Variables Declaration
    
    //Variables Declaration - Scope(Class scope)

    @IBOutlet weak var commentsTableView: UITableView!
    
    /// CommentId is aUnique Id to get comments data from server
    var commentId: String!

    /// Comments Model class Object - Text shown during load the TableView
    var commentsObj = CommentClass()
    
    var replyClassObj = ReplyClass()

    var expandedRows = Set<Int>()
    
    /// Util class Object - To check internet connection, to show loading view etc..
    var utilObj = UtilClass()

    
    // MARK: View Controller Life cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Check internet status
        if UtilClass.isConnectedToNetwork()
        {
            self.commentsTableView.delegate = self;
            self.commentsTableView.dataSource = self;
            self.commentsTableView.rowHeight = UITableViewAutomaticDimension

            // Show activity indicator on the table view
            self.commentsTableView.addSubview(utilObj.showLoadingViewOn(tableView: self.commentsTableView))
            
            // To get comments data
            self.getCommentsDataFromServer(commentId: self.commentId)
        }
        else
        {
            self.displayAlertView(alertMessage: "Please connect to internet")
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableView funtions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ExpandableCell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell") as! ExpandableCell
        
        cell.commentLabel?.text = self.commentsObj.title
        cell.commentLabel?.numberOfLines = 0
        
        ///Image to be shown on click of Tableview cell
        cell.replyLabel?.text = self.replyClassObj.text
        cell.replyLabel?.numberOfLines = 0

        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 254.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandableCell
            else { return }
        
        switch cell.isExpanded
        {
            case true:
                self.expandedRows.remove(indexPath.row)
            case false:
                // To get reply data
                if let replyId = self.commentsObj.kidsArray?.firstObject
                {
                    self.getCommentsDataFromServer(commentId: "\(replyId)")
                }
                self.expandedRows.insert(indexPath.row)
        }
        
        
        cell.isExpanded = !cell.isExpanded
        
        //To expand and collapse Tableview cells
        self.commentsTableView.beginUpdates()
        self.commentsTableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandableCell
            else { return }
        
        self.expandedRows.remove(indexPath.row)
        
        cell.isExpanded = false
        
        //To expand and collapse Tableview cells
        self.commentsTableView.beginUpdates()
        self.commentsTableView.endUpdates()
        
    }

    
    // MARK: API Calls

    func getCommentsDataFromServer(commentId:String)
    {
        
        var resultString = kBaseUrl
        resultString += "/item/"+commentId+".json"
        
        /// Delegate call backs
        /// 1.func didgetResponseSuccessfully(jsonData: Any)
        /// 2. func didgetResponseFail(error: NSString)
        let apiManager = APIRequestManager();
        apiManager.delegate = self
        apiManager.getJsonResponseFromUrl(urlString: resultString)

    }
    
    // MARK: APIRequestManager delegate funtions

    func didgetResponseSuccessfully(jsonData: Any)
    {
        let jsonResponseDict:NSDictionary = (jsonData as? NSDictionary)!

        // Only replies will have Parent Id
        if jsonResponseDict["parent"] != nil
        {
            self.replyClassObj = ReplyClass(jsonResponseDict as! Dictionary<String, AnyObject>)
            
        }
        else
        {
            self.commentsObj = CommentClass(jsonResponseDict as! Dictionary<String, AnyObject>)

        }
        
        
        
        DispatchQueue.main.sync {
            
            self.commentsTableView .reloadData()
            
            // Hides and stops the text and the spinner
            utilObj.removeLoadingView()
        }
    }
    
    func didgetResponseFail(error: NSString)
    {
        self.displayAlertView(alertMessage: error as String)
    }
    

    // MARK: Alert View
    
    func displayAlertView(alertMessage:String)
    {
        
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            switch action.style{
                
            case .default:
                
                if UtilClass.isConnectedToNetwork()
                {
                    //Get data from server, if user connects to internet
                    self.getCommentsDataFromServer(commentId: self.commentId)
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
