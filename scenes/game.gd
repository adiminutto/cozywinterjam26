extends Node
class_name Game

var clients: Array[Client] = []

var player
###
# TODO: Script the tile map layer
###

func _add_funds(amt) -> void:
	print(amt)
	print(player.funds)
	var temp_funds = player.funds
	temp_funds += amt
	if temp_funds < 0:
		EventBus.transaction_success.emit(false)
	else:
		player.funds += amt
		EventBus.transaction_success.emit(true)

func _ready() -> void:
	player = Player.new()
	print("PLAYER: %s" % player)
	print(player.funds)
	EventBus.add_funds.connect(_add_funds)

class Decoration:
	extends Game
	
	var item_name: String = ""
	var cost: float = 0
	var tier: int = 0 # what tier does it become available
	
	# What vibes does the furniture give?
	var moods: Array[String] = []
	# From a range of 1 - 5 how fancy is the furniture?
	var fancy: int = 1
	
	func _ready() -> void:
		pass
	
class Client:
	extends Game
	
	# Clients are tiered 1 - 5
	var tier = 0
	var mood = ""
	var dialogue = {
		"intro": {
			
		},
		"requirements": {
			
		},
	}
	
	var requirements = {
		
	}
	
	# how much money they payout to the player
	var payment: float = 2000
	
	func _ready() -> void:
		pass
	
	pass

class Player:
	extends Game
	
	# what tier is the player at, this dictates the decorations avail and the client
	var tier: int = 1 
	
	var funds: float = 1000
	
	# Dict[String, Array[Decoration]]
	var decorations: Dictionary = {}

	
	func _ready() -> void:
		# load decorations
		pass
