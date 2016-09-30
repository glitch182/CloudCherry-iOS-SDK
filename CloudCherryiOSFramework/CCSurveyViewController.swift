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


class headerFooterView : UIView {
    
    override init(frame: CGRect) {
        
        super.init(frame : frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}


class questionCounterLabel : UILabel {
    
    override init(frame: CGRect) {
        
        super.init(frame : frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}



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
    
    var isSingleSelect = Bool()
    var singleSelectOptions = [String]()
    var multiSelectOptions = [String]()
    
    var questionCounter = 0
    var primaryButtonCounter = 0
    var showPreviousQuestion = false
    
    var partialResponseID = String()
    
    var logoImage = UIImage()
    
    var ratingTexts = [String]()
    
    var npsQuestionAnswered = false
    var starRatingQuestionAnswered = false
    var smileRatingQuestionAnswered = false
    
    var selectButtonMaxX = CGFloat(0)
    var selectButtonMaxY = CGFloat(0)
    
    var selectedNPSRating = Int()
    var selectedSmileRating = Int()
    var selectedSingleSelectOption = String()
    var selectedMultiSelectOptions = [String]()
    
    var headerColorCode = String()
    var footerColorCode = String()
    var backgroundColorCode = String()
    
    var red: [CGFloat] = [234/255, 234/255, 234/255, 234/255, 234/255, 234/255, 240/255, 239/255, 239/255, 116/255, 62/255]
    var green: [CGFloat] = [15/255, 61/255, 87/255, 113/255, 127/255, 148/255, 158/255, 219/255, 243/255, 244/255, 158/255]
    var blue: [CGFloat] = [42/255, 35/255, 37/255, 40/255, 41/255, 49/255, 43/255, 54/255, 59/255, 60/255, 76/255]
    
    var smileyUnicodes = ["\u{1F620}", "\u{1F61E}", "\u{1F610}", "\u{1F60A}", "\u{1F60D}"]
    
    
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
    
    var questionCtrLabel = questionCounterLabel()
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
        selectedNPSRating = Int(self.starRatingView.rating)
        
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
            
            
            headerView = headerFooterView(frame: CGRect(x: 0, y: 0, width: surveyView.frame.width, height: 50))
            headerView.backgroundColor = hexStringToUIColor(headerColorCode)
            
            surveyView.addSubview(headerView)
            
            
            // Setting up Text Label in Header View
            
            
            headerLabel = UILabel(frame: CGRect(x: 10, y: 15, width: headerView.frame.width - 20, height: 20))
            headerLabel.adjustsFontSizeToFitWidth = true
            headerLabel.font = UIFont(name: "Helvetica", size: 15)
            headerLabel.textColor = UIColor.whiteColor()
            headerView.addSubview(headerLabel)
            
            
            // Setting up Footer View for Survey View
            
            
            footerView = headerFooterView(frame: CGRect(x: 0, y: surveyView.frame.height - 50, width: surveyView.frame.width, height: 50))
            footerView.backgroundColor = hexStringToUIColor(footerColorCode)
            
            surveyView.addSubview(footerView)
            
            
            // Setting up Logo Image in Footer View
            
            
            let aLogoImageViewXAlign: CGFloat = (surveyView.frame.width - 50) / 2
            
            logoImageView = UIImageView(frame: CGRect(x: aLogoImageViewXAlign, y: 0, width: 50, height: 50))
            logoImageView.image = self.logoImage
            
            footerView.addSubview(logoImageView)
            
            
            // Setting up Question Counter
            
            
            questionCtrLabel = questionCounterLabel(frame: CGRect(x: surveyView.frame.width - 60, y: surveyView.frame.height - 70, width: 50, height: 20))
            questionCtrLabel.font = UIFont(name: "Helvetica", size: 11)
            questionCtrLabel.textAlignment = .Right
            
            surveyView.addSubview(questionCtrLabel)
            
            
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
        
        self.selectButtonMaxX = 0
        
        self.showPreviousQuestion = true
        
        self.showQuestion()
        
    }
    
    
    // Handles showing the next question
    
    
    func nextButtonTapped() {
        
        self.questionCounter += 1
        
        self.selectButtonMaxX = 0
        
        self.showPreviousQuestion = false
        
        self.showQuestion()
        
    }
    
    
    // Handles removing subviews
    
    
    func removeSubViews() {
        
        if ((self.questionCounter - 1 != 0) && (!self.showPreviousQuestion)) {
            
            self.submitResponse()
            
        }
        
        for aView in self.surveyView.subviews {
            
            if ((!aView.isKindOfClass(headerFooterView)) && (!aView.isKindOfClass(questionCounterLabel))) {
                
                aView.removeFromSuperview()
                
            }
            
        }
        
        if (self.questionCounter == questionTexts.count) {
            
            questionCtrLabel.removeFromSuperview()
            
        }
        
    }
    
    
    // Handles showing question
    
    
    func showQuestion() {
        
        self.removeSubViews()
        
        if (self.questionCounter <= questionTexts.count) {
            
            questionCtrLabel.text = "\(self.questionCounter)/\(questionTexts.count - 1)"
            
        }
        
        if (self.questionCounter - 1 == 0) {
            
            previousButton.hidden = true
            
        } else {
            
            previousButton.hidden = false
            faciliationTextLabel.hidden = true
            
        }
        
        self.surveyView.endEditing(true)
        
        headerLabel.text = questionTexts[self.questionCounter - 1]
        
        switch (self.questionDisplayTypes[self.questionCounter - 1]) {
            
        case "Scale":
            
            
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
            
        case "MultilineText":
            
            multiLineTextView = UITextView(frame: CGRect(x: 5, y: 100, width: self.surveyView.frame.width - 10, height: self.surveyView.frame.height - 200))
            multiLineTextView.layer.borderColor = UIColor.blackColor().CGColor
            multiLineTextView.layer.borderWidth = 1.0
            multiLineTextView.autocorrectionType = .No
            multiLineTextView.spellCheckingType = .No
            
            surveyView.addSubview(multiLineTextView)
            
        case "Star-5":
            
            let aStarRatingYAlign: CGFloat = (self.surveyView.frame.height - 40) / 2
            
            starRatingView = FloatRatingView(frame: CGRect(x: 40, y: aStarRatingYAlign, width: self.surveyView.frame.width - 80, height: 40))
            
            starRatingView.delegate = self
            starRatingView.emptyImage = UIImage(named: "StarEmpty", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
            starRatingView.fullImage = UIImage(named: "StarFull", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
            starRatingView.contentMode = UIViewContentMode.ScaleAspectFit
            
            self.surveyView.addSubview(starRatingView)
            
            
        case "Text":
            
            let aSingleLineTextFieldY: CGFloat = (self.surveyView.frame.height - 40) / 2
            
            singleLineTextField = UITextField(frame: CGRect(x: 5, y: aSingleLineTextFieldY, width: self.surveyView.frame.width - 10, height: 40))
            singleLineTextField.borderStyle = .Line
            singleLineTextField.keyboardType = .Default
            
            self.surveyView.addSubview(singleLineTextField)
            
        case "Number":
            
            let aSingleLineTextFieldY: CGFloat = (self.surveyView.frame.height - 40) / 2
            
            singleLineTextField = UITextField(frame: CGRect(x: 5, y: aSingleLineTextFieldY, width: self.surveyView.frame.width - 10, height: 40))
            singleLineTextField.borderStyle = .Line
            singleLineTextField.keyboardType = .NumberPad
            
            self.surveyView.addSubview(singleLineTextField)
            
        case "Smile-5" :
            
            let aWidth = self.surveyView.frame.width - 50
            let aButtonWidth = aWidth / 5
            let aRatingButtonYAlign: CGFloat = (surveyView.frame.height - aButtonWidth) / 2
            
            for anIndex in 0 ..< 5 {
                
                let aSmileyButton = UIButton(type: .Custom)
                aSmileyButton.frame = CGRect(x: ((aButtonWidth * CGFloat(anIndex)) + 5) + 22, y: aRatingButtonYAlign, width: aButtonWidth, height: 50)
                aSmileyButton.tag = anIndex + 1
                aSmileyButton.setTitle(self.smileyUnicodes[anIndex], forState: .Normal)
                aSmileyButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
                aSmileyButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                aSmileyButton.layer.borderWidth = 1.0
                aSmileyButton.addTarget(self, action: #selector(CCSurveyViewController.smileRatingButtonTapped(_:)), forControlEvents: .TouchUpInside)
                
                self.surveyView.addSubview(aSmileyButton)
                
            }
            
        case "MultiSelect" :
            
            self.setupOptionButtons("MultiSelect")
            
        case "Select":
            
            self.setupOptionButtons("Select")
            
        case "End":
            
            questionCtrLabel.removeFromSuperview()
            
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
            
            footerLabel.hidden = false
            
            surveyView.addSubview(footerLabel)
            
            let aLogoImage = UIImage(named: "CCLogo", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)
            let aLogoImageWidth = (aLogoImage?.size.width)! - 10
            let aLogoImageHeight = (aLogoImage?.size.height)! - 10
            
            cloudCherryLogoImageView = UIImageView(frame: CGRect(x: (surveyView.frame.width - aLogoImageWidth) / 2, y: surveyView.frame.height - 30, width: aLogoImageWidth, height: aLogoImageHeight))
            cloudCherryLogoImageView.contentMode = .ScaleAspectFit
            cloudCherryLogoImageView.image = aLogoImage
            
            surveyView.addSubview(cloudCherryLogoImageView)
            
            submitButton.setTitle("FINISH", forState: .Normal)
            
        default:
            
            break
            
        }
        
    }
    
    
    // Sets up Single/Multi Select Buttons
    
    
    func setupOptionButtons(iQuestionDisplayType: String) {
        
        var anOptions = [String]()
        var anOptionButtonY = CGFloat(5)
        var anOnlyOneLine = true
        
        var aFirstButtonTag = 1
        var aLastButtonTag = 1
        
        if (iQuestionDisplayType == "MultiSelect") {
            
            anOptions = multiSelectOptions
            
        } else {
            
            anOptions = singleSelectOptions
            
        }
        
        let aButtonView = UIView(frame: CGRect(x: 0, y: 50, width: self.surveyView.frame.width, height: self.surveyView.frame.height - 100))
        
        for anIndex in 0 ..< anOptions.count {
            
            let anOptionButton = UIButton(type: .Custom)
            anOptionButton.frame = CGRect(x: (self.selectButtonMaxX) + 10, y: anOptionButtonY, width: 50, height: 40)
            anOptionButton.setTitle(anOptions[anIndex], forState: .Normal)
            anOptionButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            anOptionButton.titleLabel?.font = UIFont(name: "Helvetica", size: 11)
            anOptionButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            anOptionButton.layer.borderWidth = 1.0
            anOptionButton.tag = anIndex + 1
            
            anOptionButton.sizeToFit()
            
            aLastButtonTag = anIndex + 1
            
            let aButtonMaxX = CGRectGetMaxX(anOptionButton.frame)
            let aButtonWidth = anOptionButton.frame.width
            
            anOptionButton.frame = CGRect(x: (self.selectButtonMaxX) + 10, y: anOptionButtonY, width: aButtonWidth + 6, height: 40)
            
            aButtonView.addSubview(anOptionButton)
            
            if (aButtonMaxX >= (self.surveyView.frame.width - 10)) {
                
                anOnlyOneLine = false
                
                anOptionButtonY = CGRectGetMaxY(anOptionButton.frame) + 10
                self.selectButtonMaxX = 0
                
                anOptionButton.frame = CGRect(x: (self.selectButtonMaxX) + 10, y: anOptionButtonY, width: aButtonWidth + 6, height: 40)
                
                let aLastButton = aButtonView.viewWithTag(aLastButtonTag - 1) as! UIButton
                let aLastButtonMaxX = CGRectGetMaxX(aLastButton.frame)
                let aRemainingPadding = self.surveyView.frame.width - aLastButtonMaxX
                var aNewButtonX = (aRemainingPadding / 2) + 5
                
                for anIndex in aFirstButtonTag ..< aLastButtonTag {
                    
                    let aButton = aButtonView.viewWithTag(anIndex) as! UIButton
                    
                    if (anIndex == aFirstButtonTag) {
                        
                        aButton.frame = CGRect(x: aNewButtonX, y: CGRectGetMinY(aButton.frame), width: aButton.frame.width, height: 40)
                        aNewButtonX = CGRectGetMaxX(aButton.frame) + 10
                        
                    } else {
                        
                        aButton.frame = CGRect(x: aNewButtonX, y: CGRectGetMinY(aButton.frame), width: aButton.frame.width, height: 40)
                        aNewButtonX = CGRectGetMaxX(aButton.frame) + 10
                        
                    }
                    
                    
                }
                
                aFirstButtonTag = aLastButtonTag
                
                anOnlyOneLine = true
                
            }
            
            self.selectButtonMaxX = CGRectGetMaxX(anOptionButton.frame)
            self.selectButtonMaxY = CGRectGetMaxY(anOptionButton.frame)
            
            if (iQuestionDisplayType == "MultiSelect") {
                
                anOptionButton.addTarget(self, action: #selector(CCSurveyViewController.multiSelectButtonTapped(_:)), forControlEvents: .TouchUpInside)
                
            } else {
                
                anOptionButton.addTarget(self, action: #selector(CCSurveyViewController.singleSelectButtonTapped(_:)), forControlEvents: .TouchUpInside)
                
            }
            
        }
        
        let aButtonViewHeight = self.selectButtonMaxY + 5
        let aButtonViewYAlign: CGFloat = (surveyView.frame.height - aButtonViewHeight) / 2
        
        aButtonView.frame = CGRect(x: 0, y: aButtonViewYAlign, width: self.surveyView.frame.width, height: aButtonViewHeight)
        
        self.surveyView.addSubview(aButtonView)
        
        if (anOnlyOneLine) {
            
            let aLastButton = self.surveyView.viewWithTag(aLastButtonTag) as! UIButton
            let aLastButtonMaxX = CGRectGetMaxX(aLastButton.frame)
            let aRemainingPadding = self.surveyView.frame.width - aLastButtonMaxX
            var aNewButtonX = (aRemainingPadding / 2) + 5
            
            for anIndex in aFirstButtonTag ..< aLastButtonTag + 1 {
                
                let aButton = self.view.viewWithTag(anIndex) as! UIButton
                
                if (anIndex == aFirstButtonTag) {
                    
                    aButton.frame = CGRect(x: aNewButtonX, y: CGRectGetMinY(aButton.frame), width: aButton.frame.width, height: 40)
                    aNewButtonX = CGRectGetMaxX(aButton.frame) + 10
                    
                } else {
                    
                    aButton.frame = CGRect(x: aNewButtonX, y: CGRectGetMinY(aButton.frame), width: aButton.frame.width, height: 40)
                    aNewButtonX = CGRectGetMaxX(aButton.frame) + 10
                    
                }
                
                
            }
            
        }
        
    }
    
    
    // Submits the partial response after every question
    
    
    func submitResponse() {
        
        let aRequest = NSMutableURLRequest(URL: NSURL(string: "\(_IP)\(POST_ANSWER_PARTIAL)")!)
        
        var aSurveyResponse = Dictionary<String, AnyObject>()
        var aSurveyResponseArray: Array<AnyObject> = []
        var aCurrentQuestionAnswered = false
        
        let anIndex = self.questionCounter - 2
        
        switch (self.questionDisplayTypes[self.questionCounter - 2]) {
            
        case "Scale":
            
            // NPS Question
            
            if (npsQuestionAnswered) {
                
                aCurrentQuestionAnswered = true
                
                aSurveyResponse = ["numberInput" : selectedNPSRating, "questionId" : self.questionIDs[anIndex], "questionText" : self.questionTexts[anIndex]]
                
            }
            
        case "MultilineText":
            
            // Multiline Answer
            
            if (multiLineTextView.text != "") {
                
                aCurrentQuestionAnswered = true
                
                let aResponseText = multiLineTextView.text
                
                aSurveyResponse = ["textInput" : aResponseText, "questionId" : self.questionIDs[anIndex], "questionText" : self.questionTexts[anIndex]]
                
            }
            
        case "Star-5":
            
            // Star Rating Answer
            
            if (starRatingQuestionAnswered) {
                
                aCurrentQuestionAnswered = true
                
                aSurveyResponse = ["numberInput" : selectedNPSRating, "questionId" : self.questionIDs[anIndex], "questionText" : self.questionTexts[anIndex]]
                
            }
            
        case "Text":
            
            // Single Line AlphaNumeric Text
            
            if (singleLineTextField.text != "") {
            
                aCurrentQuestionAnswered = true
                
                aSurveyResponse = ["textInput" : singleLineTextField.text!, "questionId" : self.questionIDs[anIndex], "questionText" : self.questionTexts[anIndex]]
                
                singleLineTextField.text = ""
                
            }
            
        case "Number":
            
            // Single Line Numeric Text
            
            if (singleLineTextField.text != "") {
                
                aCurrentQuestionAnswered = true
            
                aSurveyResponse = ["textInput" : singleLineTextField.text!, "questionId" : self.questionIDs[anIndex], "questionText" : self.questionTexts[anIndex]]
                
                singleLineTextField.text = ""
                
            }
            
        case "Smile-5" :
            
            // Smiley Question
            
            if (smileRatingQuestionAnswered) {
                
                aCurrentQuestionAnswered = true
                
                aSurveyResponse = ["numberInput" : selectedSmileRating, "questionId" : self.questionIDs[anIndex], "questionText" : self.questionTexts[anIndex]]
                
            }
            
        case "MultiSelect" :
            
            // Multi Select Question
            
            if (selectedMultiSelectOptions.count != 0) {
                
                aCurrentQuestionAnswered = true
                
                var selectedMultiOptionsString = ""
                
                for anIndex in 0 ..< selectedMultiSelectOptions.count {
                    
                    if (anIndex == (selectedMultiSelectOptions.count - 1)) {
                        
                        selectedMultiOptionsString += "\(selectedMultiSelectOptions[anIndex])"
                        
                    } else {
                        
                        selectedMultiOptionsString += "\(selectedMultiSelectOptions[anIndex]),"
                        
                    }
                    
                }
                
                aSurveyResponse = ["textInput" : selectedMultiOptionsString, "questionId" : self.questionIDs[anIndex], "questionText" : self.questionTexts[anIndex]]
                
            }
            
        case "Select":
            
            // Single Select Option
            
            if (!selectedSingleSelectOption.isEmpty) {
                
                aCurrentQuestionAnswered = true
                
                aSurveyResponse = ["textInput" : selectedSingleSelectOption, "questionId" : self.questionIDs[anIndex], "questionText" : self.questionTexts[anIndex]]
                
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
        
        npsQuestionAnswered = false
        starRatingQuestionAnswered = false
        smileRatingQuestionAnswered = false
        tappedButton = UIButton()
        
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
        
        if let aTappedNPSButton = self.view.viewWithTag(iButton.tag) as? UIButton {
            
            npsQuestionAnswered = true
            
            let anIndex = tappedButton.tag - 1
            
            if (anIndex != -1) {
                
                tappedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                tappedButton.backgroundColor = UIColor(red: red[anIndex], green: green[anIndex], blue: blue[anIndex], alpha: 1.0)
                tappedButton.layer.borderColor = UIColor.clearColor().CGColor
                
            }
            
            aTappedNPSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            aTappedNPSButton.backgroundColor = UIColor.lightGrayColor()
            aTappedNPSButton.layer.borderColor = UIColor.blackColor().CGColor
            aTappedNPSButton.layer.borderWidth = 1.0
            
            tappedButton = aTappedNPSButton
            
            selectedNPSRating = iButton.tag - 1
            
        }
        
    }
    
    
    // Handles Smile Rating button taps
    
    
    func smileRatingButtonTapped(iButton: UIButton) {
        
        if let aTappedSmileButton = self.view.viewWithTag(iButton.tag) as? UIButton {
            
            smileRatingQuestionAnswered = true
            
            let anIndex = tappedButton.tag - 1
            
            if (anIndex != -1) {
                
                tappedButton.backgroundColor = UIColor.clearColor()
                
            }
            
            aTappedSmileButton.backgroundColor = UIColor.lightGrayColor()
            
            tappedButton = aTappedSmileButton
            
            selectedSmileRating = iButton.tag
            
        }
        
    }
    
    
    // Handles Single Select button taps
    
    
    func singleSelectButtonTapped(iButton: UIButton) {
        
        if let aTappedButton = self.view.viewWithTag(iButton.tag) as? UIButton {
            
            tappedButton.backgroundColor = UIColor.whiteColor()
            tappedButton = iButton
            
            aTappedButton.backgroundColor = UIColor(red: 242/255, green: 219/255, blue: 29/255, alpha: 1.0)
            
            self.selectedSingleSelectOption = (aTappedButton.titleLabel?.text!)!
            
        }
        
    }
    
    
    // Handles Multi Select button taps
    
    
    func multiSelectButtonTapped(iButton: UIButton) {
        
        if let aTappedButton = self.view.viewWithTag(iButton.tag) as? UIButton {
            
            let aSelectedButtonTitle = (aTappedButton.titleLabel?.text!)!
            
            if (self.selectedMultiSelectOptions.contains(aSelectedButtonTitle)) {
                
                self.removeSelectedString(&self.selectedMultiSelectOptions, iStringToRemove: aSelectedButtonTitle)
                aTappedButton.backgroundColor = UIColor.whiteColor()
                print(self.selectedMultiSelectOptions)
                
            } else {
                
                self.selectedMultiSelectOptions.append(aSelectedButtonTitle)
                aTappedButton.backgroundColor = UIColor(red: 242/255, green: 219/255, blue: 29/255, alpha: 1.0)
                print(self.selectedMultiSelectOptions)
                
            }
            
        }
        
    }
    
    
    func removeSelectedString (inout iFromArray: [String], iStringToRemove: String){
        
        iFromArray = iFromArray.filter{$0 != iStringToRemove}
        
    }
    
}
