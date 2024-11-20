---
layout: page
title: "Using G.U.I.D.E in your project"
permalink: /usage/using-guide
description: "How to use G.U.I.D.E in your project"
---

## Introduction

G.U.I.D.E provides a lot of functionality and for many projects only a limited subset is actually needed. If you just want a quick introduction on how to use it check out the [quick start tutorial]({{site.baseurl}}/quick-start). 

## Actions
Actions are the main way in which your game code will interact with G.U.I.D.E. In contrast to Godot's built-in input actions, G.U.I.D.E actions are resources of type `GUIDEAction` which you create as files in your project. To create an action, simply right-click in Godot's file system explorer and then create a new resource:

{% include video.html path="assets/img/manual/manual_create_action.mp4" %}

Actions have quite a few properties which control how they work. You can edit the action's properties by double-clicking them, then you can edit their properties in the inspector.

| Property                       | Description                                                                                                                                                                        |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| _Name_                         | The name of the action. Is used when emitting the action as a Godot action and as a fallback when _Display Name_ is not set.                                                       |
| _Action Value Type_            | The value type associated with the action. This is the only required configuration property.                                                                                       |
| _Block Lower Priority Actions_ | If set this action will block other actions that are lower priority and share the same input. See [action priority](#action-priority) below.                                       |
| _Emit As Godot Actions_ | If checked whenever this action triggers, it will emit an `InputEventAction` into Godot`s input system. This is useful for interacting code that uses Godot actions (e.g. the UI). |
| _Is Remappable_ | Marks the action as remappable. This allows remapping the action to new input at runtime.                                                                                          |
| _Display Name_ | A display name to show the player for this action. Useful when creating UI for remapping input.                                                                                    |
| _Display Category_ | A display category in which the action is located. Useful when creating UI for remapping input.                                                                                    |

### Using actions in game code

Actions can be used in different ways in your game code. Before you can do that, you first need to get access to the action in your game code. The recommended way to do this is using an `@export` variable in your script. This allows you to simply drag the action you want to access into the inspector.

```gdscript
@export var action:GUIDEAction 
```

Because an action is a resource, you can also get access to it by using Godot's `load` or `preload` functions, if you prefer this over an `@export`:

```gdscript
var action:GUIDEAction = load("res://path/to/my_action.tres")
```

You can now poll the action's state in `_process` or `_physics_process`:

```gdscript
func _process(delta:float) -> void:
    if action.is_triggered():
        print("The action was triggered!")
```

Alternatively you can also get notified whenever the action changes its state. For this the action provides a range of [signals]({{site.baseurl}}/usage/concepts#action-signals).

```gdscript
func _ready():
    action.triggered.connect(_on_action_triggered)
    
func _on_action_triggered():
    print("The action was triggered")
```

You can use whichever way works best for your project, you can also mix them. In addition to a state, each action also has a value. The type of value depends on the _Action Value Type_ you have set up when creating the action. You can access the current value of the action using the `value_xxx` properties:

```gdscript
# For boolean actions (on/off)
var action_value:bool = action.value_bool

# For float actions (a single axis, e.g. joy trigger)
var action_value:float = action.value_axis_1d

# For vector2 actions (two axes, e.g. joy stick or mouse position)
var action_value:Vector2 = action.value_axis_2d

# For vector3 actions (three axes, e.g. 3D cursor)
var action_value:Vector3 = action.value_axis_3d
```

Note, that the value is independent from the state of an action. Even if an action is currently not triggered, it still has a value. 

## Mapping contexts

Mapping contexts allow you to assign input to actions. Like an action, a mapping context is also just a resource of type `GUIDEMappingContext`, so you can create one similar to how you create an action:

![Creating a mapping context]({{site.baseurl}}/assets/img/manual/quick_start_create_mapping_context.png)


If you now double-click on the newly create mapping context, a custom editor will open and allow you to create bindings for your actions:

![Mapping context editor]({{site.baseurl}}/assets/img/manual/manual_mapping_context_editor.png)

### Creating action mappings

To create a new action mapping, press the _+_ button (#`1` in the image). This will create a new row for an action mapping. Start by dragging the action for which you want to create a binding into the action slot (#`2` in the image):

{% include video.html path="assets/img/manual/quick_start_create_action_mapping.mp4" %}

### Adding input mappings
Now you can create input mappings for your action. In the simplest case, an action is bound to a single piece of input (e.g. key on the keyboard, a button or a stick on the controller). To bind an input to your action, press the _+_ button next to the _Input Mappings_ list (#`3` in the image). You can now bind an input to the action by clicking the pen icon (#`4` in the image). The input dialog allows you to either detect an input or manually specify one:

{% include video.html path="assets/img/manual/manual_input_dialog.mp4" %}

Most of the time you will want to use the input detection as it is the quickest way to select an input. However some inputs (like _Action_ or _Any_) can only be selected manually on the right side of the dialog. Note, that the value type of the input doesn't necessarily need to match the value type of your action as the action value is calculated from the inputs (see [action value calculation](#action-value-calculation) below).

If you want to edit an input, you can either click the pen icon again and select a completely new input, or you can click on the input and then edit it in the inspector:

{% include video.html path="assets/img/manual/manual_edit_inputs.mp4" %}

If you want you can also bind more than one input to the same action. The values of all inputs bound to an action will be combined into the final action value (see [action value calculation](#action-value-calculation) below).

### Adding modifiers

Modifiers allow you to modify the value 



## The G.U.I.D.E debugger