/obj/structure/railing
	name = "railing"
	desc = "A simple bar railing designed to protect against careless trespass."
	icon = 'icons/obj/railing.dmi'
	icon_state = "railing_preview"
	density = TRUE
	throwpass = 1
	layer = OBJ_LAYER
	climb_speed_mult = 0.25
	anchored = FALSE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CHECKS_BORDER | ATOM_FLAG_CLIMBABLE | ATOM_FLAG_CAN_BE_PAINTED
	obj_flags = OBJ_FLAG_ROTATABLE
	health_max = 70

	var/broken =    FALSE
	var/neighbor_status = 0
	/// Color code. If set, the railing will be painted this color on init. Primarily used for mapping variants.
	var/init_color

/obj/structure/railing/mapped
	material = MATERIAL_ALUMINIUM
	anchored = TRUE
	init_color = COLOR_GUNMETAL

/obj/structure/railing/mapped/no_density
	density = FALSE

/obj/structure/railing/mapped/no_density/Initialize()
	. = ..()
	update_icon()

/obj/structure/railing/Process()
	if(!material || !material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_damage(round(material.radioactivity/20), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/obj/structure/railing/Initialize(mapload, material_key)
	. = ..()

	if (material_key)
		material = material_key
	if (!material)
		material = DEFAULT_FURNITURE_MATERIAL
	if(!isnull(material) && !istype(material))
		material = SSmaterials.get_material_by_name(material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL

	name = "[material.display_name] [initial(name)]"
	desc = "A simple [material.display_name] railing designed to protect against careless trespass."
	set_max_health(material.integrity / 5)
	color = material.icon_colour

	if(material.products_need_process())
		START_PROCESSING(SSobj, src)
	if(material.conductive)
		obj_flags |= OBJ_FLAG_CONDUCTIBLE
	else
		obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)

	if (init_color)
		set_color(init_color)

	update_icon(FALSE)

/obj/structure/railing/Destroy()
	NeighborsCheck(TRUE)
	. = ..()

/obj/structure/railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!istype(mover) || mover.checkpass(PASS_FLAG_TABLE))
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/railing/on_death()
	visible_message(SPAN_DANGER("\The [src] [material.destruction_desc]!"))
	playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
	material.place_shard(get_turf(usr))
	qdel(src)

/obj/structure/railing/proc/NeighborsCheck(UpdateNeighbors = 1)
	neighbor_status = 0
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)

	for(var/obj/structure/railing/R in src.loc)
		if (QDELETED(R))
			continue
		if ((R.dir == Lturn) && R.anchored)
			neighbor_status |= 32
			if (UpdateNeighbors)
				R.update_icon(0)
		if ((R.dir == Rturn) && R.anchored)
			neighbor_status |= 2
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, Lturn))
		if (QDELETED(R))
			continue
		if ((R.dir == src.dir) && R.anchored)
			neighbor_status |= 16
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, Rturn))
		if (QDELETED(R))
			continue
		if ((R.dir == src.dir) && R.anchored)
			neighbor_status |= 1
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))
		if (QDELETED(R))
			continue
		if ((R.dir == Rturn) && R.anchored)
			neighbor_status |= 64
			if (UpdateNeighbors)
				R.update_icon(0)
	for (var/obj/structure/railing/R in get_step(src, (Rturn + src.dir)))
		if (QDELETED(R))
			continue
		if ((R.dir == Lturn) && R.anchored)
			neighbor_status |= 4
			if (UpdateNeighbors)
				R.update_icon(0)

