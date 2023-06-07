/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/window.dmi'
	density = TRUE
	w_class = ITEM_SIZE_NORMAL

	damage_hitsound = 'sound/effects/Glasshit.ogg'

	layer = SIDE_WINDOW_LAYER
	anchored = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CAN_BE_PAINTED | ATOM_FLAG_CHECKS_BORDER
	obj_flags = OBJ_FLAG_ROTATABLE
	alpha = 180
	var/material/reinf_material
	var/damaged_reinf = FALSE
	var/init_material = MATERIAL_GLASS
	var/init_reinf_material = null
	var/const/CONSTRUCT_STATE_COMPLETE = 2
	var/const/CONSTRUCT_STATE_ANCHORED = 1
	var/const/CONSTRUCT_STATE_UNANCHORED = 0
	var/construction_state = CONSTRUCT_STATE_COMPLETE
	var/id
	var/polarized = 0
	var/basestate = "window"
	var/reinf_basestate = "rwindow"
	var/paint_color
	var/base_color // The windows initial color. Used for resetting purposes.
	var/repair_pending = 0 // Amount of health pending repair once the window is welded
	rad_resistance_modifier = 0.5
	blend_objects = list(/obj/machinery/door, /turf/simulated/wall) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)

	atmos_canpass = CANPASS_PROC

/obj/structure/window/get_mechanics_info()
	. = "<p>If damaged, it can be repaired by applying some [get_material_display_name()] then welding it. This particular window can require up to [get_glass_cost()] sheets to fully repair depending on damage.</p>"

/obj/structure/window/get_material()
	return material

/obj/structure/window/get_material_display_name()
	. = ..()
	. = "[.] sheets"
	if (reinf_material)
		. = "[reinf_material.display_name]-reinforced [.]"

/obj/structure/window/Initialize(mapload, start_dir=null, constructed=0, new_material, new_reinf_material)
	. = ..()
	if(!new_material)
		new_material = init_material
		if(!new_material)
			new_material = MATERIAL_GLASS
	if(!new_reinf_material)
		new_reinf_material = init_reinf_material
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL

	if(new_reinf_material)
		reinf_material = SSmaterials.get_material_by_name(new_reinf_material)

	name = "[reinf_material ? "[reinf_material.display_name]-reinforced " : ""][material.display_name] window"
	desc = "A window pane made from [material.display_name][reinf_material ? " and reinforced with [reinf_material.display_name]" : ""]."

	if (start_dir)
		set_dir(start_dir)

	var/new_max_health = material.integrity
	if(reinf_material)
		new_max_health += 0.5 * reinf_material.integrity
	set_max_health(new_max_health)

	if(is_fulltile())
		layer = FULL_WINDOW_LAYER
		CLEAR_FLAGS(obj_flags, OBJ_FLAG_ROTATABLE)

	health_min_damage = material.hardness * 1.25
	if (reinf_material)
		health_min_damage += round(reinf_material.hardness * 0.625)
	health_min_damage = round(health_min_damage / 10)

	if (constructed)
		set_anchored(FALSE)
		construction_state = CONSTRUCT_STATE_UNANCHORED

	base_color = get_color()

	update_connections(1)
	update_icon()
	update_nearby_tiles(need_rebuild=1)

/obj/structure/window/Destroy()
	set_density(0)
	update_nearby_tiles()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/window/W in orange(1, location))
		W.update_connections()
		W.queue_icon_update()

/obj/structure/window/examine(mob/user)
	. = ..(user)
	to_chat(user, SPAN_NOTICE("It is fitted with \a [material.display_name] pane."))
	if(reinf_material)
		to_chat(user, SPAN_NOTICE("It is reinforced with \a [reinf_material.display_name] lattice."))

	if (reinf_material)
		switch (construction_state)
			if (CONSTRUCT_STATE_UNANCHORED)
				to_chat(user, SPAN_WARNING("The window is not in the frame."))
			if (CONSTRUCT_STATE_ANCHORED)
				to_chat(user, SPAN_WARNING("The window is pried into the frame but not yet fastened."))
			if (CONSTRUCT_STATE_COMPLETE)
				to_chat(user, SPAN_NOTICE("The window is fastened to the frame."))

	if (anchored)
		to_chat(user, SPAN_NOTICE("It is fastened to \the [get_turf(src)]."))
	else
		to_chat(user, SPAN_WARNING("It is not fastened to anything."))

	if (paint_color)
		to_chat(user, SPAN_NOTICE("\The [material] pane is stained with paint."))

	if (polarized)
		to_chat(user, SPAN_NOTICE("It appears to be wired."))

