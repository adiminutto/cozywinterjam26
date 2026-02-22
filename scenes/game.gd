extends Node
class_name Game

@onready var textbox: CanvasLayer = $Textbox
@onready var level: Level = $Level
@onready var funds_label: Label = $CanvasLayer/Funds/Panel/FundsLabel

@onready var decoration_shop: Control = $CanvasLayer/DecorationShop
@onready var tools: Tools = $CanvasLayer/Tools
@onready var funds_ui: Control = $CanvasLayer/Funds
@onready var submit_ui: MarginContainer = $CanvasLayer/SubmitUi
@onready var open_journal_ui: MarginContainer = $CanvasLayer/OpenJournalUi
const ROX_WADDLES_PORTRAIT = preload("uid://rtiqyfjl86kk")
const ASSISTANT_PORTRAIT = preload("uid://ciqiw1l7sd7pd")
const BOSS_PORTRAIT = preload("uid://cduw21ulvmwhq")
@onready var portrait: TextureRect = $CanvasLayer/PortraitUi/Panel/Portrait
@onready var portrait_ui: MarginContainer = $CanvasLayer/PortraitUi
@onready var restart_ui: MarginContainer = $CanvasLayer/RestartUi
@onready var next_client_button: Button = $CanvasLayer/RestartUi/MarginContainer/HBoxContainer/NextClientButton
@onready var restart_button: Button = $CanvasLayer/RestartUi/MarginContainer/HBoxContainer/RestartButton

var clients: Array[Client] = []

var score
var player
var client

var tween: Tween

var fake_funds: int: set = _on_fake_funds_set

func _on_fake_funds_set(funds):
	fake_funds = funds
	funds_label.text = "$"+str(int(fake_funds))
###
# TODO: Script the tile map layer
###

func _add_funds(amt) -> void:
	print(amt)
	print(player.funds)
	var temp_funds = player.funds
	temp_funds += amt
	if tween:
		tween.kill()
	if temp_funds < 0:
		EventBus.transaction_success.emit(false)
	else:
		temp_funds = player.funds
		print(temp_funds)
		player.funds += amt
		## TODO: ADD MONEY SOUND EFFECT
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "fake_funds", player.funds, 1.0)
		EventBus.transaction_success.emit(true)

func _process_submission():
	#{
	#	"bed": {"count": 2, "weight": 3},
	#	"stove": {"count": 1, "weight": 4},
	#	"kitchen_sink": {"count": 1, "weight": 4},
	#	"fridge": {"count": 1, "weight": 4},
	#	"hanging_cabinet": {"count": 2, "weight": 3},
	#	"cabinet": {"count": 2, "weight": 4},
	#	"tv_stand": {"count": 1, "weight": 2},
	#	"tv": {"count": 1, "weight": 5}
	#	"storage": {"count
	#}
	## TODO: ADD SUPPORT FOR STORAGE COUNTS
	var client_under_tolerance_map = {
		1: 0,
		2: 1,
		3: 1,
		4: 1,
		5: 2,
		6: 2,
		7: 2,
		8: 3,
		9: 3,
		10: 3,
	}
	
	score = 0
	## We must eval the requirments vs what the player has submitted.
	## First we must check the ratio of requirements the player submitted
	## 
	var missed_items = []
	var item_over_tolerance = 2
	var client_responses = {
		"Good": [],
		"Mid": [],
		"Bad": []
	}
	
	var req = client.requirements
	var player_objects = level.get_children()
	print(player_objects)
	player_objects.remove_at(0)
	player_objects.remove_at(0)
	player_objects.remove_at(0)
	player_objects.remove_at(0)
	player_objects.remove_at(0)
	print(player_objects)
	var player_objects_dict = {}
	for item in player_objects:
		if not player_objects_dict.has(item.item_type):
			player_objects_dict[item.item_type] = {"count": 1}
		else:
			player_objects_dict[item.item_type]["count"] += 1
			
	print(player_objects_dict)
	for item in req:
		# Eval one requirement item at a time
		var item_score = 0
		var item_categories = Definitions.ITEM_TO_CATEGORY_MAP[item]
		if item in player_objects_dict:
			var player_count = player_objects_dict[item]["count"]
			var client_count = req[item]["count"]
			var client_score = req[item]["weight"]
			var item_under_tolerance = client_under_tolerance_map[client_count]
			
			var count_diff = player_count - client_count
			if count_diff == 0:
				## perfect match
				item_score += client_score
				## GOOD
				if item_categories:
					client_responses = response_dialogue_matcher(client_responses,item_categories[0],item,"Good","Default")
				pass
			elif count_diff > 0:
				## OVER
				## There should be wiggle room here,
				if count_diff <= item_over_tolerance:
					## MID OVER
					item_score += (client_score - count_diff)
					
					if item_categories:
						client_responses = response_dialogue_matcher(client_responses,item_categories[0],item,"Mid","Over")
				else:
					## BAD OVER
					## Too much budget spent here,  
					item_score += 1
					
					if item_categories:
						client_responses = response_dialogue_matcher(client_responses,item_categories[0],item,"Bad","Over")
				pass
			elif count_diff < 0:
				## too little / spent too little
				## UNDER
				if abs(count_diff) <= item_under_tolerance:
					## MID
					## Reward a few points
					item_score += client_score / 2
					
					if item_categories:
						client_responses = response_dialogue_matcher(client_responses,item_categories[0],item,"Mid","Under")
				else:
					## BAD
					if item_categories:
						client_responses = response_dialogue_matcher(client_responses,item_categories[0],item,"Bad","Under")
					pass
		else:
			## PLAYER MISSED THIS ITEM ##
			missed_items.append(item)
			## BAD
			if item_categories:
				client_responses = response_dialogue_matcher(client_responses,item_categories[0],item,"Bad","Under")
			pass
		
		score += item_score
		
	## TODO: OMISSIONS HANDLING
	# including one quantity of omission is MID
	# including more than one is BAD
	print("CLIENT RESPONSES")
	print(client_responses)
	print("PLAYER SCORE")
	print(score)
	client.responses_queue = client_responses
	client.change_state(client.ClientState.RESPONSE)
	pass

