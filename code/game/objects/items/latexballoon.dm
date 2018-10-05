/obj/item/latexballon
	name = "latex glove"
	desc = "A latex glove, usually used as a balloon."
	icon_state = "latexballon"
	item_state = "lgloves"
	force = 0
	throwforce = 0
	w_class = ITEM_SIZE_SMALL
	throw_speed = 1
	throw_range = 15
	var/state
	var/datum/gas_mixture/air_contents = null

/obj/item/latexballon/proc/blow(obj/item/weapon/tank/tank)
	if (icon_state == "latexballon_bursted")
		return
	src.air_contents = tank.remove_air_volume(3)
	icon_state = "latexballon_blow"
	item_state = "latexballon"

/obj/item/latexballon/proc/burst()
	if (!air_contents)
		return
	playsound(src, 'sound/weapons/gunshot/gunshot.ogg', 100, 1)
	icon_state = "latexballon_bursted"
	item_state = "lgloves"
	loc.assume_air(air_contents)

/obj/item/latexballon/ex_act(severity)
	burst()
	switch(severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(50))
				qdel(src)

/obj/item/latexballon/bullet_act()
	burst()

/obj/item/latexballon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C+100)
		burst()
	return

/obj/item/latexballon/attackby(obj/item/W as obj, mob/user as mob)
	if (W.can_puncture())
		burst()
