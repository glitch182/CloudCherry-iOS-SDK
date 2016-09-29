# CloudCherry-iOS-SDK

iOS SDK for CloudCherry

## Steps to Install Framework:

1. Drag and Drop the framework in your Xcode Project

**For Swift Projects**

2. Click on File -> New -> File
3. Under iOS -> Source, select ’Objective-C File’ of File Type: ‘Empty File’
4. Save it in your current Xcode project location
5. When asked for an option to configure an Objective-C Bridging Header, accept and create
6. Copy and paste ```#import <CloudCherryiOSFramework/CloudCherryiOSFramework.h>``` in your Bridging Header
7. To start the survey, configure and start the SDK by:
	
```
let aSurvey = CCSurvey(iUsername: <Your username here>, iPassword: <Your password here>)
self.navigationController?.pushViewController(aSurvey, animated: false)
```
