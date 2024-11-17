---
layout: page
title: Examples
permalink: /usage/examples
description: "Examples that ship with G.U.I.D.E."
---

# {{ page.title }}

G.U.I.D.E ships with quite a few small example projects that demonstrate how to use the plugin. You can find the examples in the `guide_examples` folder in the plugin's root directory. The following examples are included:

- `2d_axis_mapping` - Shows how to map 2D input from WASD keys to a 2D action so it can move a 2D character.
- `action_priority` - Shows the built-in action priority system. The example shows how to handle actions with overlapping input. In the example players have two spell quickbars bound to the controller D-pad. The first bar can be accessed by hitting the D-pad directly , the second bar can be accessed by holding the left trigger and hitting the D-pad. G.U.I.D.E will prioritize the second bar over the first bar if both are pressed at the same time.
- `combos` - Shows the built-in combo trigger. Players can double-tap to perform a dash or use a sequence of inputs to perform a special fireball attack.
- `input_contexts' - Shows using multiple mapping contexts at the same time. In the example the player uses one set of action mappings to control a character and switches to another set of action mappings when controlling a boat. This allows to trigger different actions with the same input controls.
- `input_scheme_switching` - Shows how to switch between different input schemes. In the example the player can switch between a keyboard and a controller input scheme while the game is running.
- `mouse_position_2d` - Shows the built-in _mouse position_ input in combination with the _canvas coordinates_ modifier to get the mouse position in world space directly from the input system.
- `mouse_position_3d` - Shows the built-in _mouse position_ input in combination with the _3d coordinates_ modifier to get the mouse position in 3D world space directly from the input system. Also shows how to use chorded triggers to rotate the camera with mouse movement while the right mouse button is held.
- `quick_start` - This is the example that is also shown in the [Quick Start Guide]({{ site.baseurl }}/quick_start). It shows how to create a simple 2D character controller with G.U.I.D.E.
- `remapping` - Shows how to use the built-in remapping system to allow players to remap their controls with a dialog.
- `simple_input` - a very barebones example that shows how to create a simple input action and bind it to a key press.
- `tap_and_hold` - Shows the built-in _tap_ and _hold_ trigger. Players can tap a button to jump or hold it to perform a somersault.
- `two_joysticks` - Shows how to do local multiplayer with two joysticks. Each player has their own joystick and can move around independently while both players use the same script to handle input.