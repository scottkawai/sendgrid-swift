# SendGrid-Swift

This library allows you to quickly and easily send emails through SendGrid using Swift.

## Important: Breaking Changes
Version 0.1.0 and higher have been migrated over to use SendGrid's [V3 Mail Send Endpoint](https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html), which contains code-breaking changes.

Version 0.2.0 and higher uses Swift 3, which introduces breaking changes from previous versions.

## Full Documentation

Full documentation of the library is available [here](http://scottkawai.github.io/sendgrid-swift/docs/).

## Table Of Contents

- [Installation](#installation)
    + [With Cocoapods](#with-cocoapods)
    + [Swift Package Manager](#swift-package-manager)
    + [As A Submodule](#as-a-submodule)
- [Usage](#usage)
    + [Authorization](#authorization)
    + [Content](#content)
    + [Personalizations](#personalizations)
    + [Attachments](#attachments)
    + [Mail and Tracking Settings](#mail-and-tracking-settings)
    + [Unsubscribe Groups (ASM)](#unsubscribe-groups-asm)
    + [IP Pools](#ip-pools)
    + [Scheduled Sends](#scheduled-sends)
    + [Categories](#categories)
    + [Sections](#sections)
    + [Template Engine](#template-engine)
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
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .Package(
            url: "https://github.com/scottkawai/sendgrid-swift.git",
            majorVersion: 0, 
            minor: 2
        )
    ]
)
```

### As A Submodule

Add this repo as a submodule to your project and update:

```shell
cd /path/to/your/project
git submodule add https://github.com/scottkawai/sendgrid-swift.git
```

This will add a `sendgrid-swift` folder to your directory. Next, you need to add all the Swift files under `/sendgrid-swift/Sources/` to your project.

## Usage

### Authorization

The V3 endpoint supports API keys for authorization (***Note***: username and passwords cannot be used for authorization).  Using the `Session` class, you can configure an instance with your API key to be used over and over again to send email requests:

```swift
let session = Session()
session.authentication = Authentication.apiKey("SG.abcdefghijklmnop.qrstuvwxyz012345-6789")

/*
`Session` also has a singleton instance that you can configure once and reuse throughout your code.
*/
Session.shared.authentication = Authentication.apiKey("SG.abcdefghijklmnop.qrstuvwxyz012345-6789")
```

### Content

To specify the content of an email, use the `Content` class. In general, an email will have plain text and/or HTML text content, however you can specify other types of content, such as an ICS calendar invite. Following RFC 1341, section 7.2, if either HTML or plain text content are to be sent in your email: the plain text content needs to be first, followed by the HTML content, followed by any other content.

### Personalizations

The new V3 endpoint introduces the idea of "personalizations."  When using the API, you define a set of global characteristics for the email, and then also define seperate personalizations, which contain recipient-specific information for the email. Since personalizations contain the recipients of the email, each request must contain at least 1 personalization.

```swift
// Send a basic example
let personalization = Personalization(recipients: "test@example.com")
let plainText = Content(contentType: ContentType.plainText, value: "Hello World")
let htmlText = Content(contentType: ContentType.htmlText, value: "<h1>Hello World</h1>")
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: [plainText, htmlText],
    subject: "Hello World"
)
do {
    try Session.shared.send(request: email)
} catch {
    print(error)
}
```

An `Email` instance can have up to 1000 `Personalization` instances. A `Personalization` can be thought of an individual email.  It can contain several `to` addresses, along with `cc` and `bcc` addresses.  Keep in mind that if you put two addresses in a single `Personalization` instance, each recipient will be able to see each other's email address.  If you want to send to several recipients where each recipient only sees their own address, you'll want to create a seperate `Personalization` instance for each recipient.

The `Personalization` class also allows personalizing certain email attributes, including:

- Subject
- Headers
- Substitution tags
- [Custom arguments](https://sendgrid.com/docs/API_Reference/SMTP_API/unique_arguments.html)
- Scheduled sends

If a `Personalization` instance contains an email attribute that is also defined globally in the request (such as the subject), the `Personalization` instance's value takes priority.

Here is an advanced example of using personalizations:

```swift
// Send an advanced example
let recipients = [
    Address(email: "jose@example.none", name: "Jose"),
    Address(email: "isaac@example.none", name: "Isaac"),
    Address(email: "tim@example.none", name: "Tim")
]
let personalizations = recipients.map { (recipient) -> Personalization in
    let name = recipient.name ?? "there"
    return Personalization(
        to: [recipient],
        cc: nil,
        bcc: [Address("bcc@example.none")],
        subject: "Hello \(name)!",
        headers: ["X-Campaign":"12345"],
        substitutions: ["%name%":name],
        customArguments: ["campaign_id":"12345"]
    )
}
let contents = Content.emailContent(
    plain: "Hello %name%,\n\nHow are you?\n\nBest,\nSender",
    html: "<p>Hello %name%,</p><p>How are you?</p><p>Best,<br>Sender</p>"
)
let email = Email(
    personalizations: personalizations,
    from: Address("sender@example.none"),
    content: contents,
    subject: nil
)
email.headers = [
    "X-Campaign": "12345"
]
email.customArguments = [
    "campaign_id": "12345"
]
do {
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

You'll notice in the example above, the global email defines custom headers and custom arguments. In addition, each personalization defines some headers and custom arguments. For the resulting email, the headers and custom arguments will be merged together. In the event of a conflict, the personalization's values will be used.

### Attachments

The `Attachment` class allows you to easily add attachments to an email. All you need is to convert your desired attachment into `NSData` and initialize it like so:

```swift
let personalization = Personalization(recipients: "test@example.com")
let contents = Content.emailContent(
    plain: "Hello World",
    html: "<h1>Hello World</h1>"
)
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: contents,
    subject: "Hello World"
)
do {
    if let path = Bundle.main.url(forResource: "proposal", withExtension: "pdf") {
        let attachment = Attachment(
            filename: "proposal.pdf",
            content: try Data(contentsOf: path),
            disposition: .Attachment,
            type: .pdf,
            contentID: nil
        )
        email.attachments = [attachment]
    }
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

You can also use attachments as inline images by setting the `disposition` property to `.Inline` and setting the `cid` property.  You can then reference that unique CID in your HTML like so:

```swift
let personalization = Personalization(recipients: "test@example.com")
let contents = Content.emailContent(
    plain: "Hello World",
    html: "<img src=\"cid:main_logo_12345\" /><h1>Hello World</h1>"
)
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: contents,
    subject: "Hello World"
)
do {
    if let path = Bundle.main.urlForImageResource("logo.png") {
        let attachment = Attachment(
            filename: "logo.png",
            content: try Data(contentsOf: path),
            disposition: .inline,
            type: .png,
            contentID: "main_logo_12345"
        )
        email.attachments = [attachment]
    }
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

### Mail and Tracking Settings

There are various classes available that you can use to modify the [mail](https://sendgrid.com/docs/User_Guide/Settings/mail.html) and [tracking](https://sendgrid.com/docs/User_Guide/Settings/tracking.html) settings for a specific email.

**MAIL SETTINGS**

The following mail setting classes are available:

| Setting                | Description |
|------------------------|-------------|
| `BCCSetting`           | This allows you to have a blind carbon copy automatically sent to the specified email address for every email that is sent. |
| `BypassListManagement` | Allows you to bypass all unsubscribe groups and suppressions to ensure that the email is delivered to every single recipient. This should only be used in emergencies when it is absolutely necessary that every recipient receives your email. Ex: outage emails, or forgot password emails. |
| `Footer`               | The default footer that you would like appended to the bottom of every email. |
| `SandboxMode`          | This allows you to send a test email to ensure that your request body is valid and formatted correctly. For more information, please see our [Classroom](https://sendgrid.com/docs/Classroom/Send/v3_Mail_Send/sandbox_mode.html). |
| `SpamChecker`          |  This allows you to test the content of your email for spam. |

**TRACKING SETTINGS**

The following tracking setting classes are available:

| Setting                | Description |
|------------------------|-------------|
| `ClickTracking`        | Allows you to track whether a recipient clicked a link in your email. |
| `GoogleAnalytics`      | Allows you to enable tracking provided by Google Analytics. |
| `OpenTracking`         | Allows you to track whether the email was opened or not, but including a single pixel image in the body of the content. When the pixel is loaded, we can log that the email was opened. |
| `SubscriptionTracking` | Allows you to insert a subscription management link at the bottom of the text and html bodies of your email. If you would like to specify the location of the link within your email, you may specify a substitution tag. |

**EXAMPLE**

Each setting has its own properties that can be configured, but here's a basic example:

```swift
let personalization = Personalization(recipients: "test@example.com")
let contents = Content.emailContent(
    plain: "Hello World",
    html: "<h1>Hello World</h1>"
)
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: contents,
    subject: "Hello World"
)
email.mailSettings = [
    Footer(
        enable: true,
        text: "Copyright 2016 MyCompany",
        html: "<p><small>Copyright 2016 MyCompany</small></p>"
    )
]
email.trackingSettings = [
    ClickTracking(enable: true),
    OpenTracking(enable: false)
]
do {
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

### Unsubscribe Groups (ASM)

If you use SendGrid's [unsubscribe groups](https://sendgrid.com/docs/User_Guide/Suppressions/advanced_suppression_manager.html) feature, you can specify which unsubscribe group to send an email under like so:

```swift
let personalization = Personalization(recipients: "test@example.com")
let contents = Content.emailContent(
    plain: "Hello World",
    html: "<h1>Hello World</h1>"
)
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: contents,
    subject: "Hello World"
)
/// Assuming your unsubscribe group has an ID of 4815…
email.asm = ASM(groupID: 4815)
do {
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

You can also specify which unsubscribe groups should be shown on the subscription management page for this email:

```swift
let personalization = Personalization(recipients: "test@example.com")
let contents = Content.emailContent(
    plain: "Hello World",
    html: "<h1>Hello World</h1>"
)
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: contents,
    subject: "Hello World"
)
/// Assuming your unsubscribe group has an ID of 4815…
email.asm = ASM(groupID: 4815, groupsToDisplay: [16,23,42])
do {
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

### IP Pools

If you're on a pro plan or higher, and have set up [IP Pools](https://sendgrid.com/docs/API_Reference/Web_API_v3/IP_Management/ip_pools.html) on your account, you can specify a specific pool to send an email over like so:

```swift
let personalization = Personalization(recipients: "test@example.com")
let contents = Content.emailContent(
    plain: "Hello World",
    html: "<h1>Hello World</h1>"
)
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: contents,
    subject: "Hello World"
)
/// Assuming you have an IP pool called "transactional" on your account…
email.ipPoolName = "transactional"
do {
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

### Scheduled Sends

If you don't want the email to be sent right away, but rather at some point in the future, you can use the `sendAt` property. **NOTE**: You cannot schedule an email further than 72 hours in the future.  You can also assign an optional, unique `batchID` to the email so that you can [cancel via the API](https://sendgrid.com/docs/API_Reference/Web_API_v3/cancel_schedule_send.html) in the future if needed.

```swift
let personalization = Personalization(recipients: "test@example.com")
let contents = Content.emailContent(
    plain: "Hello World",
    html: "<h1>Hello World</h1>"
)
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: contents,
    subject: "Hello World"
)
// Schedule the email for 24 hours from now.
email.sendAt = Date(timeIntervalSinceNow: 24 * 60 * 60)

// This part is optional, but by setting the batch ID, we have the ability to cancel this send via the API if needed.
email.batchID = "76A8C7A6-B435-47F5-AB13-15F06BA2E3WD"

do {
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

In the above example, we've set the `sendAt` property on the global email, which means every personalization will be scheduled for that time.  You can also set the `sendAt` property on a `Personalization` if you want each one to be set to a different time, or only have certain ones scheduled:

```swift
let recipientInfo: [String:Date?] = [
    "jose@example.none": Date(timeIntervalSinceNow: 4 * 60 * 60),
    "isaac@example.none": nil,
    "tim@example.none": Date(timeIntervalSinceNow: 12 * 60 * 60)
]
let personalizations = recipientInfo.map { (recipient, date) -> Personalization in
    let personalization = Personalization(recipients: recipient)
    personalization.sendAt = date
    return personalization
}
let contents = Content.emailContent(
    plain: "Hello there,\n\nHow are you?\n\nBest,\nSender",
    html: "<p>Hello there,</p><p>How are you?</p><p>Best,<br>Sender</p>"
)
let email = Email(
    personalizations: personalizations,
    from: Address("sender@example.none"),
    content: contents,
    subject: nil
)
do {
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

### Categories

You can assign categories to an email which will show up in your SendGrid stats, Email Activity, and event webhook. You can not have more than 10 categories per email.

```swift
let personalization = Personalization(recipients: "test@example.com")
let contents = Content.emailContent(
    plain: "Hello World",
    html: "<h1>Hello World</h1>"
)
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: contents,
    subject: "Hello World"
)
email.categories = ["Foo", "Bar"]
do {
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

### Sections

Sections allow you to define large blocks of content that can be inserted into your emails using substitution tags. An example of this might look like the following:

```swift
let bob = Personalization(recipients: "bob@example.com")
bob.substitutions = [
    ":salutation": ":male",
    ":name": "Bob",
    ":event_details": "event2",
    ":event_date": "Feb 14"
]

let alice = Personalization(recipients: "alice@example.com")
alice.substitutions = [
    ":salutation": ":female",
    ":name": "Alice",
    ":event_details": "event1",
    ":event_date": "Jan 1"
]

let casey = Personalization(recipients: "casey@example.com")
casey.substitutions = [
    ":salutation": ":neutral",
    ":name": "Casey",
    ":event_details": "event1",
    ":event_date": "Aug 11"
]

let personalization = [
    bob,
    alice,
    casey
]
let plainText = ":salutation,\n\nPlease join us for the :event_details."
let htmlText = "<p>:salutation,</p><p>Please join us for the :event_details.</p>"
let content = Content.emailContent(plain: plainText, html: htmlText)
let email = Email(
    personalizations: personalization, 
    from: Address("from@example.com"), 
    content: content
)
email.subject = "Hello World"
email.sections = [
    ":male": "Mr. :name",
    ":female": "Ms. :name",
    ":neutral": ":name",
    ":event1": "New User Event on :event_date",
    ":event2": "Veteran User Appreciation on :event_date"
]
```

### Template Engine

If you use SendGrid's [Template Engine](https://sendgrid.com/docs/User_Guide/Transactional_Templates/index.html), you can specify a template to apply to an email like so:

```swift
let personalization = Personalization(recipients: "test@example.com")
let contents = Content.emailContent(
    plain: "Hello World",
    html: "<h1>Hello World</h1>"
)
let email = Email(
    personalizations: [personalization],
    from: Address("foo@bar.com"),
    content: contents,
    subject: "Hello World"
)
/// Assuming you have a template with ID "52523e14-7e47-45ed-ab32-0db344d8cf9z" on your account…
email.templateID = "52523e14-7e47-45ed-ab32-0db344d8cf9z"
do {
    try Session.shared.send(request: email) { (response, error) in
        print(response?.stringValue)
    }
} catch {
    print(error)
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-fancy-new-feature`)
3. Commit your changes (`git commit -am 'Added fancy new feature'`)
4. Write tests for any changes and ensure existing tests pass
5. Push to the branch (`git push origin my-fancy-new-feature`)
6. Create a new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2016 Scott K.

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