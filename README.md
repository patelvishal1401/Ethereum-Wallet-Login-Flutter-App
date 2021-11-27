# User login app on blockchain with flutter

In this project, we have managed to create a user login app using on ethereum blockchain, on starting this app with `flutter run`


## Tech stack

1) Flutter : Android, Ios, Web App
2) Ganache : Local Blockchain
3) Truffle : Smart contract development environment

## Config

1) Truffle : /truffle-config.js

   Change network host and port

   Compile & Deploy Samrt Contract : `truffle compile` & `truffle migrate`

2) App Config : /lib/main.dart

   Change Localhost path and port from `rpcUrl` variable


## Run App

- Get list of devices : `flutter devices`
- Run on android emulator : `flutter run -d <device name>`
- Run on chrome : `flutter run -d chrome`
- Generate Android Project : `flutter create -a kotlin .`
- Generate IOS Project : `flutter create -a swift .`