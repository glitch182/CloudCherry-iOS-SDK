//
//  CCSurveyViewController.swift
//  CCSampleApp
//
//  Created by Vishal Chandran on 22/09/16.
//  Copyright © 2016 Vishal Chandran. All rights reserved.
//
// ********************************************************* //
//                                                           //
//       Name: CCSurveyViewController                        //
//                                                           //
//    Purpose: Handles displaying the survey to the user     //
//                                                           //
// ********************************************************* //

var _PARTIAL_SURVEY_COMPLETE = false

import UIKit

class CCSurveyViewController: UIViewController, FloatRatingViewDelegate {
    
    
    // MARK: - Variables
    
    
    var keyboardAppeared = false
    var yOffset: CGFloat = 0
    
    var welcomeText = String()
    var thankYouText = String()
    
    var questionIDs = [String]()
    var questionTexts = [String]()
    var questionDisplayTypes = [String]()
    var questionSequenceNumbers = [Int]()
    
    var questionCounter = 0
    var primaryButtonCounter = 0
    
    var partialResponseID = String()
    
    var logoImage = UIImage()
    
    var ratingTexts = [String]()
    
    var npsQuestionAnswered = false
    var starRatingQuestionAnswered = false
    var selectedRating = Int()
    
    var headerColorCode = String()
    var footerColorCode = String()
    var backgroundColorCode = String()
    
    var red: [CGFloat] = [234/255, 234/255, 234/255, 234/255, 234/255, 234/255, 240/255, 239/255, 239/255, 116/255, 62/255]
    var green: [CGFloat] = [15/255, 61/255, 87/255, 113/255, 127/255, 148/255, 158/255, 219/255, 243/255, 244/255, 158/255]
    var blue: [CGFloat] = [42/255, 35/255, 37/255, 40/255, 41/255, 49/255, 43/255, 54/255, 59/255, 60/255, 76/255]
    
    
    // MARK: - Outlets
    
    
    var surveyView = UIView()
    
    var footerLabel = UILabel()
    var cloudCherryLogoImageView = UIImageView()
    
    var primaryButton = UIButton()
    
    var faciliationTextLabel = UILabel()
    var headerLabel = UILabel()
    
    var headerView = UIView()
    var footerView = UIView()
    var logoImageView = UIImageView()
    
    var questionCounterLabel = UILabel()
    var tappedButton = UIButton()
    var previousButton = UIButton()
    var submitButton = UIButton()
    
    var singleLineTextField = UITextField()
    var multiLineTextView = UITextView()
    var starRatingView = FloatRatingView()
    
    
    // MARK: - View Life Cycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        self.view.opaque = false
        
        
        // Setting up Survey View
        
        
        surveyView = UIView(frame: CGRect(x: 20, y: self.view.frame.height / 4, width: self.view.frame.width - 40, height: self.view.frame.height / 2))
        surveyView.backgroundColor = hexStringToUIColor(backgroundColorCode)
        
        self.view.addSubview(surveyView)
        
        
        // Setting up Welcome Text
        
        
        faciliationTextLabel = UILabel(frame: CGRect(x: 0, y: 10, width: surveyView.frame.width, height: 20))
        faciliationTextLabel.font = UIFont(name: "Helvetica", size: 18)
        faciliationTextLabel.numberOfLines = 2
        faciliationTextLabel.textAlignment = .Center
        faciliationTextLabel.text = self.welcomeText
        
        surveyView.addSubview(faciliationTextLabel)
        
        
        // Setting up Primary Button
        
        
        let aPrimaryButtonWidth: CGFloat = 120
        
        let aPrimaryButtonXAlign: CGFloat = (surveyView.frame.width - aPrimaryButtonWidth) / 2
        let aPrimaryButtonYAlign: CGFloat = (surveyView.frame.height - 50) / 2
        
