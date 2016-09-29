# CloudCherry-iOS-SDK

iOS SDK for CloudCherry

## Steps to Install Framework:

- Drag and Drop the framework in your Xcode Project

**For Swift Projects**

- Click on File -> New -> File
- Under iOS -> Source, select ’Objective-C File’, as shown below:

![Image of creating Objective-C File]
(http://i.imgur.com/kODUOYk.png)

- Choose 'Empty File' as the File type and save it in your current Xcode project location
- When asked for an option to configure an Objective-C Bridging Header, accept and create, as shown below:

![Image of configuring and creating Objective-C File]
(http://i.imgur.com/qJyAdiw.png)

- The Bridging Header will be created under the name ```<Your Project Name>-Bridging-Header.h```
- Copy and paste ```#import <CloudCherryiOSFramework/CloudCherryiOSFramework.h>``` in your Bridging Header
- Open ```Build Settings``` of your Project Target
- Search for 'Enable Bitcode'
- Set it to 'No' as shown below:

![Image of disabling Bitcode in Project]
(http://i.imgur.com/7WrAR7l.png)

- To initialize the SDK, configure it using either Username/Password combination or by generating and using a Static Token from CloudCherry Dashboard:

**Username/Password Initialization**

```Swift
let aSurvey = CCSurvey(iUsername: <Your username here>, iPassword: <Your password here>)
```
*OR*

**Static Token Initialization**

```Swift
let aSurvey = CCSurvey(iStaticToken: <Your Static Token here>)
```

**Setting up pre-fills in SDK**

User can set up their Email ID and Mobile Number as pre-fills, which will be sent along with the survey responses

```Swift
aSurvey.setPrefill(<Enter Email ID here>, iMobileNumber: <Enter Mobile Number here>)
```

**Triggering Survey**

- Finally start the survey by using the underlying syntax:

```Swift
self.navigationController?.pushViewController(aSurvey, animated: false)
```
