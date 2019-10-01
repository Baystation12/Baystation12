
/datum/faction/proc/hail_open(var/faction_name)
	var/faction_greeting = pick(\
		"This is [leader_name]. ",\
		"This is the [name]. ",\
		"This is [leader_name] [pick("of","from")] the [name]. "\
		)
	var/rep = get_faction_reputation(faction_name)
	if(rep < 10)
		faction_greeting += pick(\
			"What is it?",\
			"I'm busy.",\
			"Is it urgent?",\
			"Who is this?"\
			)
	else if(rep < 100)
		faction_greeting += pick(\
			"How can I help?",\
			"What do you need?",\
			"I'm busy but go ahead.",\
			"I remember you.",\
			"What can I do for you?"\
			)
	else
		faction_greeting += pick(\
			"Great to hear from you!",\
			"Good to hear from you!",\
			"It's been too long.",\
			"Is there anything I can do for you?",\
			"How are you going?"\
			)
	return faction_greeting

/datum/faction/proc/hail_angry()
	return pick(\
		"Get lost[pick("", " loser"," drekhead"," scum"," idiot")]!",\
		"No way I'm talking to you!",\
		"I don't want to speak to you right now.")

/datum/faction/proc/hail_disappointed()
	return pick(\
		"What a shame.",\
		"Could have used your help with that one.",\
		"[pick("I","We","[name]")] needed your help with that.",\
		"[pick("I","We","[name]")] couldn't have completed that without you.",\
		"[pick("I'm","We're","[name] are")] disappointed in you.",\
		"[pick("I'm","We're","[name] are")] not angry, just disappointed.")

/datum/faction/proc/hail_end()
	return pick(\
		"See you.",\
		"See you later.",\
		"Have a good one.",\
		"Take it easy.",\
		"Later.",\
		"Bye.",\
		"Goodbye.",\
		"Bye for now.")

/datum/faction/proc/hail_quest_new()
	return pick(\
		"I need your help with something.",\
		"We need your help with something.",\
		"[name] needs your help with something.",\
		"I've got a job for you.",\
		"We've got a job for you.",\
		"[name] has got a job for you.")

/datum/faction/proc/hail_quest_accept()
	return pick(\
		"[pick("I","We","[name]")] need your help with this one.",\
		"[pick("I'm","We're","[name] are")] looking for results with this one.",\
		"[pick("I","We","[name] ")] expect you to deliver.",\
		"[pick("I'm","We're","[name] are")] glad to be working with you.")

/datum/faction/proc/hail_quest_complete()
	return pick(\
		"Glad to do business with you.",\
		"It sounded rough out there. I'm glad you came through.",\
		"Good job. Hope this makes up for it.",\
		"[pick("I'm","We're","[name] are")] won't forget this.",\
		"[pick("I","We","[name]")] couldn't have done it without you.",\
		"You have [pick("my","our","[name]\'s")]thanks.")

/datum/faction/proc/hail_idle()
	return pick(\
		"[pick("Pirate","UNSC","Criminal")] scum will be defeated.",\
		"[pick("Pirate","UNSC","Criminal")] activity has been worsening lately.",\
		"[pick("Pirates","the UNSC","Criminals")] have been hitting our shipping and it's starting to hurt.",\
		"What [pick("pirates","the UNSC","criminals")] did to me makes this personal.",\
		"We'll overthrow the UEG one day.",\
		"I wish I could take time off to go on vacation.",\
		"We've got a revolution to win here. What's taking so long?",\
		"UEG increased our taxes last month. Bastards.",\
		"One of our bases got raided by [pick("pirates","the UNSC","criminals")] \
			[pick("last month","last week","yesterday","the other month","the other week","the other day")]. \
			[pick("Luckily we didn't lose much","We lost good men in that attack","We lost some weapons and armour, but were otherwise ok","We lost everything")].",\
		"Did you hear about the invading aliens? Apparently they're hunting humans.",\
		"We fought [pick("pirates","the UNSC","criminals")] \
			[pick("last month","last week","yesterday","the other month","the other week","the other day")], \
			it was a [pick("slaughter","huge victory","terrible defeat")].")
