//
//  CCSurvey.swift
//  CloudCherryiOSFramework
//
//  Created by Vishal Chandran on 23/09/16.
//  Copyright © 2016 Vishal Chandran. All rights reserved.
//

import UIKit

public class CCSurvey: UIViewController {

    
    // MARK: - Variables
    
    
    var welcomeText = String()
    var thankYouText = String()
    
    var questionID = [String]()
    var questionText = [String]()
    var questionDisplayTypes = [String]()
    var questionSequenceNumbers = [Int]()
    
    var partialResponseID = String()
    
    var logoURL = String()
    var logoImage = UIImage()
    
    var multiSelects = [String]()
    var ratingTexts = [String]()
    
    var headerColorCode = String()
    var footerColorCode = String()
    var backgroundColorCode = String()
    
    
    // MARK: - Outlets
    
    
    var blackLoadingView = UIView()
    
    
    // MARK: - View Life Cycle Methods
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.showLoading()
        
        
    }

    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Sets the username and password for CloudCherry
    
    public init(iUsername: String, iPassword: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        if (iUsername == "") {
            
            print("ERROR: FAILED TO INITALIZE. USERNAME IS EMPTY")
            
        } else  if (iPassword == "") {
            
            print("ERROR: FAILED TO INITALIZE. PASSWORD IS EMPTY")
            
        } else {
            
            _USERNAME = iUsername
            _PASSWORD = iPassword
            
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Methods
    
    
    // Shows Loading Screen and logs into Cloud Cherry in the background
    
    public func showLoading() {
        
        if (_USERNAME.isEmpty || _PASSWORD.isEmpty) {
            
            print("ERROR: FAILED TO INITALIZE. USERNAME AND PASSWORD CANNOT BE EMPTY")
            
        } else {
            
            blackLoadingView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
            blackLoadingView.backgroundColor = UIColor.blackColor()
            blackLoadingView.alpha = 0.75
            
            let aMainWindow = UIApplication.sharedApplication().delegate!.window
            aMainWindow!!.addSubview(blackLoadingView)
            
            let aLoadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            aLoadingIndicator.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
            aLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
            blackLoadingView.addSubview(aLoadingIndicator)
            aLoadingIndicator.startAnimating()
            
            performSelectorInBackground(#selector(CCSurvey.loginToCloudCherry), withObject: nil)
            
        }
        
    }
    
    
    // Login to CloudCherry adn fetches Access Token
    
    
    func loginToCloudCherry() {
        
        var aResponseStatus = false
        
        let aRequest = NSMutableURLRequest(URL: NSURL(string: "\(_IP)\(POST_LOGIN_TOKEN)")!)
        
        let anEscapedUsernameString = getURLEncodedEscapedString(_USERNAME)
        let anEscapedPasswordString = getURLEncodedEscapedString(_PASSWORD)
        
        let aPostString: String = "grant_type=password&username=\(anEscapedUsernameString)&password=\(anEscapedPasswordString)"
        let aPostData: NSData = aPostString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let aPostDataLength: String = "\(aPostData.length)"
        
        aRequest.HTTPMethod = "POST"
        aRequest.addValue(aPostDataLength, forHTTPHeaderField: "Content-Length")
        aRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        aRequest.HTTPBody = aPostData
        
        let aLoginGroup = dispatch_group_create()
        dispatch_group_enter(aLoginGroup)
        
        let aTask = NSURLSession.sharedSession().dataTaskWithRequest(aRequest, completionHandler: { (aData: NSData?,  aResponse: NSURLResponse?, aError: NSError?) -> Void in
            
            if let aHttpResponse = aResponse as? NSHTTPURLResponse {
                
                let aStatusCode = aHttpResponse.statusCode
                
                if (aStatusCode == 200) {
                    
                    if let aResult = try? NSJSONSerialization.JSONObjectWithData(aData!, options: NSJSONReadingOptions.MutableContainers) as!NSDictionary {
                        
                        print(aResult)
                        
                        aResponseStatus = true
                        
                        _ACCESS_TOKEN = aResult["access_token"] as! String
                        
                        dispatch_group_leave(aLoginGroup)
                        
                    } else {
                        
                        print("ERROR")
                        
                    }
                    
                } else {
                    
                    print("ERROR: INVALID CREDENTIALS")
                    
                }
                
            } else {
                
                print(aError?.localizedDescription)
                dispatch_group_leave(aLoginGroup)
                
            }
        })
        aTask.resume()
        
        dispatch_group_wait(aLoginGroup, DISPATCH_TIME_FOREVER)
        
        if (aResponseStatus) {
            
            self.createSurveyToken()
            
        }

        
    }
    
    
    // Creates a Survey Token
    
    
    func createSurveyToken() {
        
        var aResponseStatus = false
        
        let aRequest = NSMutableURLRequest(URL: NSURL(string: "\(_IP)\(POST_CREATE_SURVEY_TOKEN)")!)
        let aMessage: Dictionary <String, String>?
        
        aRequest.HTTPMethod = "POST"
        aRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        aRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        aRequest.addValue("Bearer \(_ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        aMessage = ["token" : "iostest", "location" : "ios"] as Dictionary <String, String>
        aRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(aMessage!, options: [])
        
        let aCreateSurveyGroup = dispatch_group_create()
        dispatch_group_enter(aCreateSurveyGroup)
        
        let aTask = NSURLSession.sharedSession().dataTaskWithRequest(aRequest, completionHandler: { (aData: NSData?,  aResponse: NSURLResponse?, aError: NSError?) -> Void in
            if (aResponse as? NSHTTPURLResponse) != nil {
                
                if let aResult = try? NSJSONSerialization.JSONObjectWithData(aData!, options: NSJSONReadingOptions.MutableContainers) as!NSDictionary {
                    
                    print(aResult)
                    
                    _SURVEY_TOKEN = aResult["id"] as! String
                    
                    aResponseStatus = true
                    
                    dispatch_group_leave(aCreateSurveyGroup)
                    
                } else {
                    
                    print("ERROR: COULD NOT CREATE SURVEY TOKEN")
                    
                }
            } else {
                print(aError?.localizedDescription)
                dispatch_group_leave(aCreateSurveyGroup)
            }
        })
        aTask.resume()
        
        dispatch_group_wait(aCreateSurveyGroup, DISPATCH_TIME_FOREVER)
        
        if (aResponseStatus) {
            
            self.getSurveyQuestions()
            
        }
        
    }
    
    
    // Fetch the Survey Questions with Tag 'ios'
    
    
    func getSurveyQuestions() {
        
        var aResponseStatus = false
        
        let aRequest = NSMutableURLRequest(URL: NSURL(string: "\(_IP)\(GET_QUESTIONS_API)")!)
        
        aRequest.HTTPMethod = "GET"
        aRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        aRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        aRequest.addValue("Bearer \(_ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        
        let aGetSurveyGroup = dispatch_group_create()
        dispatch_group_enter(aGetSurveyGroup)
        
        let aTask = NSURLSession.sharedSession().dataTaskWithRequest(aRequest, completionHandler: { (aData: NSData?,  aResponse: NSURLResponse?, aError: NSError?) -> Void in
            if (aResponse as? NSHTTPURLResponse) != nil {
                
                if let aResult = try? NSJSONSerialization.JSONObjectWithData(aData!, options: NSJSONReadingOptions.MutableContainers) as!NSDictionary {
                    
                    print(aResult)
                    
                    let aQuestions = aResult["questions"] as! [NSDictionary]
                    self.welcomeText = aResult["welcomeText"] as! String
                    self.thankYouText = aResult["thankyouText"] as! String
                    self.partialResponseID = aResult["partialResponseId"] as! String
                    let aCompleteLogoURL = aResult["logoURL"] as! String
                    
                    self.headerColorCode = aResult["colorCode1"] as! String
                    self.footerColorCode = aResult["colorCode2"] as! String
                    self.backgroundColorCode = aResult["colorCode3"] as! String
                    
                    let aLogoURLDelimiters = NSCharacterSet(charactersInString: "?")
                    let aLogoURLSplitStrings = aCompleteLogoURL.componentsSeparatedByCharactersInSet(aLogoURLDelimiters)
                    self.logoURL = aLogoURLSplitStrings[0]
                    
                    print(aQuestions)
                    
                    for aQuestion in aQuestions {
                        
                        if let aQuestionTags = aQuestion["questionTags"] as? [String] {
                            
                            if (aQuestionTags.contains("ios")) {
                                
                                print(aQuestion)
                                
                                self.questionID.append(aQuestion["id"] as! String)
                                self.questionText.append(aQuestion["text"] as! String)
                                self.questionSequenceNumbers.append(aQuestion["sequence"] as! Int)
                                
                                let aQuestionDisplayType = aQuestion["displayType"] as! String
                                
                                self.questionDisplayTypes.append(aQuestionDisplayType)
                                
                                if (aQuestionDisplayType == "Scale") {
                                    
                                    if let aMultiSelect = aQuestion["multiSelect"] as? [String] {
                                        
                                        let aMultiSelectDelimiters = NSCharacterSet(charactersInString: "-")
                                        let aMultiSelectSplitStrings = aMultiSelect[0].componentsSeparatedByCharactersInSet(aMultiSelectDelimiters)
                                        
                                        for aMultiSelectSplitString in aMultiSelectSplitStrings {
                                            
                                            let aDelimiters = NSCharacterSet(charactersInString: ";")
                                            let aSplitStrings = aMultiSelectSplitString.componentsSeparatedByCharactersInSet(aDelimiters)
                                            
                                            self.ratingTexts.append(aSplitStrings[1])
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    aResponseStatus = true
                    
                    dispatch_group_leave(aGetSurveyGroup)
                    
                } else {
                    
                    print("ERROR: COULD NOT FETCH QUESTIONS")
                    
                }
            } else {
                print(aError?.localizedDescription)
                dispatch_group_leave(aGetSurveyGroup)
            }
        })
        aTask.resume()
        
        dispatch_group_wait(aGetSurveyGroup, DISPATCH_TIME_FOREVER)
        
        if (aResponseStatus) {
            
            let aLogoDownloadGroup = dispatch_group_create()
            dispatch_group_enter(aLogoDownloadGroup)
            
            self.logoImage = UIImage(data: NSData(contentsOfURL: NSURL(string: logoURL)!)!)!
            
            dispatch_group_leave(aLogoDownloadGroup)
            dispatch_group_wait(aLogoDownloadGroup, DISPATCH_TIME_FOREVER)
            
            self.startSurvey()
            
        }
        
    }
    
    
    // Start the Survey by presenting the Screen
    
    
    func startSurvey() {
        
        blackLoadingView.removeFromSuperview()
        
        let aSurveyViewController = CCSurveyViewController()
        aSurveyViewController.modalPresentationStyle = .OverCurrentContext
        
        aSurveyViewController.welcomeText = self.welcomeText
        aSurveyViewController.thankYouText = self.thankYouText
        
        aSurveyViewController.questionID = self.questionID
        aSurveyViewController.questionText = self.questionText
        aSurveyViewController.partialResponseID = self.partialResponseID
        
        aSurveyViewController.headerColorCode = self.headerColorCode
        aSurveyViewController.footerColorCode = self.footerColorCode
        aSurveyViewController.backgroundColorCode = self.backgroundColorCode
        
        aSurveyViewController.logoImage = self.logoImage
        
        aSurveyViewController.ratingTexts = self.ratingTexts
        
        self.navigationController?.pushViewController(aSurveyViewController, animated: false)
        
    }
    
    
    // Gets URL Encoded Escaped String for passing into Username and Password fields
    
    
    func getURLEncodedEscapedString(iString: String) -> String {
        
        let aCustomAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
        let anEscapedString = iString.stringByAddingPercentEncodingWithAllowedCharacters(aCustomAllowedSet)
        
        return anEscapedString!
        
    }

}
