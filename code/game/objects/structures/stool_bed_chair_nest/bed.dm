/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_stance = BUCKLE_FORCE_PRONE
	var/material/padding_material
	var/base_icon = "bed"
	var/material_alteration = MATERIAL_ALTERATION_ALL


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
		var/image/I = image('icons/obj/furniture.dmi', base_icon)
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


/obj/structure/bed/get_interactions_info()
	. = ..()
	.["Carpet"] = "<p>Pads \the [initial(name)] with carpet.</p>"
	.[CODEX_INTERACTION_GRAB] = "<p>Attempts to buckle the victim to \the [initial(name)]. If successful, this drops the grab.</p>"
	.[CODEX_INTERACTION_MATERIAL_STACK] = "<p>If the material can be used to pad furniture, pads \the [initial(name)] with the material.</p>"
	.[CODEX_INTERACTION_WIRECUTTERS] = "<p>Removes any padding.</p>"
	.[CODEX_INTERACTION_WRENCH] = "<p>Dismantles \the [initial(name)].</p>"


/obj/structure/bed/use_grab(obj/item/grab/grab, list/click_params)
	if (!can_buckle(grab.affecting, grab.assailant))
		return TRUE
	grab.assailant.visible_message(
		SPAN_WARNING("\The [grab.assailant] starts buckling \the [grab.affecting] to \the [src]."),
		SPAN_DANGER("You start buckling \the [grab.affecting] to \the [src]."),
		exclude_mobs = list(grab.affecting)
	)
	to_chat(grab.affecting, SPAN_DANGER("\The [grab.assailant] starts buckling you to \the [src]."))
	if (!do_after(grab.assailant, 2 SECONDS, src, DO_PUBLIC_UNIQUE) || !grab.assailant.use_sanity_check(src, grab))
		return TRUE
	if (!can_buckle(grab.affecting, grab.assailant) || !user_buckle_mob(grab.affecting, grab.assailant))
		return TRUE
	qdel(src)
	return TRUE


/obj/structure/bed/use_tool(obj/item/tool, mob/user, list/click_params)
	// Carpet Stack - Add padding
	if (istype(tool, /obj/item/stack/tile/carpet))
		if (padding_material)
			to_chat(user, SPAN_WARNING("\The [src] is already padded with [padding_material.use_name]."))
			return TRUE
		var/obj/item/stack/tile/carpet/carpet = tool
		carpet.use(1)
		add_padding(MATERIAL_CARPET)
		user.visible_message(
			SPAN_NOTICE("\The [user] pads \the [src] with some [carpet.plural_name]."),
			SPAN_NOTICE("You pad \the [src] with some [carpet.plural_name].")
		)
		return TRUE

	// Material Stack - Add padding
	if (istype(tool, /obj/item/stack/material))
		if (padding_material)
			to_chat(user, SPAN_WARNING("\The [src] is already padded with [padding_material.use_name]."))
			return TRUE
		var/obj/item/stack/material/stack_material = tool
		if (!HAS_FLAGS(stack_material.material.flags, MATERIAL_PADDING))
			to_chat(user, SPAN_WARNING("\The [tool] cannot be used to pad \the [src]."))
			return TRUE
		var/obj/item/stack/material/stack = tool
		stack.use(1)
		add_padding(stack_material.material.name)
		user.visible_message(
			SPAN_NOTICE("\The [user] pads \the [src] with some [stack.plural_name]."),
			SPAN_NOTICE("You pad \the [src] with some [stack.plural_name].")
		)
		return TRUE

	// Wirecutters - Remove padding
	if (isWirecutter(tool))
		if (!padding_material)
			to_chat(user, SPAN_WARNING("\The [src] has no padding to remove."))
			return TRUE
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \the [src]'s [padding_material.use_name] padding with \a [tool]."),
			SPAN_NOTICE("You remove \the [src]'s [padding_material.use_name] padding with \the [tool].")
		)
		remove_padding()
		return TRUE

	// Wrench - Dismantle
	if (isWrench(tool))
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		dismantle()
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
		)
		qdel(src)
		return TRUE

	return ..()


/obj/structure/bed/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		var/mob/living/affecting = G.affecting
		user.visible_message(SPAN_NOTICE("[user] attempts to buckle [affecting] into \the [src]!"))
		if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
			if(user_buckle_mob(affecting, user))
				qdel(W)
	else
		..()

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
	icon = 'icons/obj/furniture.dmi'
	icon_state = "mattress"
	desc = "A bare mattress. It doesn't look very comfortable."
	anchored = FALSE

/obj/structure/mattress/dirty
	name = "dirty mattress"
	icon_state = "dirty_mattress"
	desc = "A dirty, smelly mattress covered in body fluids. You wouldn't want to touch this."
