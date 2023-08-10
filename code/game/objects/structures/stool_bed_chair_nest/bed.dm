/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/structures/furniture.dmi'
	icon_state = "bed"
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_stance = BUCKLE_FORCE_PRONE
	var/material/padding_material
	var/base_icon = "bed"
	var/material_alteration = MATERIAL_ALTERATION_ALL
	/// Bitflags. Bed/chair specific flags.
	var/bed_flags = EMPTY_BITFIELD


/obj/structure/bed/New(newloc, new_material = DEFAULT_FURNITURE_MATERIAL, new_padding_material)
	..(newloc)
	color = null
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	if(new_padding_material)
		padding_material = SSmaterials.get_material_by_name(new_padding_material)
	update_icon()

/obj/structure/bed/get_material()
	return material

// Reuse the cache/code from stools, todo maybe unify.
/obj/structure/bed/on_update_icon()
	// Prep icon.
	icon_state = ""
	overlays.Cut()
	// Base icon.
	var/cache_key = "[base_icon]-[material.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image('icons/obj/structures/furniture.dmi', base_icon)
		if(material_alteration & MATERIAL_ALTERATION_COLOR)
			I.color = material.icon_colour
		stool_cache[cache_key] = I
	overlays |= stool_cache[cache_key]
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding")
			if(material_alteration & MATERIAL_ALTERATION_COLOR)
				I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		overlays |= stool_cache[padding_cache_key]

	// Strings.
	if(material_alteration & MATERIAL_ALTERATION_NAME)
		SetName(padding_material ? "[padding_material.adjective_name] [initial(name)]" : "[material.adjective_name] [initial(name)]") //this is not perfect but it will do for now.

	if(material_alteration & MATERIAL_ALTERATION_DESC)
		desc = initial(desc)
		desc += padding_material ? " It's made of [material.use_name] and covered with [padding_material.use_name]." : " It's made of [material.use_name]."

/obj/structure/bed/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return ..()

/obj/structure/bed/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
			return
		if(EX_ACT_HEAVY)
			if (prob(50))
				qdel(src)
				return
		if(EX_ACT_LIGHT)
			if (prob(5))
				qdel(src)
				return


/obj/structure/bed/use_tool(obj/item/tool, mob/user, list/click_params)
	// Material Stack - Add padding
	if (isstack(tool))
		if (HAS_FLAGS(bed_flags, BED_FLAG_CANNOT_BE_PADDED))
			USE_FEEDBACK_FAILURE("\The [src] cannot be padded.")
			return TRUE
		if (padding_material)
			USE_FEEDBACK_FAILURE("\The [src] is already padded with [padding_material.display_name].")
			return TRUE
		var/obj/item/stack/stack = tool
		if (!stack.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 1, "to pad \the [src].")
			return TRUE
		var/padding_type
		if (istype(tool, /obj/item/stack/tile/carpet))
			padding_type = MATERIAL_CARPET
		else if (istype(tool, /obj/item/stack/material))
			var/obj/item/stack/material/material_stack = tool
			if (!material_stack.material || !HAS_FLAGS(material_stack.material.flags, MATERIAL_PADDING))
				USE_FEEDBACK_FAILURE("\The [tool] can't be used to pad \the [src].")
				return TRUE
			padding_type = material_stack.get_material_name()
		else
			USE_FEEDBACK_FAILURE("\The [tool] can't be used to pad \the [src].")
			return TRUE
		stack.use(1)
		user.visible_message(
			SPAN_NOTICE("\The [user] pads \the [src] with \a [tool]."),
			SPAN_NOTICE("You pad \the [src] with \the [tool].")
		)
		add_padding(padding_type)
		return TRUE

	// Wirecutters - Remove padding
	if (isWirecutter(tool))
		if (!padding_material)
			USE_FEEDBACK_FAILURE("\The [src] has no padding to remove.")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \the [src]'s padding with \a [tool]."),
			SPAN_NOTICE("You remove \the [src]'s padding with \the [tool].")
		)
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		remove_padding()
		return TRUE

	// Wrench - Dismantle
	if (isWrench(tool))
		if (HAS_FLAGS(bed_flags, BED_FLAG_CANNOT_BE_DISMANTLED))
			USE_FEEDBACK_FAILURE("\The [src] cannot be dismantled.")
			return TRUE
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		dismantle()
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
		)
		qdel_self()
		return TRUE

	return ..()


/obj/structure/bed/use_grab(obj/item/grab/grab, list/click_params)
	// Force-buckle
	grab.assailant.visible_message(
		SPAN_WARNING("\The [grab.assailant] starts to buckle \the [grab.affecting] to \the [src]."),
		SPAN_DANGER("You start to buckle \the [grab.affecting] to \the [src]!"),
		SPAN_ITALIC("You hear the sound of struggling."),
		exclude_mobs = list(grab.affecting)
	)
	grab.affecting.show_message(
		SPAN_DANGER("\The [grab.assailant] starts to buckle you to \the [src]!"),
		VISIBLE_MESSAGE,
		SPAN_DANGER("You feel someone trying to force you into a bed or chair!")
	)
	if (!do_after(grab.assailant, 2 SECONDS, src, DO_PUBLIC_UNIQUE) || !grab.use_sanity_check(src))
		return TRUE
	grab.assailant.visible_message(
		SPAN_WARNING("\The [grab.assailant] buckles \the [grab.affecting] to \the [src]."),
		SPAN_DANGER("You buckle \the [grab.affecting] to \the [src]!"),
		SPAN_ITALIC("You hear the sound of buckling."),
		exclude_mobs = list(grab.affecting)
	)
	grab.affecting.show_message(
		SPAN_DANGER("\The [grab.assailant] buckles you to \the [src]!"),
		VISIBLE_MESSAGE,
		SPAN_DANGER("You feel someone buckle you into a bed or chair!")
	)
	qdel(grab)
	return TRUE


/obj/structure/bed/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/structure/bed/proc/add_padding(padding_type)
	padding_material = SSmaterials.get_material_by_name(padding_type)
	update_icon()

/obj/structure/bed/proc/dismantle()
	material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	base_icon = "psychbed"

/obj/structure/bed/psych/New(newloc)
	..(newloc,MATERIAL_WALNUT, MATERIAL_LEATHER_GENERIC)

/obj/structure/bed/padded/New(newloc)
	..(newloc,MATERIAL_ALUMINIUM,MATERIAL_CLOTH)


/obj/structure/mattress
	name = "mattress"
	icon = 'icons/obj/structures/furniture.dmi'
	icon_state = "mattress"
	desc = "A bare mattress. It doesn't look very comfortable."
	anchored = FALSE

/obj/structure/mattress/dirty
	name = "dirty mattress"
	icon_state = "dirty_mattress"
	desc = "A dirty, smelly mattress covered in body fluids. You wouldn't want to touch this."
