# YassirChallenge
Coding Challenge implementation for Yassir

## Technical Stack

### Enviroment
- Xcode 14.0
- Swift 5.7

### Dependencies

- SwiftLint - Linting of Swift code
- [SDWebImage](https://github.com/SDWebImage/SDWebImage)

### Dependency Manager
- Homebrew
- Swift Package Manager

### Deployment
- Source Control - [GitHub](https://github.com/)

### CI
- Github Actions

Command: xcodebuild clean build test -project YassirChallenge.xcodeproj -scheme "CI" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO

## Functionality

- Load the Movie List information from server launch of application
- Show error in alert for server error
- Show all the Movie List on the screen in listing format
- provided basic information about each movie in each row
- On tap on any movie, user is redirected to new screen with details
- Load details from server using movie id and present on the detail screen

Tech Specs:
- Presentation layer implemented with MVVM architectural design pattern
- Focus on SOLID principles
- `MovieListLoader` is an abstract boundary. Currently it is implemented for remote fetch implementation, similarly using this abstraction layer we can fetch from cache , filesystem or core data with respective implementation.
- `MovieListLoader` is considered as a use case
- Get Movie Details use case also implemented through abstract boundary with `MovieDetailLoader`
- `HTTPClient` is an abstract boundry to interact with server. Currently it is implemented with URLSession similarly it can be implemented though other frameworks such as Alomafire
- Unit test cases added for `HTTPClient` , `MovieListLoader` and view models
- Code Coverage enabled
- Integrated SwiftLint
- CI implementation with GitHub Action to build and test

## Improvements
- Default configuation is been used. This can be implemented throguh it own use use to load configuation from user when when launch and integrate cacheing logic(if required)
- Sort all the movies.
- Pagination and batching of request
- Filters implementation
- Dependency injection of view controller module through swinject or other frameworks
- Navigation logic can be redesigned with coordinator patter or composition root 
- Spinner or Loader for Detail and map view while network request
- Retry logic for API's
- UI Test case



## Getting Started
### Getting the project
- The project can be cloned from https://github.com/chetan15aggarwal/TierChallenge

