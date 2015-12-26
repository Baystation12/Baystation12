/obj/item/weapon/flame/candle
	name = "red candle"
	desc = "a small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = 1
	light_color = "#E09D37"
	var/wax = 2000

/obj/item/weapon/flame/candle/New()
	wax = rand(800, 1000) // Enough for 27-33 minutes. 30 minutes on average.
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
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding tool
			light("<span class='notice'>\The [user] casually lights the [name] with [W].</span>")
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

/obj/item/weapon/flame/candle/light(var/flavor_text = "<span class='notice'>\The [usr] lights the [name].</span>")
	if(!..())
		return
	visible_message(flavor_text, 1)
	set_light(CANDLE_LUM)

/obj/item/weapon/flame/candle/process()
	if(..())
		wax--
		if(!wax)
			die()

/obj/item/weapon/flame/candle/die()
	set_light(0)
	if(!..())
		return
	var/obj/item/trash/candle/C = new (get_turf(src))
	var/mob/living/carbon/human/holder = loc
	if(istype(holder))
		holder.unEquip(src)
		holder.put_in_hands(C)
	qdel(src)

/obj/item/weapon/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)