/obj/structure/window/examine_damage_state(mob/user)
	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if (0)
			to_chat(user, SPAN_NOTICE("It looks fully intact."))
		if (1 to 24)
			to_chat(user, SPAN_WARNING("\The [material] pane has a few cracks."))
		if (25 to 49)
			to_chat(user, SPAN_WARNING("\The [material] pane looks slightly damaged."))
		if (50 to 74)
			to_chat(user, SPAN_WARNING("\The [material] pane looks moderately damaged."))
		else
			to_chat(user, SPAN_WARNING("\The [material] pane looks severely damaged."))

/obj/structure/window/get_color()
	if (paint_color)
		return paint_color
	else if (material?.icon_colour)
		return material.icon_colour
	else if (base_color)
		return base_color
	else
		return ..()

/obj/structure/window/set_color(color)
	paint_color = color
	update_icon()

/obj/structure/window/CanFluidPass(coming_from)
	return (!is_fulltile() && coming_from != dir)

/obj/structure/window/post_health_change(health_mod, prior_health, damage_type)
	..()
	queue_icon_update()
	if (health_mod < 0)
		var/initial_damage_percentage = round((prior_health / get_max_health()) * 100)
		var/damage_percentage = get_damage_percentage()
		if (damage_percentage >= 75 && initial_damage_percentage < 75)
			visible_message(SPAN_DANGER("\The [src] looks like it's about to shatter!"))
			playsound(loc, "glasscrack", 100, 1)
		else if (damage_percentage >= 50 && initial_damage_percentage < 50)
			visible_message(SPAN_WARNING("\The [src] looks seriously damaged!"))
			playsound(loc, "glasscrack", 100, 1)
		else if (damage_percentage >= 25 && initial_damage_percentage < 25)
			visible_message(SPAN_WARNING("Cracks begin to appear in \the [src]!"))
			playsound(loc, "glasscrack", 100, 1)

/obj/structure/window/proc/get_glass_cost()
	return is_fulltile() ? 4 : 1

/obj/structure/window/proc/get_repaired_per_unit()
	return round(get_max_health() / get_glass_cost())

/obj/structure/window/on_death()
	shatter()

/obj/structure/window/proc/shatter(display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message(SPAN_WARNING("\The [src] shatters!"))

	var/debris_count = round(get_glass_cost() / rand(1, 4))
	for(var/i = 1 to debris_count)
		material.place_shard(loc)
		if(reinf_material)
			debris_count = rand(0, 1)
			new /obj/item/stack/material/rods(loc, debris_count, reinf_material.name)
	qdel(src)

/obj/structure/window/ex_act(severity)
	if (severity == EX_ACT_DEVASTATING)
		qdel(src)
		return
	..()

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(is_fulltile())
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) & dir)
		return !density
	else
		return 1

/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/window/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(MUTATION_HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message(SPAN_DANGER("[user] smashes through [src]!"))
		user.do_attack_animation(src)
		shatter()
	else if(MUTATION_FERAL in user.mutations)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2) //Additional cooldown
		attack_generic(user, 10, "smashes")

	else if (user.a_intent && user.a_intent == I_HURT)

		if (istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(H))
				attack_generic(H,25)
				return

		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.do_attack_animation(src)
		user.visible_message(SPAN_DANGER("\The [user] bangs against \the [src]!"),
							SPAN_DANGER("You bang against \the [src]!"),
							"You hear a banging sound.")
	else
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.visible_message("[user.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
	return

/obj/structure/window/do_simple_ranged_interaction(mob/user)
	visible_message(SPAN_NOTICE("Something knocks on \the [src]."))
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)
	return TRUE


