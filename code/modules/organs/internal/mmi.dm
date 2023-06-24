/obj/item/organ/internal/mmi
	name = "\improper Man-Machine Interface"
	desc = "A complex life support shell that interfaces between a brain and electronic devices."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi0"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_BIO = 4, TECH_ENGINEERING = 4, TECH_DATA = 4)
	status = ORGAN_ROBOTIC
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = FALSE
	max_damage = 75
	min_bruised_damage = 25
	min_broken_damage = 50
	relative_size = 95
	req_access = list(access_robotics)

	var/locked = FALSE
	var/obj/item/organ/internal/brain/brain


/obj/item/organ/internal/mmi/Destroy()
	if (istype(loc, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/robot = loc
		robot.mmi = null
	QDEL_NULL(brain)
	return ..()


/obj/item/organ/internal/mmi/Initialize()
	. = ..()
	if (istype(loc, /mob/living/carbon/human))
		steal_brain(loc)


/obj/item/organ/internal/mmi/on_update_icon()
	icon_state = "mmi[!!brain]"


/obj/item/organ/internal/mmi/attackby(obj/item/item, mob/living/user)
	. = TRUE
	if (istype(item, /obj/item/organ/internal/brain))
		if (locked)
			to_chat(user, SPAN_WARNING("\The [src] is locked."))
			return
		if (brain)
			to_chat(user, SPAN_WARNING("\The [src] is occupied."))
			return
		var/obj/item/organ/internal/brain/candidate = item
		if (!candidate.can_use_mmi)
			to_chat(user, SPAN_WARNING("\The [item] is not a suitable candidate."))
			return
		user.visible_message(
			SPAN_ITALIC("\The [user] inserts \a [candidate] into \a [src]."),
			SPAN_ITALIC("You insert \the [candidate] into \the [src]."),
			range = 5
		)
		brain = candidate
		brain.forceMove(src)
		var/mob/living/carbon/brain/brainmob = brain.brainmob
		if (brainmob)
			brainmob.container = src
			brainmob.set_stat(CONSCIOUS)
			brainmob.switch_from_dead_to_living_mob_list()
		update_icon()
		return
	if (istype(item, /obj/item/card/id) || istype(item, /obj/item/modular_computer))
		var/success = allowed(user)
		var/user_message
		if (success)
			locked = !locked
			user_message = SPAN_NOTICE("You [locked ? "lock" : "unlock"] \the [src].")
		else
			user_message = SPAN_WARNING("You fail to [!locked ? "lock" : "unlock"] \the [src].")
		user.visible_message(
			SPAN_ITALIC("\The [user] swipes \a [item] across \a [src]."),
			user_message,
			range = 5
		)
		return
	return ..()


/obj/item/organ/internal/mmi/attack_self(mob/living/user)
	if (locked)
		to_chat(user, SPAN_WARNING("\The [src] is locked."))
		return
	if (!brain)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return
	var/mob/living/carbon/brain/brainmob = brain.brainmob
	if (brainmob)
		brainmob.container = null
		brainmob.remove_from_living_mob_list()
	user.put_in_hands(brain)
	brain = null
	update_icon()


/obj/item/organ/internal/mmi/relaymove(mob/user, direction)
	if (user.stat || user.stunned)
		return
	var/obj/item/rig/rig = get_rig()
	if(rig)
		rig.forced_move(direction, user)


/obj/item/organ/internal/mmi/emp_act(severity)
	var/mob/living/carbon/brain/brainmob = brain.brainmob
	if (brainmob)
		switch (severity)
			if (EMP_ACT_HEAVY)
				brainmob.emp_damage += rand(20, 30)
			if (EMP_ACT_LIGHT)
				brainmob.emp_damage += rand(10, 20)
	..()


/obj/item/organ/internal/mmi/Process()
	..()
	if (owner?.is_asystole())
		take_internal_damage(0.5)


/obj/item/organ/internal/mmi/handle_regeneration()
	if (!damage || !owner || owner.is_asystole())
		return
	if (damage < 0.1 * max_damage)
		heal_damage(0.1)
		if(brain)
			brain.heal_damage(0.1)


/obj/item/organ/internal/mmi/take_internal_damage(amount, silent)
	..()
	if (brain)
		brain.take_internal_damage(amount)


/obj/item/organ/internal/mmi/die()
	..()
	if (brain)
		brain.die()


/obj/item/organ/internal/mmi/proc/removed()
	if (istype(owner) && src == owner.internal_organs[BP_BRAIN])
		var/mob/living/carbon/brain/brainmob = brain?.brainmob
		var/datum/mind/mind = owner?.mind
		if (mind && brainmob)
			mind.transfer_to(brainmob)
	..()


/obj/item/organ/internal/mmi/replaced(mob/living/carbon/human/human)
	. = ..()
	if (!.)
		return
	if (human.ckey)
		human.ghostize()
	var/mob/living/carbon/brain/brainmob = brain?.brainmob
	var/datum/mind/mind = brainmob?.mind
	if (mind)
		mind.transfer_to(human)
	else
		target.ckey = brainmob?.ckey
	return TRUE


/obj/item/organ/internal/mmi/proc/steal_brain(mob/living/carbon/human/human)
	QDEL_NULL(brain)
	if (!istype(human))
		return
	brain = human?.internal_organs[BP_BRAIN]
	if (!istype(brain))
		brain = null
		return
	brain.removed(human)
	brain.forceMove(src)
	if (brain.brainmob)
		brain.brainmob.container = src
	update_icon()


/obj/item/organ/internal/mmi/radio
	var/obj/item/device/radio/radio


/obj/item/organ/internal/mmi/radio/Initialize()
	. = ..()
	radio = new (src)
	radio.broadcasting = TRUE


/obj/item/organ/internal/mmi/radio/verb/ToggleBroadcast()
	set name = "Toggle Radio Broadcast"
	set category = "MMI"
	set popup_menu = FALSE
	set src = usr.loc
	if (brain?.brainmob?.stat != CONSCIOUS)
		return
	radio.broadcasting = !radio.broadcasting
	to_chat(brainmob, SPAN_ITALIC("Radio receive [radio.broadcasting ? "enabled" : "disabled"]."))


/obj/item/organ/internal/mmi/radio/verb/ToggleReceive()
	set name = "Toggle Radio Receive"
	set category = "MMI"
	set popup_menu = FALSE
	set src = usr.loc
	if (brain?.brainmob?.stat != CONSCIOUS)
		return
	radio.listening = !radio.listening
	to_chat(brainmob, SPAN_ITALIC("Radio receive [radio.listening ? "enabled" : "disabled"]."))
