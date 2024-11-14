extends Node2D


@export var mapping_context:GUIDEMappingContext


func _ready():
	print("AP_READY")
	GUIDE.enable_mapping_context(mapping_context)
