## Using Timelane in Combine projects

 1. Add the TimelaneCombine package to your Xcode project
**File > Swift Packages > Add Package Dependency...**

 2. TimelaneCombine's Package URL is:
**`https://github.com/icanzilb/TimelaneCombine`**

 3. Import the package: `import TimelaneCombine`

 4. Use the `lane()` operator to send a given subscription to the Timelane Instrument:
```
     yourPublisher
        .lane("My Publisher")

```

 5. Profile the app by using the Timelane Instrument template and observe your subscriptions.
