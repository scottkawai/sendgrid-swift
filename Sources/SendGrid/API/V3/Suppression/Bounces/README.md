# Bounces API

This folder contains the classes used to make the [Bounces API](https://sendgrid.com/docs/API_Reference/Web_API_v3/bounces.html) calls.

## Table Of Contents

- [Get All Bounces](#get-all-bounces)
- [Get Specific Bounce](#get-specific-bounce)
- [Delete All Bounces](#delete-all-bounces)
- [Delete Specific Bounces](#delete-specific-bounces)

## Get All Bounces

To retrieve the list of all bounces, use the `Bounce.Get` class with the `init(start:end:page:)` initializer. The library will automatically map the response to the `Bounce` struct model, accessible via the `model` property on the response instance you get back.

```swift
do {
    // If you don't specify any parameters, then the first page of your entire
    // bounce list will be fetched:
    let request = Bounce.Get()
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `Bounce` structs.
        response?.model?.forEach { print($0.email) }
        
        // The response object has a `Pagination` instance on it as well.
        // You can use this to get the next page, if you wish.
        //
        // if let nextPage = response?.pages?.next {
        //    let nextRequest = Bounce.Get(page: nextPage)
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
    // Bounces starting from yesterday
    let now = Date()
    let start = now.addingTimeInterval(-86400) // 24 hours

    let request = Bounce.Get(start: start, end: now, page: page)
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `Bounce` structs.
        response?.model?.forEach { print($0.email) }
    }
} catch {
    print(error)
}
```

## Get Specific Bounce

If you're looking for a specific email address in the bounce list, you can use the `init(email:)` initializer on `Bounce.Get`:

```swift
do {
    let request = Bounce.Get(email: "foo@example.none")
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `Bounce` structs.
        if let match = response?.model?.first {
          print("\(match.email) bounced with reason \"\(match.reason)\"")
        }
    }
} catch {
    print(error)
}
```

## Delete All Bounces

To delete all bounces, use the request returned from `Bounce.Delete.all`.  This request will delete all bounces on your bounce list.

```swift
do {
    let request = Bounce.Delete.all
    try Session.shared.send(request: request) { (response) in
        print(response?.httpUrlResponse?.statusCode)
    }
} catch {
    print(error)
}
```

## Delete Specific Bounces

To delete specific entries from your bounce list, use the `Bounce.Delete` class. You can either specify email addresses (as strings), or you can use `Bounce` instances (useful for if you just retrieved some from the [Get Bounces](#get-all-bounces) call above).

```swift
do {
    let request = Bounce.Delete(emails: "foo@example.none", "bar@example.none")
    try Session.shared.send(request: request) { (response) in
        print(response?.httpUrlResponse?.statusCode)
    }
} catch {
    print(error)
}
```
