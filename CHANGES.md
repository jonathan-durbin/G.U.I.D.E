# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Breaking Changes
- The `input_detected` signal of `GUIDEInputDetector` had a typo in it (was `input_dectected`) and was renamed to fix this. If your code uses this signal you will need to update it. Also check your scenes if you connected this signal using the editor.

### Added
- Support for touch input:
	- _Touch Position_  - will track the position of one or more fingers, similar to _Mouse Position_
	- _Touch Axis2D_ - will track the position change of one or more fingers, similar to _Mouse Axis2D_
	- _Touch Axis1D_ - similar to _Touch Axis2D_ but tracks a single axis, only.
	- _Touch Distance_ - tracks distance changes between two fingers. Useful for implementing pinch/zoom gestures.
	- _Touch Angle_ - tracks rotation changes between two fingers. Useful for implementing rotation gestures.
- New trigger type _Stability_ which triggers depending on whether the input has changed after initial actuatation. Useful for touch input to detect taps and drags.
- A new `touch` example has been added, showing how to use the new touch features to implement camera drags, pinch/zoom and rotation.
- New modifier _Normalize_ to normalize an input vector.

### Improved
- `GUIDEInputDetector` can now filter for device types, so you can limit detected input to keyboard, mouse or joystick/gamepad input.
- `GUIDEInputDetector` now has a `is_detecting` property to find out whether it is currently detecting input.
- `GUIDEInputDetector` now has a setting determining which joy index should be assigned to detected joy events.
- `GUIDERemapper` can now also filter for single actions, so it is easier to remap input for a specific action.
- The `remapping` example's usability for controllers has been improved, showing some techniques on how to make UI more controller friendly.

### Fixed
- Triggers will no longer consider infinite input values as "actuating". Vector.INF is reserved for cases where no value is available.
- Modifiers now handle infinite input values more gracefully instead of producing `NaN` values.
- The text provider will no longer try to translate physical keys to labels on mobile platforms where Godot doesn't support this.
- Inputs of type `GUIDEInputAction` are now properly displayed in the debugger.

## [0.0.4] - 2024-12-28
### Fixed
- Fixed broken equality comparison on `GUIDEInputAny` ([#3](https://github.com/godotneers/G.U.I.D.E/issues/3)).

## [0.0.3] - 2024-12-21
### Added
- New trigger type _Released_ which triggers when the input is released (the opposite of _Pressed_).
- New modifier _Virtual Cursor_ which provides a virtual mouse cursor that can be controlled by any input (experimental).

### Changed
- In the debugger, inputs now show the raw Vector3 coming from the input. This helps understanding modifiers better as we can see the value that is going into the modifier.

### Fixed
- Added missing equality comparison for `GUIDEInputAny` and `GUIDEInputMousePosition` so these inputs are not needlessly duplicated and updated multiple times per frame.
- Triggers do no longer reset the action value to zero when they don't fire. They are intended to be orthogonal to the action values, so they should react to changes of the value, rather than modify it (for that we have modifiers).
- Fixed several smaller rendering problems with rendering items (e.g. broken direction indicator for Xbox controllers and joysticks, right trigger being shown as left trigger, etc.). To clear cached icons, go to _Project_ > _Open user data folder_  and in this folder delete the `_guide_cache` folder. This will recreate icons. 
- Fixed size of the icons which should be 16x16 not 32x32 ([#2](https://github.com/godotneers/G.U.I.D.E/issues/2)).

## [0.0.2] - 2024-12-02
### Breaking Changes
- Removed the leftover`get_value_axis_xxx` methods from the `GUIDEAction` class. Use the `value_axis_xxx` property instead.
- `GUIDEDebugger` is no longer a public node class because it cannot work as a standalone node. Use the provided `guide_debugger.tscn` scene to add a debugger to your project.
### Added
- `GUIDEAction` now has additional functions to check whether it is currently in `Completed` or `Ongoing` state.
- Added two new modifiers: _Curve_ which allows to apply a curve to the input value and _Map range_ which allows to map the input value to a different range. A huge thanks goes to [Regal Media](https://github.com/RegalMedia) for submitting a PR with this feature!
### Improved
- The `input_mappings_changed` signal in `GUIDE` now also fires when any joystick is connected or disconnected.


## [0.0.1] - 2024-11-17
- Initial release of the plugin.