/obj/structure/window/can_use_item(obj/item/tool, mob/user, click_params)
	. = ..()
	if (!.)
		return

	// Unmodifiable area check
	var/area/area = get_area(src)
	if (!area?.can_modify_area())
		USE_FEEDBACK_FAILURE("This area does not allow structural modifications.")
		return FALSE


/obj/structure/window/use_tool(obj/item/tool, mob/user, list/click_params)
	// Cable Coil - Polarize window
	if (isCoil(tool))
		if (polarized)
			USE_FEEDBACK_FAILURE("\The [src] is already polarized.")
			return TRUE
		var/obj/item/stack/cable_coil/cable = tool
		if (!cable.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 1, "to wire and polarize \the [src].")
			return TRUE
		playsound(src, 'sound/effects/sparks1.ogg', 50, TRUE)
		polarized = TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] wires and polarizes \the [src] with \a [tool]."),
			SPAN_NOTICE("You wire and polarize \the [src] with \the [tool].")
		)
		return TRUE

	// Crowbar - Remove reinforced window from frame
	if (isCrowbar(tool))
		if (!reinf_material)
			USE_FEEDBACK_FAILURE("\The [src] doesn't have a reinforced frame to pry out.")
			return TRUE
		if (construction_state == CONSTRUCT_STATE_COMPLETE)
			USE_FEEDBACK_FAILURE("\The [src] needs to be unfastened from the frame before you can pry it out.")
			return TRUE
		if (!anchored)
			USE_FEEDBACK_FAILURE("\The [src] isn't anchored and doesn't need to be pried.")
			return TRUE
		if (construction_state == CONSTRUCT_STATE_ANCHORED)
			construction_state = CONSTRUCT_STATE_UNANCHORED
		else
			construction_state = CONSTRUCT_STATE_ANCHORED
		playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] pries \the [src] [construction_state ? "into" : "out of"] its frame with \a [tool]."),
			SPAN_NOTICE("You pry \the [src] [construction_state ? "into" : "out of"] its frame with \the [tool].")
		)
		return TRUE

	// Material Stack - Repair window
	if (istype(tool, /obj/item/stack/material))
		if (!health_damaged())
			USE_FEEDBACK_FAILURE("\The [src] doesn't need repairs.")
			return TRUE
		if ((repair_pending + get_current_health()) >= get_max_health())
			USE_FEEDBACK_FAILURE("\The [src] already has enough new [material] applied.")
			return TRUE
		var/obj/item/stack/material/stack = tool
		if (material != stack.material || reinf_material != stack.reinf_material)
			USE_FEEDBACK_FAILURE("\The [src] must be repaired with the same type of [get_material_display_name()] it was made of.")
			return TRUE
		if (!stack.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 1, "to repair \the [src].")
			return TRUE
		repair_pending += get_repaired_per_unit()
		user.visible_message(
			SPAN_NOTICE("\The [user] replaces some of \the [src]'s damaged [material] with \a [tool]."),
			SPAN_NOTICE("You replace some of \the [src]'s damaged [material] with \a [tool].")
		)
		if (repair_pending < get_damage_value())
			user.show_message(SPAN_WARNING("It looks like it could use more sheets"), VISIBLE_MESSAGE)
		return TRUE

	// Multitool
	// - Toggle tinting (Anchored)
	// - Set ID (Unanchored)
	if (isMultitool(tool))
		if (!polarized)
			USE_FEEDBACK_FAILURE("\The [src] is not wired and cannot be toggled.")
			return TRUE
		// Toggle Tinting
		if (anchored)
			toggle()
			playsound(src, 'sound/effects/pop.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] toggles \the [src]'s tinting with \a [tool]."),
				SPAN_NOTICE("You toggle \the [src]'s tinting with \the [tool].")
			)
			return TRUE
		// Set ID
		var/input = input(user, "What ID would you like to set this window to?", "[src] - Polarization ID", id) as null|text
		input = sanitizeSafe(input, MAX_NAME_LEN)
		if (!input || input == id || !user.use_sanity_check(src, tool))
			return TRUE
		id = input
		user.visible_message(
			SPAN_NOTICE("\The [user] configures \the [src] with \a [tool]."),
			SPAN_NOTICE("You set \the [src]'s polarization ID to '[id]' with \the [tool].")
		)
		return TRUE

	// Plasmacutter - Dismantle window
	if (istype(tool, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/plasmacutter = tool
		if (!plasmacutter.slice(user))
			return TRUE
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts slicing \the [src] apart with \a [tool]."),
			SPAN_NOTICE("You start slicing \the [src] apart with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 2) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] slices \the [src] apart with \a [tool]."),
			SPAN_NOTICE("You slice \the [src] apart with \the [tool].")
		)
		dismantle()
		return TRUE

	// Screwdriver - Fasten window
	if (isScrewdriver(tool))
		// Reinforced Window
		if (reinf_material)
			switch(construction_state)
				if (CONSTRUCT_STATE_UNANCHORED)
					if (!can_install_here(user))
						return TRUE
					set_anchored(!anchored)
					playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
					user.visible_message(
						SPAN_NOTICE("\The [user] [!anchored ? "un" : null]fastens \the [src] [!anchored ? "from" : "to"] the floor with \a [tool]."),
						SPAN_NOTICE("You [!anchored ? "un" : null]fasten \the [src] [!anchored ? "from" : "to"] the floor with \the [tool].")
					)
					return TRUE
				if (CONSTRUCT_STATE_ANCHORED)
					construction_state = CONSTRUCT_STATE_COMPLETE
				if (CONSTRUCT_STATE_COMPLETE)
					construction_state = CONSTRUCT_STATE_ANCHORED
			update_nearby_icons()
			playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] [construction_state == CONSTRUCT_STATE_ANCHORED ? "un" : null]fastens \the [src] [construction_state == CONSTRUCT_STATE_ANCHORED ? "from" : "to"] its frame with \a [tool]."),
				SPAN_NOTICE("You [construction_state == CONSTRUCT_STATE_ANCHORED ? "un" : null]fasten \the [src] [construction_state == CONSTRUCT_STATE_ANCHORED ? "from" : "to"] its frame with \the [tool].")
			)
			return TRUE
		// Regular Windows
		if (!anchored && !can_install_here(user))
			return TRUE
		if (anchored)
			construction_state = CONSTRUCT_STATE_UNANCHORED
		else
			construction_state = CONSTRUCT_STATE_ANCHORED
		set_anchored(!anchored)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] [!anchored ? "un" : null]fastens \the [src] [!anchored ? "from" : "to"] the floor with \a [tool]."),
			SPAN_NOTICE("You [!anchored ? "un" : null]fasten \the [src] [!anchored ? "from" : "to"] the floor with \the [tool].")
		)
		return TRUE

	// Wirecutters - Remove wiring
	if (isWirecutter(tool))
		if (!polarized)
			USE_FEEDBACK_FAILURE("\The [src] has no wiring to remove.")
			return TRUE
		if (opacity)
			toggle()
		new /obj/item/stack/cable_coil(user.loc, 1)
		polarized = FALSE
		id = null
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts \the [src]'s wiring with \a [tool]."),
			SPAN_NOTICE("You cut \the [src]'s wiring with \the [tool].")
		)
		return TRUE

	// Wrench - Dismantle
	if (isWrench(tool))
		if (anchored || construction_state)
			USE_FEEDBACK_FAILURE("\The [src] must be detached from the floor[reinf_material ? " and its frame" : null] before you can dismantle it.")
			return TRUE
		if (polarized)
			USE_FEEDBACK_FAILURE("\The [src]'s wiring must be removed before you can dismantle it.")
			return TRUE
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
		)
		dismantle()
		return TRUE

	// Welding Tool - Finalize repairs
	if (isWelder(tool))
		if (!health_damaged())
			USE_FEEDBACK_FAILURE("\The [src] does not need repairs.")
			return TRUE
		if (!repair_pending)
			USE_FEEDBACK_FAILURE("\The [src] needs some [get_material_display_name()] applied before you can weld it.")
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.remove_fuel(1, user))
			return TRUE
		restore_health(repair_pending)
		repair_pending = 0
		user.visible_message(
			SPAN_NOTICE("\The [user] welds \the [src]'s [material] into place with \a [tool]."),
			SPAN_NOTICE("You weld \the [src]'s [material] into place with \the [tool].")
		)
		return TRUE

	return ..()


