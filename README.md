# README

## Name
_figology._ is a fibre-tracking application.

## Features
- Facilitates authentication using email and password or Google accounts.
- Allows users to input their fibre goal or calculate their fibre goal based on their age, height, weight, and activity level.
- Allows users to log, edit, and delete their intake of various foods, from which their fibre intake is calculated. 
- Organises and displays fibre intake by meal, including historical data. 

## Installation
This version of the application is only supported by macOS devices. 

### Installing the required software 
Xcode and CocoaPods need to be installed to run this application. 
If these are already installed, skip this section. 
1. Install Xcode from the App Store. 
2. Open the Terminal and install CocoaPods by entering ``brew install cocoapods``.

### Cloning and running _figology._
1. Open Xcode and select **Clone Git Repository**. 
2. Enter the [repository link](https://github.com/o1iviachen/figology.git) and select **Clone**.
3. Select a location to save the cloned repository and select **Clone** to complete the cloning process.
4. Go to the Project File icon at the top of the Project Navigator (left-side panel) and change the Bundle Identifier. Apple recommends the following format: ``com.[your-organization-or-name].[app-name]``. Furthermore, change your Team.
5. Log in to [Firebase](https://firebase.google.com/) and go to console.
6. Create a Firebase project. At the following screen, select the iOS+ icon. Only follow the shown steps 1 and 2, but click through all steps to reach the Project page. Ensure to use your Bundle Identifier as the Apple bundle ID and the newly added property list is exactly titled "GoogleService-Info.plist."
7. On the left-side panel, click the Build dropdown and select Authentication.
   - Add Email/Password and Google as authentication methods.
   - Click the Build dropdown again and select Firebase Database.
   - Create a new Cloud Firestore database.
8. To install CocoaPods dependencies, open the Terminal and navigate to the folder containing the cloned repository using ``cd`` and the file's entire pathway.
   This terminal command may look like ``cd /Users/su/Desktop/figology``. Then, enter ``pod install``. From now on, only open the new .xcworkspace file.
9. Create a new Configuration Settings File in the project folder titled "Secrets."
   - Create your Nutritionix API Key and ID at [Nutritionix](https://developer.nutritionix.com/signup) and store them as variables named ``NUTRITIONIX_APP_KEY`` and ``NUTRITIONIX_APP_ID``.
   - Go to the GoogleService-Info.plist, copy the value belonging to the ``REVERSED_CLIENT_ID`` key and store it as a variable named ``GOOGLE_URL_SCHEME``.
   - The file should now look like the following:
      - ```
        NUTRITIONIX_APP_KEY = <YOUR_APP_KEY>
        NUTRITIONIX_APP_ID = <YOUR_APP_ID>
        GOOGLE_URL_SCHEME = <YOUR_URL_SCHEME>
        ```
10. Go to the Project File icon and click the Project, not the Targets. Go to the Info tab. Under Configurations, select both dropdowns for Debug and Release. For both configurations, select "None" and change the field to "Secrets."
11. In Xcode, click the Run button or press ``Cmd + R`` to run _figology._ 

## Known Bugs
After signing up, users will not be directed to the calculator page automatically. 
However, users should direct themselves to this page to set their fibre goal. 
This bug does not hinder the application's functionality. 

## Support
Contact olivia63chen@gmail.com directly or through the support page on _figology._ if help is required. 

## Sources 
|Source |Description |
|---     |---          |
|https://www.udemy.com/course/ios-13-app-development-bootcamp/?couponCode=ST20MT190425G1|We followed many videos from this course to develop our project. Using this course, we familiarised ourselves with Swift, CocoaPods, and working with APIs.|
|https://www.youtube.com/watch?v=B_VFHeg2LH4&t=7s|We used this tutorial to develop and implement the Calendar UI on _figology._|
|https://stackoverflow.com/questions/37873608/how-do-i-detect-if-a-user-is-already-logged-in-firebase|We used this source to check if a user was already authenticated upon launching the application.|
|https://docx.syndigo.com/developers/docs/search-item-endpoint|We used this source to access branded food data from Nutritionix.|
|https://docx.syndigo.com/developers/docs/natural-language-for-nutrients|We used this source to access unbranded food data from Nutritionix.|
|https://cloud.google.com/firestore/docs/manage-data/add-data|This source helped us log user data to our Firestore database.|
|https://stackoverflow.com/questions/40268619/why-are-function-parameters-immutable-in-swift|This source helped us understand function parameter immutability in Swift.|
|https://firebase.google.com/docs/auth/ios/password-auth|We used this source to implement Firebase email/password login and sign-up.|
|https://firebase.google.com/docs/auth/ios/google-signin|We referenced this website when integrating Google authentication.|
|https://firebase.google.com/docs/auth/ios/manage-users|This website provided code for resetting users' passwords.|
|https://firebase.google.com/docs/firestore/query-data/get-data|This source helped us retrieve data from Firestore to create user-specific interfaces.|
|https://stackoverflow.com/questions/24103069/add-swipe-to-delete-uitableviewcell|We used code from this source to implement swipe-to-delete functionality in our Food View Controller Food Cells.|
|https://medium.com/@prabhatkasera/dispatch-async-in-ios-bd32295b042f|This article helped us use concurrency to improve our application's performance.|
|https://stackoverflow.com/questions/49376157/swift-dispatchgroup-notify-before-task-finish|This thread helped us solve issues with dispatch groups completing before loops were finished.|
|https://stackoverflow.com/questions/16608536/how-to-get-the-previous-viewcontroller-that-pushed-my-current-view|We used this source to learn how to determine the previous view controller for navigation logic.|
|https://stackoverflow.com/questions/24070450/how-to-get-the-current-time-as-datetime|We used code from this source to learn how to produce timestamps associated with users' consumed foods.|
|https://stackoverflow.com/questions/68107275/swift-5-present-viewcontroller-half-way|This source helped us learn how to present a view controller halfway up the screen for the pickers.|
|https://stackoverflow.com/questions/1509547/giving-uiview-rounded-corners|This thread taught us how to style UI elements with rounded corners.|
|https://stackoverflow.com/questions/65743004/swiftui-send-email-using-mfmailcomposeviewcontroller|We used this source to implement email support.|
|https://www.calculator.net/bmr-calculator.html|We referenced this calculator to calculate users' calorie intake to develop our fibre goal calculator.|
|https://macrofactorapp.com/does-fiber-have-calories/|We referenced this source to calculate users' fibre intake from their calorie intake, again to develop our fibre goal calculator.|
|https://www.youtube.com/watch?v=B_VFHeg2LH4&t=7s|We followed this tutorial for Firebase authentication setup in iOS environments.|
