## Using Timelane Core

 1. Add the TimelaneCore package to your Xcode project
**File > Swift Packages > Add Package Dependency...**

 2. TimelaneCombine's Package URL is:
**`https://github.com/icanzilb/TimelaneCore`**

 3. Import the package: `import TimelaneCore`

 4. To create a subscription use:
 `let s = Timelane.Subscription(name: "My Sub")`
 
 5. To start the subscription: `subscription.begin()`

 6. To end the subscription: `subscription.end()`

 7. Profile the app by using the Timelane Instrument template and observe your subscriptions.
