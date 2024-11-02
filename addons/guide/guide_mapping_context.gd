@tool
class_name GUIDEMappingContext
extends Resource


@export_category("Action Remapping")
## The display name for this mapping context during action remapping 
@export var display_name:String

@export var mappings:Array[GUIDEActionMapping] = []


func _editor_name() -> String:
	if display_name.is_empty():
		return resource_path.get_file()
	else:
		return display_name + "(" + resource_path.get_file() + ")"
