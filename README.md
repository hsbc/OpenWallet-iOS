# OpenWallet iOS App

The iOS application of the OpenWallet. Support iOS 15.0 or later.

## Background

OpenWallet is a mobile application that serves as an open platform for digital assets.

## Getting Started

### Summary

This project use XcodeGen to generate the Xcode project using the folder structure and a project spec.

### Install XcodeGen

* Install XcodeGen, for example, with Homebrew
    - Run `brew install xcodegen` in terminal. Note: you may need to upgrade Homebrew to `3.5.2` or later version.
    - Run `xcodegen --version` in terminal and confirm version `2.29.0` or later version has been installed.

### Generate .xcodeproj file with XcodeGen

* In terminal, navigate to the project folder, i.e. `openharbor-aesg-ios` folder
* Run `xcodegen generate` in terminal, the `OpenWallet.xcodeproj` should be generated.
* Open the ios app project with Xcode and run the application.

<br/>

## Project Structures

    .
    ├─ config                                  # scheme configuration file (debug, release)
    │  ├─ debug.xcconfig
    │  ├─ release.xcconfig
    ├─ Frameworks                              # local dependecies libraries
    ├─ OpenWallet                             # Source files (alternatively `lib` or `app`)
    │  ├─ Certificates              
    │     ├─ **** Server Cert ****   #  certificate of backend server in production environment for ssl pinning. Note: replace it with your own cert file that matches your backend environment
    │  └─ ...
    ├─ OpenWalletTests                        # Automated unit test cases
    ├─ OpenWalletUITests                      # Automated UI test cases
    ├─ scripts                                 # scripting files
    ├─ vendor                                  # vendor libraries, e.g. RASP
    ├─ README.md                               # script files
    ├─ .gitignore
    ├─ .gitlab-ci.yml                          # Gitlab CICD pipeline configuration file
    ├─ .swiftlint.yml                          # configuration for swift lint
    ├─ project.yml                             # configuration file for Xcodegen
    ├─ LICENSE
    └─ README.md

<br/>

## Scheme configuration
---
Configure the `debug.xcconfig` and `release.xcconfig` file to customize the application. Find key configuration options below.

Options:
- `OW_APP_NAME`                            # The application name
- `OW_APP_DISPLAY_NAME`                    # The display name of the application on the iOS device once installed
- `OW_APP_BUNDLE_ID`                       # Applicaton Bundle ID
- `OW_HIDE_COVER_SCREEN`                   # Option to toggle the show/hide of the cover screen. Set to `YES` to hide the cover screen, `NO` to show.
- `OW_ENABLE_SSL_PINNING`                  # Option to toggle whether ssl pinning should be enable. Set to `YES` to enable, and `NO` to disable 
- `CODE_SIGNING_ALLOWED`                   # Code signning setting for building the iOS application. Set to `YES` to allow code signning, and `NO` to not allow 
- `OW_SERVER_CERTIFICATE_FILE_NAME`        # name of the certificate of the backend server. Note: this is required for certificate pinning, and is optional for public key pinning
- `OW_SERVER_CERTIFICATE_FILE_EXTENSION`   # file extension of the server certificate
- `OW_SERVER_HOST`                         # Host of the backend server (without http/https protocol)
- `OW_MIDDLE_LAYER_BASE_URL`               # Full base url of the backend server
- `INCLUDE_SERVER_GATEWAY_ACCESS_COOKIE`   # Option to turn server gateway access cookie on and off. Set to `YES` to turn on, `NO` to turn off
- `OW_SERVER_GATEWAY_ACCESS_COOKIE_NAME`   # Name of the access cookie
- `OW_SERVER_GATEWAY_ACCESS_COOKIE_VALUE`  # Value of the access cookie
- `OW_IPFS_GATEWAY_DOMAIN_URL`             # Domain url of the IPFS gateway. Note: currently, nft assets are hosted on IPFS
- `IPFS_TOKEN_URI_PREFIX`                  # The prefix of URI of tokens hosted on IPFS.
