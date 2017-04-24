//
//  Package.swift
//  LoginServer
//
//  Created by Adrian Nenu on 24/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "LoginServer",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/BlueSocket", majorVersion: 0, minor: 12)
    ]
)
