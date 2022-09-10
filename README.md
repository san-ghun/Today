#  Today

> from the [UIKit - iOS App Dev Tutorials | Apple Developer Documentation](https://developer.apple.com/tutorials/app-dev-training/#uikit-essentials) 

- An app that helps users track their important tasks for the day.
- Developed with the UIKit, an imperative framwork for constructing app for iOS.


## UIKit overview

UIKit is a graphical framework for building apps on Apple platforms. Use UIKit to define and manage your app’s interface using a comprehensive library of standard components. Here are some of the key features of UIKit:

- **Extensive API coverage** — Access an extensive library of items in the UIKit framework, including the core objects, views, and controls that you’ll need to build iOS apps with few or no modifications.

- **Compositional layouts** — Create flexible visual layouts by constructing a collection view from small, reusable components and applying state-driven updates to cells.

- **Precise UI display** — Use Auto Layout to create layouts that work on all Apple devices in any orientation, whether you’re building your view programmatically or using Interface Builder.

- **Legacy app support** — Before iOS 13, developers built all apps on UIKit. If you’re maintaining or extending legacy apps in iOS, watchOS, or tvOS, you need a good foundation in UIKit.

- **Strong community adoption** — Benefit from extensive content and support from the UIKit community, in addition to Apple documentation.

- **Interoperability with SwiftUI** — Easily integrate UIKit and SwiftUI to use the best of both frameworks.

To learn more about the framework, refer to [UIKit](https://developer.apple.com/documentation/uikit) in the Apple Developer Documentation.


## Tour of the app

Today, a productivity app for iOS that presents daily reminders. The goal of Today is not only to help users focus on their tasks for the day, but also to use visual design and animation to present a muted, calm interface.

Take a closer look at the Today app.

### Reminder list
The main screen of the app displays a list of a user’s reminders. The segmented control in the navigation bar lets users filter reminders by due date categories: Today, Future, or All. The user can complete reminders by tapping a done button. The progress circle — the large circle above the reminder list — fills in as the user completes reminders. Tapping the Add button (+) in the navigation bar creates a new reminder.

![Screenshot of reminder list screen with sample reminders and progress circle](https://docs-assets.developer.apple.com/published/3fae06fa35e10cba5b175fd629e45ba0/UIK_000-020-010~dark.png)

### Reminder view and editing modes
The detail screen shows more information about a reminder, including its title, due date, time due, and additional notes. In view mode, as shown here, the reminder details appear in rows with icons. The user can alter the reminder’s details by tapping the Edit button.

In editing mode, a visually distinct view displays editable fields and pickers to let the user change details. You’ll reuse this edit view to display the Add Reminder screen.

![Screenshot of reminder detail screen with sample title, date, time, and note](https://docs-assets.developer.apple.com/published/2d37b8ac90afd2fee6d0c18b75e0e060/UIK_000-020-020~dark.png)

### Add reminder screen
The Add Reminder screen appears when the user taps the Add button (+) in the reminder list. This screen shares cells with the edit view, but presents modally instead of pushing onto the navigation stack.

![Screenshot of Add Reminder modal screen with title, date, time, and notes fields](https://docs-assets.developer.apple.com/published/ab03dd131bc0b1760c9f20a660533560/UIK_000-020-030~dark.png)



### Tips for success

- Learn more by doing. 
- Take an active role in learning. Think about how to accomplish the task.
