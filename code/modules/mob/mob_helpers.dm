// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
/proc/ishuman(A)
	if(istype(A, /mob/living/carbon/human))
		return 1
	return 0

/proc/isalien(A)
	if(istype(A, /mob/living/carbon/alien))
		return 1
	return 0

/proc/isxenomorph(A)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		return istype(H.species, /datum/species/xenos)
	return 0

/proc/ismonkey(A)
	if(A && istype(A, /mob/living/carbon/monkey))
		return 1
	return 0

/proc/isbrain(A)
	if(A && istype(A, /mob/living/carbon/brain))
		return 1
	return 0

/proc/isslime(A)
	if(istype(A, /mob/living/carbon/slime))
		return 1
	return 0

/proc/isrobot(A)
	if(istype(A, /mob/living/silicon/robot))
		return 1
	return 0

/proc/isanimal(A)
	if(istype(A, /mob/living/simple_animal))
		return 1
	return 0

/proc/iscorgi(A)
	if(istype(A, /mob/living/simple_animal/corgi))
		return 1
	return 0

/proc/iscrab(A)
	if(istype(A, /mob/living/simple_animal/crab))
		return 1
	return 0

/proc/iscat(A)
	if(istype(A, /mob/living/simple_animal/cat))
		return 1
	return 0

/proc/ismouse(A)
	if(istype(A, /mob/living/simple_animal/mouse))
		return 1
	return 0

/proc/isbear(A)
	if(istype(A, /mob/living/simple_animal/hostile/bear))
		return 1
	return 0

/proc/iscarp(A)
	if(istype(A, /mob/living/simple_animal/hostile/carp))
		return 1
	return 0

/proc/isclown(A)
	if(istype(A, /mob/living/simple_animal/hostile/retaliate/clown))
		return 1
	return 0

/proc/isAI(A)
	if(istype(A, /mob/living/silicon/ai))
		return 1
	return 0

/proc/ispAI(A)
	if(istype(A, /mob/living/silicon/pai))
		return 1
	return 0

/proc/iscarbon(A)
	if(istype(A, /mob/living/carbon))
		return 1
	return 0

/proc/issilicon(A)
	if(istype(A, /mob/living/silicon))
		return 1
	return 0

/proc/isliving(A)
	if(istype(A, /mob/living))
		return 1
	return 0

proc/isobserver(A)
	if(istype(A, /mob/dead/observer))
		return 1
	return 0

proc/isorgan(A)
	if(istype(A, /datum/organ/external))
		return 1
	return 0

proc/isdeaf(A)
	if(istype(A, /mob))
		var/mob/M = A
		return (M.sdisabilities & DEAF) || M.ear_deaf
	return 0

proc/isnewplayer(A)
	if(istype(A, /mob/new_player))
		return 1
	return 0

proc/hasorgans(A)
	return ishuman(A)

proc/iscuffed(A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.handcuffed)
			return 1
	return 0

/proc/hsl2rgb(h, s, l)
	return //TODO: Implement

/*
	Miss Chance
*/

//TODO: Integrate defence zones and targeting body parts with the actual organ system, move these into organ definitions.

//The base miss chance for the different defence zones
var/list/global/base_miss_chance = list(
	"head" = 40,
	"chest" = 10,
	"groin" = 20,
	"l_leg" = 20,
	"r_leg" = 20,
	"l_arm" = 20,
	"r_arm" = 20,
	"l_hand" = 50,
	"r_hand" = 50,
	"l_foot" = 50,
	"r_foot" = 50,
)

//Used to weight organs when an organ is hit randomly (i.e. not a directed, aimed attack).
//Also used to weight the protection value that armour provides for covering that body part when calculating protection from full-body effects.
var/list/global/organ_rel_size = list(
	"head" = 25,
	"chest" = 70,
	"groin" = 30,
	"l_leg" = 25,
	"r_leg" = 25,
	"l_arm" = 25,
	"r_arm" = 25,
	"l_hand" = 10,
	"r_hand" = 10,
	"l_foot" = 10,
	"r_foot" = 10,
)

