@tool
class_name GUIDEUI
extends Node

const IconMaker = preload("icon_maker/icon_maker.gd")

var _icon_maker:IconMaker

func _ready():
	_icon_maker = preload("icon_maker/icon_maker.tscn").instantiate()
	add_child(_icon_maker)
	
	
	
## Formats the given string into a BBCode replacing %s placeholders with icons representing
## the input. Can be used to show input in a UI with a RichTextLabel (e.g. "press 'A' to jump").
## Automatically handles input type and modifiers (e.g. Shift+A, etc.). Since icons are
## built in the background, you need to `await` on this function.
func format_input_with_icons(format:String, input:Array[GUIDEInput], height_px:int = 32) -> String:
	var replacements:Array[String] = []
	for i in input.size():
		var images = await get_input_icons(input[i], height_px)
		var replacement = ""
		for j in images.size():
			replacement += "[img]" + images[j].resource_path + "[/img]"
			if j + 1 < images.size():
				replacement += "+"
		replacements.append(replacement)
		
	return format % replacements
			
	
## Returns a set of icons representing the given input. For most inputs this will
## only be a single icon, but e.g. for combinations like Ctrl+Shift+S this will return
## 3 icons.	Since icons are built in the background, you need to `await` on this function.
func get_input_icons(input:GUIDEInput, height_px:int = 32) -> Array[Texture2D]:	
	var result:Array[Texture2D] = []
			
	# for GUIDEInputKey we have the additional wrinkle that this may actually
	# be more than 1 key  (e.g. Ctrl+Shift+A), so we may need to make more textures.
	if input is GUIDEInputKey:
		if input.control:
			var ctrl = GUIDEInputKey.new()
			ctrl.key = KEY_CTRL
			result.append_array(await get_input_icons(ctrl, height_px))
		if input.alt:
			var alt = GUIDEInputKey.new()
			alt.key = KEY_ALT
			result.append_array(await get_input_icons(alt, height_px))
		if input.shift:
			var shift = GUIDEInputKey.new()
			shift.key = KEY_SHIFT
			result.append_array(await get_input_icons(shift, height_px))
		if input.meta:
			var meta = GUIDEInputKey.new()
			meta.key = KEY_META
			result.append_array(await get_input_icons(meta, height_px))
			
	var new_icon := await _icon_maker.make_icon(input, height_px)
	result.append(new_icon)
	return result
			
			
			
	
			
			
	
		
			

