extends Node

@export var game_controls:GUIDEMappingContext
@export var open_menu_action:GUIDEAction

@onready var menu:Control = %Menu
@onready var input_detector:GUIDEInputDetector = %GUIDEInputDetector

func _ready():
	# We start in game mode, so enable the game controls
	GUIDE.enable_mapping_context(game_controls)
	open_menu_action.triggered.connect(_open_menu)
	input_detector.input_dectected.connect(_on_input_detected)
	
	var narf = GUIDEInputKey.new()
	narf.key = KEY_K
	narf.shift = true
	narf.control = true
	narf.alt = true
	
	$RichTextLabel.parse_bbcode(await GUIDE.UI.format_input_with_icons("Press %s to jump!", [narf], 64))
	

	
	
func _open_menu() -> void:
	# disable the game controls, so player can no longer
	# move while the menu is open
	GUIDE.disable_mapping_context(game_controls)
	
	menu.visible = true


func _on_input_detected(input:GUIDEInput) -> void:
	print(input)
	

func _on_button_pressed():
	input_detector.detect_axis_1d()