func response_dialogue_matcher(responses,category,item,res_quality,res_type):
	if category:
		if Definitions.CLIENT_1_RESPONSES[res_quality][category].get(item):
			responses[res_quality].push_back(Definitions.CLIENT_1_RESPONSES[res_quality][category][item][res_type])
		elif Definitions.CLIENT_1_RESPONSES[res_quality][category].get(res_type):
			responses[res_quality].push_back(Definitions.CLIENT_1_RESPONSES[res_quality][category][res_type])
		else:
			if Definitions.CLIENT_1_RESPONSES[res_quality][category].get("Generic"):
				if Definitions.CLIENT_1_RESPONSES[res_quality][category]["Generic"].get(res_type):
					#responses[res_quality].push_back(Definitions.CLIENT_1_RESPONSES[res_quality][category]["Generic"][res_type])
					pass
			print("MISSING %s %s DIALOGUE FOR %s AND %s" % [res_quality, res_type, category, item])
	return responses

func score_grading():
	var percent_score = round((score / Definitions.CLIENT_1_MAX_SCORE) * 100)
	var grade
	if percent_score == 100:
		grade = "A+"
	elif percent_score >= 93 and percent_score <= 99:
		grade = "A"
	elif percent_score >= 85 and percent_score <= 92:
		grade = "A-"
	elif percent_score >= 60 and percent_score <= 84:
		grade = "B+"
	elif percent_score >= 75 and percent_score <= 79:
		grade = "B"
	elif percent_score >= 70 and percent_score <= 74:
		grade = "B-"
	elif percent_score >= 67 and percent_score <= 69:
		grade = "C+"
	elif percent_score >= 63 and percent_score <= 66:
		grade = "C"
	elif percent_score >= 60 and percent_score <= 62:
		grade = "C-"
	elif percent_score >= 57 and percent_score <= 59:
		grade = "D+"
	elif percent_score >= 53 and percent_score <= 56:
		grade = "D"
	elif percent_score >= 50 and percent_score <= 52:
		grade = "D-"
	elif percent_score < 50:
		grade = "F"
	return grade

func hide_level_Ui():
	submit_ui.hide()
	decoration_shop.hide()
	tools.hide()
	funds_ui.hide()
	open_journal_ui.hide()
	portrait_ui.hide()
	restart_ui.hide()
	
