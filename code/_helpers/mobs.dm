/atom/movable/proc/get_mob()
	return

/obj/vehicle/train/get_mob()
	return buckled_mob

/mob/get_mob()
	return src

/mob/living/bot/mulebot/get_mob()
	if(load && istype(load, /mob/living))
		return list(src, load)
	return src

//helper for inverting armor blocked values into a multiplier
#define blocked_mult(blocked) max(1 - (blocked/100), 0)

/proc/mobs_in_view(var/range, var/source)
	var/list/mobs = list()
	for(var/atom/movable/AM in view(range, source))
		var/M = AM.get_mob()
		if(M)
			mobs += M

	return mobs

proc/random_hair_style(gender, species = SPECIES_HUMAN)
	var/h_style = "Bald"

	var/datum/species/mob_species = all_species[species]
	var/list/valid_hairstyles = mob_species.get_hair_styles()
	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)

	return h_style

proc/random_facial_hair_style(gender, var/species = SPECIES_HUMAN)
	var/f_style = "Shaved"
	var/datum/species/mob_species = all_species[species]
	var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(gender)
	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)
		return f_style

proc/random_name(gender, species = SPECIES_HUMAN)
	if(species)
		var/datum/species/current_species = all_species[species]
		if(current_species)
			var/decl/cultural_info/current_culture = SSculture.get_culture(current_species.default_cultural_info[TAG_CULTURE])
			if(current_culture)
				return current_culture.get_random_name(gender)
	return capitalize(pick(gender == FEMALE ? GLOB.first_names_female : GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))

proc/random_skin_tone(var/datum/species/current_species)
	var/species_tone = current_species ? 35 - current_species.max_skin_tone() : -185
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(species_tone,34)

	return min(max(. + rand(-25, 25), species_tone), 34)

proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teenager"
		if(19 to 30)		return "young adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-aged"
		if(60 to 70)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

/proc/RoundHealth(health)
	var/list/icon_states = icon_states('icons/mob/hud_med.dmi')
	for(var/icon_state in icon_states)
		if(health >= text2num(icon_state))
			return icon_state
	return icon_states[icon_states.len] // If we had no match, return the last element

//checks whether this item is a module of the robot it is located in.
/proc/is_robot_module(var/obj/item/thing)
	if(!thing)
		return FALSE
	if(istype(thing.loc, /mob/living/exosuit))
		return FALSE
	if(!istype(thing.loc, /mob/living/silicon/robot))
		return FALSE
	var/mob/living/silicon/robot/R = thing.loc
	return (thing in R.module.equipment)

/proc/get_exposed_defense_zone(var/atom/movable/target)
	return pick(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_CHEST, BP_GROIN)


/mob/var/do_unique_user_handle = 0
/atom/var/do_unique_target_user

/proc/do_after(mob/user, delay, atom/target, do_flags = DO_DEFAULT, incapacitation_flags = INCAPACITATION_DEFAULT)
	return !do_after_detailed(user, delay, target, do_flags, incapacitation_flags)

