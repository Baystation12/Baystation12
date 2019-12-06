// RCON REMOTE CONTROL CONSOLE
//
// Last Change 1.1.2015 by Atlantis
//
// Allows remote operation of electrical systems on station (SMESs and Breaker Boxes)

/obj/machinery/computer/rcon
	name = "\improper RCON console"
	desc = "Console used to remotely control machinery."
	icon_keyboard = "power_key"
	icon_screen = "ai-fixer"
	light_color = "#a97faa"
	req_access = list(access_engine)
	var/current_tag = null
	var/datum/nano_module/rcon/rcon

/obj/machinery/computer/rcon/New()
	..()
	rcon = new(src)

/obj/machinery/computer/rcon/Destroy()
	qdel(rcon)
	rcon = null
	..()

/obj/machinery/computer/rcon/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

// Proc: ui_interact()
// Parameters: 4 (standard NanoUI parameters)
// Description: Uses dark magic (NanoUI) to render this machine's UI
/obj/machinery/computer/rcon/ui_interact(mob/user, ui_key = "rcon", var/datum/nanoui/ui = null, var/force_open = 1)
	rcon.ui_interact(user, ui_key, ui, force_open)

/obj/machinery/computer/rcon/on_update_icon()
	..()
	if(is_operable())
		overlays += image('icons/obj/computer.dmi', "ai-fixer-empty", overlay_layer)
