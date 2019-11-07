
/obj/item/grab
	name = "grab"
	canremove = 0

	var/mob/living/carbon/human/affecting = null
	var/mob/living/carbon/human/assailant = null

	var/datum/grab/current_grab
	var/type_name
	var/start_grab_name

	var/last_action
	var/last_upgrade

	var/special_target_functional = 1

	var/attacking = 0
	var/target_zone
	var/done_struggle = FALSE // Used by struggle grab datum to keep track of state.

	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = ITEM_SIZE_NO_CONTAINER
/*
	This section is for overrides of existing procs.
*/
/obj/item/grab/Initialize(mapload, mob/living/carbon/human/victim)
	. = ..()
	current_grab = all_grabstates[start_grab_name]

	assailant = loc
	if(!istype(assailant))
		return INITIALIZE_HINT_QDEL
	affecting = victim
	if(!istype(affecting))
		return INITIALIZE_HINT_QDEL
	target_zone = assailant.zone_sel.selecting
	assailant.remove_cloaking_source(assailant.species)

	if(!can_grab())
		return INITIALIZE_HINT_QDEL
	if(!init())
		return INITIALIZE_HINT_QDEL

	var/obj/item/organ/O = get_targeted_organ()
	SetName("[name] ([O.name])")
	GLOB.dismembered_event.register(affecting, src, .proc/on_organ_loss)
	GLOB.zone_selected_event.register(assailant.zone_sel, src, .proc/on_target_change)

/obj/item/grab/examine(mob/user)
	. = ..()
	var/obj/item/O = get_targeted_organ()
	to_chat(user, "A grab on \the [affecting]'s [O.name].")

/obj/item/grab/Process()
	current_grab.process(src)

/obj/item/grab/attack_self(mob/user)
	switch(assailant.a_intent)
		if(I_HELP)
			downgrade()
		else
			upgrade()

/obj/item/grab/attack(mob/M, mob/living/user)

	// Relying on BYOND proc ordering isn't working, so go go ugly workaround.
	if(ishuman(user) && affecting == M)
		var/mob/living/carbon/human/H = user
		if(H.check_psi_grab(src))
			return
	// End workaround

	current_grab.hit_with_grab(src)

/obj/item/grab/resolve_attackby(atom/A, mob/user, var/click_params)
	assailant.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!A.grab_attack(src))
		return ..()
	action_used()
	if (current_grab.downgrade_on_action)
		downgrade()
	return TRUE

/obj/item/grab/dropped()
	..()
	if(!QDELETED(src))
		qdel(src)

/obj/item/grab/can_be_dropped_by_client(mob/M)
	if(M == assailant)
		return TRUE

/obj/item/grab/Destroy()
	if(affecting)
		GLOB.dismembered_event.unregister(affecting, src)
		reset_position()
		affecting.grabbed_by -= src
		affecting.reset_plane_and_layer()
		affecting = null
	if(assailant)
		GLOB.zone_selected_event.unregister(assailant.zone_sel, src)
		assailant = null
	return ..()

/*
	This section is for newly defined useful procs.
*/

/obj/item/grab/proc/on_target_change(obj/screen/zone_sel/zone, old_sel, new_sel)
	if(src != assailant.get_active_hand())
		return // Note that because of this condition, there's no guarantee that target_zone = old_sel
	if(target_zone == new_sel)
		return
	var/old_zone = target_zone
	target_zone = new_sel
	if(!istype(get_targeted_organ(), /obj/item/organ))
		current_grab.let_go(src)
		return
	current_grab.on_target_change(src, old_zone, target_zone)

/obj/item/grab/proc/on_organ_loss(mob/victim, obj/item/organ/lost)
	if(affecting != victim)
		crash_with("A grab switched affecting targets without properly re-registering for dismemberment updates.")
		return
	var/obj/item/organ/O = get_targeted_organ()
	if(!istype(O))
		current_grab.let_go(src)
		return // Sanity check in case the lost organ was improperly removed elsewhere in the code.
	if(lost != O)
		return
	current_grab.let_go(src)

/obj/item/grab/proc/force_drop()
	assailant.drop_from_inventory(src)

/obj/item/grab/proc/can_grab()
	if(!assailant.Adjacent(affecting))
		return 0
	if(assailant.anchored || affecting.anchored)
		return 0
	if(assailant.get_active_hand())
		to_chat(assailant, "<span class='notice'>You can't grab someone if your hand is full.</span>")
		return 0
	if(assailant.grabbed_by.len)
		to_chat(assailant, "<span class='notice'>You can't grab someone if you're being grabbed.</span>")
		return 0
	var/obj/item/organ/organ = get_targeted_organ()
	if(!istype(organ))
		to_chat(assailant, "<span class='notice'>\The [affecting] is missing that body part!</span>")
		return 0
	if(assailant == affecting)
		if(!current_grab.can_grab_self)	//let's not nab ourselves
			to_chat(assailant, "<span class='notice'>You can't grab yourself!</span>")
			return 0
		var/list/bad_parts = assailant.hand ? list(BP_L_ARM, BP_L_HAND) :  list(BP_R_ARM, BP_R_HAND)
		if(organ.organ_tag in bad_parts)
			to_chat(assailant, "<span class='notice'>You can't grab your own [organ.name] with itself!</span>")
			return 0
	for(var/obj/item/grab/G in affecting.grabbed_by)
		if(G.assailant == assailant && G.target_zone == target_zone)
			var/obj/O = G.get_targeted_organ()
			to_chat(assailant, "<span class='notice'>You already grabbed [affecting]'s [O.name].</span>")
			return 0
	return 1

