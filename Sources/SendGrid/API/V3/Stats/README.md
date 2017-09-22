# Statistics API

This folder contains the classes used to make the [Stats API](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/index.html) calls.

## Table Of Contents

- [Get Global Stats](#get-global-stats)
- [Get Category Stats](#get-category-stats)
- [Get Subuser Stats](#get-subuser-stats)

## Get Global Stats

To retrieve the [global stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/global.html), use the `Statistic.Global` class. At minimum you need to specify a start date.

```swift
do {
    let now = Date()
    let lastMonth = now.addingTimeInterval(-2592000) // 30 days
    let request = Statistic.Global(
        startDate: lastMonth,
        endDate: now,
        aggregatedBy: .week
    )
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `Statistic` structs.
        response?.model?.forEach{ (stat) in
            // Do something with the stats here...
        }
    }
} catch {
    print(error)
}
```

## Get Category Stats

To retrieve [category stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/categories.html), use the `Statistic.Category` class. At minimum, you need to specify a start date and some categories.

```swift
do {
    let now = Date()
    let lastMonth = now.addingTimeInterval(-2592000) // 30 days
    let request = Statistic.Category(
        startDate: lastMonth,
        endDate: now,
        aggregatedBy: .week,
        categories: "Foo", "Bar"
    )
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `Statistic` structs.
        response?.model?.forEach{ (stat) in
            // Do something with the stats here...
        }
    }
} catch {
    print(error)
}
```

## Get Subuser Stats

To retrieve [subuser stats](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/subusers.html), use the `Statistic.Subuser` class. At minimum, you need to specify a start date and some subusers.

```swift
do {
    let now = Date()
    let lastMonth = now.addingTimeInterval(-2592000) // 30 days
    let request = Statistic.Subuser(
        startDate: lastMonth,
        endDate: now,
        aggregatedBy: .week,
        subusers: "Foo", "Bar"
    )
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `Statistic` structs.
        response?.model?.forEach{ (stat) in
            // Do something with the stats here...
        }
    }
} catch {
    print(error)
}
```