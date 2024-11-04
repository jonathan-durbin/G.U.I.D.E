## Removes and frees all children of a node.
static func clear(node:Node):
	if not is_instance_valid(node):
		return
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
