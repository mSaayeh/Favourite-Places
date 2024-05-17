# Favourite Places

Favourite Places is a Flutter application that allows users to save their favorite places with a name, image, and coordinates. This README file provides an overview of the app, installation instructions, and features used.

## Table of Contents
- [Features](#features)
- [Screenshots](#screenshots)
- [Features Used](#features-used)

## Features
- Save your favorite places with a name, image, and coordinates.
- Use the mobile camera to take images.
- Fetch current location coordinates using GPS.
- Delete or Edit existing places.
- Store data locally using SQLite.

## Screenshots
![Home Screen](screenshots/home_screen.png)
*The home screen where all favorite places are listed.*

![Add Place](screenshots/add_place.png)
*The screen to add a new favorite place with an option to pick an image and get location coordinates.*

![Place Details](screenshots/place_details.png)
*The screen displaying the details of a selected favorite place.*

![Edit Place](screenshots/edit_place.png)
*The screen to edit a saved favorite place with an option to pick a different image or update location coordinates.*


## Features Used
- SQFlite: Used for storing favorite places data locally in a SQLite database.
- Riverpod: Used for state management across the application.
- image_picker: Used to pick images from the gallery or camera.
- location: Used to fetch the device's current location coordinates.
- path: Used to manipulate file and directory paths.
