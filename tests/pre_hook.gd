extends GutHookScript

# Installs the debugger before we run our tests. Can help in certain
# situations to debug issues.
func run():
	var debugger_root = CanvasLayer.new()
	var debugger = load("res://addons/guide/debugger/guide_debugger.tscn").instantiate()
	debugger_root.add_child(debugger)
	Engine.get_main_loop().root.add_child(debugger_root)
	GUIDEInputFormatter._ensure_readiness()
	# this is a hack to exclude the input formatter from the orphan count
	gut._orphan_counter.add_counter("pre_run")
	
