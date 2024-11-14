extends MarginContainer

signal closed(applied_config:GUIDERemappingConfig)

const Utils = preload("../utils.gd")

@export var keyboard_context:GUIDEMappingContext
@export var controller_context:GUIDEMappingContext
@export var binding_row_scene:PackedScene
@export var binding_section_scene:PackedScene

@onready var _keyboard_bindings:Container = %KeyboardBindings
@onready var _controller_bindings:Container = %ControllerBindings
@onready var _press_prompt:Control = %PressPrompt
@onready var _controller_invert_horizontal:CheckBox = %ControllerInvertHorizontal
@onready var _controller_invert_vertical:CheckBox = %ControllerInvertVertical
@onready var _tab_container:TabContainer = %TabContainer


## The input detector for detecting new input
@onready var _input_detector:GUIDEInputDetector = %GUIDEInputDetector

## The remapper, helps us quickly remap inputs.
var _remapper:GUIDERemapper = GUIDERemapper.new()

## The config we're currently working on
var _remapping_config:GUIDERemappingConfig

var _restore_contexts:Array[GUIDEMappingContext] = []

func open():
	# switch the tab to the scheme that is currently enabled
	if GUIDE.is_mapping_context_enabled(controller_context):
		_tab_container.current_tab = 1
	else:
		_tab_container.current_tab = 0

	# Remember which contexts are currently active (should really be only one)
	_restore_contexts = GUIDE.get_enabled_mapping_contexts()
	for context in _restore_contexts:
		# Disable them, so the player doesn't move in the background.
		GUIDE.disable_mapping_context(context)
	
		
	_tab_container.get_tab_bar().grab_focus()
	
	# Open the user's last edited remapping config, if it exists
	_remapping_config = Utils.load_remapping_config()
	
	# And initialize the remapper
	_remapper.initialize([keyboard_context, controller_context], _remapping_config)
	
	_clear(_keyboard_bindings)
	_clear(_controller_bindings)
	
	# fill the keyboard section
	_fill_remappable_items(keyboard_context, _keyboard_bindings)
	
	# fill the controller section
	_fill_remappable_items(controller_context, _controller_bindings)
	
	_controller_invert_horizontal.button_pressed = _remapper.get_custom_data("invert_horizontal", false)
	_controller_invert_vertical.button_pressed = _remapper.get_custom_data("invert_horizontal", false)
	
	
	visible = true
	
	
## Fills remappable items and sub-sections into the given container	
func _fill_remappable_items(context:GUIDEMappingContext, root:Container):
	var items := _remapper.get_remappable_items(context)
	var section_name = ""
	for item in items:
		if item.action.display_category != section_name:
			section_name = item.action.display_category
			var section = binding_section_scene.instantiate()
			root.add_child(section)
			section.text = section_name
			
		var instance = binding_row_scene.instantiate()
		root.add_child(instance)
		
		# Show the current binding.
		instance.initialize(item, _remapper.get_bound_input_or_null(item))
		instance.rebind.connect(_rebind_item)



func _rebind_item(item:GUIDERemapper.ConfigItem):
	_press_prompt.visible = true
	# detect a new input
	_input_detector.detect(item.action.action_value_type)
	var input = await _input_detector.input_dectected

	_press_prompt.visible = false

	_tab_container.get_tab_bar().grab_focus()

	# check if the detection was aborted.
	if input == null:
		return

	# check for collisions 
	var collisions := _remapper.get_input_collisions(item, input)
		
	# if any collision is from a non-bindable action, we cannot use this input
	if collisions.any(func(it:GUIDERemapper.ConfigItem): return not it.action.is_remappable):
		return
		
	# unbind the colliding entries.
	for collision in collisions:
		_remapper.set_bound_input(collision, null)
		
	# now bind the new input
	_remapper.set_bound_input(item, input)
			


func _clear(root:Container):
	for child in root.get_children():
		root.remove_child(child)
		child.queue_free()
		


func _on_controller_invert_horizontal_toggled(toggled_on:bool):
	_remapper.set_custom_data(Utils.CUSTOM_DATA_INVERT_HORIZONTAL, toggled_on)


func _on_controller_invert_vertical_toggled(toggled_on:bool):
	_remapper.set_custom_data(Utils.CUSTOM_DATA_INVERT_VERTICAL, toggled_on)


func _on_ok_pressed():
	# get the modified config
	var final_config := _remapper.get_mapping_config()
	# store it
	Utils.save_remapping_config(final_config)
	# and close the dialog
	visible = false
	closed.emit(final_config)
	# and re-enable the mapping contexts
	for context in _restore_contexts:
		GUIDE.enable_mapping_context(context)

func _on_cancel_pressed():
	# close the dialog and return the unmodified config
	visible = false
	closed.emit(_remapping_config)

	# and re-enable the mapping contexts
	for context in _restore_contexts:
		GUIDE.enable_mapping_context(context)