        primaryButton = UIButton(frame: CGRect(x: aPrimaryButtonXAlign, y: aPrimaryButtonYAlign, width: aPrimaryButtonWidth, height: 50))
        primaryButton.backgroundColor = UIColor(red: 213/255, green: 25/255, blue: 44/255, alpha: 1.0)
        primaryButton.setTitle("CONTINUE", forState: .Normal)
        primaryButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        primaryButton.setTitleColor(.whiteColor(), forState: .Normal)
        primaryButton.addTarget(self, action: #selector(CCSurveyViewController.primaryButtonTapped), forControlEvents: .TouchUpInside)
        
        surveyView.addSubview(primaryButton)
        
        
        // Setting up CC Footer
        
        
        footerLabel = UILabel(frame: CGRect(x: 0, y: surveyView.frame.size.height - 50, width: surveyView.frame.width, height: 20))
        footerLabel.font = UIFont(name: "Helvetica", size: 11)
        footerLabel.text = "Customer Delight powered by"
        footerLabel.textAlignment = .Center
        
        surveyView.addSubview(footerLabel)
        
        
        // Setting up CloudCherry Logo
        
        
        let aLogoImage = UIImage(named: "CCLogo", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
        let aLogoImageWidth = (aLogoImage?.size.width)! - 10
        let aLogoImageHeight = (aLogoImage?.size.height)! - 10
        
        cloudCherryLogoImageView = UIImageView(frame: CGRect(x: (surveyView.frame.width - aLogoImageWidth) / 2, y: surveyView.frame.height - 30, width: aLogoImageWidth, height: aLogoImageHeight))
        cloudCherryLogoImageView.contentMode = .ScaleAspectFit
        cloudCherryLogoImageView.image = aLogoImage
        
        surveyView.addSubview(cloudCherryLogoImageView)
        
        
        // Adding Observers for Keyboard Show/Hide
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CCSurveyViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CCSurveyViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: self.view.window)
        
        
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        
        // Removing Observers
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Notification Methods for Keyboard Show/Hide
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if (!keyboardAppeared) {
            
            keyboardAppeared = true
            
            if yOffset == 0 {
                yOffset = self.surveyView.frame.origin.y
                self.surveyView.frame.origin.y = 20
            } else {
                
            }
            
        }
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
        if (keyboardAppeared) {
            
            keyboardAppeared = false
            
            if yOffset != 0 {
                self.surveyView.frame.origin.y = yOffset
                yOffset = 0
            } else {
                
            }
            
        }
        
    }
    
    
    // MARK: - FloatRatingViewDelegate Method
    
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        
        print("Star Rating: \(Int(self.starRatingView.rating))")
        
