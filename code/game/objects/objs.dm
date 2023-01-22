/obj
	layer = OBJ_LAYER
	animate_movement = 2

	var/obj_flags

	var/list/matter //Used to store information about the contents of the object.
	var/w_class // Size of the object.
	var/unacidable = FALSE //universal "unacidabliness" var, here so you can use it in any obj.
	var/throwforce = 1
	var/sharp = FALSE		// whether this object cuts
	var/edge = FALSE		// whether this object is more likely to dismember
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/damtype = DAMAGE_BRUTE
	var/armor_penetration = 0
	var/anchor_fall = FALSE
	var/holographic = 0 //if the obj is a holographic object spawned by the holodeck

/obj/proc/eject_item(obj/item/I, mob/living/user)
	if(!I || !user.IsAdvancedToolUser())
		return FALSE
	user.put_in_hands(I)
	playsound(src.loc, 'sound/weapons/guns/interaction/hpistol_magin.ogg', 75, 1)
	user.visible_message(
		"[user] removes [I] from [src].",
		SPAN_NOTICE("You remove [I] from [src].")
	)
	return TRUE

/obj/proc/insert_item(obj/item/I, mob/living/user)
	if(!I || !user.unEquip(I))
		return FALSE
	I.forceMove(src)
	playsound(src.loc, 'sound/weapons/guns/interaction/hpistol_magout.ogg', 75, 1)
	to_chat(user, SPAN_NOTICE("You insert [I] into [src]."))
	return TRUE

/obj/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src) | usr
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				if(CanUseTopic(M, DefaultTopicState()) > STATUS_CLOSE)
					is_in_use = 1
					interact(M)
				else
					M.unset_machine()
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				if(CanUseTopic(M, DefaultTopicState()) > STATUS_CLOSE)
					is_in_use = 1
					interact(M)
				else
					M.unset_machine()
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	ui_interact(user)
	..()

/obj/proc/interact(mob/user)
	return

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(var/hide)
	set_invisibility(hide ? INVISIBILITY_MAXIMUM : initial(invisibility))

/obj/proc/hides_under_flooring()
	return level == 1

/obj/proc/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return

/obj/proc/see_emote(mob/M as mob, text, var/emote_type)
	return

/obj/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/obj/proc/damage_flags()
	. = 0
	if(has_edge(src))
		. |= DAMAGE_FLAG_EDGE
	if(is_sharp(src))
		. |= DAMAGE_FLAG_SHARP
		if (damtype == DAMAGE_BURN)
			. |= DAMAGE_FLAG_LASER

/obj/attackby(obj/item/O, mob/user)
	if(obj_flags & OBJ_FLAG_ANCHORABLE)
		if(isWrench(O))
			wrench_floor_bolts(user)
			update_icon()
			return
	return ..()

/obj/proc/wrench_floor_bolts(mob/user, delay=20)
	playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
	if(anchored)
		user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
	else
		user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
	if(do_after(user, delay, src, DO_PUBLIC_UNIQUE))
		if(!src) return
		to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
		anchored = !anchored
	return 1

/obj/attack_hand(mob/living/user)
	if(Adjacent(user))
		add_fingerprint(user)
	..()

/obj/is_fluid_pushable(var/amt)
	return ..() && w_class <= round(amt/20)

/obj/proc/can_embed()
	return is_sharp(src)

/obj/AltClick(mob/user)
	if(obj_flags & OBJ_FLAG_ROTATABLE)
		rotate(user)
	..()

/obj/examine(mob/user)
	. = ..()
	if((obj_flags & OBJ_FLAG_ROTATABLE))
		to_chat(user, SPAN_SUBTLE("Can be rotated with alt-click."))

/obj/proc/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	if(anchored)
		to_chat(user, SPAN_NOTICE("\The [src] is secured to the floor!"))
		return

	set_dir(turn(dir, 90))
	update_icon()

//For things to apply special effects after damaging an organ, called by organ's take_damage
/obj/proc/after_wounding(obj/item/organ/external/organ, datum/wound)

/**
 * Test for if stepping on a tile containing this obj is safe to do, used for things like landmines and cliffs.
 */
/obj/proc/is_safe_to_step(mob/living/L)
	return TRUE