// This will run from Initialize, after can_grab and other checks have succeeded. Must call parent; returning FALSE means failure and qdels the grab.
/obj/item/grab/proc/init()
	if(!assailant.put_in_active_hand(src))
		return FALSE // This should succeed as we checked the hand, but if not we abort here.
	affecting.UpdateLyingBuckledAndVerbStatus()
	affecting.grabbed_by += src // This is how we handle affecting being deleted.
	adjust_position()
	action_used()
	if(affecting.w_uniform)
		affecting.w_uniform.add_fingerprint(assailant)
	assailant.do_attack_animation(affecting)
	playsound(affecting.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	update_icon()
	return TRUE

// Returns the organ of the grabbed person that the grabber is targeting
/obj/item/grab/proc/get_targeted_organ()
	return (affecting.get_organ(target_zone))

/obj/item/grab/proc/resolve_item_attack(var/mob/living/M, var/obj/item/I, var/target_zone)
	if((M && ishuman(M)) && I)
		return current_grab.resolve_item_attack(src, M, I, target_zone)
	else
		return 0

/obj/item/grab/proc/action_used()
	assailant.remove_cloaking_source(assailant.species)
	last_action = world.time
	leave_forensic_traces()

/obj/item/grab/proc/check_action_cooldown()
	return (world.time >= last_action + current_grab.action_cooldown)

/obj/item/grab/proc/check_upgrade_cooldown()
	return (world.time >= last_upgrade + current_grab.upgrade_cooldown)

/obj/item/grab/proc/leave_forensic_traces()
	var/obj/item/clothing/C = affecting.get_covering_equipped_item_by_zone(target_zone)
	if(istype(C))
		C.leave_evidence(assailant)
		if(prob(50))
			C.ironed_state = WRINKLES_WRINKLY

/obj/item/grab/proc/upgrade(var/bypass_cooldown = FALSE)
	if(!check_upgrade_cooldown() && !bypass_cooldown)
		to_chat(assailant, "<span class='danger'>It's too soon to upgrade.</span>")
		return

	var/datum/grab/upgrab = current_grab.upgrade(src)
	if(upgrab)
		current_grab = upgrab
		last_upgrade = world.time
		adjust_position()
		update_icon()
		leave_forensic_traces()
		current_grab.enter_as_up(src)

/obj/item/grab/proc/downgrade()
	var/datum/grab/downgrab = current_grab.downgrade(src)
	if(downgrab)
		current_grab = downgrab
		update_icon()

/obj/item/grab/on_update_icon()
	if(current_grab.icon)
		icon = current_grab.icon
	if(current_grab.icon_state)
		icon_state = current_grab.icon_state

/obj/item/grab/proc/draw_affecting_over()
	affecting.plane = assailant.plane
	affecting.layer = assailant.layer + 0.01

/obj/item/grab/proc/draw_affecting_under()
	affecting.plane = assailant.plane
	affecting.layer = assailant.layer - 0.01


/obj/item/grab/proc/throw_held()
	return current_grab.throw_held(src)

/obj/item/grab/proc/handle_resist()
	current_grab.handle_resist(src)

/obj/item/grab/proc/adjust_position(var/force = 0)
	if(force)	affecting.forceMove(assailant.loc)

	if(!assailant || !affecting || !assailant.Adjacent(affecting))
		qdel(src)
		return 0
	else
		current_grab.adjust_position(src)

/obj/item/grab/proc/reset_position()
	current_grab.reset_position(src)

/*
	This section is for the simple procs used to return things from current_grab.
*/
/obj/item/grab/proc/stop_move()
	return current_grab.stop_move

/obj/item/grab/proc/force_stand()
	return current_grab.force_stand

/obj/item/grab/attackby(obj/W, mob/user)
	if(user == assailant)
		current_grab.item_attack(src, W)

/obj/item/grab/proc/can_absorb()
	return current_grab.can_absorb

/obj/item/grab/proc/assailant_reverse_facing()
	return current_grab.reverse_facing

/obj/item/grab/proc/shield_assailant()
	return current_grab.shield_assailant

/obj/item/grab/proc/point_blank_mult()
	return current_grab.point_blank_mult

/obj/item/grab/proc/damage_stage()
	return current_grab.damage_stage

/obj/item/grab/proc/force_danger()
	return current_grab.force_danger

/obj/item/grab/proc/grab_slowdown()
	return current_grab.grab_slowdown

/obj/item/grab/proc/ladder_carry()
	return current_grab.ladder_carry

/obj/item/grab/proc/assailant_moved()
	current_grab.assailant_moved(src)

/obj/item/grab/proc/restrains()
	return current_grab.restrains

/obj/item/grab/proc/resolve_openhand_attack()
		return current_grab.resolve_openhand_attack(src)

