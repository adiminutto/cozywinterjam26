extends Node2D
class_name EditorObject

@onready var level: Level = $"../Level"

@onready var cursor_sprite = $Sprite2D
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

@onready var level_tile_map = $"../Level/TileMapLayer"


const TILE_SIZE = 32
## TOOLS
var place_toggle = false
var move_toggle = false
var erase_toggle = false

## HOVERING
var hover_item
var moving_item

## PLACING
var can_place
var current_item
var success

## MOVING
var dragging
var initial_pos

func _on_item_hover(item):
	hover_item = item
	pass

func _transaction_success(success):
	self.success = success
	_set_success()

func _set_success():
	return success

func _ready() -> void:
	EventBus.hover_item.connect(_on_item_hover)
	EventBus.transaction_success.connect(_transaction_success)
	
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	# We can use level script to communicate between the tilemap and the object positions
	print(level.world_to_cell(global_position))
	#print(level_tile_map.get_cell_tile_data(level.world_to_cell(global_position)))
	
	## PLACE LOGIC ##
	if place_toggle:
		if ( current_item != null and can_place and Input.is_action_just_pressed("left_click")):
			var new_item = current_item.instantiate()
			var tile_data = level_tile_map.get_cell_tile_data(level.world_to_cell(global_position))
			var valid_tiles = new_item.valid_tiles
			var valid_placement = false
			for tile_flag in valid_tiles:
				if tile_data and tile_data.get_custom_data(tile_flag):
					valid_placement = true
					
			if valid_placement:
				## VERIFY PLAYER HAS FUNDS ##
				print(new_item.price)
				EventBus.add_funds.emit(-new_item.price)
				await _set_success()
				print("SUCCESS %s" % success)
				if success:
					print(new_item)
					level.add_child(new_item)
					new_item.global_position.x = ((round(global_position.x / TILE_SIZE)) * TILE_SIZE)
					new_item.global_position.y = ((round(global_position.y / TILE_SIZE)) * TILE_SIZE)
					#new_item.global_position = get_global_mouse_position()
					## TODO: PLACE / DROP SOUND EFFECT
				else:
					print("NOT ENOUGH FUNDS")
					cursor_sprite.texture = null
					current_item = null
					## TODO: ERROR SOUND EFFECT
				success = null
	
	## MOVE LOGIC ##
	if move_toggle:
		if dragging:
			# IF SOMEONE SAME NODE ENDS UP HERE REMOVE IT PLS
			if hover_item:
				if hover_item == moving_item:
					hover_item = null
			
			global_position = get_global_mouse_position()
			moving_item.global_position.x = ((round(global_position.x / TILE_SIZE)) * TILE_SIZE)
			moving_item.global_position.y = ((round(global_position.y / TILE_SIZE)) * TILE_SIZE)
			## TODO: ADD DRAG SOUND EFFECT
		if (dragging and Input.is_action_just_released("left_click")):
			if hover_item:
				# Basically we tried to place on top of another object so
				# lets reset to previous valid pos
				moving_item.global_position = initial_pos
			else:
				moving_item.global_position.x = ((round(global_position.x / TILE_SIZE)) * TILE_SIZE)
				moving_item.global_position.y = ((round(global_position.y / TILE_SIZE)) * TILE_SIZE)
			dragging = false
			# Make object selectable again
			moving_item.get_child(0).input_pickable = true
			## TODO: ADD DROP SOUND EFFECT
		if (hover_item and Input.is_action_just_pressed("left_click")):
			# Pickup item
			# then enable drag functionality
			dragging = true
			moving_item = hover_item
			moving_item.get_child(0).input_pickable = false
			initial_pos = hover_item.global_position
			hover_item = null
			## TODO: ADD PICK UP SOUND EFFECT
			
			pass
		pass
	
	## ERASE LOGIC ##
	if erase_toggle:
		if (hover_item and Input.is_action_just_pressed("left_click")):
			# we are trying to erase something
			var item_price = hover_item.price
			EventBus.add_funds.emit(item_price)
			hover_item.queue_free()
			## TODO: ADD ERASE SOUND EFFECT
			pass
		pass
	
	if (current_item != null and Input.is_action_just_pressed("pause")):
		cursor_sprite.texture = null
		current_item = null
		## TODO: UNSELECT SOUND EFFECT
