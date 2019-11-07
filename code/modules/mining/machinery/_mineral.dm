/obj/machinery/mineral
	icon = 'icons/obj/machines/mining_machines.dmi'
	density =  TRUE
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/turf/input_turf
	var/turf/output_turf
	var/obj/machinery/computer/mining/console

/obj/machinery/mineral/Destroy()
	input_turf = null
	output_turf = null
	if(console)
		if(console.connected == src)
			console.connected = null
		console = null
	. = ..()

/obj/machinery/mineral/Initialize()
	set_input(input_turf)
	set_output(output_turf)
	find_console()
	. = ..()

/obj/machinery/mineral/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state))
		updateUsrDialog()

/obj/machinery/mineral/proc/set_input(var/_dir)
	input_turf = _dir ? get_step(loc, _dir) : null

/obj/machinery/mineral/proc/set_output(var/_dir)
	output_turf = _dir ? get_step(loc, _dir) : null

/obj/machinery/mineral/proc/get_console_data()
	. = list("<h1>Input/Output</h1>")
	if(input_turf)
		. += "<b>Input</b>: [dir2text(get_dir(src, input_turf))]."
	else
		. += "<b>Input</b>: disabled."
	if(output_turf)
		. += "<b>Output</b>: [dir2text(get_dir(src, output_turf))]."
	else
		. += "<b>Output</b>: disabled."
	. += "<br><a href='?src=\ref[src];configure_input_output=1'>Configure</a>"

/obj/machinery/mineral/CanUseTopic(var/mob/user)
	return max(..(), (console && console.CanUseTopic(user)))

/obj/machinery/mineral/proc/find_console()
	if(ispath(console))
		for(var/c in GLOB.alldirs)
			var/turf/T = get_step(loc, c)
			if(T)
				var/obj/machinery/computer/mining/tmpconsole = locate(console) in T
				if(tmpconsole && !tmpconsole.connected)
					console = tmpconsole
					console.connected = src
					break

/obj/machinery/mineral/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["configure_input_output"])
		interact(usr)
		. = TRUE
	else if(href_list["scan_for_console"])
		find_console()
		. = TRUE
	if(console && usr.Adjacent(console))
		usr.set_machine(console)
		console.add_fingerprint(usr)

/obj/machinery/mineral/interface_interact(var/mob/user)
	interact(user)
	return TRUE

/obj/machinery/mineral/proc/can_configure(var/mob/user)
	if(user.incapacitated())
		return FALSE
	if(istype(user, /mob/living/silicon))
		return TRUE
	return (Adjacent(user) || (console && console.Adjacent(user)))

/obj/machinery/mineral/interact(var/mob/user)

	if(!can_configure(user)) return

	var/choice = input("Do you wish to change the input direction, or the output direction?") as null|anything in list("Input", "Output")
	if(isnull(choice) || !can_configure(user)) return

	var/list/_dirs = list("North" = NORTH, "South" = SOUTH, "East" = EAST, "West" = WEST, "Clear" = 0)
	var/dchoice = input("Do you wish to change the input direction, or the output direction?") as null|anything in _dirs
	if(isnull(dchoice) || !can_configure(user)) return

	if(choice == "Input")
		set_input(dchoice ? _dirs[dchoice] : null)
		to_chat(user, "<span class='notice'>You [input_turf ? "configure" : "disable"] \the [src]'s input system.</span>")
	else
		set_output(dchoice ? _dirs[dchoice] : null)
		to_chat(user, "<span class='notice'>You [output_turf ? "configure" : "disable"] \the [src]'s output system.</span>")