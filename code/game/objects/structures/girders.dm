/obj/structure/girder
	icon_state = "girder"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	w_class = ITEM_SIZE_NO_CONTAINER
	health_max = 100
	var/const/GIRDER_STATE_NORMAL = 0
	var/const/GIRDER_STATE_REINFORCEMENT_UNSECURED = 1
	var/const/GIRDER_STATE_REINFORCED = 2
	var/state = GIRDER_STATE_NORMAL
	var/cover = 50 //how much cover the girder provides against projectiles.
	var/material/reinf_material
	var/reinforcing = 0

/obj/structure/girder/Initialize()
	set_extension(src, /datum/extension/penetration/simple, 100)
	. = ..()

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = FALSE
	health_max = 50
	cover = 25

/obj/structure/girder/bullet_act(obj/item/projectile/Proj)
	//Girders only provide partial cover. There's a chance that the projectiles will just pass through. (unless you are trying to shoot the girder)
	if(Proj.original != src && !prob(cover))
		return PROJECTILE_CONTINUE //pass through
	. = ..()

/obj/structure/girder/on_death()
	dismantle()

/obj/structure/girder/CanFluidPass(coming_from)
	return TRUE

/obj/structure/girder/proc/reset_girder()
	anchored = TRUE
	cover = initial(cover)
	revive_health()
	state = GIRDER_STATE_NORMAL
	icon_state = initial(icon_state)
	reinforcing = 0
	if(reinf_material)
		reinforce_girder()


/obj/structure/girder/can_anchor(obj/item/tool, mob/user, silent)
	if (reinf_material || state != GIRDER_STATE_NORMAL)
		if (!silent)
			USE_FEEDBACK_FAILURE("\The [src]'s reinforcements must be removed before it can be moved.")
		return FALSE

	return ..()


/obj/structure/girder/use_tool(obj/item/tool, mob/user, list/click_params)
	// Crowbar - Dislodge
	if (isCrowbar(tool))
		if (!can_anchor(tool, user))
			return TRUE
		playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts dislodging \the [src] with \a [tool]."),
			SPAN_NOTICE("You start dislodging \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!can_anchor(tool, user))
			return TRUE
		icon_state = "displaced"
		anchored = FALSE
		set_max_health(50)
		cover = 25
		user.visible_message(
			SPAN_NOTICE("\The [user] dislodges \the [src] with \a [tool]."),
			SPAN_NOTICE("You dislodge \the [src] with \a [tool].")
		)
		return TRUE

	// Diamond Drill, Plasmacutter, Psiblade (Paramount) - Slice girder
	if (istype(tool, /obj/item/pickaxe/diamonddrill) || istype(tool, /obj/item/gun/energy/plasmacutter) || istype(tool, /obj/item/psychic_power/psiblade/master/grand/paramount))
		var/obj/item/gun/energy/plasmacutter/cutter = tool
		if (istype(cutter) && !cutter.slice(user))
			return TRUE
		playsound(loc, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts cutting \the [src] with \a [tool]."),
			SPAN_NOTICE("You start cutting \the [src] with \the [tool].")
		)
		if (!user.do_skilled((reinf_material ? 4 : 2) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		playsound(loc, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts apart \the [src] with \a [tool]."),
			SPAN_NOTICE("You cut apart \the [src] with \a [tool].")
		)
		if (reinf_material)
			reinf_material.place_dismantled_product(get_turf(src))
		dismantle()
		return TRUE

	// Material - Construct wall or reinforce
	if (istype(tool, /obj/item/stack/material))
		if (reinforcing && !reinf_material)
			reinforce_with_material(tool, user)
			return TRUE
		construct_wall(tool, user)
		return TRUE

	// Screwdriver
	// - Unsecure support struts
	// - Allow reinforcement
	if (isScrewdriver(tool))
		switch (state)
			if (GIRDER_STATE_NORMAL)
				if (!anchored)
					USE_FEEDBACK_FAILURE("\The [src] needs to be anchored before you can add reinforcements.")
					return TRUE
				if (reinf_material)
					USE_FEEDBACK_FAILURE("\The [src] already has \a [reinf_material.adjective_name] reinforcement.")
					return TRUE
				playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
				reinforcing = !reinforcing
				user.visible_message(
					SPAN_NOTICE("\The [user] adjusts \the [src] with \a [tool]. It can now be [reinforcing ? "reinforced" : "constructed"]."),
					SPAN_NOTICE("You adjust \the [src] with \the [tool]. It can now be [reinforcing ? "reinforced" : "constructed"].")
				)
				return TRUE
			if (GIRDER_STATE_REINFORCEMENT_UNSECURED)
				playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] starts securing \the [src]'s support struts with \a [tool]."),
					SPAN_NOTICE("You starts securing \the [src]'s support struts with \the [tool].")
				)
				if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
					return TRUE
				if (state != GIRDER_STATE_REINFORCEMENT_UNSECURED)
					USE_FEEDBACK_FAILURE("\The [src]'s state has changed.")
					return TRUE
				state = GIRDER_STATE_REINFORCED
				user.visible_message(
					SPAN_NOTICE("\The [user] secures \the [src]'s support struts with \a [tool]."),
					SPAN_NOTICE("You secure \the [src]'s support struts with \the [tool].")
				)
				return TRUE
			if (GIRDER_STATE_REINFORCED)
				playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] starts unsecuring \the [src]'s support struts with \a [tool]."),
					SPAN_NOTICE("You starts unsecuring \the [src]'s support struts with \the [tool].")
				)
				if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
					return TRUE
				if (state != GIRDER_STATE_REINFORCED)
					USE_FEEDBACK_FAILURE("\The [src]'s state has changed.")
					return TRUE
				playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
				state = GIRDER_STATE_REINFORCEMENT_UNSECURED
				user.visible_message(
					SPAN_NOTICE("\The [user] unsecures \the [src]'s support struts with \a [tool]."),
					SPAN_NOTICE("You unsecure \the [src]'s support struts with \the [tool].")
				)
				return TRUE

	// Wirecutters - Remove reinforcement
	if (isWirecutter(tool))
		switch (state)
			if (GIRDER_STATE_NORMAL)
				USE_FEEDBACK_FAILURE("\The [src] has no reinforcements to remove.")
				return TRUE
			if (GIRDER_STATE_REINFORCEMENT_UNSECURED)
				playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] starts removing \the [src]'s support struts with \a [tool]."),
					SPAN_NOTICE("You start removing \the [src]'s support struts with \the [tool].")
				)
				if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
					return TRUE
				if (state != GIRDER_STATE_REINFORCEMENT_UNSECURED)
					USE_FEEDBACK_FAILURE("\The [src]'s state has changed.")
					return TRUE
				playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
				if (reinf_material)
					reinf_material.place_dismantled_product(get_turf(src))
					reinf_material = null
				reset_girder()
				user.visible_message(
					SPAN_NOTICE("\The [user] removes \the [src]'s support struts with \a [tool]."),
					SPAN_NOTICE("You remove \the [src]'s support struts with \the [tool].")
				)
				return TRUE

	// Wrench - Dismantle girder
	if (isWrench(tool))
		if (state != GIRDER_STATE_NORMAL)
			USE_FEEDBACK_FAILURE("\The [src]'s reinforcements must be removed before it can be dismantled.")
			return TRUE
		if (anchored)
			playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] starts dismantling \the [src] with \a [tool]."),
				SPAN_NOTICE("You start dismantling \the [src] with \the [tool].")
			)
			if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
				return TRUE
			if (state != GIRDER_STATE_NORMAL || !anchored)
				USE_FEEDBACK_FAILURE("\The [src]'s state has changed.")
				return TRUE
			playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
				SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
			)
			dismantle()
			return TRUE
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts securing \the [src] with \a [tool]."),
			SPAN_NOTICE("You start securing \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (state != GIRDER_STATE_NORMAL || anchored)
			USE_FEEDBACK_FAILURE("\The [src]'s state has changed.")
			return TRUE
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] secures \the [src] with \a [tool]."),
			SPAN_NOTICE("You secure \the [src] with \the [tool].")
		)
		reset_girder()
		return TRUE

	return ..()