/obj/structure/window/proc/dismantle()
	var/obj/item/stack/material/S = material.place_sheet(loc, is_fulltile() ? 4 : 1)
	if(S && reinf_material)
		S.reinf_material = reinf_material
		S.update_strings()
		S.update_icon()
	qdel(src)

/obj/structure/window/use_grab(obj/item/grab/grab, list/click_params)
	// Harm intent - Bash against the window
	if (grab.assailant.a_intent == I_HURT)
		if (!grab.force_danger())
			USE_FEEDBACK_GRAB_MUST_UPGRADE("to smash them against \the [src]")
			return TRUE
		var/def_zone = ran_zone(BP_HEAD, 20)
		if (grab.damage_stage() < 2)
			grab.assailant.visible_message(
				SPAN_DANGER("\The [grab.assailant] bashes \the [grab.affecting] against \the [src]!"),
				SPAN_DANGER("You bash \the [grab.affecting] against \the [src]!")
			)
			if (prob(50))
				grab.affecting.Weaken(1)
			grab.affecting.apply_damage(10, DAMAGE_BRUTE, def_zone, used_weapon = src)
			hit(25, grab.assailant, grab.affecting)
		else
			grab.assailant.visible_message(
				SPAN_DANGER("\The [grab.assailant] crushes \the [grab.affecting] against \the [src]!"),
				SPAN_DANGER("You crush \the [grab.affecting] against \the [src]!")
			)
			grab.affecting.Weaken(5)
			grab.affecting.apply_damage(20, DAMAGE_BRUTE, def_zone, used_weapon = src)
			hit(50, grab.assailant, grab.affecting)
		return TRUE

	return ..()


