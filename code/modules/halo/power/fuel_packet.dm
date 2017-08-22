

//Fuel packet item

/obj/item/fusion_fuel
	name = "fusion fuel packet"
	desc = "A packet of fuel for the starship fusion reactors."
	icon = 'fusion_drive.dmi'
	icon_state = "fuel_packet"
	item_state = "box"
	var/fuel_left = 3600
	var/max_fuel = 3600

/obj/item/fusion_fuel/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	..()
	to_chat(user,"It has [fuel_left] out [max_fuel] units of fuel left ([100 * fuel_left/max_fuel]%).")
