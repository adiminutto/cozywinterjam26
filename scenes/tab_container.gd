extends TabContainer

@onready var object_cursor = $"../../../EditorObject"

func _on_mouse_entered() -> void:
	print("ENTER")
	object_cursor.can_place = false
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	print("EXIT")
	object_cursor.can_place = true
	pass # Replace with function body.