/obj/structure/railing/on_update_icon(update_neighbors = TRUE)
	NeighborsCheck(update_neighbors)
	overlays.Cut()
	if (!neighbor_status || !anchored)
		icon_state = "railing0-[density]"
		if (density)//walking over a railing which is above you is really weird, do not do this if density is 0
			overlays += image(icon, "_railing0-1", layer = ABOVE_HUMAN_LAYER)
	else
		icon_state = "railing1-[density]"
		if (density)
			overlays += image(icon, "_railing1-1", layer = ABOVE_HUMAN_LAYER)
		if (neighbor_status & 32)
			overlays += image(icon, "corneroverlay[density]")
		if ((neighbor_status & 16) || !(neighbor_status & 32) || (neighbor_status & 64))
			overlays += image(icon, "frontoverlay_l[density]")
			if (density)
				overlays += image(icon, "_frontoverlay_l1", layer = ABOVE_HUMAN_LAYER)
		if (!(neighbor_status & 2) || (neighbor_status & 1) || (neighbor_status & 4))
			overlays += image(icon, "frontoverlay_r[density]")
			if (density)
				overlays += image(icon, "_frontoverlay_r1", layer = ABOVE_HUMAN_LAYER)
			if(neighbor_status & 4)
				var/pix_offset_x = 0
				var/pix_offset_y = 0
				switch(dir)
					if(NORTH)
						pix_offset_x = 32
					if(SOUTH)
						pix_offset_x = -32
					if(EAST)
						pix_offset_y = -32
					if(WEST)
						pix_offset_y = 32
				overlays += image(icon, "mcorneroverlay[density]", pixel_x = pix_offset_x, pixel_y = pix_offset_y)
				if (density)
					overlays += image(icon, "_mcorneroverlay1", pixel_x = pix_offset_x, pixel_y = pix_offset_y, layer = ABOVE_HUMAN_LAYER)

/obj/structure/railing/verb/flip() // This will help push railing to remote places, such as open space turfs
	set name = "Flip Railing"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, SPAN_WARNING("It is fastened to the floor and cannot be flipped."))
		return 0

	if(!turf_is_crowded())
		to_chat(usr, SPAN_WARNING("You can't flip \the [src] - something is in the way."))
		return 0

	forceMove(get_step(src, src.dir))
	set_dir(turn(dir, 180))
	update_icon()

/obj/structure/railing/CheckExit(atom/movable/O, turf/target)
	if(istype(O) && O.checkpass(PASS_FLAG_TABLE))
		return 1
	if(get_dir(O.loc, target) == dir)
		if(!density)
			return 1
		return 0
	return 1


/obj/structure/railing/use_grab(obj/item/grab/grab, list/click_params)
	var/obj/occupied = turf_is_crowded()
	if (occupied)
		USE_FEEDBACK_GRAB_FAILURE(SPAN_WARNING("There's \a [occupied] blocking \the [src]."))
		return TRUE

	if (!grab.force_danger())
		var/action = grab.assailant.a_intent == I_HURT ? "to slam them against \the [src]" : "to throw them over \the [src]"
		USE_FEEDBACK_GRAB_MUST_UPGRADE(action)
		return TRUE

	// Harm intent - Face slamming
	if (grab.assailant.a_intent == I_HURT)
		var/blocked = grab.affecting.get_blocked_ratio(BP_HEAD, DAMAGE_BRUTE, damage = 8)
		if (prob(30 * (1 - blocked)))
			grab.affecting.Weaken(5)
		grab.affecting.apply_damage(8, DAMAGE_BRUTE, BP_HEAD)
		playsound(src, 'sound/effects/grillehit.ogg', 50, 1)
		grab.assailant.visible_message(
			SPAN_WARNING("\The [grab.assailant] slams \the [grab.affecting]'s face against \the [src]!"),
			SPAN_DANGER("You slam \the [grab.affecting]'s face against \the [src]!")
		)
		return TRUE

	if (get_turf(grab.affecting) == get_turf(src))
		grab.affecting.forceMove(get_step(src, dir))
	else
		grab.affecting.dropInto(loc)
	grab.affecting.Weaken(5)
	grab.assailant.visible_message(
		SPAN_WARNING("\The [grab.assailant] throws \the [grab.affecting] over \the [src]."),
		SPAN_WARNING("You throw \the [grab.affecting] over \the [src]."),
	)
	return TRUE


