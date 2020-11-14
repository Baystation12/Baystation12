/obj/item/weapon/sd_key
	name = "self destruct key"
	desc = "For when the final duty must be performed. The key can only be imprinted by a head of staff, premature activation is not required."
	icon = 'icons/boh/items/sd_keys.dmi'
	icon_state = "key_base"
	w_class = ITEM_SIZE_TINY
	var/mob/living/carbon/human/owner
	var/list/allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/rd, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/hos) //Who can imprint this key?
	var/ownertag
	var/job_name
	var/skeleton_key = FALSE //used in the self destruct terminal stuff.

/obj/item/weapon/sd_key/skeleton_key
	name = "hacked self destruct key"
	desc = "A key to the ship's self destruct. It's obviously been hacked extensively."
	skeleton_key = TRUE
	ownertag = "skeleton"


/obj/item/weapon/sd_key/Initialize()
	. = ..()
	update_icon()

/obj/item/weapon/sd_key/examine(mob/user)
	. = ..()
	if(owner)
		to_chat(user, SPAN_NOTICE("It belongs to [owner], [job_name], according to the display."))

/obj/item/weapon/sd_key/attack_self(mob/user)
	var/turf/E = get_turf(user)
	if(skeleton_key)
		to_chat(user, SPAN_NOTICE("The circuitry in this thing has been modified extensively. You feel like you don't need to imprint onto it."))
		return
	if(!owner)
		to_chat(user, SPAN_NOTICE("You press your thumb against the key, feeling a tingle as the imprinting sequence activates..."))
		var/datum/mind/imprintmind = user.mind
		if(imprintmind.assigned_job)
			if(imprintmind.assigned_job.type in allowed_jobs)
				to_chat(user, SPAN_NOTICE("[src] chirps swiftly, it's indicator lights shifting to the color of your job."))
				playsound(src.loc, 'sound/effects/compbeep5.ogg', 25, 0, 10)
				owner = user
				get_imprint(imprintmind.assigned_job)
				GLOB.global_announcer.autosay("Notice. Successful activation of self destruct key in [E.loc]. Registered to [owner], [job_name].", "Self Destruct Key Monitor", "Security")
				return
			else
				to_chat(user, SPAN_WARNING("[src] buzzes, flashing red once and refuses to register you."))
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 25, 0, 10)
				GLOB.global_announcer.autosay("Caution. Failed activation of self destruct key in [E.loc].", "Self Destruct Key Monitor", "Security")
				return
		else
			to_chat(user, SPAN_WARNING("[src] buzzes, flashing red once and refuses to register you."))
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 25, 0, 10)
			GLOB.global_announcer.autosay("Caution. Failed activation of self destruct key in [E.loc].", "Self Destruct Key Monitor", "Security")
			return
	if(owner)
		if(user == owner)
			var/list/answer_list = list("Yes", "No")
			var/answer = input("Do you wish to reset the key?", "Key Reset Prompt") as null|anything in answer_list
			if(answer == "Yes")
				to_chat(user, SPAN_NOTICE("[src] beeps stridently, then the lights on it's surface fade to nothing."))
				playsound(src.loc, 'sound/effects/compbeep5.ogg', 25, 0, 10)
				owner = null
				ownertag = null
				job_name = null
				GLOB.global_announcer.autosay("Notice. Successful deactivation of self destruct key in [E.loc].", "Self Destruct Key Monitor", "Security")
				update_icon()
			else
				return

/obj/item/weapon/sd_key/proc/get_imprint(var/datum/job/ownerjob)
	var/imprinttype = ownerjob.type
	switch(imprinttype)
		if(/datum/job/captain)
			ownertag = "co"
		if(/datum/job/hop)
			ownertag = "xo"
		if(/datum/job/rd)
			ownertag = "cso"
		if(/datum/job/cmo)
			ownertag = "cmo"
		if(/datum/job/chief_engineer)
			ownertag = "ce"
		if(/datum/job/hos)
			ownertag = "cos"
	job_name = ownerjob.title
	update_icon()

/obj/item/weapon/sd_key/on_update_icon()
	if(skeleton_key)
		overlays += image('icons/boh/items/sd_keys.dmi', "skeleton_key")
		return //we don't do any of the fancy stuff if we're a skeleton key.
	overlays += image('icons/boh/items/sd_keys.dmi', "trefoil")

	if(ownertag)
		overlays += image('icons/boh/items/sd_keys.dmi', "imprint_[ownertag]")
		return
	else
		overlays.Cut()
		overlays += image('icons/boh/items/sd_keys.dmi', "trefoil")
