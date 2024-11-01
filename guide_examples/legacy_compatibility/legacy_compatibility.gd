extends MarginContainer

@export var mapping_context:GUIDEMappingContext

# Called when the node enters the scene tree for the first time.
func _ready():
	GUIDE.enable_mapping_context(mapping_context)
	%Button.grab_focus()
