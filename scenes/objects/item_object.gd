extends Node2D
class_name ItemObject

@export var item_type: String
@export var item_tier: int
@export var price: float
@export var valid_tiles: Array[String]
## ["is_floor","is_wall"]
@export var place_on_objects: bool # Can this item be placed on objects
@export var valid_objects: Array[String] # Valid item types that it can be placed on

func _on_entity_mouse_entered() -> void:
	print("IN")
	EventBus.emit_signal("hover_item",self)
	#editor_object.hover_item = self
	pass # Replace with function body.

func _on_entity_mouse_exited() -> void:
	print("OUT")
	#editor_object.hover_item = null
	EventBus.emit_signal("hover_item",null)
	pass # Replace with function body.
