# WORK IN PROGRESS

This is the working branch for version 1.0.0.  The focus areas for this version are:

- Rewrite from the ground up using Swift 4.
- Use the new Codable protocol in Swift 4.
- Add support for Linux.
- Add a Docker container for development.
- Add support for more API calls other than mail send.

----

# SendGrid-Swift

This library allows you to quickly and easily send emails through SendGrid using Swift.

## Important: Version 1.0.0 Breaking Changes

Versions 1.0.0 and higher have been migrated to Swift 4 and adds Linux support, which contains code-breaking API changes.

**Previous Breaking Changes**

- Versions 0.2.0 and higher uses Swift 3, which introduces breaking changes from previous versions.
- Versions 0.1.0 and higher have been migrated over to use SendGrid's [V3 Mail Send Endpoint](https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html), which contains code-breaking changes.

## Full Documentation

Full documentation of the library is available [here](http://scottkawai.github.io/sendgrid-swift/docs/).

## Table Of Contents

- [Installation](#installation)
    + [With Cocoapods](#with-cocoapods)
    + [Swift Package Manager](#swift-package-manager)
    + [As A Submodule](#as-a-submodule)
- [Usage](#usage)
    + [Authorization](#authorization)
    + [API Calls](#api-calls)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

### With Cocoapods

Add the following to your Podfile:

```ruby
pod 'SendGrid', :git => 'https://github.com/scottkawai/sendgrid-swift.git'
```

### Swift Package Manager

Add the following to your Package.swift:

```swift
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(
            url: "https://github.com/scottkawai/sendgrid-swift.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "MyApp",
            dependencies: ["SendGrid"])
    ]
)
```

**Note!** Make sure you also list "SendGrid" as a dependency in the "targets" section of your manifest.

### As A Submodule

Add this repo as a submodule to your project and update:

```shell
cd /path/to/your/project
git submodule add https://github.com/scottkawai/sendgrid-swift.git
```

This will add a `sendgrid-swift` folder to your directory. Next, you need to add all the Swift files under `/sendgrid-swift/Sources/` to your project.

## Usage

### Authorization

The V3 endpoint supports authorization via API keys (preferred) and basic authentication via your SendGrid username and password (*Note:* the Mail Send API only allows API keys). Using the `Session` class, you can configure an instance with your authorization method to be used over and over again to send email requests:

It is also highly recommended that you do not hard-code any credentials in your code. If you're running this on Linux, it's recommended that you use environment variables instead, like so:

```swift
///
/// Assuming you set your SendGrid API key as an environment variable
/// named "SG_API_KEY"...
///
let session = Session()
guard let myApiKey = ProcessInfo.processInfo.environment["SG_API_KEY"] else { 
    print("Unable to retrieve API key")
    return
}
session.authentication = Authentication.apiKey(myApiKey)

///
/// Alternatively `Session` has a singleton instance that you can 
/// configure once and reuse throughout your code.
///
///     Session.shared.authentication = Authentication.apiKey(myApiKey)
```

### API Calls

All the available API calls are located in their own folders under the `./Sources/SendGrid/API` folder, and each one has its own README explaining how to use it. Below is a list of the currently available API calls:

- [Statistics](Sources/SendGrid/API/V3/Stats)
    + [Global Stats](Sources/SendGrid/API/V3/Stats#get-global-stats)
    + [Category Stats](Sources/SendGrid/API/V3/Stats#get-category-stats)
    + [Subuser Stats](Sources/SendGrid/API/V3/Stats#get-subuser-stats)
- Suppressions
    + [Blocks API](Sources/SendGrid/API/V3/Suppression/Blocks)
    + [Bounces API](Sources/SendGrid/API/V3/Suppression/Bounces)
    + [Invalid Emails API](Sources/SendGrid/API/V3/Suppression/Invalid%20Emails)
    + [Global Unsubscribes API](Sources/SendGrid/API/V3/Suppression/Global%20Unsubscribes)
    + [Spam Reports API](Sources/SendGrid/API/V3/Suppression/Spam%20Reports)
- [Mail Send](Sources/SendGrid/API/V3/Mail/Send)

## Development

If you're developing on macOS, you an generate an Xcode project by running the following:

```shell
cd /path/to/sendgrid-swift
swift package generate-xcodeproj
```

This project also contains a Dockerfile and a docker-compose.yml file which runs Ubuntu 16.04 with Swift 4 installed. Running `docker-compose up` will execute the `swift build` command in the Linux container. If you want to run other commands, you can run `docker-compose run --rm app <command>`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-fancy-new-feature`)
3. Commit your changes (`git commit -am 'Added fancy new feature'`)
4. Write tests for any changes and ensure existing tests pass
    - **Note!** Be sure that your changes also work on Linux. You can use the Docker container to quickly test this by running `docker-compose run --rm app swift test`
5. Push to the branch (`git push origin my-fancy-new-feature`)
6. Create a new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2017 Scott K.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.