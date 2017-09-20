# Global Unsubscribes API

This folder contains the classes used to make the [Global Unsubscribes API](https://sendgrid.com/docs/API_Reference/Web_API_v3/Suppression_Management/global_suppressions.html) calls.

## Table Of Contents

- [Get All Global Unsubscribes](#get-all-global-unsubscribes)
- [Get Specific Global Unsubscribe](#get-specific-global-unsubscribe)
- [Add Global Unsubscribes](#add-global-unsubscribes)
- [Delete Global Unsubscribe](#delete-global-unsubscribe)

## Get All Global Unsubscribes

To retrieve the list of all global unsubscribes, use the `GlobalUnsubscribe.Get` class with the `init(start:end:page:)` initializer. The library will automatically map the response to the `GlobalUnsubscribe` struct model, accessible via the `model` property on the response instance you get back.

```swift
do {
    // If you don't specify any parameters, then the first page of your entire
    // global unsubscribe list will be fetched:
    let request = GlobalUnsubscribe.Get()
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `GlobalUnsubscribe` structs.
        response?.model?.forEach { print($0.email) }
        
        // The response object has a `Pagination` instance on it as well.
        // You can use this to get the next page, if you wish.
        //
        // if let nextPage = response?.pages?.next {
        //    let nextRequest = GlobalUnsubscribe.Get(page: nextPage)
        // }
    }
} catch {
    print(error)
}
```

You can also specify any or all of the init parameters to filter your search down:

```swift
do {
    // Retrieve page 2
    let page = Page(limit: 500, offset: 500)
    // Global unsubscribes starting from yesterday
    let now = Date()
    let start = now.addingTimeInterval(-86400) // 24 hours

    let request = GlobalUnsubscribe.Get(start: start, end: now, page: page)
    try Session.shared.send(request: request) { (response) in
        response?.model?.forEach { print($0.email) }
    }
} catch {
    print(error)
}
```

## Get Specific Global Unsubscribe

If you're looking for a specific email address in the global unsubscribe list, you can use the `init(email:)` initializer on `GlobalUnsubscribe.Get`:

```swift
do {
    let request = GlobalUnsubscribe.Get(email: "foo@example")
    try Session.shared.send(request: request) { (response) in
        response?.model?.forEach { print($0.email) }
    }
} catch {
    print(error)
}
```

## Add Global Unsubscribes

To add email addresses to your global unsubscribe list, use the `GlobalUnsubscribe.Add` class. You can specify email addresses (as strings), or you can use `Address` instances.

```swift
do {
    let request = GlobalUnsubscribe.Add(emails: "foo@example.none", "bar@example.none")
    try Session.shared.send(request: request) { (response) in 
        print(response?.httpUrlResponse?.statusCode)
    }
} catch {
    print(error)
}
```

## Delete Global Unsubscribe

To delete specific entries from your global unsubscribe list, use the `GlobalUnsubscribe.Delete` class. You can specify an email address (as a string), or you can use a `GlobalUnsubscribe` instance (useful for if you just retrieved some from the [Get Global Unsubscribe](#get-all-global-unsubscribes) call above).

```swift
do {
    let request = GlobalUnsubscribe.Delete(email: "foo@example.none")
    try Session.shared.send(request: request) { (response) in
        print(response?.httpUrlResponse?.statusCode)
    }
} catch {
    print(error)
}
```
