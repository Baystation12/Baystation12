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

/mob/proc/set_machine(obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(hide)
	set_invisibility(hide ? INVISIBILITY_MAXIMUM : initial(invisibility))

/obj/proc/hides_under_flooring()
	return level == ATOM_LEVEL_UNDER_TILE

/obj/proc/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = SPAN_CLASS("game say", "[SPAN_CLASS("name", "[M.name]: ")] [SPAN_CLASS("message", text))]"
		mo.show_message(rendered, 2)
		*/
	return

/obj/proc/see_emote(mob/M as mob, text, emote_type)
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


/obj/get_interactions_info()
	. = ..()
	if (HAS_FLAGS(initial(obj_flags), OBJ_FLAG_ANCHORABLE))
		.[CODEX_INTERACTION_WRENCH] = "<p>Anchors and unanchors the object after a short timer. When unanchored, the object can be moved.</p>"



/obj/use_tool(obj/item/tool, mob/user, list/click_params)
	// Wrench - Toggle anchored
	if (isWrench(tool) && can_wrench_bolts(tool, user))
		wrench_floor_bolts(tool, user)
		return TRUE

	return ..()


/**
 * Checks if the object can have its bolts toggled by a wrench. By default, this only checks `obj_flags` for `OBJ_FLAG_ANCHORABLE`.
 *
 * **Parameters**:
 * - `tool` - The tool used to wrench the object.
 * - `user` - The mob attempting the wrenching.
 * - `silent` (Boolean, default `FALSE`) - If set, does not send feedback messages to `user`.
 *
 * Returns boolean.
 */
/obj/proc/can_wrench_bolts(obj/item/tool, mob/user, silent = FALSE)
	if (!HAS_FLAGS(obj_flags, OBJ_FLAG_ANCHORABLE))
		return FALSE
	return TRUE


/**
 * Handles toggling the anchored state using a wrench. Performs no pre-checks.
 *
 * **Parameters**:
 * - `tool` - The item used to perform the wrenching.
 * - `user` - The mob performing the wrenching.
 * - `delay` (Integer. Default `2 SECONDS`) - Time used for the do_after call.
 */
/obj/proc/wrench_floor_bolts(obj/item/tool, mob/user, delay = 2 SECONDS)
	playsound(loc, 'sound/items/Ratchet.ogg', 50, TRUE)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts [anchored ? "unsecuring" : "securing"] \the [src] [anchored ? "from" : "to"] the floor with \a [tool]."),
		SPAN_NOTICE("You start [anchored ? "unsecuring" : "securing"] \the [src] [anchored ? "from" : "to"] the floor with \the [tool].")
	)
	if (!do_after(user, delay, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool))
		return
	playsound(loc, 'sound/items/Ratchet.ogg', 50, TRUE)
	user.visible_message(
		SPAN_NOTICE("\The [user] [anchored ? "unsecures" : "secures"] \the [src] [anchored ? "from" : "to"] the floor with \a [tool]."),
		SPAN_NOTICE("You [anchored ? "unsecure" : "secure"] \the [src] [anchored ? "from" : "to"] the floor with \the [tool].")
	)
	anchored = !anchored
	update_icon()


/obj/attack_hand(mob/living/user)
	if(Adjacent(user))
		add_fingerprint(user)
	..()

/obj/is_fluid_pushable(amt)
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
