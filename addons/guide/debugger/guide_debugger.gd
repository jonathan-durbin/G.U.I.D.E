class_name GUIDEDebugger
extends MarginContainer

@onready var _v_flow_container:Container = %VFlowContainer
var _labels:Dictionary = {}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_labels:Dictionary = {}
	
	for mapping in GUIDE._active_action_mappings:
		var action = mapping.action
		if not _labels.has(action):
			var new_label:Label = Label.new()
			new_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_v_flow_container.add_child(new_label)
			new_labels[action] = new_label
		else:
			new_labels[action] = _labels[action]
			
		var label:Label = new_labels[action]	
		var action_name = action.name
		if action_name == "":
			action_name = action.resource_path.get_file()
			
		var action_state:String = ""
		match(action._last_state):
			GUIDEAction.GUIDEActionState.COMPLETED:
				action_state = "Completed"
			GUIDEAction.GUIDEActionState.ONGOING:
				action_state = "Ongoing"
			GUIDEAction.GUIDEActionState.TRIGGERED:
				action_state = "Triggered"
				
		var action_value:String = ""
		match(action.action_value_type):
			GUIDEAction.GUIDEActionValueType.BOOL:
				action_value = str(action.get_value_bool())
			GUIDEAction.GUIDEActionValueType.AXIS_1D:
				action_value = str(action.get_value_axis_1d())
			GUIDEAction.GUIDEActionValueType.AXIS_2D:
				action_value = str(action.get_value_axis_2d())
			GUIDEAction.GUIDEActionValueType.AXIS_3D:
				action_value = str(action.get_value_axis_3d())
				
		label.text = "[%s] %s - %s" % [action_name, action_state, action_value]
		
	for old_action in _labels.keys():
		if new_labels.has(old_action):
			continue
		
		var old_label:Control = _labels[old_action]
		_v_flow_container.remove_child(old_label)
		old_label.queue_free()
		
	
	_labels = new_labels
