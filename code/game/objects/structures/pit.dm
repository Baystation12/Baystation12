/obj/structure/pit
	name = "pit"
	desc = "Watch your step, partner."
	icon = 'icons/obj/pit.dmi'
	icon_state = "pit1"
	blend_mode = BLEND_MULTIPLY
	density = FALSE
	anchored = TRUE
	var/open = 1


/obj/structure/pit/use_tool(obj/item/tool, mob/user, list/click_params)
	// Shovel - Dig or fill pit
	if (istype(tool, /obj/item/shovel))
		user.visible_message(
			SPAN_NOTICE("\The [user] starts [open ? "filling" : "digging open"] \the [src] with \a [tool]."),
			SPAN_NOTICE("You start [open ? "filling" : "digging open"] \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 5) SECONDS, SKILL_HAULING, src) || !user.use_sanity_check(src, tool))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] [open ? "fills" : "digs open"] \the [src] with \a [tool]."),
			SPAN_NOTICE("You [open ? "fill" : "dig open"] \the [src] with \the [tool].")
		)
		if (open)
			close(user)
		else
			open()
		return TRUE

	// Wood Material - Add grave marker
	if (istype(tool, /obj/item/stack/material/wood))
		if (open)
			USE_FEEDBACK_FAILURE("\The [src] needs tobe filled before you can add a grave marker.")
			return TRUE
		var/obj/structure/gravemarker/grave = locate() in loc
		if (grave)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [grave].")
			return TRUE
		var/obj/item/stack/material/wood/stack = tool
		if (!stack.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 1, "to make a grave marker")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts making a grave marker on top of \the [src] with \a [tool]."),
			SPAN_NOTICE("You start making a grave marker on top of \the [src] with \the [tool].")
		)
		if (!user.do_skilled(5 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (grave)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [grave].")
			return TRUE
		if (!stack.use(1))
			return TRUE
		var/obj/structure/gravemarker/new_grave = new(loc)
		new_grave.add_fingerprint(user, tool = tool)
		user.visible_message(
			SPAN_NOTICE("\The [user] makes a grave marker on top of \the [src] with \a [tool]."),
			SPAN_NOTICE("You make a grave marker on top of \the [src] with \the [tool].")
		)
		return TRUE

	return ..()


/obj/structure/pit/on_update_icon()
	icon_state = "pit[open]"
	if(istype(loc,/turf/simulated/floor/exoplanet))
		var/turf/simulated/floor/exoplanet/E = loc
		if(E.dirt_color)
			color = E.dirt_color

/obj/structure/pit/proc/open()
	name = "pit"
	desc = "Watch your step, partner."
	open = 1
	for(var/atom/movable/A in src)
		A.forceMove(src.loc)
	update_icon()

/obj/structure/pit/proc/close(user)
	name = "mound"
	desc = "Some things are better left buried."
	open = 0
	for(var/atom/movable/A in src.loc)
		if(!A.anchored && A != user)
			A.forceMove(src)
	update_icon()

/obj/structure/pit/return_air()
	if(open && loc)
		return loc.return_air()
	else
		return null

/obj/structure/pit/proc/digout(mob/escapee)
	var/breakout_time = 1 //2 minutes by default

	if(open)
		return

	if(escapee.stat || escapee.restrained())
		return

	escapee.setClickCooldown(100)
	to_chat(escapee, SPAN_WARNING("You start digging your way out of \the [src] (this will take about [breakout_time] minute\s)"))
	visible_message(SPAN_DANGER("Something is scratching its way out of \the [src]!"))

	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		playsound(src.loc, 'sound/weapons/bite.ogg', 100, 1)

		if(!do_after(escapee, 5 SECONDS, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			to_chat(escapee, SPAN_WARNING("You have stopped digging."))
			return
		if(open)
			return

		if(i == 6*breakout_time)
			to_chat(escapee, SPAN_WARNING("Halfway there..."))

	to_chat(escapee, SPAN_WARNING("You successfuly dig yourself out!"))
	visible_message(SPAN_DANGER("\the [escapee] emerges from \the [src]!"))
	playsound(src.loc, 'sound/effects/squelch1.ogg', 100, 1)
	open()

/obj/structure/pit/closed
	name = "mound"
	desc = "Some things are better left buried."
	open = 0

/obj/structure/pit/closed/Initialize()
	. = ..()
	close()

//invisible until unearthed first
/obj/structure/pit/closed/hidden
	invisibility = INVISIBILITY_OBSERVER

/obj/structure/pit/closed/hidden/open()
	..()
	set_invisibility(INVISIBILITY_LEVEL_ONE)

//spoooky
/obj/structure/pit/closed/grave
	name = "grave"
	icon_state = "pit0"

/obj/structure/pit/closed/grave/Initialize()
	var/obj/structure/closet/coffin/C = new(src.loc)
	var/obj/item/remains/human/bones = new(C)
	bones.layer = LYING_MOB_LAYER
	var/obj/structure/gravemarker/random/R = new(src.loc)
	R.generate()
	. = ..()

/obj/structure/gravemarker
	name = "grave marker"
	desc = "You're not the first."
	icon = 'icons/obj/gravestone.dmi'
	icon_state = "wood"
	pixel_x = 15
	pixel_y = 8
	anchored = TRUE
	var/message = "Unknown."

/obj/structure/gravemarker/cross
	icon_state = "cross"

/obj/structure/gravemarker/examine(mob/user)
	. = ..()
	to_chat(user, "It says: '[message]'")

/obj/structure/gravemarker/random/Initialize()
	generate()
	. = ..()

/obj/structure/gravemarker/random/proc/generate()
	icon_state = pick("wood","cross")

	var/singleton/cultural_info/S = SSculture.get_culture(CULTURE_HUMAN)
	var/nam = S.get_random_name(pick(MALE,FEMALE))
	var/cur_year = GLOB.using_map.game_year
	var/born = cur_year - rand(5,150)
	var/died = max(cur_year - rand(0,70),born)

	message = "Here lies [nam], [born] - [died]."


/obj/structure/gravemarker/use_tool(obj/item/tool, mob/user, list/click_params)
	// Hatchet - Remove marker
	if (istype(tool, /obj/item/material/hatchet))
		user.visible_message(
			SPAN_NOTICE("\The [user] starts hacking away at \the [src] with \a [tool]."),
			SPAN_NOTICE("You start hacking away at \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 2) SECONDS, list(SKILL_CONSTRUCTION, SKILL_HAULING), src) || !user.use_sanity_check(src, tool))
			return TRUE
		var/obj/item/stack/material/wood/stack = new(loc, 1)
		transfer_fingerprints_to(stack)
		user.visible_message(
			SPAN_NOTICE("\The [user] hacks \the [src] apart with \a [tool]."),
			SPAN_NOTICE("You hack \the [src] apart with \the [tool].")
		)
		qdel_self()
		return TRUE

	// Pen - Label grave
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "What should the grave say?", "[src] - Name", message) as null|text
		input = sanitizeSafe(input, MAX_NAME_LEN)
		if (!input || input == message || !user.use_sanity_check(src, tool))
			return TRUE
		message = input
		user.visible_message(
			SPAN_NOTICE("\The [user] labels \the [src] with \a [tool]."),
			SPAN_NOTICE("You label \the [src] with '[message]' using \the [tool].")
		)
		return TRUE

	return ..()