        starRatingQuestionAnswered = true
        selectedRating = Int(self.starRatingView.rating)
        
    }
    
    
    // MARK: - Private Methods
    
    
    // Handles Button Tap for Primary button
    
    
    func primaryButtonTapped() {
        
        primaryButtonCounter += 1
        
        if (primaryButtonCounter == 1) {
            
            faciliationTextLabel.hidden = true
            primaryButton.hidden = true
            footerLabel.hidden = true
            cloudCherryLogoImageView.hidden = true
            
            
            // Setting up Header View for Survey View
            
            
            headerView = UIView(frame: CGRect(x: 0, y: 0, width: surveyView.frame.width, height: 50))
            headerView.backgroundColor = hexStringToUIColor(headerColorCode)
            
            surveyView.addSubview(headerView)
            
            
            // Setting up Text Label in Header View
            
            
            headerLabel = UILabel(frame: CGRect(x: 10, y: 15, width: headerView.frame.width - 20, height: 20))
            headerLabel.adjustsFontSizeToFitWidth = true
            headerLabel.font = UIFont(name: "Helvetica", size: 15)
            headerLabel.textColor = UIColor.whiteColor()
            headerView.addSubview(headerLabel)
            
            
            // Setting up Footer View for Survey View
            
            
            footerView = UIView(frame: CGRect(x: 0, y: surveyView.frame.height - 50, width: surveyView.frame.width, height: 50))
            footerView.backgroundColor = hexStringToUIColor(footerColorCode)
            
            surveyView.addSubview(footerView)
            
            
            // Setting up Logo Image in Footer View
            
            
            let aLogoImageViewXAlign: CGFloat = (surveyView.frame.width - 50) / 2
            
            logoImageView = UIImageView(frame: CGRect(x: aLogoImageViewXAlign, y: 0, width: 50, height: 50))
            logoImageView.image = self.logoImage
            
            footerView.addSubview(logoImageView)
            
            
            // Setting up Question Counter
            
            
            let aQuestionCounterLabelView = UIView(frame: CGRect(x: surveyView.frame.width - 60, y: surveyView.frame.height - 70, width: 50, height: 20))
            
            surveyView.addSubview(aQuestionCounterLabelView)
            
            questionCounterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
            questionCounterLabel.font = UIFont(name: "Helvetica", size: 11)
            questionCounterLabel.textAlignment = .Right
            
            aQuestionCounterLabelView.addSubview(questionCounterLabel)
            
            
            // Setting up Previous Button in Footer View
            
            
            previousButton = UIButton(type: .Custom)
            previousButton.frame = CGRect(x: 10, y: 5, width: 100, height: 40)
            previousButton.backgroundColor = UIColor.lightGrayColor()
            previousButton.setTitle("PREVIOUS", forState: .Normal)
            previousButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            previousButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
            previousButton.addTarget(self, action: #selector(CCSurveyViewController.previousButtonTapped), forControlEvents: .TouchUpInside)
            
            footerView.addSubview(previousButton)
            
            
            // Setting up Next/Submit Button in Footer View
            
            
            submitButton = UIButton(type: .Custom)
            submitButton.frame = CGRect(x: surveyView.frame.width - 110, y: 5, width: 100, height: 40)
            submitButton.backgroundColor = UIColor.lightGrayColor()
            submitButton.setTitle("NEXT", forState: .Normal)
            submitButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            submitButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
            submitButton.addTarget(self, action: #selector(CCSurveyViewController.nextButtonTapped), forControlEvents: .TouchUpInside)
            
            footerView.addSubview(submitButton)
            
            self.nextButtonTapped()
            
        } else {
            
            self.navigationController?.popToRootViewControllerAnimated(false)
            
        }
        
    }
    
    
    // Handles button tap for Previous Button
    
    
    func previousButtonTapped() {
        
        self.questionCounter -= 1
        
        self.showQuestion()
        
    }
    
    
    // Handles showing the next question
    
    
    func nextButtonTapped() {
        
        self.questionCounter += 1
        
        self.showQuestion()
        
    }
    
    
    // Handles showing question
    
    
    func showQuestion() {
        
        if (self.questionCounter <= questionTexts.count) {
            
            questionCounterLabel.text = "\(self.questionCounter)/\(questionTexts.count)"
            
        }
        
        switch (self.questionCounter) {
            
        case 1:
            
            self.view.endEditing(true)
            
            previousButton.hidden = true
            
            faciliationTextLabel.hidden = true
            
            headerLabel.text = questionTexts[self.questionCounter - 1]
            
            multiLineTextView.removeFromSuperview()
            starRatingView.removeFromSuperview()
            
            
            // Setting up Rating System
            
            
            let aButtonWidth = ((surveyView.frame.width) - 10) / 11
            
            let aRatingButtonYAlign: CGFloat = (surveyView.frame.height - aButtonWidth) / 2
            
            for anIndex in 0 ..< 11 {
                
                let aRatingButton = UIButton(type: .Custom)
                aRatingButton.frame = CGRect(x: ((aButtonWidth * CGFloat(anIndex)) + 5), y: aRatingButtonYAlign, width: aButtonWidth, height: aButtonWidth)
                aRatingButton.tag = anIndex + 1
                aRatingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                aRatingButton.backgroundColor = UIColor(red: red[anIndex], green: green[anIndex], blue: blue[anIndex], alpha: 1.0)
                aRatingButton.setTitle("\(anIndex)", forState: .Normal)
                aRatingButton.titleLabel?.font = UIFont(name: "Helvetica", size: 11)
                aRatingButton.addTarget(self, action: #selector(CCSurveyViewController.npsRatingButtonTapped(_:)), forControlEvents: .TouchUpInside)
                
                surveyView.addSubview(aRatingButton)
                
            }
            
            if (ratingTexts.count != 0) {
                
                let aRatingOneLabel = UILabel(frame: CGRect(x: 5, y: (aRatingButtonYAlign + aButtonWidth + 5), width: 50, height: 20))
                aRatingOneLabel.text = ratingTexts[0]
                aRatingOneLabel.font = UIFont(name: "Helvetica", size: 10)
                
                surveyView.addSubview(aRatingOneLabel)
                
                
                let aRatingTwoLabel = UILabel(frame: CGRect(x: surveyView.frame.width - 105, y: (aRatingButtonYAlign + aButtonWidth + 5), width: 100, height: 20))
                aRatingTwoLabel.textAlignment = .Right
                aRatingTwoLabel.text = ratingTexts[1]
                aRatingTwoLabel.font = UIFont(name: "Helvetica", size: 10)
                
                surveyView.addSubview(aRatingTwoLabel)
                
            }
            
        case 2:
            
            previousButton.hidden = false
            
            self.submitResponse()
            
            starRatingView.removeFromSuperview()
            
            headerLabel.text = questionTexts[self.questionCounter - 1]
            
            for aView in self.surveyView.subviews {
                
                if (aView.isKindOfClass(UIButton)) {
                    
                    aView.removeFromSuperview()
                    
                }
                
                if (aView.isKindOfClass(UILabel)) {
                    
                    aView.removeFromSuperview()
                    
                }
                
            }
            
            multiLineTextView = UITextView(frame: CGRect(x: 5, y: 100, width: self.surveyView.frame.width - 10, height: self.surveyView.frame.height - 200))
            multiLineTextView.layer.borderColor = UIColor.blackColor().CGColor
            multiLineTextView.layer.borderWidth = 1.0
            multiLineTextView.autocorrectionType = .No
            multiLineTextView.spellCheckingType = .No
            
            surveyView.addSubview(multiLineTextView)
            
            
        case 3:
            
            self.view.endEditing(true)
            
            self.submitResponse()
            
            headerLabel.text = questionTexts[self.questionCounter - 1]
            
            singleLineTextField.removeFromSuperview()
            
            for aView in self.surveyView.subviews {
                
                if (aView.isKindOfClass(UITextView)) {
                    
                    aView.removeFromSuperview()
                    
                }
                
            }
            
            let aStarRatingYAlign: CGFloat = (self.surveyView.frame.height - 40) / 2
            
            starRatingView = FloatRatingView(frame: CGRect(x: 40, y: aStarRatingYAlign, width: self.surveyView.frame.width - 80, height: 40))
            
            starRatingView.delegate = self
            starRatingView.emptyImage = UIImage(named: "StarEmpty", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
            starRatingView.fullImage = UIImage(named: "StarFull", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
            starRatingView.contentMode = UIViewContentMode.ScaleAspectFit
            
            self.surveyView.addSubview(starRatingView)
            
            
        case 4:
            
            self.submitResponse()
            
            headerLabel.text = questionTexts[self.questionCounter - 1]
            
            for aView in self.surveyView.subviews {
                
                if (aView.isKindOfClass(FloatRatingView)) {
                    
                    aView.removeFromSuperview()
                    
                }
                
            }
            
            self.surveyView.endEditing(true)
            
            let aSingleLineTextFieldY: CGFloat = (self.surveyView.frame.height - 40) / 2
            
            singleLineTextField = UITextField(frame: CGRect(x: 5, y: aSingleLineTextFieldY, width: self.surveyView.frame.width - 10, height: 40))
            singleLineTextField.borderStyle = .Line
            singleLineTextField.keyboardType = .Default
            
            self.surveyView.addSubview(singleLineTextField)
            
        case 5:
            
            self.submitResponse()
            
            headerLabel.text = questionTexts[self.questionCounter - 1]
            
            self.surveyView.endEditing(true)
            
            singleLineTextField.text = ""
            singleLineTextField.keyboardType = .NumberPad
            
        case 6:
            
            self.submitResponse()
            
            headerLabel.text = ""
            
            for aView in self.surveyView.subviews {
                
                if (aView.isKindOfClass(UITextField)) {
                    
                    aView.removeFromSuperview()
                    
                }
                
            }
            
            questionCounterLabel.removeFromSuperview()
            
            headerView.hidden = true
            footerView.hidden = true
            logoImageView.hidden = true
            
            faciliationTextLabel.hidden = false
            faciliationTextLabel.frame = CGRect(x: 0, y: 10, width: surveyView.frame.width, height: 20)
            faciliationTextLabel.text = self.thankYouText
            
            surveyView.addSubview(faciliationTextLabel)
            
            primaryButton.hidden = false
            primaryButton.setTitle("CLOSE", forState: .Normal)
            
            surveyView.addSubview(primaryButton)
            surveyView.addSubview(footerLabel)
            
            footerLabel.hidden = false
            cloudCherryLogoImageView.hidden = false
            
            submitButton.setTitle("FINISH", forState: .Normal)
            
        default:
            
            break
            
        }
        
    }
    
    
    // Submits the partial response after every question
    
    
    func submitResponse() {
        
        let aRequest = NSMutableURLRequest(URL: NSURL(string: "\(_IP)\(POST_ANSWER_PARTIAL)")!)
        
        var aSurveyResponse = Dictionary<String, AnyObject>()
        var aSurveyResponseArray: Array<AnyObject> = []
        var aCurrentQuestionAnswered = false
        
        switch (self.questionCounter) {
            
        case 2:
            
            // NPS Question
            
            if (npsQuestionAnswered) {
                
                aCurrentQuestionAnswered = true
                
                aSurveyResponse = ["numberInput" : selectedRating, "questionId" : self.questionIDs[0], "questionText" : self.questionTexts[0]]
                
            }
            
        case 3:
            
            // Multiline Answer
            
            if (multiLineTextView.text != "") {
                
                aCurrentQuestionAnswered = true
                
                let aResponseText = multiLineTextView.text
                
                aSurveyResponse = ["textInput" : aResponseText, "questionId" : self.questionIDs[1], "questionText" : self.questionTexts[1]]
                
            }
            
        case 4:
            
            // Star Rating Answer
            
            if (starRatingQuestionAnswered) {
                
                aCurrentQuestionAnswered = true
                
                aSurveyResponse = ["numberInput" : selectedRating, "questionId" : self.questionIDs[2], "questionText" : self.questionTexts[2]]
                
            }
            
        case 5:
            
            // Single Line AlphaNumeric Text
            
            if (singleLineTextField.text != "") {
            
                aCurrentQuestionAnswered = true
                
                aSurveyResponse = ["textInput" : singleLineTextField.text!, "questionId" : self.questionIDs[3], "questionText" : self.questionTexts[3]]
                
            }
            
        case 6:
            
            // Single Line Numeric Text
            
            if (singleLineTextField.text != "") {
                
                aCurrentQuestionAnswered = true
            
                aSurveyResponse = ["textInput" : singleLineTextField.text!, "questionId" : self.questionIDs[4], "questionText" : self.questionTexts[4]]
                
            }
            
        default:
            
            break
            
        }
        
        if (aCurrentQuestionAnswered) {
            
            if (!_PREFILL_EMAIL.isEmpty) {
                
                aSurveyResponse["prefillEmail"] = _PREFILL_EMAIL
                
            }
            
            if (!_PREFILL_MOBILE.isEmpty) {
                
                aSurveyResponse["prefillMobile"] = _PREFILL_MOBILE
                
            }
            
        }
        
        aSurveyResponseArray.append(aSurveyResponse)
        
        let aJsonData: NSData =  try! NSJSONSerialization.dataWithJSONObject(aSurveyResponseArray, options: NSJSONWritingOptions.PrettyPrinted)
        let aJsonString: String = String(data: aJsonData, encoding: NSUTF8StringEncoding)!
        
        print(aJsonString)
        
        let aPostData = NSMutableData(data: aJsonString.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        aRequest.HTTPMethod = "POST"
        aRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        aRequest.HTTPBody = aPostData
        
        let aTaskOne = NSURLSession.sharedSession().dataTaskWithRequest(aRequest) { (aData, aResponse, anError) in
            
            if let aHttpResponse = aResponse as? NSHTTPURLResponse {
                
                let aResponseStatusCode = aHttpResponse.statusCode
                
                print("Response Status Code: \(aResponseStatusCode)")
                
                if (aResponseStatusCode == 204) {
                    
                    print("\(self.questionDisplayTypes[self.questionCounter - 2]) Response Submitted")
                    
                }
                
            } else {
                
                print(anError?.localizedDescription)
                
            }
            
        }
        
        aTaskOne.resume()
        
    }
    
    
    // Converts HEX color string to RGB (HEX received from API response)
    
    
    func hexStringToUIColor(iHexColorCodeString:String) -> UIColor {
        
        var aColorCodeString:String = iHexColorCodeString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (aColorCodeString.hasPrefix("#")) {
            aColorCodeString = aColorCodeString.substringFromIndex(aColorCodeString.startIndex.advancedBy(1))
        }
        
        if ((aColorCodeString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var aRGBValue:UInt32 = 0
        NSScanner(string: aColorCodeString).scanHexInt(&aRGBValue)
        
        return UIColor(
            red: CGFloat((aRGBValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((aRGBValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(aRGBValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
    
    
    // Handles NPS Survey button taps
    
    
    func npsRatingButtonTapped(iButton: UIButton) {
        
        if let aTappedButton = self.view.viewWithTag(iButton.tag) as? UIButton {
            
            npsQuestionAnswered = true
            
            let anIndex = tappedButton.tag - 1
            
            if (anIndex != -1) {
                
                tappedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                tappedButton.backgroundColor = UIColor(red: red[anIndex], green: green[anIndex], blue: blue[anIndex], alpha: 1.0)
                tappedButton.layer.borderColor = UIColor.clearColor().CGColor
                
            }
            
            aTappedButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            aTappedButton.backgroundColor = UIColor.lightGrayColor()
            aTappedButton.layer.borderColor = UIColor.blackColor().CGColor
            aTappedButton.layer.borderWidth = 1.0
            
            tappedButton = aTappedButton
            
            selectedRating = iButton.tag - 1
            
        }
        
    }
    
}
