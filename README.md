# G.U.I.D.E - Godot Unified Input Detection Engine

G.U.I.D.E is an extension for the Godot Engine that allows you to easily use input from multiple sources, such as keyboard, mouse, gamepad, etc. in a unified way. Gone are the days, where mouse input was handled differently from joysticks. No matter where the input comes from - your game code stays the same.

## Features

- Unified input detection and handling from multiple sources (keyboard, mouse, gamepad, etc.).
- Actions can have different value types (e.g. boolean, 1D, 2D or 3D axis).
- Multiple mapping contexts (e.g different controls while walking, driving, flying, etc.)
- Mapping contexts can be easily enabled/disabled at any time, e.g. to lock all input during a cutscene or while being in a menu.
- Actions can be prioritized, so higher priority actions win over lower priority ones when they share input.
- Inputs from different sources can be combined (e.g. build a 2D axis from 4 buttons or 2 gamepad triggers).
- Inputs can be modified (e.g. for joystick dead-zones, sensitivity, inversion, etc.).
- Built-in support for common action patterns (e.g. tap, hold, press, release, etc.).
- Built-in support for local multiplayer (e.g. multiple players with different input sources).
- Built-in remapping system (e.g. change input mappings at runtime).
- Built-in support for displaying input prompts for the configured input mappings.
- Integrates with Godot's built-in input system (so you can send G.U.I.D.E actions as Godot actions).



## Acknowledgements / Licenses

The input prompts use the great icons made by Nicolae (Xelu) Berbece (https://thoseawesomeguys.com/prompts/) under CC0 License.