/obj/structure/window/proc/hit(damage, mob/user, atom/weapon = null, damage_type = DAMAGE_BRUTE)
	if (can_damage_health(damage, damage_type))
		var/weapon_text = weapon ? " with \the [weapon]" : null
		user.visible_message(
			SPAN_DANGER("\The [user] attacks \the [src][weapon_text]!"),
			SPAN_WARNING("You attack \the [src][weapon_text]!"),
			SPAN_WARNING("You hear the sound of something hitting a window.")
		)
		playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
		damage_health(damage, damage_type, skip_can_damage_check = TRUE)
		deanchor(user)
	else
		var/weapon_text = weapon ? " with \the [weapon]" : null
		playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)
		user.visible_message(
			SPAN_WARNING("\The [user] attacks \the [src][weapon_text], but it bounces off!"),
			SPAN_WARNING("You attack \the [src][weapon_text], but it bounces off! You need something stronger."),
			SPAN_WARNING("You hear the sound of something hitting a window.")
		)

/obj/structure/window/proc/deanchor(atom/impact_origin)
	if (!health_dead && get_damage_percentage() >= 85)
		set_anchored(FALSE)
		step(src, get_dir(impact_origin, src))

/obj/structure/window/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	if (anchored)
		to_chat(user, SPAN_NOTICE("\The [src] is secured to the floor!"))
		return

	var/newdir=turn(dir, 90)
	if(!is_fulltile())
		for(var/obj/structure/window/W in loc)
			if(W.dir == newdir)
				to_chat(user, SPAN_NOTICE("There's already a window facing that direction here!"))
				return

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(newdir)
	update_nearby_tiles(need_rebuild=1)

/obj/structure/window/Move()
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

/obj/structure/window/proc/set_anchored(new_anchored)
	if(anchored == new_anchored)
		return
	anchored = new_anchored
	update_connections(1)
	update_nearby_icons()

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

// Visually connect with every type of window as long as it's full-tile.
/obj/structure/window/can_visually_connect()
	return ..() && is_fulltile()

