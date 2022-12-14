<img src="https://github.com/heestand-xyz/Linker/blob/main/Assets/Linker-App-Icon.png?raw=true" width="128"/>

# Linker

a mini social app.

<img src="https://github.com/heestand-xyz/Linker/blob/main/Assets/Linker-Screenshot-1.png?raw=true" width="256"/> <img src="https://github.com/heestand-xyz/Linker/blob/main/Assets/Linker-Screenshot-2.png?raw=true" width="256"/>

## Description

In **Linker** you can posts links with a description.

Links are presented in a rich context with images from the website link. 

You can create an account and add a profile photo.

You can delete your own posted links.

## Setup

- To run the app, open the project in Xcode 13.4 or later.
- Select a team under Signing & Capabilities.
- Select a simulator or device with iOS 15 or later.
- Run the app and sign up for an account.

Alternately sign in with the test account `tester@test.com` and password `123Abc!`.

## Architecture

**Linker** uses dependency injection with services. There are two main services, `Auth` and `Content`. `Auth` is used to sign-in, sign-up and sign-out a user and `Content` is used to fetch, create and delete posts.

The service manager can take a mocked or a main service, making it easy to switch between mocked and production mode. 

## Dependencies

**Linker** is powered by Firebase. This swift package dependency should automatically download.

The app uses SwiftUI for the UI. The app also uses Combine and async / await for business logic and network calls.  

## Tests

There are unit tests under `LinkerTests/LinkerTests.swift`.

These tests verify that the app works as expected.

## Minimum Requirements

iOS 15.0

Xcode 13.4
