DZAppRater
==========

The idea behind this, is that when the user opens up your application for a limited amount of sessions, the typical "Rate us" UIAlertView will be shown. The user might want to rate your app, so it will open up the AppStore on the review section and this will free the user from making a lot of steps to reach your review page.
I have used this mechanism for a lot of apps, and it is impressive the way this helps getting more reviews on the AppStore. Hope it helps you!


## Some Screenshots
![DZDocumentsPickerController](http://www.dzen.cl/github/DZAppRater.jpg)

## How to use

### Step 1
```
Import "DZAppRater.h" to your AppDelegate.
```

### Step 2
In your AppDelegate's application:didFinishLaunchingWithOptions: write down the following lines of code:

```
[[DZAppRater sharedInstance] setAppIdentifier:YOUR_APP_IDENTIFIER];
[[DZAppRater sharedInstance] setRaterInterval:3];
[[DZAppRater sharedInstance] startTracking];
```


## License
(The MIT License)

Copyright (c) 2012 Ignacio Romero Zurbuchen <iromero@dzen.cl>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.