
/obj/item/device/flashlight/flaming_torch
	name = "wooden torch"
	desc = "A crude light source at night."
	icon = 'desert_outpost.dmi'
	icon_state = "torch"
	item_state = "baton"
	brightness_on = 5
	light_color = "#ffa500"
	matter = list("wood" = 1)
	action_button_name = "Flaming Torch"
	var/fuel_ticks_left = 100
	var/max_fuel_ticks = 100

/obj/item/device/flashlight/flaming_torch/update_icon()
	..()
	if(on)
		damtype = BURN
		force = 15
	else
		damtype = BRUTE
		force = 10

/obj/item/device/flashlight/flaming_torch/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(on)
		fuel_ticks_left -= 10

/obj/item/device/flashlight/flaming_torch/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	..()
	to_chat(user, "It has [fuel_ticks_left] out of [max_fuel_ticks] units of fuel left ([100 * fuel_ticks_left/max_fuel_ticks]%).")

/obj/item/device/flashlight/flaming_torch/attack_self(mob/user)
	if(..())
		if(on)
			GLOB.processing_objects += src
		else
			GLOB.processing_objects -= src

/obj/item/device/flashlight/flaming_torch/process()
	fuel_ticks_left -= 1
	if(fuel_ticks_left <= 0)
		set_light(0)
		var/mob/M = src.loc
		if(M && istype(M))
			M.remove_from_mob(src)
			M.show_message("<span class='warning'>[src] burns itself out.</span>")
		qdel(src)
