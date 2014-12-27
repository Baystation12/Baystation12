/obj/item/weapon/flame/candle
	name = "red candle"
	desc = "a candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = 1

	var/wax = 200

/obj/item/weapon/flame/candle/update_icon()
	var/i
	if(wax>150)
		i = 1
	else if(wax>80)
		i = 2
	else i = 3
	icon_state = "candle[i][lit ? "_lit" : ""]"


/obj/item/weapon/flame/candle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding tool
			light("\red [user] casually lights the [name] with [W].")
	else if(istype(W, /obj/item/weapon/flame/lighter))
		var/obj/item/weapon/flame/lighter/L = W
		if(L.lit)
			light()
	else if(istype(W, /obj/item/weapon/flame/match))
		var/obj/item/weapon/flame/match/M = W
		if(M.lit)
			light()
	else if(istype(W, /obj/item/weapon/flame/candle))
		var/obj/item/weapon/flame/candle/C = W
		if(C.lit)
			light()


/obj/item/weapon/flame/candle/proc/light(var/flavor_text = "\red [usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		//src.damtype = "fire"
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		SetLuminosity(CANDLE_LUM)
		processing_objects.Add(src)


/obj/item/weapon/flame/candle/process()
	if(!lit)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		if(istype(src.loc, /mob))
			src.dropped()
		del(src)
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)


/obj/item/weapon/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		SetLuminosity(0)
		user.SetLuminosity(user.luminosity - CANDLE_LUM)


/obj/item/weapon/flame/candle/pickup(mob/user)
	if(lit)
		SetLuminosity(0)
		user.SetLuminosity(user.luminosity + CANDLE_LUM)


/obj/item/weapon/flame/candle/dropped(mob/user)
	if(lit)
		user.SetLuminosity(user.luminosity - CANDLE_LUM)
		SetLuminosity(CANDLE_LUM)
