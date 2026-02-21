extends Node
class_name Game

@onready var textbox: CanvasLayer = $Textbox
@onready var level: Level = $Level

var clients: Array[Client] = []

var score
var player
var client
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

func _process_submission():
	#{
	#	"bed": {"count": 2, "tier": 2, "weight": 3},
	#	"stove": {"count": 1, "tier": 3, "weight": 4},
	#	"kitchen_sink": {"count": 1, "tier": 3, "weight": 4},
	#	"fridge": {"count": 1, "tier": 3, "weight": 4},
	#	"hanging_cabinet": {"count": 2, "tier": 3, "weight": 3},
	#	"cabinet": {"count": 2, "tier": 3, "weight": 4},
	#	"tv_stand": {"count": 1, "tier": 1, "weight": 2},
	#	"tv": {"count": 1, "tier": 1, "weight": 5}
	#}
	score = 0
	## We must eval the requirments vs what the player has submitted.
	## First we must check the ratio of requirements the player submitted
	## 
	var req = client.requirements
	var player_objects = level.get_children()
	player_objects.remove_at(0)
	var player_objects_dict = {}
	for item in player_objects:
		if not player_objects_dict.has(item.item_type):
			player_objects_dict[item.item_type] = {"count": 1, "tiers": [item.item_tier]}
		else:
			player_objects_dict[item.item_type]["count"] += 1
			player_objects_dict[item.item_type]["tiers"].append(item.item_tier)
			
	print(player_objects_dict)
	for item in req:
		## Let's eval
		if item in player_objects_dict:
			## TODO: ADD DIALOGUE TOGGLES
			var item_score = 0
			var player_count = player_objects_dict[item]["count"]
			var client_count = req[item]["count"]
			var count_diff = player_count - client_count
			if count_diff == 0:
				## perfect match
				item_score += client_count
				pass
			if count_diff > 0:
				## too many / spent too much
				#item_score += req[item]["count"]
				pass
			if count_diff < 0:
				## too little / spent too little
				pass
			
			var tiers_count = player_objects_dict[item]["tiers"].count(req[item]["tier"])
			if tiers_count >= client_count:
				## perfect match
				item_score += client_count
			if tiers_count >= client_count/2 and tiers_count < client_count:
				## okay match
				item_score += client_count/2
			if tiers_count < client_count/2:
				## bad match
				pass
		
	pass

func _process(delta: float) -> void:
	if textbox.has_method("queue_text"):
		match client.current_state:
			client.ClientState.INTRO:
				print(client.intro_dialogue)
				for text in client.intro_dialogue:
					textbox.queue_text(text)
				client.change_state(client.ClientState.REQ)
				pass
			client.ClientState.REQ:
				print(client.req_dialogue)
				for text in client.req_dialogue:
					textbox.queue_text(text)
				client.change_state(client.ClientState.WAIT)
			client.ClientState.WAIT:
				## WAIT FOR PLAYER TO SUBMIT AND FOR EVAL CALCS TO HAPPEN
				pass
			client.ClientState.RESPONSE:
				## SHOW RESPONSES BASED ON PLAYERS EVALUTATION
				pass
	pass

func _ready() -> void:
	player = Player.new()
	print("PLAYER: %s" % player)
	print(player.funds)
	EventBus.add_funds.connect(_add_funds)
	EventBus.submission.connect(_process_submission)
	client = Client.new()
	client.dialogue = Definitions.CLIENT_1_DIALOGUE
	client.requirements = Definitions.CLIENT_1_REQUIREMENTS
	client.payment = Definitions.CLIENT_1_PAYMENT
	
	#call_deferred("client.change_state",)
	client.change_state(client.ClientState.INTRO)
	#call_deferred(client.queue_up_dialogue(client.intro_dialogue))
	print("CLIENT: %s" % client)
	print(client.dialogue)
	print(client.requirements)
	print(client.payment)
	
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
	var tier: int
	var mood = ""
	
	var dialogue: set = _on_set_text
	func _on_set_text(dialogue_dict):
		intro_dialogue = dialogue_dict["intro"]
		req_dialogue = dialogue_dict["requirements"]
		#great_responses = dialogue_dict["great_responses"]
		#good_responses = dialogue_dict["good_responses"]
		#mid_responses = dialogue_dict["mid_responses"]
		#bad_responses = dialogue_dict["bad_responses"]
		#terrible_responses = dialogue_dict["terrible_responses"]
		
	var intro_dialogue
	var req_dialogue
	## TODO: RESPONSE DIALOGUE
	var great_responses
	var good_responses
	var mid_responses
	var bad_responses
	var terrible_responses
	
	var requirements
	
	# how much money they payout to the player
	var payment: float
	
	var current_state
	
	enum ClientState {
		INTRO,
		REQ,
		WAIT,
		RESPONSE
	}
	
	func change_state(next_state):
		current_state = next_state
		match current_state:
			ClientState.INTRO:
				print("Changing state to: State.INTRO")
			ClientState.REQ:
				print("Changing state to: State.REQ")
			ClientState.RESPONSE:
				print("Changing state to: State.RESPONSE")
	
	func _ready() -> void:
		#textbox.text_queue.push_back(intro_dialogue)
		super._ready()
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
