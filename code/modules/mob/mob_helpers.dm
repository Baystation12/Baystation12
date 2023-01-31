/proc/issmall(A)
	if(A && istype(A, /mob/living))
		var/mob/living/L = A
		return L.mob_size <= MOB_SMALL
	return 0

//returns the number of size categories between two mob_sizes, rounded. Positive means A is larger than B
/proc/mob_size_difference(mob_size_A, mob_size_B)
	return round(log(2, mob_size_A/mob_size_B), 1)

/mob/proc/can_wield_item(obj/item/W)
	if(W.w_class >= ITEM_SIZE_LARGE && issmall(src))
		return FALSE //M is too small to wield this
	return TRUE


/mob/proc/isSynthetic()
	return FALSE


/mob/living/silicon/isSynthetic()
	return TRUE


/mob/living/carbon/human/isSynthetic()
	if(isnull(full_prosthetic))
		robolimb_count = 0
		for(var/obj/item/organ/external/E in organs)
			if(BP_IS_ROBOTIC(E))
				robolimb_count++
		full_prosthetic = (robolimb_count == length(organs))
		update_emotes()
	return full_prosthetic

/mob/living/carbon/human/proc/isFBP()
	return istype(internal_organs_by_name[BP_BRAIN], /obj/item/organ/internal/mmi_holder)


/// Determine if the mob is the supplied species by text name, species path, or species instance name
/mob/proc/is_species(datum/species/S)
	return FALSE


/mob/living/carbon/is_species(datum/species/S)
	if (!S) return FALSE
	if (istext(S)) return species.name == S
	if (ispath(S)) return species.name == initial(S.name)
	return species.name == S.name


/**
 * Checks if the target has a grab from the user
 */
/mob/proc/has_danger_grab(mob/user)
	if (user == src || istype(user, /mob/living/silicon/robot) || istype(user, /mob/living/bot))
		return TRUE

	for (var/obj/item/grab/G in grabbed_by)
		if (G.force_danger())
			return TRUE


/proc/isdeaf(mob/living/M)
	return istype(M) && (M.ear_deaf || M.sdisabilities & DEAFENED)

/proc/iscuffed(mob/living/carbon/C)
	return istype(C) && C.handcuffed


/proc/getsensorlevel(mob/living/carbon/human/H)
	if (!istype(H) || !istype(H.w_uniform, /obj/item/clothing/under))
		return SUIT_SENSOR_OFF
	var/obj/item/clothing/under/U = H.w_uniform
	return U.sensor_mode


/proc/hassensorlevel(mob/living/carbon/human/H, level)
	return getsensorlevel(H) >= level


/*
	Miss Chance
*/

//TODO: Integrate defence zones and targeting body parts with the actual organ system, move these into organ definitions.

//The base miss chance for the different defence zones
var/global/list/base_miss_chance = list(
	BP_HEAD = 70,
	BP_CHEST = 10,
	BP_GROIN = 20,
	BP_L_LEG = 60,
	BP_R_LEG = 60,
	BP_L_ARM = 30,
	BP_R_ARM = 30,
	BP_L_HAND = 50,
	BP_R_HAND = 50,
	BP_L_FOOT = 70,
	BP_R_FOOT = 70,
)

//Used to weight organs when an organ is hit randomly (i.e. not a directed, aimed attack).
//Also used to weight the protection value that armour provides for covering that body part when calculating protection from full-body effects.
var/global/list/organ_rel_size = list(
	BP_HEAD = 25,
	BP_CHEST = 70,
	BP_GROIN = 30,
	BP_L_LEG = 25,
	BP_R_LEG = 25,
	BP_L_ARM = 25,
	BP_R_ARM = 25,
	BP_L_HAND = 10,
	BP_R_HAND = 10,
	BP_L_FOOT = 10,
	BP_R_FOOT = 10,
)

