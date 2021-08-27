/obj/structure/pit
	name = "pit"
	desc = "Watch your step, partner."
	icon = 'icons/obj/pit.dmi'
	icon_state = "pit1"
	blend_mode = BLEND_MULTIPLY
	density = FALSE
	anchored = TRUE
	var/open = 1

/obj/structure/pit/attackby(obj/item/W, mob/user)
	if( istype(W,/obj/item/shovel) )
		visible_message("<span class='notice'>\The [user] starts [open ? "filling" : "digging open"] \the [src]</span>")
		if( do_after(user, 50) )
			visible_message("<span class='notice'>\The [user] [open ? "fills" : "digs open"] \the [src]!</span>")
			if(open)
				close(user)
			else
				open()
		else
			to_chat(user, "<span class='notice'>You stop shoveling.</span>")
		return
	if (!open && istype(W,/obj/item/stack/material/wood))
		if(locate(/obj/structure/gravemarker) in src.loc)
			to_chat(user, "<span class='notice'>There's already a grave marker here.</span>")
		else
			visible_message("<span class='notice'>\The [user] starts making a grave marker on top of \the [src]</span>")
			if( do_after(user, 50) )
				visible_message("<span class='notice'>\The [user] finishes the grave marker</span>")
				var/obj/item/stack/material/wood/plank = W
				plank.use(1)
				new/obj/structure/gravemarker(src.loc)
			else
				to_chat(user, "<span class='notice'>You stop making a grave marker.</span>")
		return
	..()

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

/obj/structure/pit/proc/close(var/user)
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
	to_chat(escapee, "<span class='warning'>You start digging your way out of \the [src] (this will take about [breakout_time] minute\s)</span>")
	visible_message("<span class='danger'>Something is scratching its way out of \the [src]!</span>")

	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		playsound(src.loc, 'sound/weapons/bite.ogg', 100, 1)

		if(!do_after(escapee, 50))
			to_chat(escapee, "<span class='warning'>You have stopped digging.</span>")
			return
		if(open)
			return

		if(i == 6*breakout_time)
			to_chat(escapee, "<span class='warning'>Halfway there...</span>")

	to_chat(escapee, "<span class='warning'>You successfuly dig yourself out!</span>")
	visible_message("<span class='danger'>\the [escapee] emerges from \the [src]!</span>")
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

	var/decl/cultural_info/S = SSculture.get_culture(CULTURE_HUMAN)
	var/nam = S.get_random_name(pick(MALE,FEMALE))
	var/cur_year = GLOB.using_map.game_year
	var/born = cur_year - rand(5,150)
	var/died = max(cur_year - rand(0,70),born)

	message = "Here lies [nam], [born] - [died]."

/obj/structure/gravemarker/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/material/hatchet))
		visible_message("<span class = 'warning'>\The [user] starts hacking away at \the [src] with \the [W].</span>")
		if(!do_after(user, 30))
			visible_message("<span class = 'warning'>\The [user] hacks \the [src] apart.</span>")
			new /obj/item/stack/material/wood(src)
			qdel(src)
	if(istype(W,/obj/item/pen))
		var/msg = sanitize(input(user, "What should it say?", "Grave marker", message) as text|null)
		if(msg)
			message = msg