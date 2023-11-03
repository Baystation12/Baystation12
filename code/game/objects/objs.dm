/obj
	layer = OBJ_LAYER
	animate_movement = 2

	var/obj_flags

	var/list/matter //Used to store information about the contents of the object.
	var/w_class // Size of the object.
	var/unacidable = FALSE //universal "unacidabliness" var, here so you can use it in any obj.
	var/throwforce = 0
	///// whether this object cuts
	var/sharp = FALSE
	///Whether this object is more likely to dismember
	var/edge = FALSE
	///For items that can puncture e.g. thick plastic but aren't necessarily sharp. Called in can_puncture()
	var/puncture = FALSE
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/damtype = DAMAGE_BRUTE
	var/armor_penetration = 0
	var/anchor_fall = FALSE
	var/holographic = 0 //if the obj is a holographic object spawned by the holodeck

/obj/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/MouseDrop_T(atom/dropped, mob/living/user)
	// Handle tabling objects
	if (dropped != src && HAS_FLAGS(obj_flags, OBJ_FLAG_RECEIVE_TABLE) && isobj(dropped))
		var/obj/object = dropped
		if (HAS_FLAGS(object.obj_flags, OBJ_FLAG_CAN_TABLE))
			if (object.anchored)
				USE_FEEDBACK_FAILURE("\The [object] is firmly anchored and cannot be moved.")
				return TRUE
			if (!isturf(loc))
				USE_FEEDBACK_FAILURE("\The [src] must be on a turf to lift \the [dropped] onto it.")
				return TRUE
			if (!user.skill_check(SKILL_HAULING, SKILL_BASIC))
				USE_FEEDBACK_FAILURE("You're not strong enough to lift \the [dropped] onto \the [src].")
				return TRUE
			var/has_blocker = FALSE
			for (var/atom/thing as anything in get_turf(src))
				if (thing == src)
					continue
				if (ismob(thing) || thing.density)
					has_blocker = thing
					break
			if (has_blocker)
				USE_FEEDBACK_FAILURE("You can't lift \the [dropped] onto \the [src]. \The [has_blocker] is in the way.")
				return TRUE
			user.visible_message(
				SPAN_NOTICE("\The [user] starts lifting \the [dropped] onto \the [src]."),
				SPAN_NOTICE("You start lifting \the [dropped] onto \the [src].")
			)
			if (!user.do_skilled(6 SECONDS, SKILL_HAULING, src, do_flags = DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, dropped))
				return TRUE
			if (!HAS_FLAGS(obj_flags, OBJ_FLAG_RECEIVE_TABLE))
				USE_FEEDBACK_FAILURE("\The [src]'s state has changed.")
				return TRUE
			if (!HAS_FLAGS(object.obj_flags, OBJ_FLAG_CAN_TABLE))
				USE_FEEDBACK_FAILURE("\The [dropped]'s state has changed.")
				return TRUE
			if (object.anchored)
				USE_FEEDBACK_FAILURE("\The [object] is firmly anchored and cannot be moved.")
				return TRUE
			if (!isturf(loc))
				USE_FEEDBACK_FAILURE("\The [src] must be on a turf to lift \the [dropped] onto it.")
				return TRUE
			has_blocker = FALSE
			for (var/atom/thing as anything in get_turf(src))
				if (thing == src)
					continue
				if (ismob(thing) || thing.density)
					has_blocker = thing
					break
			if (has_blocker)
				USE_FEEDBACK_FAILURE("You can't lift \the [dropped] onto \the [src]. \The [has_blocker] is in the way.")
				return TRUE
			object.forceMove(loc)
			user.visible_message(
				SPAN_NOTICE("\The [user] lifts \the [dropped] onto \the [src]."),
				SPAN_NOTICE("You lift \the [dropped] onto \the [src].")
			)
			return TRUE

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

/obj/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (isWrench(tool) && HAS_FLAGS(obj_flags, OBJ_FLAG_ANCHORABLE))
		wrench_floor_bolts(user, tool)
		return TRUE
	return ..()

/**
 * Whether or not the object can be anchored in its current state/position. Assumes the anchorable flag has already been checked.
 *
 * **Parameters**:
 * - `tool` - Tool being used to un/anchor the object.
 * - `user` - User performing the interaction.
 * - `silent` (Boolean, default `FALSE`) - If set, does not send user feedback messages on failure.
 *
 * Returns boolean.
 */
/obj/proc/can_anchor(obj/item/tool, mob/user, silent = FALSE)
	if (isinspace())
		if (!silent)
			USE_FEEDBACK_FAILURE("\The [src] cannot be anchored in space.")
		return FALSE
	return TRUE


/obj/proc/wrench_floor_bolts(mob/user, obj/item/tool, delay = 2 SECONDS)
	if (!can_anchor(tool, user))
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] begins [anchored ? "un" : ""]securing \the [src] [anchored ? "from" : "to"] the floor with \a [tool]."),
		SPAN_NOTICE("You begin [anchored ? "un" : ""]securing \the [src] [anchored ? "from" : "to"] the floor with \the [tool].")
	)
	playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
	if (!user.do_skilled((tool.toolspeed * delay), SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] [anchored ? "un" : ""]secures \the [src] [anchored ? "from" : "to"] the floor with \a [tool]."),
		SPAN_NOTICE("You [anchored ? "un" : ""]secure \the [src] [anchored ? "from" : "to"] the floor with \the [tool].")
	)
	playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
	anchored = !anchored
	post_anchor_change()
	return


/**
 * Called when the object's anchor state is changed via `wrench_floor_bolts()`.
 */
/obj/proc/post_anchor_change()
	update_icon()
	return


/obj/attack_hand(mob/living/user)
	if (Adjacent(user))
		add_fingerprint(user)

	if (ishuman(user) && !isitem(src) && user.a_intent == I_HURT && get_max_health())
		var/mob/living/carbon/human/assailant = user
		var/datum/unarmed_attack/attack = assailant.get_unarmed_attack(src)
		if (!attack)
			return ..()
		assailant.do_attack_animation(src)
		assailant.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/damage = attack.damage + rand(1,5)
		var/attack_verb = "[pick(attack.attack_verb)]"

		if (!can_damage_health(damage, attack.get_damage_type()))
			playsound(loc, attack.attack_sound, 25, TRUE, -1)
			user.visible_message(
				SPAN_WARNING("\The [user] hits \the [src], but doesn't even leave a dent!"),
				SPAN_WARNING("You hit \the [src], but cause no visible damage and hurt yourself!")
			)
			user.apply_damage(3, DAMAGE_BRUTE, user.hand ? BP_L_HAND : BP_R_HAND)
			return TRUE

		playsound(loc, attack.attack_sound, 25, TRUE, -1)
		assailant.visible_message(
				SPAN_WARNING("\The [assailant] [attack_verb] \the [src]!"),
				SPAN_WARNING("You [attack_verb] \the [src]!")
				)
		damage_health(damage, attack.get_damage_type(), attack.damage_flags())
		return
	..()

/obj/is_fluid_pushable(amt)
	return ..() && w_class <= round(amt/20)

/obj/proc/can_embed()
	return is_sharp(src)

/obj/AltClick(mob/user)
	if(obj_flags & OBJ_FLAG_ROTATABLE)
		rotate(user)
		return TRUE
	return ..()

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

/obj/get_mass()
	return min(2**(w_class-1), 100)
