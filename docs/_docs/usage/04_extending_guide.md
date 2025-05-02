---
layout: page
title: "Extending G.U.I.D.E"
permalink: /usage/extending-guide
description: "How to write custom components for G.U.I.D.E"
---

## Introduction

G.U.I.D.E ships with a lot of built-in components that cover a wide range of use cases. However, you may have a certain use case that is specific for your game and is not covered by the built-in components. G.U.I.D.E is built in an extensible way so it is easy to add functionality that you need.

## Creating custom inputs

G.U.I.D.E can accept any `Vector3` as input, no matter where it comes from. So you can add your own custom inputs if you like to support a device that is not natively supported by G.U.I.D.E or to create a special input that behaves in a way that is useful for your game. To do this, create a new script derived from `GUIDEInput` and then implement the following functions:

```gdscript
# make sure the input is a tool script otherwise it will not show up
# in the action mapping editor
@tool 

# the class_name must be set as well
class_name MyCustomInput
extends GUIDEInput

# This function allows G.U.I.D.E to decide whether this input instance
# is the same as another input. This is important to implement because
# it allows G.U.I.D.E to deduplicate inputs that are shared between actions
# and thus improves performance. It is also used during input 
# remapping to determine whether a binding has changed.
func _is_same_as(other:GUIDEInput) -> bool:
    return other is MyCustomInput
    
# This function should return a human readable name for the input.
# The result from this function will be displayed in the 
# mapping context editor.
func _editor_name() -> String:
    return "My Custom Input"
    
# This function should return a short description of the input. The description
# is shown as tooltip when hovering over the input.
func _editor_description() -> String:
    return "An input that does something special."   

# This function should return the value type of this input. The returned
# value is used to put the input into the correct section in the 
# input mapping dialog.
func _native_value_type() -> GUIDEAction.GUIDEActionValueType:
    return GUIDEAction.GUIDEActionValueType.AXIS_3D
```

G.U.I.D.E should automatically find your new input and will offer it in the input dialog. Note that G.U.I.D.E will not be able to auto-detect your custom input, so you will need to select it from the right hand side of the input dialog.

### Input workflow in G.U.I.D.E

When a mapping context is activated, G.U.I.D.E will extract all used inputs from this mapping context and will instantiate one instance of each unique input. E.g. if we have two actions that check for the `A` key on the keyboard, only one instance of `GUIDEInputKey` checking for `A` will be created. This simplifies overlap detection and also improves performance. This is also why implementing the `_is_same_as` function is required.

After that, the `_begin_usage` function is called on the input. Custom inputs can override this to implement some necessary setup operations or set an initial input value. Most built-in inputs use this to subscribe to G.U.I.D.E's globally managed input state, which is available in the `_state` variable. Your custom input can of course get the input events from anywhere else, but it is recommended to use the `_state` variable for any Godot input events, as this is the most efficient way to get input device updates.

```gdscript
func _begin_usage() -> void:
    # subscribe to G.U.I.D.E's input state
    _state.joy_button_state_changed.connect(_on_joy_button_state_changed)
    # make sure to set the initial value
    _on_joy_button_state_changed()

func _on_joy_button_state_changed() -> void:
   if _state.is_joy_button_pressed(_joy_index, _joy_button):
       _value = Vector3(1, 0, 0)  # set the input value to pressed
   else:
       _value = Vector3.ZERO  # set the input value to not pressed
```

Now whenever input events are detected, `GUIDEInputState` will notify the input about relevant events. The inputs can now decide if and how this changes their `_value`. After the inputs are updated, G.U.I.D.E will then read the updated `_value`s and updates the action values and triggers. 

If mapping contexts are changed and an input is no longer needed, G.U.I.D.E will destroy the instance and no longer call it. Before the input is destroyed, G.U.I.D.E calls `_end_usage`. This can be overridden by custom inputs to perform any cleanup operations, such as unsubscribing from signals:

```gdscript
func _end_usage() -> void:
    # unsubscribe from G.U.I.D.E's input state
    _state.joy_button_state_changed.disconnect(_on_joy_button_state_changed)
```

### Resetting input

Sometimes it may be necessary to reset input at the end of the frame. This is commonly the case for inputs the represent delta values (e.g. mouse movement in the current frame). By default, G.U.I.D.E will not reset inputs unless they explicitly ask for it - again to increase performance. If G.U.I.D.E should reset your input, you will need to implement a few functions:

```gdscript
# Override this function and make it return "true" to tell G.U.I.D.E that 
# this input needs to be reset at the end of the frame
func _needs_reset() -> bool:
    return true

# This function will be called by G.U.I.D.E at the end of the frame when
# _needs_reset return "true".  The default implementation sets the 
# _value vector to Vector3.ZERO but you can implement any other reset functionality
# that is useful in your case.   
func _reset() -> void:
    ...

```

## Creating custom modifiers

Modifiers allow you to modify raw input and change its value. You can add custom modifiers to G.U.I.D.E if the built-in ones don't suit your needs. To do this, add a script deriving from `GUIDEModifier` to your project:

