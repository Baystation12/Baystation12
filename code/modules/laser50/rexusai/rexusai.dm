//This is rexus, rexus is the new Security dog, it comes 'equipped' with its own little contextual 'AI'.

#define MOOD_NEUTRAL 0
#define MOOD_ALERT 1
#define MOOD_AGGRESSIVE 2
#define MOOD_SCARED 4

/mob/living/special_mobs/rexus
	name = "Rexus"
	desc = "Rexus is the security's most-awarded police dog! Batteries not included."
	var/mood = MOOD_NEUTRAL
	var/list/familiarpeople = list()
	var/list/people = list()
	var/gunshots = 0
	var/list/callingnames = list(
		"Rex",
		"Rexus",
		"Rexy",
		"Doggo"
		)
	var/list/attack_commands = list(
		"Attack",
		"Take down",
		"Disarm"
		)
	var/list/defend_commands = list(
		"Guard",
		"Defend",
		"Secure"
		)
	var/list/stop_commands = list(
		"Stop",
		"Cease",
		"Hold",
		"Enough"
		)
	var/list/fetch_commands = list(
		"Get",
		"Fetch"
		)
	var/list/all_commands = list(
		fetch_commands,
		)
/mob/living/special_mobs/rexus/Process()


/mob/living/special_mobs/rexus/hear_talk(mob/living/M as mob, text)
	var/true_text = lowertext(html_decode(text))
	var/found
	for(var/called in callingnames)
		if(findtext(true_text, called))
			found = called
	if(found) //We've been summoned!
		var/commanded
		for(var/command in RecursiveListLoop(all_commands)
			if(findtext(true_text, command))
				commanded = command
		switch(commanded)
			if(commanded in attack_commands)
			if(commanded in defend_commands)
			if(commanded in stop_commands)

			var/true_text = lowertext(html_decode(text))
			for(var/menu_item in menu)
				if(findtext(true_text, menu_item))
					queue_dish(menu_item)
			if(findtext(true_text, "status"))
				state_status()
			else if(findtext(true_text, "menu"))
				state_menu()

//Extra: Blood, bleeding, fighting
/mob/living/special_mobs/rexus/proc/AssessSituation()
	/*--------Threat assesment--------*/
	for(var/mob/living/carbon/human/M in view(6))
		if(M.stat != DEAD)
			var/score = 0
			if(!M in familiarpeople)
				score += rand(5, 10) //Unfamiliar people are scary for the doggo, some more than others
				if(!M.client) //Clientless are't as dangerous, to make sure logged off people don't get bitten to death
					score -= rand(5, 10)
				for(var/obj/item/weapon/W in get_both_hands(M))
					if(istype(W, /obj/item/weapon/gun)) //Found a gun!
						score += rand(15, 30)
					else if(istype(W, /obj/item/weapon/melee) //Or a weapon!
						score += rand(10, 20)
				if(M.aiming && !M in familiarpeople) //Fuck, this is a real potential threat.
					score += rand(30, 40)
				if(M.wear_mask && M.wear_mask.flags_inv & HIDEFACE)
					score += rand(5, 12)
		else if(M.stat == UNCONSCIOUS || M.resting) //Downed people aren't that scary..
			score -= min(5, rand(25, 35))
				people["[M.real_name]"] = score
