extends Node

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
		"bed": {"count": 2, "tier": 2, "weight": 3},
		"stove": {"count": 1, "tier": 3, "weight": 4},
		"kitchen_sink": {"count": 1, "tier": 3, "weight": 4},
		"fridge": {"count": 1, "tier": 3, "weight": 4},
		"hanging_cabinet": {"count": 2, "tier": 3, "weight": 3},
		"cabinet": {"count": 2, "tier": 3, "weight": 4},
		"tv_stand": {"count": 1, "tier": 1, "weight": 2},
		"tv": {"count": 1, "tier": 1, "weight": 5}
	}
const CLIENT_1_PAYMENT = 2000

const TEXTBOX_START_SYMBOL = "{^.^}"
const TEXTBOX_END_SYMBOL = "{>.<}"
