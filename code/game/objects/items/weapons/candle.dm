/obj/item/weapon/flame/candle
	name = "candle"
	desc = "A small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = ITEM_SIZE_TINY
	light_color = "#e09d37"
	var/available_colours = list(COLOR_WHITE, COLOR_DARK_GRAY, COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_GREEN, COLOR_BLUE, COLOR_INDIGO, COLOR_VIOLET)
	var/wax
	var/last_lit

/obj/item/weapon/flame/candle/Initialize()
	wax = rand(27 MINUTES, 33 MINUTES) / SSobj.wait // Enough for 27-33 minutes. 30 minutes on average, adjusted for subsystem tickrate.
	color = pick(available_colours)
	. = ..()

/obj/item/weapon/flame/candle/on_update_icon()
	switch(wax)
		if(1500 to INFINITY)
			icon_state = "candle1"
		if(800 to 1500)
			icon_state = "candle2"
		else
			icon_state = "candle3"

	if(lit != last_lit)
		last_lit = lit
		overlays.Cut()
		if(lit)
			overlays += overlay_image(icon, "[icon_state]_lit", flags=RESET_COLOR)

/obj/item/weapon/flame/candle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(isflamesource(W) || is_hot(W))
		light(user)

/obj/item/weapon/flame/candle/resolve_attackby(var/atom/A, mob/user)
	. = ..()
	if(istype(A, /obj/item/weapon/flame/candle/) && is_hot(src))
		var/obj/item/weapon/flame/candle/other_candle = A
		other_candle.light()

/obj/item/weapon/flame/candle/proc/light(mob/user)
	if(!lit)
		lit = 1
		visible_message("<span class='notice'>\The [user] lights the [name].</span>")
		set_light(0.3, 0.1, 4, 2)
		START_PROCESSING(SSobj, src)

/obj/item/weapon/flame/candle/Process()
	if(!lit)
		return
	wax--
	if(!wax)
		var/obj/item/trash/candle/C = new(loc)
		C.color = color
		qdel(src)
		return
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/weapon/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)

/obj/item/weapon/storage/candle_box
	name = "candle pack"
	desc = "A pack of unscented candles in a variety of colours."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox"
	throwforce = 2
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 7
	slot_flags = SLOT_BELT

	startswith = list(/obj/item/weapon/flame/candle = 7)