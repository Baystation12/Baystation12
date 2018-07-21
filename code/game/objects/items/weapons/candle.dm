/obj/item/weapon/flame/candle
	name = "red candle"
	desc = "A small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = ITEM_SIZE_TINY
	light_color = "#e09d37"
	var/wax

/obj/item/weapon/flame/candle/New()
	wax = rand(27 MINUTES, 33 MINUTES) / SSobj.wait // Enough for 27-33 minutes. 30 minutes on average, adjusted for subsystem tickrate.

	..()

/obj/item/weapon/flame/candle/update_icon()
	var/i
	if(wax > 1500)
		i = 1
	else if(wax > 800)
		i = 2
	else i = 3
	icon_state = "candle[i][lit ? "_lit" : ""]"


/obj/item/weapon/flame/candle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(is_hot(W))
		light()

/obj/item/weapon/flame/candle/resolve_attackby(var/atom/A, mob/user)
	. = ..()
	if(istype(A, /obj/item/weapon/flame/candle/) && is_hot(src))
		var/obj/item/weapon/flame/candle/other_candle = A
		other_candle.light()

/obj/item/weapon/flame/candle/proc/light(mob/user)
	if(!src.lit)
		src.lit = 1
		//src.damtype = "fire"
		src.visible_message("<span class='notice'>\The [user] lights the [name].</span>")
		set_light(0.3, 0.1, 4, 2)
		START_PROCESSING(SSobj, src)


/obj/item/weapon/flame/candle/Process()
	if(!lit)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		qdel(src)
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/weapon/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)
