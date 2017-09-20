# Invalid Emails API

This folder contains the classes used to make the [Invalid Emails API](https://sendgrid.com/docs/API_Reference/Web_API_v3/invalid_emails.html) calls.

## Table Of Contents

- [Get All Invalid Emails](#get-all-invalid-emails)
- [Get Specific Invalid Email](#get-specific-invalid-email)
- [Delete All Invalid Emails](#delete-all-invalid-emails)
- [Delete Specific Invalid Emails](#delete-specific-invalid-emails)

## Get All Invalid Emails

To retrieve the list of all invalid emails, use the `InvalidEmail.Get` class with the `init(start:end:page:)` initializer. The library will automatically map the response to the `InvalidEmail` struct model, accessible via the `model` property on the response instance you get back.

```swift
do {
    // If you don't specify any parameters, then the first page of your entire
    // invalid email list will be fetched:
    let request = InvalidEmail.Get()
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `InvalidEmail` structs.
        response?.model?.forEach { print($0.email) }
        
        // The response object has a `Pagination` instance on it as well.
        // You can use this to get the next page, if you wish.
        //
        // if let nextPage = response?.pages?.next {
        //    let nextRequest = InvalidEmail.Get(page: nextPage)
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
    // Invalid emails starting from yesterday
    let now = Date()
    let start = now.addingTimeInterval(-86400) // 24 hours

    let request = InvalidEmail.Get(start: start, end: now, page: page)
    try Session.shared.send(request: request) { (response) in
        response?.model?.forEach { print($0.email) }
    }
} catch {
    print(error)
}
```

## Get Specific Invalid Email

If you're looking for a specific email address in the invalid email list, you can use the `init(email:)` initializer on `InvalidEmail.Get`:

```swift
do {
    let request = InvalidEmail.Get(email: "foo@example")
    try Session.shared.send(request: request) { (response) in
        response?.model?.forEach { print($0.email) }
    }
} catch {
    print(error)
}
```

## Delete All Invalid Emails

To delete all invalid emails, use the request returned from `InvalidEmail.Delete.all`.  This request will delete all addresses on your invalid email list.

```swift
do {
    let request = InvalidEmail.Delete.all
    try Session.shared.send(request: request) { (response) in
        print(response?.httpUrlResponse?.statusCode)
    }
} catch {
    print(error)
}
```

## Delete Specific Invalid Emails

To delete specific entries from your invalid email list, use the `InvalidEmail.Delete` class. You can either specify email addresses (as strings), or you can use `InvalidEmail` instances (useful for if you just retrieved some from the [Get Invalid Emails](#get-all-invalid-emails) call above).

```swift
do {
    let request = InvalidEmail.Delete(emails: "foo@example", "bar@example")
    try Session.shared.send(request: request) { (response) in
        print(response?.httpUrlResponse?.statusCode)
    }
} catch {
    print(error)
}
```