/obj/structure/girder/proc/construct_wall(obj/item/stack/material/S, mob/user)
	if(S.get_amount() < 2)
		to_chat(user, SPAN_NOTICE("There isn't enough material here to construct a wall."))
		return 0

	var/material/M = SSmaterials.get_material_by_name(S.default_type)
	if(!istype(M))
		return 0

	var/wall_fake
	add_hiddenprint(usr)

	if(M.integrity < 50)
		to_chat(user, SPAN_NOTICE("This material is too soft for use in wall construction."))
		return 0

	to_chat(user, SPAN_NOTICE("You begin adding the plating..."))

	if(!do_after(user,4 SECONDS, src, DO_REPAIR_CONSTRUCT) || !S.use(2))
		return TRUE

	if(anchored)
		to_chat(user, SPAN_NOTICE("You added the plating!"))
	else
		to_chat(user, SPAN_NOTICE("You create a false wall! Push on it to open or close the passage."))
		wall_fake = 1

	var/turf/Tsrc = get_turf(src)
	Tsrc.ChangeTurf(/turf/simulated/wall)
	var/turf/simulated/wall/T = get_turf(src)
	T.set_material(M, reinf_material)
	if(wall_fake)
		T.can_open = 1
	T.add_hiddenprint(usr)
	qdel(src)
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user) //if the verb is removed this can be renamed.
	if(reinf_material)
		to_chat(user, SPAN_NOTICE("\The [src] is already reinforced."))
		return 0

	if(S.get_amount() < 2)
		to_chat(user, SPAN_NOTICE("There isn't enough material here to reinforce the girder."))
		return 0

	var/material/M = S.material
	if(!istype(M) || M.integrity < 50)
		to_chat(user, "You cannot reinforce \the [src] with that; it is too soft.")
		return 0

	to_chat(user, SPAN_NOTICE("Now reinforcing..."))
	if (!do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT) || !S.use(2))
		return TRUE
	to_chat(user, SPAN_NOTICE("You added reinforcement!"))

	reinf_material = M
	reinforce_girder()
	return 1

/obj/structure/girder/proc/reinforce_girder()
	cover = 75
	set_max_health(500)
	state = GIRDER_STATE_REINFORCED
	icon_state = "reinforced"
	reinforcing = 0

/obj/structure/girder/proc/dismantle()
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)

/obj/structure/girder/cult
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	health_max = 250
	cover = 70

/obj/structure/girder/cult/dismantle()
	qdel(src)
