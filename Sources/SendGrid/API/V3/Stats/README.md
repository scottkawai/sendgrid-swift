# Statistics API

This folder contains the class used to make the [Global Stats API](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/global.html) call.

## Table Of Contents

- [Get Global Stats](#get-global-stats)
- [Get Category Stats](#get-category-stats)

## Get Global Stats

To retrieve the global stats, use the `Statistic.Global` class. At minimum you need to specify a start date.

```swift
do {
    let now = Date()
    let lastMonth = now.addingTimeInterval(-2592000) // 30 days
    let request = Statistic.Global(startDate: lastMonth, endDate: now, aggregatedBy: .week)
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

To retrieve category stats, use the `Statistic.Category` class. At minimum, you need to specify a start date and some categories.

```swift
do {
    let now = Date()
    let lastMonth = now.addingTimeInterval(-2592000) // 30 days
    let request = Statistic.Category(startDate: lastMonth, endDate: now, aggregatedBy: .week, categories: "Foo", "Bar")
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