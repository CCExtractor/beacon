# Beacon

## About the Project

This project is a flutter build native interface to ease the group travelling (or hiking). By using this, the group leader would be able to share his location with the entire crew, and in case if someone loses contact with the group, he can quickly get in the right place by following the beacon. 

## Getting Started

For setting up the development environment, follow the steps given below.

- Clone this repository after forking using `git clone https://github.com/<username>/beacon.git`
- `cd` into `beacon`
- Check for flutter setup and connected devices using `flutter doctor`
- Get all the dependencies using `flutter pub get`
- Add your Google Maps API key either by adding `MAPS_API_KEY` variable in `android/local.properties` file or by exporting it as a System environment variable by using the command `export MAPS_API_KEY=YOUR_API_KEY` (You can get your API Key with this [steps](https://developers.google.com/maps/documentation/android-sdk/get-api-key)).
  
  By this `build.gradle` will first find the `MAPS_API_KEY` on the `local.properties` file, but if there’s none (such as in production), it will search for the variable on the environment variable.
- Run the app using `flutter run`

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project Structure

This project follows MVVM architecture with following structure:

```bash
beacon/lib/
├── components/                             # Shared Components such as dialog boxes, button, and other shared widgets
├── enums/                                  # enum files
|   └── view_state.dart                     # defines view states i.e Idle, Busy, Error
├── models/                                 # model classes: beacon, location, landmark, user  
├── queries/                                # includes all graphql query strings
├── services/                               # services
|   ├── database_mutation_function.dart/    # Graphql Queries implementations
|   ├── navigation_service.dart/            # All required navigation services
|   └── ...                                 # all config files
├── utilities/                              # Utilities that includes constants file
├── views/                                  # Views/UI layer
|  ├── auth_screen.dart                     
|  ├── base_view.dart
|  ├── hike_screen.dart
|  ├── home.dart
├── viewmodels/                             # Viewmodels layer
├── splash_screen.dart                      # Very first screen displayed whilst data is loading
├── router.dart                             # All routes to ease navigation
├── locator.dart                            # dependency injection using get_it
├── main.dart                               # <3 of the app
```

## Screenshots

<img src="screenshots/1.jpg" width="24%" /> <img src="screenshots/2.jpg" width="24%"/> <img src="screenshots/3.jpg" width="24%"/> <img src="screenshots/4.jpg" width="24%"/>

## Contributing 

Whether you have some feauture requests/ideas, code improvements, refactoring, performance improvements, help is always Welcome. The more is done, better it gets.

If you found any bugs, consider opening an [issue](https://github.com/CCExtractor/beacon/issues/new).

**To know the details about features implemented till Google Summer of Code'21 and future todo's please visit [this blog](https://blog.nishthab.tech/gsoc-2021-ccextractor-beacon)**

## Community

We would love to hear from you! You may join gsoc-beacon channel of CCExtractor community through slack:

[![Slack](https://img.shields.io/badge/chat-on_slack-purple.svg?style=for-the-badge&logo=slack)](https://ccextractor.org/public/general/support/)