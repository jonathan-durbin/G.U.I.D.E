## An action to input mapping
class_name GUIDEActionMapping
extends Resource

## The action to be mapped
@export var action:GUIDEAction

## A set of input mappings that can trigger the action
@export var input_mappings:Array[GUIDEInputMapping] = []
