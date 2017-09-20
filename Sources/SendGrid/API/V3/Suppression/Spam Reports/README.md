# Spam Reports API

This folder contains the classes used to make the [Spam Reports API](https://sendgrid.com/docs/API_Reference/Web_API_v3/spam_reports.html) calls.

## Table Of Contents

- [Get All Spam Reports](#get-all-spam-reports)
- [Get Specific Spam Report](#get-specific-spam-report)
- [Delete All Spam Reports](#delete-all-spam-reports)
- [Delete Specific Spam Reports](#delete-specific-spam-reports)

## Get All Spam Reports

To retrieve the list of all spam reports, use the `SpamReport.Get` class with the `init(start:end:page:)` initializer. The library will automatically map the response to the `SpamReport` struct model, accessible via the `model` property on the response instance you get back.

```swift
do {
    // If you don't specify any parameters, then the first page of your entire
    // spam report list will be fetched:
    let request = SpamReport.Get()
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `SpamReport` structs.
        response?.model?.forEach { print($0.email) }
        
        // The response object has a `Pagination` instance on it as well.
        // You can use this to get the next page, if you wish.
        //
        // if let nextPage = response?.pages?.next {
        //    let nextRequest = SpamReport.Get(page: nextPage)
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
    // Spam Reports starting from yesterday
    let now = Date()
    let start = now.addingTimeInterval(-86400) // 24 hours

    let request = SpamReport.Get(start: start, end: now, page: page)
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `SpamReport` structs.
        response?.model?.forEach { print($0.email) }
    }
} catch {
    print(error)
}
```

## Get Specific Spam Report

If you're looking for a specific email address in the spam report list, you can use the `init(email:)` initializer on `SpamReport.Get`:

```swift
do {
    let request = SpamReport.Get(email: "foo@example.none")
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `SpamReport` structs.
        response?.model?.forEach { print($0.email) }
    }
} catch {
    print(error)
}
```

## Delete All Spam Reports

To delete all spam reports, use the request returned from `SpamReport.Delete.all`.  This request will delete all spam reports on your spam report list.

```swift
do {
    let request = SpamReport.Delete.all
    try Session.shared.send(request: request) { (response) in
        print(response?.httpUrlResponse?.statusCode)
    }
} catch {
    print(error)
}
```

## Delete Specific Spam Reports

To delete specific entries from your spam report list, use the `SpamReport.Delete` class. You can either specify email addresses (as strings), or you can use `SpamReport` instances (useful for if you just retrieved some from the [Get Spam Reports](#get-all-spam-reports) call above).

```swift
do {
    let request = SpamReport.Delete(emails: "foo@example.none", "bar@example.none")
    try Session.shared.send(request: request) { (response) in
        print(response?.httpUrlResponse?.statusCode)
    }
} catch {
    print(error)
}
```
