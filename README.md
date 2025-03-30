# BetterEveryDay

<div>
  <img src="/Resources/app-overview.jpg" style="max-height:500px" alt="App screen overview. Show the different screens of the app and how they are connected.">
</div>

BetterEveryDay is a productivity timer app, based on the [third time approach](https://www.lesswrong.com/posts/RWu8eZqbwgB9zaerh/third-time-a-better-way-to-work). In contrast to a classical pomodoro timer, where you have fixed time interval for your work and pause, the timer in a third time approach is flexible. This means your work or focus phases can take as much time as you want. When you need a pause you can always hit pause, stop the timer and relax. The pause can take up to to one third of the time you previously spend working.

If you only need a short break and still have time left in your pause, the remaining pause time is kept for the next pause. The same goes for when you take more time for your break.

## Current State

BetterEveryDay is currently in its prototype phase.

Overview
Prepare
Session

### What does already work

- Foundational logic (calculation of breaks, goal setting)
- Limit the maximal pause time, which can be earned to 3, 4, ..., 10 min
- Change the factor through which pause time is earned between 1 and 5. For example if the factor is set to 5, you have to focus on your task for 5 min to earn 1 min of pause time
- UI
  - Basic Information about the current day (total length spend in sessions, session count, distribution of focus vs pause, last 5 goals)
  - Modal to enter a new goal and start a new session
  - Session view, showing the timer, if the user is currently in focus or pause and his stated goal for the session
  - a rough draft of the settings view
- Local Notifications for reminding users when their pause time is up, if the app is not open
- Persisting the session data
- Restoring running sessions if the app was quit

### Next Steps

- Make historical data visible / Timeline view, allowing the user to revisit the goals and session of past days
- Rewrite Settings
- Modularize into smaller module
- Widgets and Live activity
- Interactive Widgets and Control Center Element
- Allow users to switch to other timer variants (classic Pomodoro)
- Adjustment for other platforms

## Used Technologies

- Swift
- SwiftUI
- Swift Charts
- Swift Data
- DocC
- XCTest

## What needs to be done before a release

- App Icons & Launchscreen
- Improve Accessibility & UX
- Add an onboarding experience
- Make sure the design is consistent (colors, shadow, font types, ...)
- Find a better name
- Add more personality (small animations, ...)
- Improve Performance
