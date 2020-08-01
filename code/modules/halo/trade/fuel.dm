/datum/shuttle
	var/obj/item/fusion_fuel/held_fuel

/obj/machinery/shuttle_fuel
	name = "shuttle fuel loader"
	desc = "An automated loading device for a fusion thruster to insert and remove deuterium fuel packets."
	icon = 'code/modules/halo/overmap/fusion_thruster.dmi'
	icon_state = "loader"
	anchored = 1
	density = 1
	var/obj/item/fusion_fuel/held_fuel
	var/datum/shuttle/my_shuttle

/obj/machinery/shuttle_fuel/New()
	. = ..()
	new /obj/item/fusion_fuel/(src.loc)

/obj/machinery/shuttle_fuel/proc/find_shuttle()
	var/area/cur_area = get_area(src)
	for(var/shuttle_name in shuttle_controller.shuttles)
		var/datum/shuttle/S = shuttle_controller.shuttles[shuttle_name]
		if(cur_area in S.shuttle_area)
			my_shuttle = S
			my_shuttle.held_fuel = held_fuel
			break

/obj/machinery/shuttle_fuel/attack_hand(var/mob/user)
	if(!my_shuttle)
		find_shuttle()

	if(isliving(user))
		if(held_fuel)
			src.visible_message("<span class='info'>[src] ejects it's spent [held_fuel].</span>")
			held_fuel.loc = src.loc
			held_fuel = null
			icon_state = "loader"
			if(my_shuttle)
				my_shuttle.held_fuel = null
		else
			to_chat(user, "<span class='notice'>[src] does not contain a deuterium fuel packet!</span>")

/obj/machinery/shuttle_fuel/attackby(var/obj/I, var/mob/user)
	if(!my_shuttle)
		find_shuttle()

	if(isliving(user))
		if(istype(I, /obj/item/fusion_fuel))
			user.drop_item()
			I.loc = src
			held_fuel = I
			if(my_shuttle)
				my_shuttle.held_fuel = held_fuel
			to_chat(user, "<span class='info'>You insert [I] into [src].</span>")
			icon_state = "loader_full"

/obj/machinery/shuttle_fuel/examine(var/user)
	. = ..()
	if(held_fuel)
		to_chat(user,"<span class='info'>[src] has \icon[held_fuel] [held_fuel] loaded.</span>")
	else
		to_chat(user,"<span class='warning'>[src] has no fuel loaded.</span>")