/obj/structure/window/can_visually_connect_to(obj/structure/S)
	return istype(S, /obj/structure/window)

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/on_update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	if(reinf_material)
		basestate = reinf_basestate
	else
		basestate = initial(basestate)
	overlays.Cut()
	layer = FULL_WINDOW_LAYER
	if (paint_color)
		color = paint_color
	else if (material?.icon_colour)
		color = material.icon_colour
	else
		color = GLASS_COLOR
	if(!is_fulltile())
		layer = SIDE_WINDOW_LAYER
		icon_state = basestate
		return

	icon_state = ""

	var/damage_alpha = 0 // Used for alpha blending of damage layer
	if (health_damaged())
		damage_alpha = 256 * round(get_damage_percentage() / 100, 0.25) - 1

	var/img_dir
	if(is_on_frame())
		for(var/i = 1 to 4)
			img_dir = SHIFTL(1, i - 1)
			if(other_connections[i] != "0")
				process_icon(basestate, "_other_onframe", "_onframe", connections[i], img_dir, damage_alpha)
			else
				process_icon(basestate, "_onframe", "_onframe", connections[i], img_dir, damage_alpha)
	else
		for(var/i = 1 to 4)
			img_dir = SHIFTL(1, i - 1)
			if(other_connections[i] != "0")
				process_icon(basestate, "_other", "", connections[i], img_dir, damage_alpha)
			else
				process_icon(basestate, "", "", connections[i], img_dir, damage_alpha)

/obj/structure/window/proc/process_icon(basestate, icon_group, damage_group, connections, img_dir, damage_alpha)
	var/image/I = image(icon, "[basestate][icon_group][connections]", dir = img_dir)
	I.color = get_color()
	overlays += I

	if (damage_group == "_onframe")
		process_overlay_damage("window0_damage", damage_alpha, img_dir)
	else
		process_overlay_damage("window[damage_group][connections]_damage", damage_alpha, img_dir)

/obj/structure/window/proc/process_overlay_damage(damage_state, damage_alpha, img_dir)
	var/image/D
	D = image(icon, damage_state, dir = img_dir)
	D.blend_mode = BLEND_MULTIPLY
	D.alpha = damage_alpha
	overlays += D

/obj/structure/window/get_material_melting_point()
	. = ..()
	if (reinf_material)
		. += 0.25 * reinf_material.melting_point

/obj/structure/window/basic
	icon_state = "window"
	color = GLASS_COLOR

/obj/structure/window/basic/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/basic/full/polarized
	polarized = 1

/obj/structure/window/boron_basic
	name = "phoron window"
	color = GLASS_COLOR_BORON
	init_material = MATERIAL_BORON_GLASS

/obj/structure/window/boron_basic/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/boron_reinforced
	name = "reinforced borosilicate window"
	icon_state = "rwindow"
	color = GLASS_COLOR_BORON
	init_material = MATERIAL_BORON_GLASS
	init_reinf_material = MATERIAL_STEEL

/obj/structure/window/boron_reinforced/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/reinforced
	name = "reinforced window"
	icon_state = "rwindow"
	init_material = MATERIAL_GLASS
	init_reinf_material = MATERIAL_STEEL

/obj/structure/window/reinforced/full
	dir = 5
	icon_state = "rwindow_full"

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	opacity = 1
	color = GLASS_COLOR_TINTED

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	color = GLASS_COLOR_FROSTED

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	basestate = "w"
	reinf_basestate = "w"
	dir = 5

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	basestate = "rwindow"
	polarized = 1

/obj/structure/window/reinforced/polarized/full
	dir = 5
	icon_state = "rwindow_full"

/obj/structure/window/proc/toggle()
	if(!polarized)
		return
	if(opacity)
		animate(src, color=get_color(), time=5)
		set_opacity(FALSE)
	else
		animate(src, color=GLASS_COLOR_TINTED, time=5)
		set_opacity(TRUE)

/obj/structure/window/proc/is_on_frame()
	if(locate(/obj/structure/wall_frame) in loc)
		return TRUE