/proc/check_zone(zone)
	if(!zone)	return "chest"
	switch(zone)
		if("eyes")
			zone = "head"
		if("mouth")
			zone = "head"
	return zone

// Returns zone with a certain probability. If the probability fails, or no zone is specified, then a random body part is chosen.
// Do not use this if someone is intentionally trying to hit a specific body part.
// Use get_zone_with_miss_chance() for that.
/proc/ran_zone(zone, probability)
	if (zone)
		zone = check_zone(zone)
		if (prob(probability))
			return zone

	var/ran_zone = zone
	while (ran_zone == zone)
		ran_zone = pick (
			organ_rel_size["head"]; "head",
			organ_rel_size["chest"]; "chest",
			organ_rel_size["groin"]; "groin",
			organ_rel_size["l_arm"]; "l_arm",
			organ_rel_size["r_arm"]; "r_arm",
			organ_rel_size["l_leg"]; "l_leg",
			organ_rel_size["r_leg"]; "r_leg",
			organ_rel_size["l_hand"]; "l_hand",
			organ_rel_size["r_hand"]; "r_hand",
			organ_rel_size["l_foot"]; "l_foot",
			organ_rel_size["r_foot"]; "r_foot",
		)

	return ran_zone

// Emulates targetting a specific body part, and miss chances
// May return null if missed
// miss_chance_mod may be negative.
/proc/get_zone_with_miss_chance(zone, var/mob/target, var/miss_chance_mod = 0)
	zone = check_zone(zone)

	// you can only miss if your target is standing and not restrained
	if(!target.buckled && !target.lying)
		var/miss_chance = 10
		if (zone in base_miss_chance)
			miss_chance = base_miss_chance[zone]
		miss_chance = max(miss_chance + miss_chance_mod, 0)
		if(prob(miss_chance))
			if(prob(70))
				return null
			return pick(base_miss_chance)

	return zone


/proc/stars(n, pr)
	if (pr == null)
		pr = 25
	if (pr <= 0)
		return null
	else
		if (pr >= 100)
			return n
	var/te = n
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		if ((copytext(te, p, p + 1) == " " || prob(pr)))
			t = text("[][]", t, copytext(te, p, p + 1))
		else
			t = text("[]*", t)
		p++
	return t

proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=lentext(phrase)
	var/counter=lentext(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,15))
			if(1,3,5,8)	newletter="[lowertext(newletter)]"
			if(2,4,6,15)	newletter="[uppertext(newletter)]"
			if(7)	newletter+="'"
			//if(9,10)	newletter="<b>[newletter]</b>"
			//if(11,12)	newletter="<big>[newletter]</big>"
			//if(13)	newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/stutter(n)
	var/te = html_decode(n)
	var/t = ""//placed before the message. Not really sure what it's for.
	n = length(n)//length of the entire word
	var/p = null
	p = 1//1 is the start of any word
	while(p <= n)//while P, which starts at 1 is less or equal to N which is the length.
		var/n_letter = copytext(te, p, p + 1)//copies text from a certain distance. In this case, only one letter at a time.
		if (prob(80) && (ckey(n_letter) in list("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z")))
			if (prob(10))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]-[n_letter]")//replaces the current letter with this instead.
			else
				if (prob(20))
					n_letter = text("[n_letter]-[n_letter]-[n_letter]")
				else
					if (prob(5))
						n_letter = null
					else
						n_letter = text("[n_letter]-[n_letter]")
		t = text("[t][n_letter]")//since the above is ran through for each letter, the text just adds up back to the original word.
		p++//for each letter p is increased to find where the next letter will be.
	return copytext(sanitize(t),1,MAX_MESSAGE_LEN)


proc/Gibberish(t, p)//t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext


