//
//  CCConstants.swift
//  CloudCherryiOSFramework
//
//  Created by Vishal Chandran on 23/09/16.
//  Copyright © 2016 Vishal Chandran. All rights reserved.
//

import Foundation

var _IP = "https://api.getcloudcherry.com/api/"
var _ACCESS_TOKEN = String()
var _SURVEY_TOKEN = String()
var _DEVICE_ID = "1234"
var _IS_USING_STATIC_TOKEN = Bool()

var _USERNAME = String()
var _PASSWORD = String()

var _PREFILL_EMAIL = String()
var _PREFILL_MOBILE = String()

var POST_LOGIN_TOKEN = "LoginToken"
var POST_CREATE_SURVEY_TOKEN = "SurveyToken"
var GET_QUESTIONS_API = "SurveyByToken/\(_SURVEY_TOKEN)/\(_DEVICE_ID)"
var POST_ANSWER_PARTIAL = "PartialSurvey/\(_SURVEY_TOKEN)/\(_PARTIAL_SURVEY_COMPLETE)/\(_DEVICE_ID)"
var POST_ANSWER_ALL = "SurveyByToken/\(_SURVEY_TOKEN)"