# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- New trigger type _Released_ which triggers when the input is released (the opposite of _Pressed_).

### Fixed
- Added missing equality comparison for `GUIDEInputAny` and `GUIDEInputMousePosition` so these inputs are not needlessly duplicated and updated multiple times per frame.


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