/proc/ninjaspeak(n)
/*
The difference with stutter is that this proc can stutter more than 1 letter
The issue here is that anything that does not have a space is treated as one word (in many instances). For instance, "LOOKING," is a word, including the comma.
It's fairly easy to fix if dealing with single letters but not so much with compounds of letters./N
*/
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = 1
	while(p <= n)
		var/n_letter
		var/n_mod = rand(1,4)
		if(p+n_mod>n+1)
			n_letter = copytext(te, p, n+1)
		else
			n_letter = copytext(te, p, p+n_mod)
		if (prob(50))
			if (prob(30))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]")
			else
				n_letter = text("[n_letter]-[n_letter]")
		else
			n_letter = text("[n_letter]")
		t = text("[t][n_letter]")
		p=p+n_mod
	return copytext(sanitize(t),1,MAX_MESSAGE_LEN)


/proc/shake_camera(mob/M, duration, strength=1)
	if(!M || !M.client || M.shakecamera)
		return
	M.shakecamera = 1
	spawn(1)

		var/atom/oldeye=M.client.eye
		var/aiEyeFlag = 0
		if(istype(oldeye, /mob/aiEye))
			aiEyeFlag = 1

		var/x
		for(x=0; x<duration, x++)
			if(aiEyeFlag)
				M.client.eye = locate(dd_range(1,oldeye.loc.x+rand(-strength,strength),world.maxx),dd_range(1,oldeye.loc.y+rand(-strength,strength),world.maxy),oldeye.loc.z)
			else
				M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
			sleep(1)
		M.client.eye=oldeye
		M.shakecamera = 0


/proc/findname(msg)
	for(var/mob/M in mob_list)
		if (M.real_name == text("[msg]"))
			return 1
	return 0


/mob/proc/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask)))
		return 1

	if((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )))
		return 1

	return 0

//converts intent-strings into numbers and back
var/list/intents = list("help","disarm","grab","hurt")
/proc/intent_numeric(argument)
	if(istext(argument))
		switch(argument)
			if("help")		return 0
			if("disarm")	return 1
			if("grab")		return 2
			else			return 3
	else
		switch(argument)
			if(0)			return "help"
			if(1)			return "disarm"
			if(2)			return "grab"
			else			return "hurt"

//change a mob's act-intent. Input the intent as a string such as "help" or use "right"/"left
/mob/verb/a_intent_change(input as text)
	set name = "a-intent"
	set hidden = 1

	if(ishuman(src) || isbrain(src))
		switch(input)
			if("help","disarm","grab","hurt")
				a_intent = input
			if("right")
				a_intent = intent_numeric((intent_numeric(a_intent)+1) % 4)
			if("left")
				a_intent = intent_numeric((intent_numeric(a_intent)+3) % 4)
		if(hud_used && hud_used.action_intent)
			hud_used.action_intent.icon_state = "intent_[a_intent]"

	else if(isrobot(src) || ismonkey(src))
		switch(input)
			if("help")
				a_intent = "help"
			if("hurt")
				a_intent = "hurt"
			if("right","left")
				a_intent = intent_numeric(intent_numeric(a_intent) - 3)
		if(hud_used && hud_used.action_intent)
			if(a_intent == "hurt")
				hud_used.action_intent.icon_state = "harm"
			else
				hud_used.action_intent.icon_state = "help"

proc/is_blind(A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.sdisabilities & BLIND || C.blinded)
			return 1
	return 0

/proc/broadcast_security_hud_message(var/message, var/broadcast_source)
	broadcast_hud_message(message, broadcast_source, sec_hud_users, /obj/item/clothing/glasses/hud/security)

/proc/broadcast_medical_hud_message(var/message, var/broadcast_source)
	broadcast_hud_message(message, broadcast_source, med_hud_users, /obj/item/clothing/glasses/hud/health)

/proc/broadcast_hud_message(var/message, var/broadcast_source, var/list/targets, var/icon)
	var/turf/sourceturf = get_turf(broadcast_source)
	for(var/mob/M in targets)
		var/turf/targetturf = get_turf(M)
		if((targetturf.z == sourceturf.z))
			M.show_message("<span class='info'>\icon[icon] [message]</span>", 1)

/proc/mobs_in_area(var/area/A)
	var/list/mobs = new
	for(var/mob/living/M in mob_list)
		if(get_area(M) == A)
			mobs += M
	return mobs
