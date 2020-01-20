
/datum/npc_speech_trigger
	var/trigger_phrase
	var/response_phrase
	var/trigger_word
	var/response_chance = 100

/datum/npc_speech_trigger/proc/get_response_phrase()
	return response_phrase

/datum/npc_speech_trigger/smuggler_response
	trigger_word  = "guns"
	response_phrase = "Did I hear someone say guns because I got some guns and other gear that fell off the back of a truck you can buy, I also will buy stuff from you if the quality is right!"

/datum/npc_speech_trigger/colonist_unsc
	trigger_word  = "UNSC"
	response_phrase = 1
	var/list/responses

/datum/npc_speech_trigger/colonist_unsc/New()
	. = ..()
	if(prob(50))
		responses = list(\
		"The UNSC are only doing what's best.",\
		"These high taxes make me feel safe becasue I know the UNSC will get stronger!",\
		"Can't wait for the UNSC to kick the URF out of here!",\
		"Don't like the UNSC, fucking leave then buddy!",\
		"UNSC is the UEG's sword and my colony's shield, you better show respect to the UNSC!",\
		"The UNSC will protect us from the URF scum!",\
		"UNSC pride colony wide!",\
		"The UEG only raise the taxes to make the UNSC stronger and better!",\
		"UNSC is true order of things and I love it!",\
		"Our boys in green are doing the right thing, maybe you should stop bad mouthing the UNSC before I kick your ass!",\
		"UNSC marines are the best trained in the colonies.",\
		"My [pick("uncle","aunt","sister","brother")] was a [pick("marine","fighter pilot","crewman in the navy")]. Our entire family supports them.",\
		"The UNSC are what's keeping humanity together out here.",\
		"A strong military is needed to keep the colonies in line.")
	else
		responses = list(\
		"I wish the UNSC would leave us alone.",\
		"The UNSC is nothing but armed thugs for the UEG.",\
		"These taxes are bullshit pushed by the UNSC to get more power!",\
		"I lost my family on Far Isle, I shall NEVER trust the UEG let alone the lapdogs know as the UNSC!",\
		"UNSC need to leave our colony before they burn it to the ground like Far Isle!",\
		"I'm sick of this pointless war, why can't the UNSC leave us be!",\
		"I'm not going to respect some UEG lapdog!",\
		"Nothing good comes from the UNSC being around.",\
		"Oh great more UNSC bootlickers!",\
		"The UNSC doesn't care about us other colonist, they view us as tools for the inner colonies and Earth!",\
		"The UNSC views us outer colonist as target practice and you know it!",\
		"You know the UEG doen't care about us at all.",\
		"We need to be free from these bullies, the URF should really fight these scumbags more!",\
		"I shall never understand the UNSC, nothing but brutes looking for bloodshed!",\
		"Piss off UNSC!",\
		"If I was stronger and had I gun I'd take care of these UNSC punks myself!",\
		"After losing my family to the UNSC, they can all burn for all I care.",\
		"Have the UNSC not gotten tired of being fascist yet, damn it all to hell!",\
		"Taxes are rising and UNSC builds a new warship. Coincidence?",\
		"I'll tell you what I think of the UNSC!",\
		"The UNSC stink.",\
		"We need to demilitarise and unite to colonise space, not build UNSC warships.",\
		"Scumbag UNSC only out for themselves")

/datum/npc_speech_trigger/colonist_unsc/get_response_phrase()
	return pick(responses)

/datum/npc_speech_trigger/colonist_innie
	trigger_word  = "Insurrection"
	response_phrase = 1
	var/list/responses

/datum/npc_speech_trigger/colonist_innie/New()
	. = ..()
	if(prob(50))
		responses = list(\
		"The United Rebel Front are just terrorists.",\
		"The damn innies need to stop this useless bloodshed!",\
		"Why are these scum still allowed to live!",\
		"The UNSC will wipe the URF scum out for sure!",\
		"Hate those damn innies, I lost my brother to them because he was a marine!",\
		"The United Rebel Front is no better than the UEG!",\
		"I'm going to report any innie to the local UNSC forces!",\
		"Damn the URF, they aren't trying to help us at all!",\
		"A good innie is a dead innie in my book.",\
		"UNSC shall save us from the URF scum!",\
		"Insurrection needs to learn their place nothing but killers and junkies!",\
		"Can't wait for the United Rebel Front to fall at the hands of the UNSC!",\
		"The insurrection wants to burn everything we've built here.",\
		"I hope the insurrection doesn't come to Geminus.",\
		"I've lost friends to the insurrection. I just want the fighting to stop.",\
		"Damn innies! We should drive them out of the sector.")
	else
		responses = list(\
		"We should be left to govern ourselves.",\
		"I've had it with the UEG, I can't wait for the URF to rise!",\
		"Never forget Far Isle!",\
		"UEG is the true cancer of the outer system!",\
		"The United Rebel Front are the true heros to us outer colonist!",\
		"I can't wait for the UNSC to fall to the URF!",\
		"At least the innies are about the little guy like me!",\
		"I will fight for my freedom if need be, becasue the UNSC are punks!",\
		"We need to govern ourselves!",\
		"Leave no man behind on our path to freedom!",\
		"Can't wait for the UEG to fall, nothing but cash hungry fools!",\
		"I'm proud to support the United Rebel Front!",\
		"Death to the fucking UEG!",\
		"Death to the fucking UNSC!",\
		"Earth is in the past, and the past is dead.",\
		"It's the United Rebel Front! Not the People's Front of Geminus, those bloody quitters...",\
		"No gods or masters. Only men.",\
		"I've heard the outer colonies are fighting to secede. There's an insurrection brewing.",\
		"I hate the colonial governor. I wish someone would overthrow them.")

/datum/npc_speech_trigger/colonist_innie/get_response_phrase()
	return pick(responses)

/datum/npc_speech_trigger/colonist_covenant
	trigger_word  = "Covenant"
	response_phrase = 1
	var/list/responses

/datum/npc_speech_trigger/colonist_covenant/New()
	. = ..()
	responses = list(\
	"I've heard aliens are real! And they're hunting down humans.",\
	"What are the Covenant? I wish I could find out more.",\
	"The Covenant killed my [pick("mother","brother","sister","father","son","daughter","uncle","aunt")]",\
	"I wish I could kill some Covenant.",\
	"Give them hell! Humanity is with you.",\
	"Why are they killing us?",\
	"Well I would have been your daddy...",\
	"I want to kill me some alien [pick("split jaws","squid heads","little squealers","gay giraffes","bird fuckers","monkey men")]!",\
	"I can't believe they're doing this to us...")

/datum/npc_speech_trigger/colonist_covenant/get_response_phrase()
	return pick(responses)
