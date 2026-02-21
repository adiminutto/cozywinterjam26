extends Node

## MAPPING ##
const CATEGORY_TO_ITEM_MAP = {
	"Sleeping": ["bed", "dresser"],
	"Seating": [],
	"Kitchen": ["stove","kitchen_sink","fridge","hanging_cabinet","cabinet"],
	"Dining": [],
	"Entertainment": ["tv","tv_stand"],
	"Decor": [],
	"Storage": ["dresser","hanging_cabinet","cabinet"],
}
const ITEM_TO_CATEGORY_MAP = {
	"bed": ["Sleeping",],
	"dresser": ["Sleeping","Storage",],
	"stove": ["Kitchen",],
	"kitchen_sink": ["Kitchen",],
	"fridge": ["Kitchen",],
	"hanging_cabinet": ["Kitchen","Storage",],
	"cabinet": ["Kitchen","Storage",],
	"tv": ["Entertainment",],
	"tv_stand": ["Entertainment",],
#	"tv": [],
#	"tv": [],
}

## CLIENT 1 ##
const CLIENT_1_DIALOGUE = {
		"intro": [
			"Howdy, names Rox Waddles! Me and my huddle are looking for something small and cozy to spend the winter!"
		],
		"requirements": [
			"There's four of us! I'd prefer the two young'uns share a bed, y'know save on budget.",
			"My wife's always dreamed of a proper kitchen, it'd be nice to squeeze that into the budget.",
			"I can't miss curling! The New Zealander Crests play every Sunday and I simply CANNOT miss it!"
		],
	}
const CLIENT_1_REQUIREMENTS = {
		"bed": {"count": 2, "weight": 4},
		"stove": {"count": 1, "weight": 4},
		"kitchen_sink": {"count": 1, "weight": 4},
		"fridge": {"count": 1, "weight": 4},
		"hanging_cabinet": {"count": 2, "weight": 2},
		"cabinet": {"count": 2, "weight": 4},
		"tv_stand": {"count": 1, "weight": 2},
		"tv": {"count": 1, "weight": 5}
	}
const CLIENT_1_OMISSIONS = {}
const CLIENT_1_RESPONSES = {
	"Good": {
		"Generic": {
			"Default": "",
		},
		"Sleeping": {
			"Generic": {
				"Default": "",
			},
			"bed": {
				"Default": "Two beds, just like I asked. I appreciate you respectin’ the budget, the kids’ll get used to sharing."
			}
		},
		"Seating": [],
		"Kitchen": {
			"Generic": {
				"Default": "My wife loves the kitchen! Next time she makes some of her famous deep fried haddock I’ll make sure to bring ya some.",
			},
		},
		"Dining": [],
		"Entertainment": {
			"Generic": {
				"Default": "",
			},
			"tv": {
				"Default": "I can’t wait to cheer on the Crests from my new TV. They’re gonna take the gold this year, I’ll tell ya what!",
			}
		},
		"Decor": [],
	},
	"Mid": {
		"Generic": {
			"Default": "",
			"Over": "",
			"Under": "",
		},
		"Sleeping": {
			"bed": {
				"Default": "",
				"Over": "Hmm, that's a little too many beds? I coulda sworn I told ya two, well it’ll do",
				"Under": "Hmm, that's too few beds? I coulda sworn I told ya two, well it’ll do"
			}
		},
		"Seating": {},
		"Kitchen": {
			"Default": "",
			"Generic": "The kitchen’s alright- not quite what we were expecting, but I reckon the wife'll still like it just fine.",
			"hanging_cabinet": "It woulda been nice to have some more storage space in the kitchen."
		},
		"Dining": {},
		"Entertainment": {
			"tv": {
				"Default": "",
				"Over": "Not too keen on the extra cost it added, but having a couple TV’s ain’t too bad. Now the family won’t bother me during my curling time.",
				"Under": ""
			},
			"tv_stand": {
				"Default": "",
				"Over": "",
				"Under": "I kinda wish the TV wasn’t on the floor, but it ain’t the worst."
			}
		},
		"Decor": [],
	},
	"Bad": {
		"Generic": {
			"Default": "",
			"Over": "{X} {Y}?? YOU BLEW THE WHOLE BUDGET ON {Y}S",
			"Under": ""
		},
		"Sleeping": {},
		"Seating": {},
		"Kitchen": {
			"Generic": {
				"Default": "My wife’s plum mad about that so-called “kitchen” you gave us. What a pathetic sight!",
				"Over": "What in sam heck do we need so many {X} for? Ya only need one. What a waste of money.",
				"Under": "How is she supposed to function without a {X}?"
			}
		},
		"Dining": {},
		"Entertainment": {
			"tv": {
				"Default": "",
				"Over": "",
				"Under": "How am I supposed to watch the Crests WITH NO TV?? You better sleep with one eye open, son."
			}
		},
		"Decor": {},
	}
}
const CLIENT_1_PAYMENT = 2000
const CLIENT_1_MAX_SCORE = 29
## CLIENT 2
const CLIENT_2_DIALOGUE = {}
const CLIENT_2_REQUIREMENTS = {}
const CLIENT_2_PAYMENT = {}

const GRADE_DIALOGUE = {
	"A+": "Absolutely astonishing work, we haven't heard a client that pleased in a few winters! You truly are a natural, we are very lucky to have you here at AIM!",
	"A": "Oustanding work! The client was very happy. I hope you can keep this consistent with the other clients!",
	"A-": "Very well done. The client had some minor comments but overall they were pleased. Good luck with the next client!",
	"B+": "Good job! The client ",
	"B": "",
	"B-": "",
	"C+": "",
	"C": "",
	"C-": "",
	"D+": "",
	"D": "",
	"D-": "",
	"F": "Wow, I know you're an intern but seriously? I mean what were you thinking. This is not gonna cut it here at AIM. Make things right or kiss this internship goodbye.",
}

const TEXTBOX_START_SYMBOL = "{^.^}"
const TEXTBOX_END_SYMBOL = "{>.<}"
