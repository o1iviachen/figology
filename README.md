# README

## Name
_figology._

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
3. Navigate to the project's directory and enter ``pod init`` then ``pod install`` in the Terminal.

### Cloning and running _figology._
1. Open XCode and select **Clone Git Repository**. 
2. Enter the [repository link](https://github.com/o1iviachen/figology.git) and select **Clone**.
3. Select a file to save the repository to and select **Clone** to complete the cloning process.
4. To install CocoaPods to this specific project, open the Terminal and navigate to the folder containing the repository using ``cd`` and the entire pathway of the file.
   This may look like ``cd /Users/su/Desktop/figology``.
   Once navigated to the folder of the workspace, enter ``pod install``. 
5. After the workspace is opened in XCode and CocoaPods is installed to this project, select your target device from the toolbar at the top of the XCode window.
   This can either be a physical device connected to your Mac or a simulator (e.g., iPhone 16 Pro).
6. In XCode, click the Run button at the top of the left sidebar or press ``Cmd + R`` to run _figology._ 

## Known Bugs
After signing up, the user will not be directed to the calculator page automatically. 
However, the user should direct themselves to this page to set their fibre goal. 
This bug doesn't hinder the functionality of the application. 

## Support

## Sources 
|Source |Description |
|---     |---          |
|https://www.udemy.com/course/ios-13-app-development-bootcamp/?couponCode=ST20MT190425G1|We followed many videos from this course to develop various parts of your project, including familiarising ourselves with Swift, learning how to use CocoaPods, and working with APIs.|
|https://www.youtube.com/watch?v=B_VFHeg2LH4&t=7s|We used this tutorial to develop and implement the Calendar UI on _figology._|
