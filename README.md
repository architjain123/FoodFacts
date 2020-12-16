# FoodFacts

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Allows users to find nutritional information of food items by taking a photograph. 

### App Evaluation
- **Category:** Health
- **Mobile:** This application will be primarily developed for mobile usage only.
- **Story:** Allows users identify the nutritional value of a food item by snapping its photo.
- **Market:** All people who  manage their foods intake routine.
- **Habit:** The target audience will use this app on a daily basis to track their food nutrition value
- **Scope:** We want to create a complete ecosystem in the future where the user just needs to snap a photo of their food items and everything else will be autocompleted by the application to maintain a track of user's intake.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [X] User signup.
* [X] User login.
* [X] User snaps a photo of the food item.
* [X] User is displayed the type of food item
* [X] User can search for food item nutritional information without photo.
* [X] User is displayed the nutritional value based on the search/photo.

**Optional Nice-to-have Stories**
* [x] User can favourite a food.
* [x] Favorite food items are displayed in a favorite screen.
* [ ] ~~User profile page~~.
* [ ] ~~App maintains a history of all the photos taken and the search results~~.
* [ ] ~~Settings (Accesibility, Notification, General, etc.)~~
* [ ] ~~User can add nutritional information of foods to expand the application database.~~

### 2. Screen Archetypes
* Home
* Login
   * User Login.
* Sign up
   * User signup.
* Main 
    * User snaps a photo of the food item.
    * User can search for food item nutritional information without photo.
* Nutrition
    * User is displayed the nutritional value of the food item based on search/photo.
    * User can favourite a food.

Optional:
* Favorite
    * Favorite food items are displayed in a favorite screen.
* Profile
    * User profile page.
* Search History
    * App maintains a history of all the photos taken and the search results.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

Optional:
* Main 
* Profile

**Flow Navigation** (Screen to Screen)

* Forced Log-in -> Registration if no log in is available
* Auto-Login -> Main screen with option to logout
* After Photo taken -> Popup shows nutrition information 
* Search item -> Popup shows nutrition information
* Favorites -> Shows the list of items favorited -> Shows nutrition information for the selected item

## Wireframes
<img src="https://github.com/MJSindhu7/FoodFacts/blob/main/Connecctions.png">

### [BONUS] Digital Wireframes & Mockups
<img src="https://github.com/MJSindhu7/FoodFacts/blob/main/MockScreens.png" width=600>

### [BONUS] Interactive Prototype
<img src="http://g.recordit.co/ROilVfnxXs.gif" width=300>

## Schema 

### Models

* User

| Property      | Type          | Description                           |
| ------------- | ------------- | -----                                 |
| UserID        | String        | unique id for the user                |
| Password      | String        | corresponding password for the user   | 
| Email         | String        | email Id of the user                  |

* Nutrition

| Property     	   | Type         	| Description 				|
| -------------	   |--------------| ----------------------------	|
| foodID             | String         | unique ID for the food item     |
| foodCategory  | String         | category of food     |
| brand               | String         | brand of the food    |
| nutrients          | object        | nutrients of the food item|

* Favorites

| Property     	| Type         	| Description 				|
| -------------	|--------------	| ----------------------------	|
| UserID      	| String      	| unique ID for the food item	|
| foodArray      | ArrayList     	| arrayList that holds foodID	|
| image          | 	File | favorited food item image |


### Networking
**List of network requests by screen**
* User
     * (Read/GET) Login:
        ```
        let username = usernameField.text!
                let password = passwordField.text!
                PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                    if user != nil {
                        print("Login successful")
                    }
                    else{
                        print("Error: \(error?.localizedDescription)")
                    }
                }
         ```

     * (Create/POST) Sign Up user information
        ```
        guard let user = PFUser.current() else {
            print("Failed to get user")
        }
        let user = PFObject(className: "User")
        user["UserID"] = "Jhon"
        user["Password"] = "234!@"
        user["Email"] = "john@gmail.com"

        user.saveInBackground { (success, error) in
            if success {
                print("Successfully saved user!")
            }
            else {
                print("Failed to create user!")
            }
        ```

* Nutrition
    * (Read/GET) Get the nutrition information of a food item
    * (Create/POST) 
   
* Favories
    * (Read/GET) Get the favorited items of a user
    * (Update/PUT) When ever favorited, add that item into the list


**[OPTIONAL:] End points planning to use**

* Reference - <https://www.logmeal.es/nutritional-information/>

    ```
          # Single/Several Dishes Detection
      url = 'https://api.logmeal.es/v2/recognition/complete'
      resp = requests.post(url,
                          files={'image': open(img, 'r')},
                          headers=headers)

      # Nutritional information
      url = 'https://api.logmeal.es/v2/recipe/nutritionalInfo'
      resp = requests.post(url,
                          data={'imageId': resp.json()['imageId']},
                          headers=headers)

      print(resp.json()) # display nutritional info
     
    ```

## Prototype Gifs

### Login functionality
<img src='https://recordit.co/QUhT2yKDJ4.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

### Search Nutritional info
<img src='http://g.recordit.co/FVKEWIV9cw.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

### Identify food type and get nutritional info
<img src='http://g.recordit.co/DJxa7hNIWO.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

### Favoriting a food item
<img src='https://recordit.co/KoqweYptW3.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />


