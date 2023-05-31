/obj/machinery/iff_beacon
	name = "IFF transponder" //This object handles ship identification on sensors.
	desc = "A complex set of various bluespace and subspace arrays that transmit a ship's identification tags."
	icon = 'packs/sierra-tweaks/icons/machinery/ship_transponder.dmi'
	icon_state = "transponder_wall"
	idle_power_usage = 500
	wires = /datum/wires/iff
	var/disabled = FALSE
	var/obfuscating = FALSE
	var/can_change_class = TRUE
	var/can_change_name = TRUE


/obj/machinery/iff_beacon/Initialize()
	..()
	wires = new/datum/wires/iff(src)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/iff_beacon/LateInitialize()
	for(var/obj/machinery/computer/ship/ship in SSmachines.machinery)
		if(GLOB.using_map.use_overmap && !ship.linked)
			var/my_sector = map_sectors["[z]"]
			if (istype(my_sector, /obj/effect/overmap/visitable))
				ship.attempt_hook_up(my_sector)

/obj/machinery/iff_beacon/use_tool(obj/item/tool, mob/user, list/click_params)
	if(isScrewdriver(tool))
		panel_open = !panel_open
		to_chat(user, "You [panel_open ?  "open" : "close"] the maintenance panel.")
		return TRUE

	if(panel_open)
		if(isMultitool(tool) || isWirecutter(tool))
			if(panel_open)
				wires.Interact(user)
			else
				USE_FEEDBACK_FAILURE("\The [src]'s wires aren't exposed.")
			return TRUE

	return ..()

/obj/machinery/iff_beacon/proc/toggle()
	if(disabled)
		return // No turning on if broken.
	if(!use_power) //need some juice to kickstart
		use_power_oneoff(idle_power_usage*5)
	update_use_power(!use_power)
	if(use_power) //We are online now. Back to displaying real name.
		for(var/obj/machinery/computer/ship/ship in SSmachines.machinery)
			ship.linked.update_obfuscated(FALSE)
			obfuscating = FALSE
	else
		for(var/obj/machinery/computer/ship/ship in SSmachines.machinery)
			ship.linked.update_obfuscated(TRUE)
			obfuscating = TRUE

/obj/machinery/iff_beacon/proc/disable()
	for(var/obj/machinery/computer/ship/ship in SSmachines.machinery)
		update_use_power(POWER_USE_OFF)
		obfuscating = TRUE
		disabled = TRUE
		ship.linked.update_obfuscated(TRUE)

/obj/machinery/iff_beacon/proc/enable()
	disabled = FALSE
	toggle()

/obj/machinery/iff_beacon/on_update_icon()
	icon_state = initial(icon_state)
	cut_overlays()
	if(!operable() || !use_power)
		icon_state += "_off"

/obj/machinery/iff_beacon/sierra
	can_change_class = FALSE
	can_change_name = FALSE

/obj/machinery/iff_beacon/name_change
	can_change_name = TRUE
	can_change_class = FALSE

/obj/machinery/iff_beacon/table
	icon_state = "transponder_table"

/obj/machinery/iff_beacon/table/name_change
	icon_state = "transponder_table"
	can_change_name = TRUE
	can_change_class = FALSE
