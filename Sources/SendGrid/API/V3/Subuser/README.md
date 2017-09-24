# Subusers API

This folder contains the classes used to make the [Subuser API](https://sendgrid.com/docs/API_Reference/Web_API_v3/subusers.html) calls.

## Get Subusers

To retrieve [list of subusers](https://sendgrid.com/docs/API_Reference/Web_API_v3/subusers.html#List-all-Subusers-for-a-parent-GET), use the `Subuser.Get` class. You can provide pagination information, and also search by username.  If you partial searches are allowed, so for instance if you had a subuser with username `foobar`, searching for `foo` would return it.

```swift
do {
    let search = Subuser.Get(username: "foo")
    try Session.shared.send(request: search) { (response) in
        if let list = response?.model {
            // The `model` property on the response will be an array of
            // `Subuser` instances.
            list.forEach { print($0.username) }
        }
    }
} catch {
    print(error)
}
```