---
layout: page
title: Input Reference
permalink: /reference/inputs
description: "A reference for all built-in inputs."
---

## Introduction
G.U.I.D.E ships with a selection of inputs for all kinds of input devices. This is a list of all built-in inputs and their settings:

## Action

This input takes a `GUIDEAction` and returns the current value of the action. This way you can use an action value as input for another action. The input will actively track the state of the action and update the value accordingly. This means the input works independently of whether the action is currently bound to an active mapping context and it also works independently of the order in which the action in bound in a mapping context. This input will always mirror the full Vector3 of the action value (even if the action only uses parts of it). The input has the following settings:

|Setting|Description|
|---|---|
|_Action_| The action that the input should track. |

## Any
This input returns `(1,0,0)` if any input is received from the selected device classes, and `(0,0,0)` otherwise. This is useful if you want to check if any input is received from a device (e.g. to switch input schemes when you detect controller input). The input has the following settings:

| Setting             | Description                                                                                                                       |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| _Mouse_         | Detect input from the mouse                                                                            |
| _Joy_         | Detect input from joysticks / joypads                                                                            |
| _Key_         | Detect input from the keyboard                                                                            |

## Joy Axis 1D

This input returns the value of a 1D axis of a joystick in the `x` component of the input value. The input is restricted to the range of `(-1, 0, 0)` to `(1, 0, 0)`, while usually being `(0,0,0)` when the axis is not actuated. Note that some joy axes only use positive values (e.g. controller triggers). The input has the following settings:

| Setting             | Description                                                                                                                       |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| _Axis_         | The joy axis that should be tracked by the input.                                                                          |



## Joy Axis 2D
This input returns the value of a 2D axis of a joystick in the `x` and `y` components of the input value. The input is restricted to the range of `(-1, -1, 0)` to `(1, 1, 0)`, while usually being `(0,0,0)` when the axis is not actuated. The input has the following settings:

| Setting             | Description                                                                                                                       |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| _X_        | The joy axis that should be tracked by the input for the `x` component.                                                                          |
| _Y_        | The joy axis that should be tracked by the input for the `y` component.                                                                          |


## Joy Button
This input returns `(1,0,0)` if the selected joystick button is pressed, and `(0,0,0)` otherwise. The input has the following settings:

| Setting             | Description                                                                                                                       |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| _Button_         | The joy button that should be tracked by the input.                                                                          |


## Key

This input returns `(1,0,0)` if the selected key is pressed, and `(0,0,0)` otherwise. The input has the following settings:

| Setting             | Description                                                                                                                       |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| _Key_         | The key that should be tracked by the input.  This is expected to be a physical key code, so that the physical location of the key in the keyboard stays the same no matter which locale the keyboard is operating in.                                                                        |

## Mouse Axis 1D

This input returns changes in mouse position along a single axis in the `x` component of the input value (e.g. `(x, 0, 0)`). The input is given in pixels per frame. You can use a _Screen Relative_ modifier to convert this into a value from -1 to 1 that is independent of the screen resolution. The input has the following settings:

| Setting             | Description                                                                                                                       |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| _Axis_         | The mouse axis that should be tracked by the input.                                                                          |

## Mouse Axis 2D

This input returns changes in mouse position along two axes in the `x` and `y` components of the input value (e.g. `(x, y, 0)`). The input is given in pixels per frame. You can use a _Screen Relative_ modifier to convert this into a value from -1 to 1 that is independent of the screen resolution. The input has no settings.

## Mouse Button

This input returns `(1,0,0)` if the selected mouse button is pressed, and `(0,0,0)` otherwise. Note, that Godot also treats the mouse wheel as buttons. If you need an axis from the wheel, you can
map _Wheel Up_ + a _Negate Modifier_ and _Wheel Down_ to a 1-dimensional action. The input has the following settings:

| Setting             | Description                                                                                                                       |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| _Button_         | The mouse button that should be tracked by the input.                                                                          |


## Mouse Position

This input returns the current mouse position in pixels relative to the top left corner of the window in the `x` and `y` components of the input value (e.g. `(x, y, 0)`). You an use a _Canvas Coordinates_ modifier to convert this into a value into 2D world coordinates for the currently active viewport or a _3D Coordinates_ modifier to convert this into 3D world coordinates (e.g. for object picking). This input has no settings.
