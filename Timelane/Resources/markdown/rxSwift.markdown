## Using Timelane in RxSwift projects

 1. Add the Timelane RxSwift package to your Xcode project
**File > Swift Packages > Add Package Dependency...**

 2. RxTimelane's Package URL is:
**`https://github.com/icanzilb/RxTimelane`**

 3. Import the package: `import RxTimelane`

 4. Use the `lane()` operator to send a given subscription to the Timelane Instrument:
```
     yourObservable
        .lane("My Observable")

```

 5. Profile the app by using the Timelane Instrument template and observe your subscriptions.
