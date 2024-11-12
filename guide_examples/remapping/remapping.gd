extends Node

@export var game_controls:GUIDEMappingContext
@export var open_menu_action:GUIDEAction

@onready var _remapping_dialog:Control = %RemappingDialog

func _ready():
	# We start in game mode, so enable the game controls
	GUIDE.enable_mapping_context(game_controls)
	# And react when the open menu action is triggered.
	open_menu_action.triggered.connect(_open_menu)
	
	
func _open_menu() -> void:
	# disable the game controls, so player can no longer
	# move while the menu is open
	GUIDE.disable_mapping_context(game_controls)
	# and show the remapping dialog
	_remapping_dialog.open()
	


	

