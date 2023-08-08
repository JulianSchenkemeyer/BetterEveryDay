# BetterEveryDay

BetterEveryDay is a productivity timer app, based on the [third time approach](https://www.lesswrong.com/posts/RWu8eZqbwgB9zaerh/third-time-a-better-way-to-work). In contrast to a classical pomodoro timer, where you have fixed time interval for your work and pause, the timer in a third time approach is flexible. This means your work or focus phases can take as much time as you want. When you need a pause you can always hit pause, stop the timer and relax. The pause can take up to to one third of the time you previously spend working. 

If you only need a short break and still have time left in your pause, the remaining pause time is kept for the next pause. The same goes for when you take more time for your break. 


## Current State

BetterEveryDay is currently in its prototype phase. During this stage my goal is to explore potential features, functions and their implementation. While UI is an important part of any app, the UI will momentarily stack lower priority to focus on the functionality first.


## Techstack

* Swift
* SwiftUI
* Swift Charts

## Features

* Timer, indicating the time spend working on a task (shown in focus phase)
* Countdown, indicating the time left in the break (shown in pause phase)
* Keep track of unused and overdrawn pause times
* Option to limit the max length of a pause (currently hardcoded to 10min)
* Summary (Reflect) screen, showing the total focus time and break time (separated in used and unused), also shown in a simple bar chart
* Local notifications, to indicate when the pause quota is used up