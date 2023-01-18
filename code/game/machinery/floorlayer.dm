/obj/machinery/floorlayer

	name = "automatic floor layer"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	var/turf/old_turf
	var/on = 0
	var/obj/item/stack/tile/T
	var/list/mode = list("dismantle"=0,"laying"=0,"collect"=0)

/obj/machinery/floorlayer/New()
	T = new/obj/item/stack/tile/floor(src)
	..()

/obj/machinery/floorlayer/Move(new_turf,M_Dir)
	..()

	if(on)
		if(mode["dismantle"])
			dismantleFloor(old_turf)

		if(mode["laying"])
			layFloor(old_turf)

		if(mode["collect"])
			CollectTiles(old_turf)


	old_turf = new_turf

/obj/machinery/floorlayer/physical_attack_hand(mob/user)
	on=!on
	user.visible_message(
		SPAN_NOTICE("\The [user] has [!on?"de":""]activated \the [src]."),
		SPAN_NOTICE("You [!on?"de":""]activate \the [src].")
	)
	return TRUE


/obj/machinery/floorlayer/use_tool(obj/item/tool, mob/user, list/click_params)
	// Crowbar - Remove tiles
	if (isCrowbar(tool))
		if (!length(contents))
			to_chat(user, SPAN_WARNING("\The [src] has no tiles to remove."))
			return TRUE
		var/obj/item/stack/tile/choice = input("Choose tile type to remove.", "Tiles") as null|anything in contents
		if (!choice || !user.use_sanity_check(src, tool))
			return TRUE
		if (!(choice in contents))
			to_chat(user, SPAN_WARNING("\The [src] doesn't contain that option anymore."))
			return TRUE
		tool.dropInto(loc)
		if (T == choice)
			T = null
		user.visible_message(
			SPAN_NOTICE("\The [user] removes some [choice] from \the [src] with \a [tool]."),
			SPAN_NOTICE("You remove \the [choice] from \the [src] with \the [tool].")
		)
		return TRUE

	// Floor Tile - Refill
	if (istype(tool, /obj/item/stack/tile))
		if (!user.unEquip(tool))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		TakeTile(tool)
		user.visible_message(
			SPAN_NOTICE("\The [user] loads \a [tool] into \the [src]."),
			SPAN_NOTICE("You load \the [tool] into \the [src].")
		)
		return TRUE

	// Screwdriver - Choose tile type
	if (isScrewdriver(tool))
		if (!length(contents))
			to_chat(user, SPAN_WARNING("\The [src] has no tiles to select."))
			return TRUE
		var/choice = input("Choose tile type.", "Tiles") as null|anything in contents
		if (!choice || !user.use_sanity_check(src, tool))
			return TRUE
		if (!(choice in contents))
			to_chat(user, SPAN_WARNING("\The [src] doesn't contain that option anymore."))
			return TRUE
		T = choice
		user.visible_message(
			SPAN_NOTICE("\The [user] configures \the [src] with \a [tool]."),
			SPAN_NOTICE("You set \the [src] to use \the [choice] with \the [tool].")
		)
		return TRUE

	// Wrench - Toggle mode
	if (isWrench(tool))
		var/choice = input("Choose work mode", "Mode") as null|anything in mode
		if (!choice || !user.use_sanity_check(src, tool))
			return TRUE
		mode[choice] = !mode[choice]
		user.visible_message(
			SPAN_NOTICE("\The [user] configures \the [src] with \a [tool]."),
			SPAN_NOTICE("You set \the [src]'s [choice] mode [mode[choice] ? "on" : "off"] with \the [tool].")
		)
		return TRUE

	return ..()


/obj/machinery/floorlayer/examine(mob/user)
	. = ..()
	var/dismantle = mode["dismantle"]
	var/laying = mode["laying"]
	var/collect = mode["collect"]
	var/message = SPAN_NOTICE("\The [src] [!T?"don't ":""]has [!T?"":"[T.get_amount()] [T] "]tile\s, dismantle is [dismantle?"on":"off"], laying is [laying?"on":"off"], collect is [collect?"on":"off"].")
	to_chat(user, message)

/obj/machinery/floorlayer/proc/reset()
	on = 0

/obj/machinery/floorlayer/proc/dismantleFloor(turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_plating())
			T.make_plating(!(T.broken || T.burnt))
	return new_turf.is_plating()

/obj/machinery/floorlayer/proc/TakeNewStack()
	for(var/obj/item/stack/tile/tile in contents)
		T = tile
		return 1
	return 0

/obj/machinery/floorlayer/proc/SortStacks()
	for(var/obj/item/stack/tile/tile1 in contents)
		for(var/obj/item/stack/tile/tile2 in contents)
			tile2.transfer_to(tile1)

/obj/machinery/floorlayer/proc/layFloor(turf/w_turf)
	if(!T)
		if(!TakeNewStack())
			return 0
	w_turf.attackby(T , src)
	return 1

/obj/machinery/floorlayer/proc/TakeTile(obj/item/stack/tile/tile)
	if(!T)	T = tile
	tile.forceMove(src)

	SortStacks()

/obj/machinery/floorlayer/proc/CollectTiles(turf/w_turf)
	for(var/obj/item/stack/tile/tile in w_turf)
		TakeTile(tile)
