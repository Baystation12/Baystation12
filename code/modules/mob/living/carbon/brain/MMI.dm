//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32
/obj/item/device/mmi/digital
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_TOOLS

/obj/item/device/mmi/digital/New()
	src.brainmob = new(src)
	src.brainmob.set_stat(CONSCIOUS)
	src.brainmob.add_language("Robot Talk")
	src.brainmob.add_language("Encoded Audio Language")

	src.brainmob.container = src
	src.brainmob.silent = 0
	PickName()
	..()

/obj/item/device/mmi/digital/proc/PickName()
	return

/obj/item/device/mmi/digital/attack_self()
	return

/obj/item/device/mmi/digital/transfer_identity(mob/living/carbon/H)
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	brainmob.set_stat(CONSCIOUS)
	if(H.mind)
		H.mind.transfer_to(brainmob)
	return

/obj/item/device/mmi
	name = "\improper Man-Machine Interface"
	desc = "A complex life support shell that interfaces between a brain and electronic devices."
	icon = 'icons/obj/assemblies/assemblies.dmi'
	icon_state = "mmi_empty"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_BIO = 3)

	req_access = list(access_robotics)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/locked = 0
	var/mob/living/carbon/brain/brainmob = null//The current occupant.
	var/obj/item/organ/internal/brain/brainobj = null	//The current brain organ.


/obj/item/device/mmi/use_tool(obj/item/tool, mob/user, list/click_params)
	// Brain - Install brain
	if (istype(tool, /obj/item/organ/internal/brain))
		if (brainobj)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [brainobj].")
			return TRUE
		var/obj/item/organ/internal/brain/brain = tool
		if (brain.damage >= brain.max_damage)
			USE_FEEDBACK_FAILURE("\The [tool] is too damaged to install in \the [src].")
			return TRUE
		if (!brain.brainmob || !brain.can_use_mmi)
			USE_FEEDBACK_FAILURE("\The [src] doesn't accept \the [tool].")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		brainmob = brain.brainmob
		brain.brainmob = null
		brainmob.forceMove(src)
		brainmob.container = src
		brainmob.set_stat(CONSCIOUS)
		brainmob.switch_from_dead_to_living_mob_list()
		brainobj = brain
		SetName("[initial(name)]: ([brainmob.real_name])")
		locked = TRUE
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \a [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		return TRUE

	// ID - Toggle MMI lock
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		if (!brainmob)
			USE_FEEDBACK_FAILURE("\The [src] has no brain to lock.")
			return TRUE
		var/id_name = GET_ID_NAME(id, tool)
		if (!check_access(id))
			USE_FEEDBACK_ID_CARD_DENIED(src, id_name)
			return TRUE
		locked = !locked
		user.visible_message(
			SPAN_NOTICE("\The [user] toggles \a [src]'s lock with \a [tool]."),
			SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src] with [id_name].")
		)
		return TRUE

	return ..()

	//TODO: ORGAN REMOVAL UPDATE. Make the brain remain in the MMI so it doesn't lose organ data.
/obj/item/device/mmi/attack_self(mob/user as mob)
	if(!brainmob)
		to_chat(user, SPAN_WARNING("You upend the MMI, but there's nothing in it."))
	else if(locked)
		to_chat(user, SPAN_WARNING("You upend the MMI, but the brain is clamped into place."))
	else
		to_chat(user, SPAN_NOTICE("You upend the MMI, spilling the brain onto the floor."))
		var/obj/item/organ/internal/brain/brain
		if (brainobj)	//Pull brain organ out of MMI.
			brainobj.forceMove(user.loc)
			brain = brainobj
			brainobj = null
		else	//Or make a new one if empty.
			brain = new(user.loc)
		brainmob.container = null//Reset brainmob mmi var.
		brainmob.forceMove(brain)//Throw mob into brain.
		brainmob.remove_from_living_mob_list() //Get outta here
		brain.brainmob = brainmob//Set the brain to use the brainmob
		brainmob = null//Set mmi brainmob var to null

		update_icon()
		SetName(initial(name))

/obj/item/device/mmi/proc/transfer_identity(mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	brainmob = new(src)
	brainmob.SetName(H.real_name)
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src

	SetName("[initial(name)]: [brainmob.real_name]")
	update_icon()
	locked = 1
	return

/obj/item/device/mmi/relaymove(mob/user, direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		rig.forced_move(direction, user)

/obj/item/device/mmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	QDEL_NULL(brainmob)
	return ..()

/obj/item/device/mmi/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	origin_tech = list(TECH_BIO = 4)

	var/obj/item/device/radio/radio = null//Let's give it a radio.


/obj/item/device/mmi/radio_enabled/New()
	..()
	radio = new(src)
	radio.broadcasting = TRUE


/obj/item/device/mmi/radio_enabled/verb/Toggle_Broadcasting()
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set category = "MMI"
	set popup_menu = FALSE
	set src = usr.loc
	if (brainmob.stat)
		to_chat(brainmob, "Can't do that while incapacitated or dead.")
	radio.listening = !radio.listening
	to_chat(brainmob, SPAN_NOTICE("Radio is [radio.broadcasting==1 ? "now" : "no longer"] broadcasting."))


/obj/item/device/mmi/radio_enabled/verb/Toggle_Listening()
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "MMI"
	set popup_menu = FALSE
	set src = usr.loc
	if (brainmob.stat)
		to_chat(brainmob, "Can't do that while incapacitated or dead.")
	radio.listening = !radio.listening
	to_chat(brainmob, SPAN_NOTICE("Radio is [radio.listening==1 ? "now" : "no longer"] receiving broadcast."))


/obj/item/device/mmi/emp_act(severity)
	if(!brainmob)
		return
	else
		switch(severity)
			if(EMP_ACT_HEAVY)
				brainmob.emp_damage += rand(20,30)
			if(EMP_ACT_LIGHT)
				brainmob.emp_damage += rand(10,20)
	..()

/obj/item/device/mmi/on_update_icon()
	icon_state = brainmob ? "mmi_full" : "mmi_empty"
