/datum/game_mode/revolution
	name = "Mutiny"
	round_description = "Morale is shattered, and a mutiny is brewing! Use the 'Check Round Info' verb for more information!"
	extended_round_description = "Time in space, away from home and loved ones, takes its toll on even the most grizzled space travelers. As time goes on, some crew find themselves \
								stretched to their breaking points; friendly faces become harsh and hostile, and the most sensible of minds become filled with bitterness and petty ideas. \
								As their peers find themselves surrounded by ever-angrier forces, the situation on the Torch is rapidly reaching its brutal climax."
	config_tag = "mutiny"
	required_enemies = 4
	required_players = 10

/datum/antagonist/revolutionary
	role_text = "Head Mutineer"
	role_text_plural = "Mutineers"

	faction_welcome = "That's it; you're done taking this crap. Obey all instructions from the leaders of the mutiny, and ensure the mutiny succeeds."
	welcome_text = "You've been out here for what feels like an eternity. The time spent in space has worn away at your conscience, and \
					you won't let yourself be canned up like a sardine for even one more jump. Take control of your situation and use the Torch for your own ends, or \
					even just to return home."

	victory_text = "The Torch has fallen to the mutiny, and its future is now in question."
	loss_text = "The attempted mutiny has failed, but the crew questions what happens now."

	//Inround revs.
	faction_role_text = "Mutineer"
	faction_descriptor = "Mutiny"

	faction = "mutiny"


/datum/antagonist/loyalists


	victory_text = "The Torch is free of the mutineers, although the cost has yet to be discovered in full."
	loss_text = "The mutineers have won; the Torch will never be the same."


/datum/antagonist/loyalists/Initialize()
	..()
	welcome_text = "The SEV Torch has been on this mission for some time, and there is still much to accomplish. \
					However, whispers abound about malcontents, saboteurs and mutineers - the very ship faces threats from within!\
					To protect your way of life, those who would change it must be pacified or eliminated, and those that remain \
					must know not to intrude on your status."
	faction_welcome = "Defend your own authority and that of your leaders; eliminate any threats."
	faction_descriptor = "[GLOB.using_map.company_name]"