```gdscript
# The script needs to be tool, so G.U.I.D.E can detect it.
@tool
# The class name needs to be set as well.
class_name Tinyize
extends GUIDEModifier

# This function handles the modification. It gets the current input value
# the delta time of the current frame and the value type of the 
# action to which this modifier is bound. It should return
# the modified input.
func _modify_input(input:Vector3, delta:float, value_type:GUIDEAction.GUIDEActionValueType) -> Vector3:
	
	return input * 0.01  # make the input really tiny

# This function should return a human readable name for the modifier.
# The result from this function will be displayed in the 
# mapping context editor.
func _editor_name() -> String:
	return "Tinyize"	

# This function should return a short description of the modifier. The description
# is shown as tooltip when hovering over the modifier.
func _editor_description() -> String:
	return "Makes the input really tiny."
``````

Like inputs, G.U.I.D.E will automatically detect your custom modifier and offer it in the mapping context editor.

### Modifier workflow in G.U.I.D.E

When a mapping context is activated, G.U.I.D.E will extract all used modifiers from this mapping context and will instantiate one instance of each modifier as needed. Contrary to inputs, modifiers will _not_ be deduplicated and therefore also don't have a `_is_same_as` method. This allows modifiers to be stateful - so they can save data across frames in internal variables and use this data to modify the input if needed.

Like with inputs, modifiers can implement a `_begin_usage` function, that G.U.I.D.E calls once the modifier is activated and allows for some initialization code to be run.

Now every frame G.U.I.D.E will first collect all input values from the defined inputs and then call the `_modify_input` value on all modifiers with the appropriate input value. The value that is returned will then be used to update the action values and triggers.

If mapping contexts are changed and a modifier is no longer needed, G.U.I.D.E will destroy the instance and no longer call it. Before the modifier is destroyed, G.U.I.D.E calls `_end_usage`. This can be overridden by custom modifiers to perform any cleanup operations.

## Creating custom triggers

Custom triggers allow you to implement your own trigger logic, if the built-in triggers do not suit your needs. To create a custom trigger, add a new script that derives from `GUIDETrigger` to your project:

```gdscript
# The script must be tool, so G.U.I.D.E can detect it.
@tool
# The class_name must be set as well.
class_name MyCustomTrigger
extends GUIDETrigger

# This function is called every frame with the current input value,
# the delta time since the last frame and the value type of the
# action to which this trigger is bound. The function should
# return the updated state of the trigger.
func _update_state(input:Vector3, delta:float, value_type:GUIDEAction.GUIDEActionValueType) -> GUIDETriggerState:
	
	# the _is_actuated helper function will detect if the 
	# input is considered to be actuated right now. It is
	# recommended to use this function instead of checking the
	# input vector manually, to ensure a consistent definition
	# of "actuated" across all inputs.
	if _is_actuated(input, value_type):
	
		# Triggers have a built-in _last_value property
		# which contains the input value as it was last frame.
		# This is useful in many cases which is why G.U.I.D.E will
		# keep this value up-to-date automatically.
		if not _is_actuated(_last_value, value_type):
			return GUIDETriggerState.TRIGGERED
		
	return GUIDETriggerState.NONE

# This function should return a human readable name for the trigger.
# The result from this function will be displayed in the 
# mapping context editor.
func _editor_name() -> String:
	return "My Custom Trigger"

# This function should return a short description of the trigger. The description
# is shown as tooltip when hovering over the trigger.
func _editor_description() -> String:
	return "Trigger for one frame when the input is actuated."

```

### Trigger workflow in G.U.I.D.E

When a mapping context is activated, G.U.I.D.E will extract all used triggers from this mapping context and will instantiate one instance of each trigger as needed. Like modifiers, triggers will _not_ be deduplicated and therefore also don't have a `_is_same_as` method. Triggers are stateful and preserve data across frames. For example, each trigger automatically comes with a `_last_value` property which holds the input value from the last frame. But triggers can of course also set up their own data as needed.

Now every frame, G.U.I.D.E will call the trigger's `_update_state` method. The trigger can then update its internal state and should return the new trigger state:

- `GUIDETriggerState.NONE` - if the trigger is currently not triggered. For example the built-in "Hold" trigger will return `NONE` if the input is currently not actuated at all.
- `GUIDETriggerState.ONGOING` - if the trigger has detected some conditions that might trigger it, but not all conditions have been reached yet. For example the built-in "Hold" trigger will return `ONGOING` if the input is currently actuated, but the configured hold time has not elapsed yet.
- `GUIDETriggerState.TRIGGERED` - if the trigger has detected that all conditions for triggering are met.  For example the built-in "Hold" trigger will return `TRIGGERED` if the input is actuated and the configured hold time has elapsed.

Based on what the trigger returns, G.U.I.D.E will update the trigger state of the actions.

### Trigger types

Triggers can have one of three trigger types. These trigger types control how the action's final trigger state is calculated when multiple triggers are present on an action. 

- `EXPLICIT` - if explicit triggers are present, then **at least one** of these triggers must trigger for the action to be triggering. Almost all built-in triggers are of this type.
- `IMPLICIT` - if implicit triggers are present, then **all** implicit triggers must trigger for the action to trigger. The _Chorded Action_ and _Stability_ triggers are of this type.
- `BLOCKING` - if blocking triggers are present, then **none** of the blocking triggers must trigger for the action to trigger. So a blocking trigger will prevent the action from triggering. Currently, no built-in trigger uses this type, but it has been added for the sake of completeness.

To set the type for your trigger, override the `_get_trigger_type` function:

```gdscript
## Returns the trigger type of this trigger.
func _get_trigger_type() -> GUIDETriggerType:
    return GUIDETriggerType.IMPLICIT
```

The default value is `EXPLICIT` so if your trigger should be explicit, you don't need to override this function.

## Creating custom icon renderers

TODO

## Creating custom text providers

TODO
