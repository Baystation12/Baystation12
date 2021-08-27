// Lightswitch Hull

/obj/item/frame/light_switch
	name = "light switch frame"
	desc = "Used for building a light switch."
	icon = 'icons/obj/power.dmi'
	icon_state = "light-p"
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/frame/light_switch/windowtint
	name = "window tint switch frame"
	desc = "Used for building a window tint switch."
	icon = 'icons/obj/power.dmi'
	icon_state = "light-p"
	obj_flags = OBJ_FLAG_CONDUCTIBLE

GLOBAL_LIST_INIT(possible_switch_offsets, list(
		"North" = list(
			"Middle Lower" = list(0,25),
			"Offset Lower" = list(7,25),
			"Middle Upper" = list(0,32),
			"Offset Upper" = list(7,32)),
		"East" = list(
			"Middle Lower" = list(25,0),
			"Offset Lower" = list(25,7),
			"Middle Upper" = list(32,0),
			"Offset Upper" = list(32,7)),
		"South" = list(
			"Middle Lower" = list(0,-25),
			"Offset Lower" = list(7,-25),
			"Middle Upper" = list(0,-32),
			"Offset Upper" = list(7,-32)),
		"West" = list(
			"Middle Lower" = list(-25,0),
			"Offset Lower" = list(-25,7),
			"Middle Upper" = list(-32,0),
			"Offset Upper" = list(-32,7))))


/obj/item/frame/light_switch/proc/position_with_direction(obj/item/frame/light_switch/S as obj, mob/user as mob)
	for(var/i = 5; i >= 0; i -= 1)
		var/direction_choice = input(user, "In which direction?", "Select direction.") as null|anything in GLOB.possible_switch_offsets
		if(!direction_choice || user.incapacitated() || !user.Adjacent(src))
			return 0

		var/list/position_options = GLOB.possible_switch_offsets[direction_choice]

		var/position_choice = input(user, "Which position?", "Select Position") as null|anything in position_options
		if(!position_choice || user.incapacitated() || !user.Adjacent(src))
			return 0

		var/list/position_data = position_options[position_choice]
		S.pixel_x = position_data[1]
		S.pixel_y = position_data[2]

		var/confirm = alert(user, "Is this what you want? Chances Remaining: [i]", "Confirmation", "Yes", "No")
		if(confirm == "Yes")
			break
	return 1

/obj/item/frame/light_switch/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(isWrench(tool))
		new /obj/item/stack/material/steel( get_turf(src.loc), 1 )
		qdel(src)
	else if(istype(tool, /obj/item/screwdriver) && isturf(user.loc))
		var/obj/machinery/light_switch/S = new (user.loc)
		if(position_with_direction(S, user))
			to_chat(user, "You fasten \the [S] with your [tool].")
			qdel(src)
		else
			qdel(S)
	else ..()

/obj/item/frame/light_switch/windowtint/attackby(obj/item/tool as obj, mob/user as mob)
	if(isWrench(tool))
		new /obj/item/stack/material/steel( get_turf(src.loc), 1 )
		qdel(src)
	else if(istype(tool, /obj/item/screwdriver) && isturf(user.loc))
		var/obj/machinery/button/windowtint/S = new(user.loc)
		if(position_with_direction(S, user))
			to_chat(user, "You fasten \the [S] with your [tool].")
			qdel(src)
		else
			qdel(S)
	else ..()