# CircularTimer
A CocoaPods library written in Swift. It's a countdown timer with a circular animation and a pin. It's fully customizable using storyboard.
***
## Examples:
### Animation
![](https://media.giphy.com/media/TLJPoQ0rlo21LqsXMp/giphy.gif)

### Background
![](https://media.giphy.com/media/l2FH5VNZ0LwwyPIi7N/giphy.gif)

### Configuration
![](https://media.giphy.com/media/YOvwyl8kur4x5XCvVM/giphy.gif)

You can customize:
* Font Size;
* Enable Timer;
* Font Color;
* Adapt Timer to hour, minute or second format;
* Background Circle Radius;
* Background Circle Color;
* Stroke;
* Stroke Width;
* Completed Stroke Width;
* Stroke Color;
* Completed Stroke Color;
* Pin Color;
* Pin Radius.

### Usage example:
```
self.timer.setTimer(60)
self.timer.start()
self.timer.pause()
self.timer.stop()

self.timer.enterForeground()
self.timer.enterBackground()
```

## Lisence

Copyright 2020 Fábio Sousa.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
