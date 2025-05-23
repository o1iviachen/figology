# README

## Name
_figology._ is a fibre-tracking application.

## Features
- Facilitates logging in using email and password, or Google accounts.
- Allows the user to input their personalised fibre goal or calculate their fibre goal based on their age.
- Allows the user to log, edit, and delete their intake of various foods, from which their fibre intake is calculated and updated. 
- Organises and displays fibre intake by meal, including historical data. 

## Installation
This iOS app is only supported for Mac. 

### Installing the required software and dependencies 
XCode and CocoaPods need to be installed to run this application. 
If these are already installed, skip this section. 
1. Install XCode from the App Store. 
2. Open the Terminal and install CocoaPods by entering ``sudo gem install cocoapods``.

### Cloning and running _figology._
1. Open XCode and select **Clone Git Repository**. 
2. Enter the [repository link](https://github.com/o1iviachen/figology.git) and select **Clone**.
3. Select a location to save the cloned repository to and select **Clone** to complete the cloning process.
4. Go to the Project File icon at the top of the Project Navigator (left-side panel) and change the Bundle Identifier. Apple recommends the following format: ``com.[your-organization-or-name].[app-name]``.
5. Log in to [Firebase](https://firebase.google.com/) and go to console.
6. Create a Firebase project. At the following screen, select the iOS+ icon. Only follow the shown steps 1 and 2. Ensure to use your Bundle Identifier as the Apple bundle ID. 
7. To install CocoaPods to this specific project, quit the project and open the Terminal and navigate to the folder containing the cloned repository using ``cd`` and the entire pathway of the file.
8. On the left-side panel, click the Build dropdown and select Authentication. Add Email/Password and Google as authentication methods. Click the Build dropdown again and select Firebase Database. Create a new database.
9. To install CocoaPods to this specific project, open the Terminal and navigate to the folder containing the repository using ``cd`` and the entire pathway of the file.
   This may look like ``cd /Users/su/Desktop/figology``. Once navigated to the folder of the workspace, enter ``pod install``. From now on, only open the new .xcworkspace file.
10. Create a new Configuration Settings File in the project folder titled "Secrets." Include your Nutritionix API Key and ID as variables named ``NUTRITIONIX_API_KEY`` and ``NUTRITIONIX_API_ID``.
11. In XCode, click the Run button at the top of the left sidebar or press ``Cmd + R`` to run _figology._ 

## Known Bugs
After signing up, the user will not be directed to the calculator page automatically. 
However, the user should direct themselves to this page to set their fibre goal. 
This bug doesn't hinder the functionality of the application. 

## Support
Contact olivia63chen@gmail.com directly or through the support page on _figology._ if help is required. 

## Sources 
|Source |Description |
|---     |---          |
|https://www.udemy.com/course/ios-13-app-development-bootcamp/?couponCode=ST20MT190425G1|We followed many videos from this course to develop various parts of your project, including familiarising ourselves with Swift, learning how to use CocoaPods, and working with APIs.|
|https://www.youtube.com/watch?v=B_VFHeg2LH4&t=7s|We used this tutorial to develop and implement the Calendar UI on _figology._|
