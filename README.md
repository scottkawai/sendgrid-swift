# SendGrid-Swift

This library allows you to quickly and easily send emails through SendGrid using Swift.

**Important:** This library requires the [SMTPAPI-Swift Library](http://github.com/scottkawai/smtpapi-swift), which is added as a submodule in this repo.

## Installation

### As A Submodule

Add this repo as a submodule to your project and update:

```shell
cd /path/to/your/project
git submodule add https://github.com/scottkawai/sendgrid-swift.git
git submodule update --init --recursive
```

This will add a `sendgrid-swift` folder to your directory. Next, you need to add the following two files to your Xcode Project:

- /sendgrid-swift/SendGrid-Swift/SendGrid.swift
- /sendgrid-swift/smtpapi-swift/SMTPAPI/SmtpApi.swift

### From The Source

Download this repo as well as the [SMTPAPI-Swift Repo](http://github.com/scottkawai/smtpapi-swift) and add the `SendGrid.swift` and `SmtpApi.swift` files to your project.

## Usage

Create a new SendGrid object with your SendGrid credentials:

```swift
var sg = SendGrid(username: "sg_username", password: "sg_password")
```

Then create a new email object with all the pertinent information:

```swift
var email = SendGrid.Email()
email.addTo("isaac@example.none", name: "Isaac")
email.setFrom("jose@example.none", name: "Jose")
email.setSubject("Hello World")
email.setTextBody("This is my first email sent through SendGrid.")
email.setHtmlBody("<p>This is my first email sent through SendGrid.</p>")
```

Finally, send your email with the SendGrid object:

```swift
sg.send(email, completionHandler: { (response, data, error) -> Void in
    if let json = NSString(data: data, encoding: NSUTF8StringEncoding) {
        println(json)
    }
})
```

See below for the various functions available when generating your email.

## Side Note About Recipients

***IMPORTANT:*** By default, this library adds "To" addresses to the [SendGrid X-SMTPAPI header](https://sendgrid.com/docs/API_Reference/SMTP_API/index.html).  This means that SendGrid will send each of the recipients an individual copy of the message so that each recipient doesn't see every other recipient's email address. Doing this, however, means that things such as BCC will not work.  If you wish to send an email that behaves like a "normal" email (where all recipients see every address in the "To" field and BCC is available), then set the `hasRecipientsInSmtpApi` on your `SendGrid.Email` instance to `false` (by default it is `true`).

```swift
var email = SendGrid.Email()
email.hasRecipientsInSmtpApi = false
```

## Functions

#### addTo(address: String, name: String?)

Adds a specified email address to the message. Optionally a "To Name" can be specified.  By default this will add the address to the [SendGrid X-SMTPAPI header](https://sendgrid.com/docs/API_Reference/SMTP_API/index.html). If you want the address to be added to the normal "To" field, first set the `hasRecipientsInSmtpApi` property on your `SendGrid.Email` instance to `false`.

```swift
var email = SendGrid.Email()
email.addTo("isaac@example.none", name: "Isaac")
email.addTo("jose@example.none", name: nil)
email.addTo("tim@example.none", name: nil)
```

#### addTos(addresses: [String], names: [String]?)

Adds a specified list of email addresses to the message. Optionally a list of "To Names" can be specified.  By default this will add the addresses to the [SendGrid X-SMTPAPI header](https://sendgrid.com/docs/API_Reference/SMTP_API/index.html). If you want the addresses to be added to the normal "To" field, first set the `hasRecipientsInSmtpApi` property on your `SendGrid.Email` instance to `false`.

```swift
var email = SendGrid.Email()
email.addTos(["isaac@example.none","jose@example.none","tim@example.none"], name: ["Isaac","Jose","Tim"])
```

#### setTos(addresses: [String], names: [String]?)

Erases any current recipient addresses and adds a specified list of email addresses to the message. Optionally a list of "To Names" can be specified.  By default this will add the addresses to the [SendGrid X-SMTPAPI header](https://sendgrid.com/docs/API_Reference/SMTP_API/index.html). If you want the addresses to be added to the normal "To" field, first set the `hasRecipientsInSmtpApi` property on your `SendGrid.Email` instance to `false`.

```swift
var email = SendGrid.Email()
email.addTo("isaac@example.none", name: "Isaac")
email.setTos(["jose@example.none","tim@example.none"], name: ["Jose","Tim"])
// In this case, only jose@example.none and tim@example.none 
// will receive the email.
```

#### setSubject(subject: String)

Sets the subject of the message.

```swift
var email = SendGrid.Email()
email.setSubject("This is an awesome subject!")
```

#### setFrom(address: String, name: String?)

Sets the sender address. Optionally a "From name" can be specified.

```swift
var email = SendGrid.Email()
email.setFrom("jose@example.none", name: "Jose")
```

#### setTextBody(text: String)

Sets the plain text body of the email.

```swift
var email = SendGrid.Email()
email.setTextBody("Awesome plain text body!")
```

#### setHtmlBody(html: String)

Sets the HTML body of the email.

```swift
var email = SendGrid.Email()
email.setHtmlBody("<p>Awesome HTML body!</p>")
```

#### setBody(text: String, html: String)

Sets both the plain text and HTML bodies.

```swift
var email = SendGrid.Email()
email.setBody("Awesome plain text body!", html: "<p>Awesome HTML body!</p>")
```

#### setReplyTo(address: String)

Sets a reply to address.

```swift
var email = SendGrid.Email()
email.setReplyTo("tim@example.none")
```

#### addCC(address: String)

Adds an email address to the CC field.

```swift
var email = SendGrid.Email()
email.addCC("tim@example.none")
email.addCC("isaac@example.none")
email.addCC("jose@example.none")
```

#### addCCs(addresses: [String])

Adds an array of addresses to the CC field.

```swift
var email = SendGrid.Email()
email.addCCs(["tim@example.none","isaac@example.none","jose@example.none"])
```

#### setCCs(addresses: [String])

Erases any current CC'd addresses and adds the specified list of addresses to the CC field.

```swift
var email = SendGrid.Email()
email.addCC("tim@example.none")
email.setCCs(["isaac@example.none","jose@example.none"])
// In this instance, only isaac@example.none and jose@example.none
// will be CC'd.
```

#### addBCC(address: String)

Adds an email address to the BCC field. ***IMPORTANT!*** *Adding BCC addresses will only work if the `hasRecipientsInSmtpApi` property on you `SendGrid.Email` instance is `false`.*

```swift
var email = SendGrid.Email()
email.hasRecipientsInSmtpApi = false
email.addBCC("tim@example.none")
email.addBCC("isaac@example.none")
email.addBCC("jose@example.none")
```

#### addBCCs(addresses: [String])

Adds an array of addresses to the BCC field. ***IMPORTANT!*** *Adding BCC addresses will only work if the `hasRecipientsInSmtpApi` property on you `SendGrid.Email` instance is `false`.*

```swift
var email = SendGrid.Email()
email.hasRecipientsInSmtpApi = false
email.addBCCs(["tim@example.none","isaac@example.none","jose@example.none"])
```

####  setBCCs(addresses: [String])

Erases any current BCC'd addresses and adds the specified list of addresses to the BCC field. ***IMPORTANT!*** *Adding BCC addresses will only work if the `hasRecipientsInSmtpApi` property on you `SendGrid.Email` instance is `false`.*

```swift
var email = SendGrid.Email()
email.hasRecipientsInSmtpApi = false
email.addBCC("jose@example.none")
email.setBCCs(["isaac@example.none","tim@example.none"])
// In this instance, only isaac@example.none and tim@example.none
// will be BCC'd.
```

#### addHeader(key: String, value: String)

Adds a custom header to the email message.

```swift
var email = SendGrid.Email()
email.addHeader("X-Custom-Header", value: "Custom header value here")
```

#### addHeaders(keyValuePairs: [String:String])

Adds custom headers to the email message.

```swift
var email = SendGrid.Email()
email.addHeaders([
    "X-Custom-Header": "Custom header value here",
    "X-Another-Header": "Badaboom!"
])
```

#### setHeaders(keyValuePairs: [String:String])

Removes any current headers and replaces them with the passed headers.

```swift
var email = SendGrid.Email()
email.addHeader("X-Custom-Header", value: "Custom header value here")
email.setHeaders([
    "X-Another-Header": "Badaboom!"
])
// In this instance, only the "X-Another-Header" header will be added.
```

#### addAttachment(filename: String, data: NSData, cid: String?)

Adds an attachment to the message. There's a few parameters in order to attach a file:

| Parameter | Explanation                                                                                                                                   |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| filename  | A String representing the filename of the attachment.                                                                                         |
| data      | An NSData object representing the data of the attachment.                                                                                     |
| cid       | An optional String representing a CID of the file in order to reference it in the HTML body. *This only works if the attachment is an image*. |

Here's an example of adding a simple txt file:

```swift
var email = SendGrid.Email()
let path = "/path/to/document.txt"
if let data = NSData(contentsOfFile: path) {
    email.addAttachment("file.txt", data: data, cid: nil)
}
```

Here's an example of adding an image with a CID, and then using it in the HTML body of your email:

```swift
var email = SendGrid.Email()
let path = "/path/to/image.jpg"
if let data = NSData(contentsOfFile: path) {
    email.addAttachment("banner.jpg", data: data, cid: "abc12345")
}
email.setHtmlBody("<img src=\"cid:abc12345\" />")
```

## X-SMTPAPI Functions

#### addSubstitution(_:values:)

Adds an array of substitution `values` for a given `key`.

```swift
var email = SendGrid.Email()
email.addSubstitution("%name%", values: ["Isaac","Jose","Tim"])
email.addSubstitution("%email%", values: ["isaac@example.none","jose@example.none","tim@example.none"])
```

#### addSection(_:value:)

Adds a new section tag. See the [Sections documentation](https://sendgrid.com/docs/API_Reference/SMTP_API/section_tags.html) for more info (this is generally used in conjunction with substitution tags).

```swift
var email = SendGrid.Email()
email.addSection("-greetMale-", value: "Hello Mr. %name%")
email.addSection("-greetFemale-", value: "Hello Ms. %name%")
```

#### addUniqueArgument(_:value:)

Adds a [Unique Argument](https://sendgrid.com/docs/API_Reference/SMTP_API/unique_arguments.html) to the email.

```swift
var email = SendGrid.Email()
email.addUniqueArgument("foo", value: "bar")
```

#### addCategory(_:)

Adds a category to the email.

```swift
var email = SendGrid.Email()
email.addCategory("Transactional")
email.addCategory("Forgot Password")
```

#### addCategories(_:)

Adds an array of categories to the email.

```swift
var email = SendGrid.Email()
email.addCategories(["Transactional", "Forgot Password"])
```

#### addFilter(_:setting:value:)

Adds settings for a specified [App](https://sendgrid.com/docs/API_Reference/SMTP_API/apps.html). The first parameter is the name of the app to edit, and uses the SendGridFilter enum defined [in the SMTPAPI-Swift repo](https://github.com/scottkawai/smtpapi-swift) to avoid common mistakes.

```swift
var email = SendGrid.Email()
email.addFilter(SendGridFilter.OpenTracking, setting: "enable", value: 0)
```

#### setSendAt(_:)

Sets a date (NSDate) to send the message at. Keep in mind that you can only schedule up to 24 hours in the future.

```swift
var email = SendGrid.Email()
var date = NSDate(timeIntervalSinceNow: (3 * 60 * 60)) // 3 hours from now
email.setSendAt(date)
```

#### setSendEachAt(_:)

Sets a list of dates that corresponds with the `to` array for when to send each message.

```swift
var email = SendGrid.Email()
var date1 = NSDate(timeIntervalSinceNow: (2 * 60 * 60))
var date2 = NSDate(timeIntervalSinceNow: (5 * 60 * 60))
email.setSendEachAt([date1, date2])
```

#### setAsmGroup(_:)

Sets an [Advanced Suppression Management Group](https://sendgrid.com/docs/User_Guide/advanced_suppression_manager.html) for the message.

```swift
var email = SendGrid.Email()
email.setAsmGroup(2)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-fancy-new-feature`)
3. Commit your changes (`git commit -am 'Added fancy new feature'`)
4. Push to the branch (`git push origin my-fancy-new-feature`)
5. Create a new Pull Request