func _process(delta: float) -> void:
	if textbox.has_method("queue_text"):
		match client.current_state:
			client.ClientState.INTRO:
				print(client.intro_dialogue)
				portrait_ui.show()
				for text in client.intro_dialogue:
					textbox.queue_dialogue(text, ROX_WADDLES_PORTRAIT)
				client.change_state(client.ClientState.REQ)
				pass
			client.ClientState.REQ:
				print(client.req_dialogue)
				for text in client.req_dialogue:
					textbox.queue_dialogue(text, ROX_WADDLES_PORTRAIT)
				client.change_state(client.ClientState.WAIT)
			client.ClientState.WAIT:
				## WAIT FOR PLAYER TO SUBMIT AND FOR EVAL CALCS TO HAPPEN
				pass
			client.ClientState.RESPONSE:
				## SHOW RESPONSES BASED ON PLAYERS EVALUTATION
				player.grade = score_grading()
				hide_level_Ui()
				#portrait.texture = 
				portrait_ui.show()
				textbox.queue_dialogue(Definitions.SUBMISSION_DIALOGUE[1], ASSISTANT_PORTRAIT)
				textbox.queue_dialogue(Definitions.SUBMISSION_DIALOGUE[2] % client.client_name, ASSISTANT_PORTRAIT)
				textbox.queue_dialogue(Definitions.SUBMISSION_DIALOGUE[3], ASSISTANT_PORTRAIT)
				## TODO: Display user score
				## TODO: Add player restart option and player advance option
				
				print(client.responses_queue)
				for category in client.responses_queue:
					for response in client.responses_queue[category]:
						textbox.queue_dialogue(response, ROX_WADDLES_PORTRAIT)
				#await textbox.tween.finished
				#portrait.texture = 
				textbox.queue_dialogue(Definitions.SUBMISSION_DIALOGUE[4], ASSISTANT_PORTRAIT)
				textbox.queue_dialogue(Definitions.SUBMISSION_DIALOGUE[5], ASSISTANT_PORTRAIT)
				
				#await textbox.tween.finished
				#portrait.texture = 
				textbox.queue_dialogue(Definitions.GRADE_DIALOGUE[player.grade], BOSS_PORTRAIT)
				
				#portrait.texture = ASSISTANT_PORTRAIT
				textbox.queue_dialogue(Definitions.SCORE_DIALOGUE[1], ASSISTANT_PORTRAIT)
				textbox.queue_dialogue(Definitions.SCORE_DIALOGUE[2] % [score, Definitions.CLIENT_1_MAX_SCORE], ASSISTANT_PORTRAIT)
				textbox.queue_dialogue(Definitions.SCORE_DIALOGUE[3] % player.grade, ASSISTANT_PORTRAIT)
				textbox.queue_dialogue(Definitions.SCORE_DIALOGUE[4] % [client.payment * round((score / Definitions.CLIENT_1_MAX_SCORE) * 100), client.payment], ASSISTANT_PORTRAIT)
				textbox.queue_dialogue(Definitions.SCORE_DIALOGUE[5], ASSISTANT_PORTRAIT)
				
				client.change_state(client.ClientState.END)
			client.ClientState.END:
				if len(textbox.text_queue) == 0: 
					restart_ui.show()
					if next_client_button.is_pressed():
						restart_ui.hide()
						if client.client_name == "Rox Waddles":
							_setup_client("Robin Yoo")
						elif client.client_name == "Robin Yoo":
							_setup_client("Bubba and Bessie Tusk")
						else:
							restart_ui.hide()
							textbox.queue_dialogue(Definitions.END_GAME[1], ASSISTANT_PORTRAIT)
							textbox.queue_dialogue(Definitions.END_GAME[2])
					if restart_button.is_pressed():
						pass
				pass
	pass

func _ready() -> void:
	restart_ui.hide()
	player = Player.new()
	fake_funds = player.funds
	print("PLAYER: %s" % player)
	print(player.funds)
	EventBus.add_funds.connect(_add_funds)
	EventBus.submission.connect(_process_submission)
	#call_deferred("client.change_state",)
	_setup_client("Rox Waddles")
	#call_deferred(client.queue_up_dialogue(client.intro_dialogue))
	print("CLIENT: %s" % client)
	print(client.dialogue)
	print(client.requirements)
	print(client.payment)

func _setup_client(client_name):
	client = Client.new()
	client.client_name = "Rox Waddles"
	client.dialogue = Definitions.CLIENT_1_DIALOGUE
	client.requirements = Definitions.CLIENT_1_REQUIREMENTS
	client.payment = Definitions.CLIENT_1_PAYMENT
	client.change_state(client.ClientState.INTRO)
	
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
	var client_name
	var dialogue: set = _on_set_text
	func _on_set_text(dialogue_dict):
		intro_dialogue = dialogue_dict["intro"]
		req_dialogue = dialogue_dict["requirements"]
		
	var intro_dialogue
	
	var req_dialogue
	
	var requirements
	
	# how much money they payout to the player
	var payment: float
	
	var current_state
	
	var responses_queue
	
	enum ClientState {
		INTRO,
		REQ,
		WAIT,
		RESPONSE,
		END
	}
	
	func change_state(next_state):
		current_state = next_state
		match current_state:
			ClientState.INTRO:
				print("Changing state to: State.INTRO")
			ClientState.REQ:
				print("Changing state to: State.REQ")
			ClientState.WAIT:
				print("Changing state to: State.WAIT")
			ClientState.RESPONSE:
				print("Changing state to: State.RESPONSE")
			ClientState.END:
				print("Changing state to: State.END")
			
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
	var grade
	# Dict[String, Array[Decoration]]
	var decorations: Dictionary = {}

	
	func _ready() -> void:
		# load decorations
		pass
