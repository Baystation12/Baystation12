
/obj/machinery/diesel_generator
	name = "Portable diesel generator"
	desc = "A diesel powered portable fuel generator."
	icon = 'icons/obj/power.dmi'
	icon_state = "portgen0"
	density = 1
	anchored = 0
	var/active = 0
	var/power_target
	flags = OBJ_CLIMBABLE
	var/obj/item/weapon/tank/diesel/held_fuel
	var/list/powerables = list(\
		/obj/structure/electric_fence\
		)

/obj/machinery/diesel_generator/New()
	..()
	name = name + " #[rand(0,9)]"

/*
/obj/machinery/diesel_generator/MouseDrop_T(atom/target, mob/user)
	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		var/obj/item/cabling_coil/coil = target
		if(coil && istype(coil))
			coil.try_wiring(src, user)
	else
		return ..()
		*/

/obj/machinery/diesel_generator/proc/enable()
	set name = "Enable diesel generator"
	set category = "IC"
	set src in view(1)

	if(held_fuel)
		active = 1
	src.verbs -= /obj/machinery/diesel_generator/proc/enable
	src.verbs += /obj/machinery/diesel_generator/proc/disable

	to_chat(usr, "<span class='info'>You enable [src].</span>")

/obj/machinery/diesel_generator/proc/disable()
	set name = "Disable diesel generator"
	set category = "IC"
	set src in view(1)

	active = 0
	src.verbs -= /obj/machinery/diesel_generator/proc/disable
	src.verbs += /obj/machinery/diesel_generator/proc/enable

	to_chat(usr, "<span class='info'>You disable [src].</span>")

/obj/machinery/diesel_generator/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	..()
	var/outmsg = "<span class='info'>"
	if(held_fuel)
		outmsg += "It contains \icon[held_fuel] [held_fuel]. "
	if(active)
		outmsg += "It is currently running. "
	outmsg += "</span>"
	to_chat(user, outmsg)

/obj/machinery/diesel_generator/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/tank/diesel))
		if(held_fuel)
			to_chat(user, "\icon[src] <span class='warning'>You must remove \icon[held_fuel] [held_fuel] from [src] first.</span>")
		else
			held_fuel = I
			user.drop_item()
			I.loc = src
			active = 0
			to_chat(user, "\icon[src] <span class='info'>You insert \icon[held_fuel] [held_fuel] into [src].</span>")
	else
		return ..()

/obj/machinery/diesel_generator/attack_hand(var/mob/living/user)
	if(held_fuel)
		to_chat(user, "\icon[src] <span class='info'>You remove \icon[held_fuel] [held_fuel] from [src].</span>")
		held_fuel.loc = src.loc
		held_fuel = null

/obj/item/weapon/tank/diesel
	name = "diesel tank"
	desc = "Contains old fashioned diesel fuel."
	icon_state = "phoron"
	gauge_icon = null
	flags = CONDUCT
	slot_flags = null	//they have no straps!
