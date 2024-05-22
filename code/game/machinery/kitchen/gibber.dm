
/obj/machinery/gibber
	name = "meat grinder"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "grinder"
	density = TRUE
	anchored = TRUE
	req_access = list(access_kitchen,access_morgue)
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	machine_name = "meat grinder"
	machine_desc = "Messily turns animals - living or dead - into edible meat. Installed safety mechanisms prevent use on humans."

	var/operating = 0        //Is it on?
	var/dirty = 0            // Does it need cleaning?
	var/mob/living/occupant  // Mob who has been put inside
	var/gib_time = 40        // Time from starting until meat appears
	var/gib_throw_dir = WEST // Direction to spit meat and gibs in.

	idle_power_usage = 2
	active_power_usage = 500

/obj/machinery/gibber/Initialize()
	. = ..()
	update_icon()

/obj/machinery/gibber/Destroy()
	if(occupant)
		occupant.dropInto(loc)
		occupant = null
	. = ..()

/obj/machinery/gibber/on_update_icon()
	ClearOverlays()
	if (dirty)
		AddOverlays(image('icons/obj/machines/kitchen.dmi', "grbloody"))
	if(inoperable())
		return
	if (!occupant)
		AddOverlays(image('icons/obj/machines/kitchen.dmi', "grjam"))
	else if (operating)
		AddOverlays(image('icons/obj/machines/kitchen.dmi', "gruse"))
	else
		AddOverlays(image('icons/obj/machines/kitchen.dmi', "gridle"))

/obj/machinery/gibber/relaymove(mob/user as mob)
	src.go_out()
	return

/obj/machinery/gibber/physical_attack_hand(mob/user)
	if(operating)
		to_chat(user, SPAN_WARNING("\The [src] is locked and running, wait for it to finish."))
		return TRUE
	startgibbing(user)
	return TRUE

/obj/machinery/gibber/examine(mob/user)
	. = ..()
	to_chat(user, "The safety guard is [emagged ? SPAN_DANGER("disabled") : "enabled"].")

/obj/machinery/gibber/emag_act(remaining_charges, mob/user)
	emagged = !emagged
	to_chat(user, SPAN_DANGER("You [emagged ? "disable" : "enable"] \the [src]'s safety guard."))
	return 1

/obj/machinery/gibber/components_are_accessible(path)
	return !operating && ..()

/obj/machinery/gibber/cannot_transition_to(state_path, mob/user)
	if(operating)
		return SPAN_NOTICE("You must wait for \the [src] to finish operating first!")
	return ..()

/obj/machinery/gibber/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(!operating)
		return TRUE

	if (istype(W, /obj/item/organ))
		if(!user.unEquip(W))
			return TRUE
		qdel(W)
		user.visible_message(SPAN_DANGER("\The [user] feeds \the [W] into \the [src], obliterating it."))
		return TRUE

	return ..()

/obj/machinery/gibber/user_can_move_target_inside(mob/target, mob/user)
	if (occupant)
		to_chat(user, SPAN_WARNING("\The [src] is already occupied!"))
		return FALSE
	if (operating)
		to_chat(user, SPAN_WARNING("\The [src] is locked and running, wait for it to finish."))
		return FALSE
	if (!(istype(target, /mob/living/carbon)) && !(istype(target, /mob/living/simple_animal)) )
		to_chat(user, SPAN_WARNING("\The [target] is not suitable for \the [src]!"))
		return FALSE
	if (istype(target,/mob/living/carbon/human) && !emagged)
		to_chat(user, SPAN_WARNING("\The [src] safety guard is engaged!"))
		return FALSE
	return ..()

/obj/machinery/gibber/use_grab(obj/item/grab/grab, list/click_params)
	if (!user_can_move_target_inside(grab.affecting, grab.assailant))
		return TRUE
	if (!grab.force_danger())
		to_chat(grab.assailant, SPAN_WARNING("You need a better grip to do that!"))
		return TRUE
	move_into_gibber(grab.assailant, grab.affecting)
	return TRUE