/obj/structure/window/proc/can_install_here(mob/user)
	//only care about full tile. Border can be installed anywhere
	if(!anchored && is_fulltile())
		for(var/obj/O in loc)
			if((O != src) && O.density && !(O.atom_flags & ATOM_FLAG_CHECKS_BORDER) \
			&& !(istype(O, /obj/structure/wall_frame) || istype(O, /obj/structure/grille)))
				to_chat(user, SPAN_NOTICE("There isn't enough space to install \the [src]."))
				return FALSE
	return TRUE

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for electrochromic windows."
	var/id
	var/range = 7
	stock_part_presets = null // This isn't a radio-enabled button; it communicates with nearby structures in view.
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc
	)

/obj/machinery/button/windowtint/attackby(obj/item/device/W as obj, mob/user as mob)
	if(isMultitool(W))
		var/t = sanitizeSafe(input(user, "Enter the ID for the button.", src.name, id), MAX_NAME_LEN)
		if(user.incapacitated() && !user.Adjacent(src))
			return
		if (user.get_active_hand() != W)
			return
		if (!in_range(src, user) && src.loc != user)
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.id = t
			to_chat(user, SPAN_NOTICE("The new ID of the button is [id]"))
		return
	if(istype(W, /obj/item/screwdriver))
		new /obj/item/frame/light_switch/windowtint(user.loc, 1)
		qdel(src)

/obj/machinery/button/windowtint/activate()
	if(operating)
		return
	for(var/obj/structure/window/W in range(src,range))
		if(W.polarized && (W.id == src.id || !W.id))
			W.toggle()
	..()

/obj/machinery/button/windowtint/power_change()
	. = ..()
	if(active && (!is_powered()))
		activate()

/obj/machinery/button/windowtint/on_update_icon()
	icon_state = "light[active]"

//Centcomm windows
/obj/structure/window/reinforced/crescent
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CHECKS_BORDER | ATOM_FLAG_NO_TOOLS

/obj/structure/window/reinforced/crescent/attack_hand()
	return

/obj/structure/window/reinforced/crescent/ex_act()
	return

/obj/structure/window/reinforced/crescent/hitby()
	return

/obj/structure/window/reinforced/crescent/can_damage_health()
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/obj/structure/window/reinforced/crescent/shatter()
	return

/proc/place_window(mob/user, loc, obj/item/stack/material/ST)
	var/window_type = input(user, "Which type of window to place?", "Window Placement") as null | anything in list("Full Size", "Directional")
	if (isnull(window_type))
		return
	var/dir_to_set
	switch (window_type)
		if ("Full Size")
			dir_to_set = 5
		if ("Directional")
			if(loc == user.loc)
				dir_to_set = user.dir
			else
				dir_to_set = get_dir(loc, user)
				if(dir_to_set & (dir_to_set - 1)) //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
					to_chat(user, SPAN_WARNING("You can't reach from this angle."))
					return

	var/required_amount = (dir_to_set & (dir_to_set - 1)) ? 4 : 1
	if (!ST.can_use(required_amount))
		to_chat(user, SPAN_NOTICE("You do not have enough sheets."))
		return
	for(var/obj/structure/window/WINDOW in loc)
		if(WINDOW.dir == dir_to_set)
			to_chat(user, SPAN_NOTICE("There is already a window facing this way there."))
			return
		if(WINDOW.is_fulltile() && (dir_to_set & (dir_to_set - 1))) //two fulltile windows
			to_chat(user, SPAN_NOTICE("There is already a window there."))
			return
	to_chat(user, SPAN_NOTICE("You start placing the window."))
	if(do_after(user, 2 SECONDS, loc, DO_REPAIR_CONSTRUCT))
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
				to_chat(user, SPAN_NOTICE("There is already a window facing this way there."))
				return
			if(WINDOW.is_fulltile() && (dir_to_set & (dir_to_set - 1)))
				to_chat(user, SPAN_NOTICE("There is already a window there."))
				return

		if (ST.use(required_amount))
			var/obj/structure/window/WD = new(loc, dir_to_set, FALSE, ST.material.name, ST.reinf_material && ST.reinf_material.name)
			to_chat(user, SPAN_NOTICE("You place [WD]."))
			WD.construction_state = 0
			WD.set_anchored(FALSE)
		else
			to_chat(user, SPAN_NOTICE("You do not have enough sheets."))
			return