/proc/check_zone(zone)
	if(!zone)	return BP_CHEST
	switch(zone)
		if(BP_EYES)
			zone = BP_HEAD
		if(BP_MOUTH)
			zone = BP_HEAD
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
			organ_rel_size[BP_HEAD];   BP_HEAD,
			organ_rel_size[BP_CHEST];  BP_CHEST,
			organ_rel_size[BP_GROIN];  BP_GROIN,
			organ_rel_size[BP_L_ARM];  BP_L_ARM,
			organ_rel_size[BP_R_ARM];  BP_R_ARM,
			organ_rel_size[BP_L_LEG];  BP_L_LEG,
			organ_rel_size[BP_R_LEG];  BP_R_LEG,
			organ_rel_size[BP_L_HAND]; BP_L_HAND,
			organ_rel_size[BP_R_HAND]; BP_R_HAND,
			organ_rel_size[BP_L_FOOT]; BP_L_FOOT,
			organ_rel_size[BP_R_FOOT]; BP_R_FOOT
		)

	return ran_zone

// Emulates targetting a specific body part, and miss chances
// May return null if missed
// miss_chance_mod may be negative.
/proc/get_zone_with_miss_chance(zone, mob/target, miss_chance_mod = 0, ranged_attack=0)
	zone = check_zone(zone)

	if(!ranged_attack)
		// target isn't trying to fight
		if(target.a_intent == I_HELP)
			return zone
		// you cannot miss if your target is prone or restrained
		if(target.buckled || target.lying)
			return zone
		// if your target is being grabbed aggressively by someone you cannot miss either
		for(var/obj/item/grab/G in target.grabbed_by)
			if(G.stop_move())
				return zone

	var/miss_chance = 10
	if (zone in base_miss_chance)
		miss_chance = base_miss_chance[zone]
	miss_chance = max(miss_chance + miss_chance_mod, 0)
	if(prob(miss_chance))
		return null
	else
		if (prob(miss_chance))
			return (ran_zone())
		else
			return zone

//Replaces some of the characters with *, used in whispers. pr = probability of no star.
//Will try to preserve HTML formatting. re_encode controls whether the returned text is HTML encoded outside tags.
/proc/stars(n, pr = 25, re_encode = 1)
	if (pr < 0)
		return null
	else if (pr >= 100)
		return n

	var/intag = 0
	var/block = list()
	. = list()
	for(var/i = 1, i <= length_char(n), i++)
		var/char = copytext_char(n, i, i+1)
		if(!intag && (char == "<"))
			intag = 1
			. += stars_no_html(JOINTEXT(block), pr, re_encode) //stars added here
			block = list()
		block += char
		if(intag && (char == ">"))
			intag = 0
			. += block //We don't mess up html tags with stars
			block = list()
	. += (intag ? block : stars_no_html(JOINTEXT(block), pr, re_encode))
	. = JOINTEXT(.)

//Ingnores the possibility of breaking tags.
/proc/stars_no_html(text, pr, re_encode)
	text = html_decode(text) //We don't want to screw up escaped characters
	. = list()
	for(var/i = 1, i <= length_char(text), i++)
		var/char = copytext_char(text, i, i+1)
		if(char == " " || prob(pr))
			. += char
		else
			. += "*"
	. = JOINTEXT(.)
	if(re_encode)
		. = html_encode(.)

/proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng = length_char(phrase)
	var/counter = length_char(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext_char(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		var/randomizer = rand(1, 15)
		switch(randomizer)
			if (1 to 4)
				newletter="[lowertext(newletter)]"
			if (5 to 8)
				newletter="[uppertext(newletter)]"
			if (9)
				newletter+="'"
			// 10-15 - Do nothing
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/stutter(n)
	var/te = html_decode(n)
	var/t = ""//placed before the message. Not really sure what it's for.
	n = length_char(n)//length of the entire word
	var/p = null
	p = 1//1 is the start of any word
	while(p <= n)//while P, which starts at 1 is less or equal to N which is the length.
		var/n_letter = copytext_char(te, p, p + 1)//copies text from a certain distance. In this case, only one letter at a time.
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
	return sanitize(t)


/proc/Gibberish(t, p)//t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i = 1, i <= length_char(t), i++)

		var/letter = copytext_char(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext


/proc/shake_camera(mob/M, duration, strength=1)
	if(!M || !M.client || M.shakecamera || M.stat || isEye(M) || isAI(M))
		return
	M.shakecamera = 1
	spawn(1)
		if(!M.client)
			return

		var/atom/oldeye=M.client.eye
		var/aiEyeFlag = 0
		if(istype(oldeye, /mob/observer/eye/aiEye))
			aiEyeFlag = 1

		var/x
		for(x=0; x<duration, x++)
			if(aiEyeFlag)
				M.client.eye = locate(dd_range(1,oldeye.loc.x+rand(-strength,strength),world.maxx),dd_range(1,oldeye.loc.y+rand(-strength,strength),world.maxy),oldeye.loc.z)
			else
				M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
			sleep(1)
			if(!M.client)
				return

		M.client.eye=oldeye
		M.shakecamera = 0


/mob/proc/abiotic(full_body = FALSE)
	var/holding_simulated_item = FALSE
	for (var/obj/item/item as anything in GetAllHeld())
		if (item.simulated)
			holding_simulated_item = TRUE

	if(full_body && (holding_simulated_item || (src.back || src.wear_mask)))
		return TRUE

	if (holding_simulated_item)
		return TRUE

	return FALSE

//converts intent-strings into numbers and back
var/global/list/intents = list(I_HELP,I_DISARM,I_GRAB,I_HURT)
/proc/intent_numeric(argument)
	if(istext(argument))
		switch(argument)
			if(I_HELP)		return 0
			if(I_DISARM)	return 1
			if(I_GRAB)		return 2
			else			return 3
	else
		switch(argument)
			if(0)			return I_HELP
			if(1)			return I_DISARM
			if(2)			return I_GRAB
			else			return I_HURT

//change a mob's act-intent. Input the intent as a string such as "help" or use "right"/"left
/mob/verb/a_intent_change(input as text)
	set name = "a-intent"
	set hidden = 1

	if(ishuman(src) || isbrain(src) || isslime(src))
		switch(input)
			if(I_HELP,I_DISARM,I_GRAB,I_HURT)
				a_intent = input
			if("right")
				a_intent = intent_numeric((intent_numeric(a_intent)+1) % 4)
			if("left")
				a_intent = intent_numeric((intent_numeric(a_intent)+3) % 4)
		if(hud_used && hud_used.action_intent)
			hud_used.action_intent.icon_state = "intent_[a_intent]"

	else if(isrobot(src))
		switch(input)
			if(I_HELP)
				a_intent = I_HELP
			if(I_HURT)
				a_intent = I_HURT
			if("right","left")
				a_intent = intent_numeric(intent_numeric(a_intent) - 3)
		if(hud_used && hud_used.action_intent)
			if(a_intent == I_HURT)
				hud_used.action_intent.icon_state = I_HURT
			else
				hud_used.action_intent.icon_state = I_HELP

/proc/is_blind(A)
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.sdisabilities & BLINDED|| C.blinded)
			return 1
	return 0

/mob/proc/welding_eyecheck()
	return

/proc/broadcast_security_hud_message(message, broadcast_source)
	broadcast_hud_message(message, broadcast_source, GLOB.sec_hud_users, /obj/item/clothing/glasses/hud/security)

/proc/broadcast_medical_hud_message(message, broadcast_source)
	broadcast_hud_message(message, broadcast_source, GLOB.med_hud_users, /obj/item/clothing/glasses/hud/health)

/proc/broadcast_hud_message(message, broadcast_source, list/targets, icon)
	var/turf/sourceturf = get_turf(broadcast_source)
	for(var/mob/M in targets)
		if(!sourceturf || (get_z(M) in GetConnectedZlevels(sourceturf.z)))
			M.show_message(SPAN_INFO("[icon2html(icon, M)] [message]"), 1)

/proc/mobs_in_area(area/A)
	var/list/mobs = new
	for(var/mob/living/M in SSmobs.mob_list)
		if(get_area(M) == A)
			mobs += M
	return mobs

//Announces that a ghost has joined/left, mainly for use with wizards
/proc/announce_ghost_joinleave(O, joined_ghosts = 1, message = "")
	var/client/C
	//Accept any type, sort what we want here
	if(istype(O, /mob))
		var/mob/M = O
		if(M.client)
			C = M.client
	else if(istype(O, /client))
		C = O
	else if(istype(O, /datum/mind))
		var/datum/mind/M = O
		if(M.current && M.current.client)
			C = M.current.client
		else if(M.original && M.original.client)
			C = M.original.client

	if(C)
		var/name
		if(C.mob)
			var/mob/M = C.mob
			if(M.mind && M.mind.name)
				name = M.mind.name
			if(M.real_name && M.real_name != name)
				if(name)
					name += " ([M.real_name])"
				else
					name = M.real_name
		if(!name)
			name = C.key
		var/diedat = ""
		if(C.mob.lastarea)
			diedat = " at [C.mob.lastarea]"
		if(joined_ghosts)
			message = "The ghost of [SPAN_CLASS("name", "[name]")] now [pick("skulks","lurks","prowls","creeps","stalks")] among the dead[diedat]. [message]"
		else
			message = "[SPAN_CLASS("name", "[name]")] no longer [pick("skulks","lurks","prowls","creeps","stalks")] in the realm of the dead. [message]"
		communicate(/singleton/communication_channel/dsay, C || O, message, /singleton/dsay_communication/direct)

/mob/proc/switch_to_camera(obj/machinery/camera/C)
	if (!C.can_use() || stat || (get_dist(C, src) > 1 || machine != src || blinded))
		return 0
	check_eye(src)
	return 1

/mob/living/silicon/ai/switch_to_camera(obj/machinery/camera/C)
	if(!C.can_use() || !is_in_chassis())
		return 0

	eyeobj.setLoc(C)
	return 1

// Returns true if the mob has a client which has been active in the last given X minutes.
/mob/proc/is_client_active(active = 1)
	return client && client.inactivity < active MINUTES

/mob/proc/can_eat()
	return 1

/mob/proc/can_force_feed()
	return 1

#define SAFE_PERP -50
/mob/living/proc/assess_perp(obj/access_obj, check_access, auth_weapons, check_records, check_arrest)
	if(stat == DEAD)
		return SAFE_PERP

	return 0

/mob/living/carbon/assess_perp(obj/access_obj, check_access, auth_weapons, check_records, check_arrest)
	if(handcuffed)
		return SAFE_PERP

	return ..()

/mob/living/carbon/human/assess_perp(obj/access_obj, check_access, auth_weapons, check_records, check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	//Agent cards lower threatlevel.
	var/obj/item/card/id/id = GetIdCard()
	if(id && istype(id, /obj/item/card/id/syndicate))
		threatcount -= 2
	// A proper	CentCom id is hard currency.
	else if(id && istype(id, /obj/item/card/id/centcom))
		return SAFE_PERP

	if(check_access && !access_obj.allowed(src))
		threatcount += 4

	if(auth_weapons && !access_obj.allowed(src))
		var/list/weapons = GetAllHeld(/obj/item/melee)
		threatcount += 4 * length(weapons)

		if(istype(belt, /obj/item/gun) || istype(belt, /obj/item/melee))
			threatcount += 2

		if(species.name != SPECIES_HUMAN)
			threatcount += 2

	if(check_records || check_arrest)
		var/perpname = name
		if(id)
			perpname = id.registered_name

		var/datum/computer_file/report/crew_record/CR = get_crewmember_record(perpname)
		if(check_records && !CR && !is_species(SPECIES_MONKEY))
			threatcount += 4

		if(check_arrest && CR && (CR.get_criminalStatus() == GLOB.arrest_security_status))
			threatcount += 4

	return threatcount

/mob/living/simple_animal/hostile/assess_perp(obj/access_obj, check_access, auth_weapons, check_records, check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	if(!istype(src, /mob/living/simple_animal/hostile/retaliate/goat))
		threatcount += 4
	return threatcount

#undef SAFE_PERP

/mob/proc/get_multitool(obj/item/device/multitool/P)
	if(istype(P))
		return P

/mob/observer/ghost/get_multitool()
	return can_admin_interact() && ..(ghost_multitool)

/mob/living/carbon/human/get_multitool()
	return ..(get_active_hand())

/mob/living/silicon/robot/get_multitool()
	return ..(get_active_hand())

/mob/living/silicon/ai/get_multitool()
	return ..(aiMulti)

/mob/proc/refresh_client_images()
	if(client)
		client.images |= client_images

/mob/proc/hide_client_images()
	if(client)
		client.images -= client_images

/mob/proc/add_client_image(image)
	if(image in client_images)
		return
	client_images += image
	if(client)
		client.images += image

/mob/proc/remove_client_image(image)
	client_images -= image
	if(client)
		client.images -= image

/mob/proc/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	for(var/mob/M in contents)
		M.flash_eyes(intensity, override_blindness_check, affect_silicon, visual, type)

/mob/proc/fully_replace_character_name(new_name, in_depth = TRUE)
	if(!new_name || new_name == real_name)	return 0
	real_name = new_name
	SetName(new_name)
	if(mind)
		mind.name = new_name
	if(dna)
		dna.real_name = real_name
	return 1

/mob/proc/ssd_check()
	return !client && !teleop

/mob/proc/jittery_damage()
	return //Only for living/carbon/human

/mob/living/carbon/human/jittery_damage()
	var/obj/item/organ/internal/heart/L = internal_organs_by_name[BP_HEART]
	if(!istype(L))
		return 0
	if(BP_IS_ROBOTIC(L))
		return 0//Robotic hearts don't get jittery.
	if(src.jitteriness >= 400 && prob(5)) //Kills people if they have high jitters.
		if(prob(1))
			L.take_internal_damage(L.max_damage / 2, 0)
			to_chat(src, SPAN_DANGER("Something explodes in your heart."))
			admin_victim_log(src, "has taken <b>lethal heart damage</b> at jitteriness level [src.jitteriness].")
		else
			L.take_internal_damage(1, 0)
			to_chat(src, SPAN_DANGER("The jitters are killing you! You feel your heart beating out of your chest."))
			admin_victim_log(src, "has taken <i>minor heart damage</i> at jitteriness level [src.jitteriness].")
	return 1

/mob/proc/try_teleport(area/thearea)
	if(!istype(thearea))
		if(istype(thearea, /list))
			thearea = thearea[1]
	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea))
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(buckled)
		buckled = null

	var/attempt = null
	var/success = 0
	var/turf/end
	var/candidates = L.Copy()
	while(length(L))
		attempt = pick(L)
		success = Move(attempt)
		if(!success)
			L.Remove(attempt)
		else
			end = attempt
			break

	if(!success)
		end = pick(candidates)
		forceMove(end)

	return end

//Tries to find the mob's email.
/proc/find_email(real_name)
	for(var/mob/mob in GLOB.alive_mobs)
		if(mob.real_name == real_name)
			if(!mob.mind)
				return
			return mob.mind.initial_email_login["login"]

//This gets an input while also checking a mob for whether it is incapacitated or not.
/mob/proc/get_input(message, title, default, choice_type, obj/required_item)
	if(src.incapacitated() || (required_item && !GLOB.hands_state.can_use_topic(required_item,src)))
		return null
	var/choice
	if(islist(choice_type))
		choice = input(src, message, title, default) as null|anything in choice_type
	else
		switch(choice_type)
			if(MOB_INPUT_TEXT)
				choice = input(src, message, title, default) as null|text
			if(MOB_INPUT_NUM)
				choice = input(src, message, title, default) as null|num
			if(MOB_INPUT_MESSAGE)
				choice = input(src, message, title, default) as null|message
	if(isnull(choice) || src.incapacitated() || (required_item && !GLOB.hands_state.can_use_topic(required_item,src)))
		return null
	return choice

/mob/proc/set_sdisability(sdisability)
	sdisabilities |= sdisability

/mob/proc/unset_sdisability(sdisability)
	sdisabilities &= ~sdisability

/mob/proc/get_accumulated_vision_handlers()
	var/result[2]
	var/asight = 0
	var/ainvis = 0
	for(var/atom/vision_handler in additional_vision_handlers)
		//Grab their flags
		asight |= vision_handler.additional_sight_flags()
		ainvis = max(ainvis, vision_handler.additional_see_invisible())
	result[1] = asight
	result[2] = ainvis

	return result
