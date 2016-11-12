#define HUMAN_EATING_NO_ISSUE		0
#define HUMAN_EATING_NBP_MOUTH		1
#define HUMAN_EATING_BLOCKED_MOUTH	2

#define add_clothing_protection(A)	\
	var/obj/item/clothing/C = A; \
	flash_protection += C.flash_protection; \
	equipment_tint_total += C.tint;

/mob/living/carbon/human/can_eat(var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NBP_MOUTH)
			to_chat(src, "Where do you intend to put \the [food]? You don't have a mouth!")
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			to_chat(src, "<span class='warning'>\The [status[2]] is in the way!</span>")
	return 0

/mob/living/carbon/human/can_force_feed(var/feeder, var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NBP_MOUTH)
			to_chat(feeder, "Where do you intend to put \the [food]? \The [src] doesn't have a mouth!")
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			to_chat(feeder, "<span class='warning'>\The [status[2]] is in the way!</span>")
	return 0

/mob/living/carbon/human/proc/can_eat_status()
	if(!check_has_mouth())
		return list(HUMAN_EATING_NBP_MOUTH)
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		return list(HUMAN_EATING_BLOCKED_MOUTH, blocked)
	return list(HUMAN_EATING_NO_ISSUE)

#undef HUMAN_EATING_NO_ISSUE
#undef HUMAN_EATING_NBP_MOUTH
#undef HUMAN_EATING_BLOCKED_MOUTH

/mob/living/carbon/human/proc/update_equipment_vision()
	flash_protection = 0
	equipment_tint_total = 0
	equipment_see_invis	= 0
	equipment_vision_flags = 0
	equipment_prescription = 0
	equipment_darkness_modifier = 0
	equipment_overlays.Cut()

	if(istype(src.head, /obj/item/clothing/head))
		add_clothing_protection(head)
	if(istype(src.glasses, /obj/item/clothing/glasses))
		process_glasses(glasses)
	if(istype(src.wear_mask, /obj/item/clothing/mask))
		add_clothing_protection(wear_mask)
	if(istype(back,/obj/item/weapon/rig))
		process_rig(back)

/mob/living/carbon/human/proc/process_glasses(var/obj/item/clothing/glasses/G)
	if(G && G.active)
		equipment_darkness_modifier += G.darkness_view
		equipment_vision_flags |= G.vision_flags
		equipment_prescription += G.prescription
		if(G.overlay)
			equipment_overlays |= G.overlay
		if(G.see_invisible >= 0)
			if(equipment_see_invis)
				equipment_see_invis = min(equipment_see_invis, G.see_invisible)
			else
				equipment_see_invis = G.see_invisible

		add_clothing_protection(G)
		G.process_hud(src)

/mob/living/carbon/human/proc/process_rig(var/obj/item/weapon/rig/O)
	if(O.visor && O.visor.active && O.visor.vision && O.visor.vision.glasses && (!O.helmet || (head && O.helmet == head)))
		process_glasses(O.visor.vision.glasses)

/mob/living/carbon/human/get_gender()
	return gender

/mob/living/carbon/human/fully_replace_character_name(var/new_name, var/in_depth = TRUE)
	var/old_name = real_name
	. = ..()
	if(!. || !in_depth)
		return

	//update the datacore records! This is goig to be a bit costly.
	for(var/list/L in list(data_core.general,data_core.medical,data_core.security,data_core.locked))
		for(var/datum/data/record/R in L)
			if(R.fields["name"] == old_name)
				R.fields["name"] = new_name
				break

	//update our pda and id if we have them on our person
	var/list/searching = GetAllContents(searchDepth = 3)
	var/search_id = 1
	var/search_pda = 1

	for(var/A in searching)
		if(search_id && istype(A,/obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/ID = A
			if(ID.registered_name == old_name)
				ID.registered_name = new_name
				ID.update_name()
				search_id = 0
		else if(search_pda && istype(A,/obj/item/device/pda))
			var/obj/item/device/pda/PDA = A
			if(PDA.owner == old_name)
				PDA.set_owner(new_name)
				search_pda = 0


//Get species or synthetic temp if the mob is a FBP. Used when a synthetic type human mob is exposed to a temp check.
//Essentially, used when a synthetic human mob should act diffferently than a normal type mob.
/mob/living/carbon/human/proc/getSpeciesOrSynthTemp(var/temptype)
	switch(temptype)
		if(COLD_LEVEL_1)
			return isSynthetic()? SYNTH_COLD_LEVEL_1 : species.cold_level_1
		if(COLD_LEVEL_2)
			return isSynthetic()? SYNTH_COLD_LEVEL_2 : species.cold_level_2
		if(COLD_LEVEL_3)
			return isSynthetic()? SYNTH_COLD_LEVEL_3 : species.cold_level_3
		if(HEAT_LEVEL_1)
			return isSynthetic()? SYNTH_HEAT_LEVEL_1 : species.heat_level_1
		if(HEAT_LEVEL_2)
			return isSynthetic()? SYNTH_HEAT_LEVEL_2 : species.heat_level_2
		if(HEAT_LEVEL_3)
			return isSynthetic()? SYNTH_HEAT_LEVEL_3 : species.heat_level_3

/mob/living/carbon/human
	var/next_sonar_ping = 0

/mob/living/carbon/human/proc/sonar_ping()
	set name = "Listen In"
	set desc = "Allows you to listen in to movement and noises around you."
	set category = "IC"

	if(incapacitated())
		to_chat(src, "<span class='warning'>You need to recover before you can use this ability.</span>")
		return
	if(world.time < next_sonar_ping)
		to_chat(src, "<span class='warning'>You need another moment to focus.</span>")
		return
	if(is_deaf() || is_below_sound_pressure(get_turf(src)))
		to_chat(src, "<span class='warning'>You are for all intents and purposes currently deaf!</span>")
		return
	next_sonar_ping += 10 SECONDS
	var/heard_something = FALSE
	to_chat(src, "<span class='notice'>You take a moment to listen in to your environment...</span>")
	for(var/mob/living/L in range(client.view, src))
		var/turf/T = get_turf(L)
		if(!T || L == src || L.stat == DEAD || is_below_sound_pressure(T))
			continue
		heard_something = TRUE
		var/feedback = list()
		feedback += "<span class='notice'>There are noises of movement "
		var/direction = get_dir(src, L)
		if(direction)
			feedback += "towards the [dir2text(direction)], "
			switch(get_dist(src, L) / client.view)
				if(0 to 0.2)
					feedback += "very close by."
				if(0.2 to 0.4)
					feedback += "close by."
				if(0.4 to 0.6)
					feedback += "some distance away."
				if(0.6 to 0.8)
					feedback += "further away."
				else
					feedback += "far away."
		else // No need to check distance if they're standing right on-top of us
			feedback += "right on top of you."
		feedback += "</span>"
		to_chat(src, jointext(feedback,null))
	if(!heard_something)
		to_chat(src, "<span class='notice'>You hear no movement but your own.</span>")

/mob/living/carbon/human/reset_layer()
	if(hiding)
		plane = HIDING_MOB_PLANE
		layer = HIDING_MOB_LAYER
	else if(lying)
		plane = LYING_HUMAN_PLANE
		layer = LYING_HUMAN_LAYER
	else
		..()
