# Global Stats API

This folder contains the class used to make the [Global Stats API](https://sendgrid.com/docs/API_Reference/Web_API_v3/Stats/global.html) call.

## Get Global Stats

To retrieve the global stats, use the `Statistic.Global` class. At minimum you need to specify a start date.

```swift
do {
    let now = Date()
    let lastMonth = now.addingTimeInterval(-2592000) // 30 days
    let request = Statistic.Global(startDate: lastMonth, endDate: now, aggregatedBy: .week)
    try Session.shared.send(request: request) { (response) in
        // The `model` property will be an array of `Statistic.Period` structs.
        response?.model?.forEach{ (statPeriod) in
            // Do something with the stats here...
        }
    }
} catch {
    print(error)
}
```