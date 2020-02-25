/datum/game_mode/revolution
	name = "Mutiny"
	round_description = "Morale is shattered, and a mutiny is brewing! Use the 'Check Round Info' verb for more information!"
	extended_round_description = "Time in space, away from home and loved ones, takes its toll on even the most grizzled space travellers. To make matters worse, the planned return trip to Sol \
								for refitting, repairs and relaxation has been cancelled by the brass; instead, the SEV Torch is to, for the first time, enter a hibernative state. All crew will enter cryogenic stasis, \
								and the shipbound AI system will complete a series of jumps that will take the ship lightyears further away from home. Outrage from friends and family of crew back \
								on Mars, Luna and other various worlds has spawned primetime scandals that dominate the 24/7 news cycle. Videolink interviews with Torch crew reveal morale is at an \
								all time low. Rumors are spreading of an impending mutiny."

/datum/antagonist/revolutionary
	role_text = "Head Mutineer"
	role_text_plural = "Mutineers"

	faction_welcome = "It's time to go home. Obey all instructions from the leaders of the mutiny, and ensure the mutiny succeeds."
	welcome_text = "You've been out here for what feels like an eternity. Time passes awkwardly in space. You were getting ready to head back to Sol - everyone has - but now \
					that's all changed, and tomorrow you're all getting canned up like sardines, and the AI is to pilot you even further away from home. Most everyone knows this isn't right, this wasn't \
					in the deal, that this isn't fair. You and a few others have decided to do something about it, and get everyone back home, by any means neccessary."

	victory_text = "The heads of staff were relieved of their posts. The Torch is finally heading home."
	loss_text = "The heads of staff managed to quash the mutiny. The mission will continue as ordered."

	//Inround revs.
	faction_role_text = "Mutineer"
	faction_descriptor = "Mutiny"

	faction = "mutiny"

	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/submap)
	restricted_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/hos, /datum/job/chief_engineer, /datum/job/rd, /datum/job/cmo)
	protected_jobs = list(/datum/job/officer)

/datum/antagonist/loyalists


	victory_text = "The heads of staff remained at their posts; the mission will continue as ordered."
	loss_text = "The heads of staff could not contain the mutiny, and the Torch is now heading home."

/datum/antagonist/loyalists/Initialize()
	..()
	welcome_text = "The SEV Torch, the most ambitious and prestigious human research project ever established, is now under threat from her very crew as a result of the Expeditionary Corps' brass decision \
					to enter 'hibernation mode' (with crew in cryosleep, and the AI piloting the ship) instead of making the scheduled return to Sol. Crew morale is dangerously low. What the Torch needs now \
					is a steady hand to guide her through what will likely be the greatest trial she will face."
	faction_welcome = "Obey all instructions, follow the chain of command, and ensure the mission continues as ordered."
	faction_descriptor = "[GLOB.using_map.company_name]"