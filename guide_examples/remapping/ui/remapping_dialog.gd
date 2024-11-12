extends MarginContainer

const Utils = preload("../utils.gd")

## The mapping context we work on
@export var mapping_context:GUIDEMappingContext

## The input detector for detecting new input
@onready var input_detector:GUIDEInputDetector = %GUIDEInputDetector

## The remapper, helps us quickly remap inputs.
var _remapper:GUIDERemapper = GUIDERemapper.new()
var _remapping_config:GUIDERemappingConfig

func open():
	# Open the user's last edited remapping config, if it exists
	_remapping_config = Utils.load_remapping_config()
	
	# And initialize the remapper
	_remapper.initialize([mapping_context], _remapping_config)