/proc/do_after_detailed(mob/user, delay, atom/target, do_flags = DO_DEFAULT, incapacitation_flags = INCAPACITATION_DEFAULT)
	if (!delay)
		return FALSE

	if (!user)
		return DO_MISSING_USER

	var/initial_handle
	if (do_flags & DO_USER_UNIQUE_ACT)
		initial_handle = sequential_id("/proc/do_after")
		user.do_unique_user_handle = initial_handle

	var/do_feedback = do_flags & DO_FAIL_FEEDBACK

	if (target?.do_unique_target_user)
		if (do_feedback)
			to_chat(user, SPAN_WARNING("\The [target.do_unique_target_user] is already interacting with \the [target]!"))
		return DO_TARGET_UNIQUE_ACT

	if ((do_flags & DO_TARGET_UNIQUE_ACT) && target)
		target.do_unique_target_user = user

	var/atom/user_loc = do_flags & DO_USER_CAN_MOVE ? null : user.loc
	var/user_dir = do_flags & DO_USER_CAN_TURN ? null : user.dir
	var/user_hand = do_flags & DO_USER_SAME_HAND ? user.hand : null

	var/atom/target_loc = do_flags & DO_TARGET_CAN_MOVE ? null : target?.loc
	var/target_dir = do_flags & DO_TARGET_CAN_TURN ? null : target?.dir
	var/target_type = target?.type

	var/target_zone = do_flags & DO_USER_SAME_ZONE ? user.zone_sel.selecting : null

	if (do_flags & DO_MOVE_CHECKS_TURFS)
		if (user_loc)
			user_loc = get_turf(user)
		if (target_loc)
			target_loc = get_turf(target)

	var/datum/progressbar/bar
	if (do_flags & DO_SHOW_PROGRESS)
		if (do_flags & DO_PUBLIC_PROGRESS)
			bar = new /datum/progressbar/public(user, delay, target)
		else
			bar = new /datum/progressbar/private(user, delay, target)

	var/start_time = world.time
	var/end_time = start_time + delay

	. = FALSE

	for (var/time = world.time, time < end_time, time = world.time)
		sleep(1)
		if (bar)
			bar.update(time - start_time)
		if (QDELETED(user))
			. = DO_MISSING_USER
			break
		if (target_type && (QDELETED(target) || target_type != target.type))
			. = DO_MISSING_TARGET
			break
		if (user.incapacitated(incapacitation_flags))
			. = DO_INCAPACITATED
			break
		if (user_loc && user_loc != (do_flags & DO_MOVE_CHECKS_TURFS ? get_turf(user) : user.loc))
			. = DO_USER_CAN_MOVE
			break
		if (target_loc && target_loc != (do_flags & DO_MOVE_CHECKS_TURFS ? get_turf(target) : target.loc))
			. = DO_TARGET_CAN_MOVE
			break
		if (user_dir && user_dir != user.dir)
			. = DO_USER_CAN_TURN
			break
		if (target_dir && target_dir != target.dir)
			. = DO_TARGET_CAN_TURN
			break
		if (!isnull(user_hand) && user_hand != user.hand)
			. = DO_USER_SAME_HAND
			break
		if (initial_handle && initial_handle != user.do_unique_user_handle)
			. = DO_USER_UNIQUE_ACT
			break
		if (target_zone && user.zone_sel.selecting != target_zone)
			. = DO_USER_SAME_ZONE
			break

	if (. && do_feedback)
		switch (.)
			if (DO_MISSING_TARGET)
				to_chat(user, SPAN_WARNING("\The [target] no longer exists!"))
			if (DO_INCAPACITATED)
				to_chat(user, SPAN_WARNING("You're no longer able to act!"))
			if (DO_USER_CAN_MOVE)
				to_chat(user, SPAN_WARNING("You must remain still to perform that action!"))
			if (DO_TARGET_CAN_MOVE)
				to_chat(user, SPAN_WARNING("\The [target] must remain still to perform that action!"))
			if (DO_USER_CAN_TURN)
				to_chat(user, SPAN_WARNING("You must face the same direction to perform that action!"))
			if (DO_TARGET_CAN_TURN)
				to_chat(user, SPAN_WARNING("\The [target] must face the same direction to perform that action!"))
			if (DO_USER_SAME_HAND)
				to_chat(user, SPAN_WARNING("You must remain on the same active hand to perform that action!"))
			if (DO_USER_UNIQUE_ACT)
				to_chat(user, SPAN_WARNING("You stop what you're doing with \the [user.do_unique_user_handle]."))
			if (DO_USER_SAME_ZONE)
				to_chat(user, SPAN_WARNING("You must remain targeting the same zone to perform that action!"))

	if (bar)
		qdel(bar)
	if ((do_flags & DO_USER_UNIQUE_ACT) && user.do_unique_user_handle == initial_handle)
		user.do_unique_user_handle = 0
	if ((do_flags & DO_TARGET_UNIQUE_ACT) && target)
		target.do_unique_target_user = null

/proc/able_mobs_in_oview(var/origin)
	var/list/mobs = list()
	for(var/mob/living/M in oview(origin)) // Only living mobs are considered able.
		if(!M.is_physically_disabled())
			mobs += M
	return mobs

// Returns true if M was not already in the dead mob list
/mob/proc/switch_from_living_to_dead_mob_list()
	remove_from_living_mob_list()
	. = add_to_dead_mob_list()

// Returns true if M was not already in the living mob list
/mob/proc/switch_from_dead_to_living_mob_list()
	remove_from_dead_mob_list()
	. = add_to_living_mob_list()

// Returns true if the mob was in neither the dead or living list
/mob/proc/add_to_living_mob_list()
	return FALSE
/mob/living/add_to_living_mob_list()
	if((src in GLOB.living_mob_list_) || (src in GLOB.dead_mob_list_))
		return FALSE
	GLOB.living_mob_list_ += src
	return TRUE

// Returns true if the mob was removed from the living list
/mob/proc/remove_from_living_mob_list()
	return GLOB.living_mob_list_.Remove(src)

// Returns true if the mob was in neither the dead or living list
/mob/proc/add_to_dead_mob_list()
	return FALSE
/mob/living/add_to_dead_mob_list()
	if((src in GLOB.living_mob_list_) || (src in GLOB.dead_mob_list_))
		return FALSE
	GLOB.dead_mob_list_ += src
	return TRUE

// Returns true if the mob was removed form the dead list
/mob/proc/remove_from_dead_mob_list()
	return GLOB.dead_mob_list_.Remove(src)

//Find a dead mob with a brain and client.
/proc/find_dead_player(var/find_key, var/include_observers = 0)
	if(isnull(find_key))
		return

	var/mob/selected = null

	if(include_observers)
		for(var/mob/M in GLOB.player_list)
			if((M.stat != DEAD) || (!M.client))
				continue
			if(M.ckey == find_key)
				selected = M
				break
	else
		for(var/mob/living/M in GLOB.player_list)
			//Dead people only thanks!
			if((M.stat != DEAD) || (!M.client))
				continue
			//They need a brain!
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.should_have_organ(BP_BRAIN) && !H.has_brain())
					continue
			if(M.ckey == find_key)
				selected = M
				break
	return selected

/proc/damflags_to_strings(damflags)
	var/list/res = list()
	if(damflags & DAM_SHARP)
		res += "sharp"
	if(damflags & DAM_EDGE)
		res += "edge"
	if(damflags & DAM_LASER)
		res += "laser"
	if(damflags & DAM_BULLET)
		res += "bullet"
	if(damflags & DAM_EXPLODE)
		res += "explode"
	if(damflags & DAM_DISPERSED)
		res += "dispersed"
	if(damflags & DAM_BIO)
		res += "bio"
	return english_list(res)
