# E-Commerce App 

## Introduction
  - This is application is built using Flutter and Firebase. This application was created as learning project for the Getx package with various features including **_Dependency Injection_** and **_State Management_**.
  - This project was also created to test the Flutter Web and Windows which are in its beta and alpha stage respectively at this time.

## Objective
  - To learn the Getx State Management
  - To test the Flutter Web and Specifically Flutter Windows

## Features
  - Product Management with CRUD functionality
  - Order Placement with History
  - Firebase Email Authentication with auto login using shared preferences
  - Localization in English and Hindi Language
  - Theme Changing
  - Can run on Mobile, Web and Desktop (using Flutter and Firebase)
  - Responsive on different screen sizes

## Status
 App is currenlty working fine: 
  - Android Platform: Redmi Note 4
  - Web Platform: Google Chrome
  - Windows Platform: Windows 10

_Note: I am currently not able to test it on the Linux and Apple Devices because I have only 1 laptop in which windows is running and can't buy apple devices :(_

## Step for Installation
  - Clone or Fork the repository.
  - Create a Firebase account and activate the email sign-in method.
  - Create a Real-Time database in the Firebase 
  - Add a file under the utils folder with constants.dart name and add follwing code:
  
```
class Constants {
  static String projectKey = 'Add your project key here';
  static String projectAPIUrl = 'Add your real-time data base project url here';
}
```
  - Run the project on any of the above devices.