/obj/structure/railing/use_tool(obj/item/tool, mob/user, list/click_params)
	// Welding Tool - Repair
	if (isWelder(tool))
		if (!health_damaged())
			USE_FEEDBACK_FAILURE("\The [src] doesn't require repairs.")
			return TRUE
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts repairing \the [src] with \a [tool]."),
			SPAN_NOTICE("You start repairing \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 2) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!health_damaged())
			USE_FEEDBACK_FAILURE("\The [src] doesn't require repairs.")
			return TRUE
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		restore_health(get_max_health() / 5)
		user.visible_message(
			SPAN_NOTICE("\The [user] repairs \the [src] with \a [tool]."),
			SPAN_NOTICE("You repair \the [src] with \the [tool].")
		)
		return TRUE

	// Wrench
	// - Dismantle (Unanchored)
	// - Toggle Density (Anchored)
	if (isWrench(tool))
		// Toggle
		if (anchored)
			playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
			set_density(!density)
			update_icon()
			user.visible_message(
				SPAN_NOTICE("\The [user] [density ? "closes" : "opens"] \the [src] with \a [tool]."),
				SPAN_NOTICE("You [density ? "close" : "open"] \the [src] with \the [tool].")
			)
			return TRUE
		// Dismantle
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts dismantling \the [src] with \a [tool]."),
			SPAN_NOTICE("You start dismantling \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 2) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (anchored)
			USE_FEEDBACK_FAILURE("\The [src]'s state has changed.")
			return TRUE
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		var/obj/new_sheet = material.place_sheet(loc, 2)
		transfer_fingerprints_to(new_sheet)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
		)
		qdel_self()
		return TRUE

	// Screwdriver - Toggle Anchored
	if (isScrewdriver(tool))
		if (!density)
			USE_FEEDBACK_FAILURE("\The [src] needs to be closed before you can unanchor it.")
			return TRUE
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts [anchored ? "un" : null]fastening \the [src] [anchored ? "from" : "to"] the floor with \a [tool]."),
			SPAN_NOTICE("You start [anchored ? "un" : null]fastening \the [src] [anchored ? "from" : "to"] the floor with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 1) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!density)
			USE_FEEDBACK_FAILURE("\The [src] needs to be closed before you can unanchor it.")
			return TRUE
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] [anchored ? "un" : null]fastens \the [src] [anchored ? "from" : "to"] the floor with \a [tool]."),
			SPAN_NOTICE("You [anchored ? "un" : null]fasten \the [src] [anchored ? "from" : "to"] the floor with \the [tool].")
		)
		anchored = !anchored
		update_icon()
		return TRUE

	return ..()


/obj/structure/railing/can_climb(mob/living/user, post_climb_check=FALSE, check_silicon=TRUE)
	. = ..()
	if (. && get_turf(user) == get_turf(src))
		var/turf/T = get_step(src, src.dir)
		if (T.density || T.turf_is_crowded(user))
			to_chat(user, SPAN_WARNING("You can't climb there, the way is blocked."))
			return 0

/obj/structure/railing/do_climb(mob/living/user)
	. = ..()
	if(.)
		if(!anchored || material.is_brittle())
			kill_health() // Fatboy

		user.jump_layer_shift()
		addtimer(new Callback(user, /mob/living/proc/jump_layer_shift_end), 2)

/obj/structure/railing/slam_into(mob/living/L)
	var/turf/target_turf = get_turf(src)
	if (target_turf == get_turf(L))
		target_turf = get_step(src, dir)
	if (!target_turf.density && !target_turf.turf_is_crowded(L))
		L.forceMove(target_turf)
		L.visible_message(SPAN_WARNING("\The [L] [pick("falls", "flies")] over \the [src]!"))
		L.Weaken(2)
		playsound(L, 'sound/effects/grillehit.ogg', 25, 1, FALSE)
	else
		..()

/obj/structure/railing/set_color(color)
	src.color = color ? color : material.icon_colour
