
/datum/npc_speech_trigger
	var/trigger_phrase
	var/response_phrase
	var/trigger_word
	var/response_chance = 100

/datum/npc_speech_trigger/proc/get_response_phrase()
	return response_phrase

/datum/npc_speech_trigger/smuggler_response
	trigger_word  = "guns"
	response_phrase = "Anyone want to buy some guns that fell off the back of a truck?"

/datum/npc_speech_trigger/colonist_unsc
	trigger_word  = "UNSC"
	response_phrase = 1
	var/list/responses

/datum/npc_speech_trigger/colonist_unsc/New()
	..()
	if(prob(50))
		responses = list(\
		"The UNSC are only doing what's best.",\
		"UNSC pride colony wide!",\
		"UNSC marines are the best trained in the colonies.",\
		"My [pick("uncle","aunt","sister","brother")] was a [pick("marine","fighter pilot","crewman in the navy")]. Our entire family supports them.",\
		"The UNSC are what's keeping humanity together out here.",\
		"A strong military is needed to keep the colonies in line.")
	else
		responses = list(\
		"I wish the UNSC would leave us alone.",\
		"Taxes are rising and UNSC builds a new warship. Coincidence?",\
		"I'll tell you what I think of the UNSC!",\
		"The UNSC stink.",\
		"We need to demilitarise and unite to colonise space, not build UNSC warships.",\
		"Scumbag UNSC only out for themselves")

/datum/npc_speech_trigger/colonist_unsc/get_response_phrase()
	return pick(responses)

/datum/npc_speech_trigger/colonist_innie
	trigger_word  = "innie"
	response_phrase = 1
	var/list/responses

/datum/npc_speech_trigger/colonist_innie/New()
	..()
	if(prob(50))
		responses = list(\
		"The United Rebel Front are just terrorists.",\
		"The insurrection wants to burn everything we've built here.",\
		"I hope the insurrection doesn't come to Geminus.",\
		"I've lost friends to the insurrection. I just want the fighting to stop.",\
		"Damn innies! We should drive them out of the sector.")
	else
		responses = list(\
		"We should be left to govern ourselves.",\
		"It's the United Rebel Front! Not the People's Front of Geminus, those bloody quitters...",\
		"No gods or masters. Only men.",\
		"I've heard the outer colonies are fighting to secede. There's an insurrection brewing.",\
		"I hate the colonial governor. I wish someone would overthrow them.")

/datum/npc_speech_trigger/colonist_innie/get_response_phrase()
	return pick(responses)