/obj/machinery/gibber/MouseDrop_T(mob/target, mob/user)
	if (!ismob(target) || !CanMouseDrop(target, user))
		return
	if (user == target && user_can_move_target_inside(target, user))
		move_into_gibber(user, target)
		return
	else
		to_chat(user, SPAN_WARNING("You need to grab \the [target] to be able to do that!"))
		return

/obj/machinery/gibber/proc/move_into_gibber(mob/user, mob/living/victim)
	user.visible_message(SPAN_DANGER("\The [user] starts to put \the [victim] into \the [src]!"))
	add_fingerprint(user)
	if(do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE) && victim.Adjacent(src) && user.Adjacent(src) && victim.Adjacent(user) && !occupant)
		user.visible_message(SPAN_DANGER("\The [user] stuffs \the [victim] into \the [src]!"))
		if(victim.client)
			victim.client.perspective = EYE_PERSPECTIVE
			victim.client.eye = src
		victim.forceMove(src)
		victim.remove_grabs_and_pulls()
		occupant = victim
		if (user != victim)
			add_fingerprint(victim)
		GLOB.destroyed_event.register(occupant, src, PROC_REF(occupant_destroyed))
		update_icon()

/obj/machinery/gibber/proc/occupant_destroyed(mob/_occupant)
	if (occupant == _occupant)
		occupant = null
		update_icon()
	GLOB.destroyed_event.unregister(_occupant, src, PROC_REF(occupant_destroyed))

/obj/machinery/gibber/verb/eject()
	set category = "Object"
	set name = "Empty Gibber"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	if(operating || !src.occupant)
		return
	for(var/obj/O in (contents - component_parts))
		O.dropInto(loc)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	GLOB.destroyed_event.unregister(occupant, src, PROC_REF(occupant_destroyed))
	src.occupant.dropInto(loc)
	src.occupant = null
	update_icon()
	return

/obj/machinery/gibber/proc/startgibbing(mob/user as mob)
	if (operating)
		return
	if (!occupant)
		visible_message(SPAN_WARNING("You hear metallic gears click harmlessly."))
		return

	use_power_oneoff(1000)
	visible_message(SPAN_DANGER("You hear a loud [occupant.isSynthetic() ? "metallic" : "squelchy"] grinding sound."))
	src.operating = 1
	update_icon()

	admin_attack_log(user, occupant, "Gibbed the victim", "Was gibbed", "gibbed")
	src.occupant.ghostize()
	addtimer(new Callback(src, PROC_REF(finish_gibbing)), gib_time)

	var/list/gib_products = shuffle(occupant.harvest_meat() | occupant.harvest_skin() | occupant.harvest_bones())
	if(length(gib_products) <= 0)
		return

	var/slab_name =  occupant.name
	var/slab_nutrition = 20

	if(iscarbon(occupant))
		var/mob/living/carbon/C = occupant
		slab_nutrition = C.nutrition / 15

	if(istype(occupant, /mob/living/carbon/human))
		slab_name = occupant.real_name

	// Small mobs don't give as much nutrition.
	if(issmall(src.occupant))
		slab_nutrition *= 0.5

	slab_nutrition /= length(gib_products)

	var/drop_products = floor(length(gib_products) * 0.35)
	for(var/atom/movable/thing in gib_products)
		if(drop_products)
			drop_products--
			qdel(thing)
		else
			thing.forceMove(src)
			if(istype(thing, /obj/item/reagent_containers/food/snacks/meat))
				var/obj/item/reagent_containers/food/snacks/meat/slab = thing
				slab.SetName("[slab_name] [slab.name]")
				slab.reagents.add_reagent(/datum/reagent/nutriment,slab_nutrition)

/obj/machinery/gibber/proc/finish_gibbing()
	operating = 0
	if (occupant)
		occupant.gib()
		qdel(occupant)

	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
	for (var/obj/thing in (contents - component_parts))
		// There's a chance that the gibber will fail to destroy some evidence.
		if(istype(thing,/obj/item/organ) && prob(80))
			qdel(thing)
			continue
		thing.dropInto(loc) // Attempts to drop it onto the turf for throwing.
		thing.throw_at(get_edge_target_turf(src,gib_throw_dir),rand(0,3),emagged ? 30 : 15) // Being pelted with bits of meat and bone would hurt.
	update_icon()
