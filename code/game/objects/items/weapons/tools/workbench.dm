//A workbench for upgrading things
/obj/structure/table/workbench
	name = "Nanocircuit Repair Bench"
	tool_qualities = list(QUALITY_WORKBENCH = 1)
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "deadspace_workbench"
	standalone = TRUE //No connecting, uses its own icon
	can_plate = FALSE


/obj/structure/table/workbench

//Quick ways to open crafting menu at this workbench
/obj/structure/table/workbench/AltClick(var/mob/user)
	if (isliving(user))
		var/mob/living/L = user
		L.open_craft_menu()

/obj/structure/table/workbench/consume_resources(var/timespent, var/user)
	var/time_in_seconds = timespent * 0.1 //This line is solely to make things more readable
	use_power(time_in_seconds * active_power_usage)





/******************************
	/* Power Code */
*******************************/
//Why on earth is use_power defined at the level of obj/machinery rather than just object? Future todo: refactor that mess.
//Beyond scope for now, so lets just duplicate some code to make workbenches use power

/obj/structure/table/workbench
	var/active_power_usage = 10 KILOWATTS	//Power used per second while working
	var/power_channel = EQUIP


/obj/structure/table/workbench/proc/use_power(var/amount, var/chan = -1)
	var/area/A = get_area(src)		// make sure it's in an area
	if(!A || !isarea(A))
		return
	if(chan == -1)
		chan = power_channel
	A.use_power(amount, chan)


//As above, more stuff copypasted from power.dm
/obj/structure/table/workbench/proc/powered(var/chan = -1, var/area/check_area = null)

	if(!src.loc)
		return 0


	if(!check_area)
		check_area = src.loc.loc		// make sure it's in an area
	if(!check_area || !isarea(check_area))
		return 0					// if not, then not powered
	if(chan == -1)
		chan = power_channel
	return check_area.powered(chan)			// return power status of the area






/******************************
	/* Data and Checking */
*******************************/
//These are overriding base procs to check if we have power
/obj/structure/table/workbench/has_quality(quality_id)
	if (powered())
		.=..()
	else
		return FALSE

/obj/structure/table/workbench/ever_has_quality(quality_id)
	if (powered())
		.=..()
	else
		return FALSE

/obj/structure/table/workbench/get_tool_quality(quality_id)
	if (powered())
		.=..()
	else
		return 0

/obj/structure/table/workbench/get_tool_type(var/mob/living/user, var/list/required_qualities, var/atom/use_on, var/datum/callback/CB)
	if (powered())
		.=..()
	else
		return list()