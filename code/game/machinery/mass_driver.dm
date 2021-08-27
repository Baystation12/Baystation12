//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/mass_driver
	name = "mass driver"
	desc = "Shoots things into space."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mass_driver"
	anchored = TRUE
	idle_power_usage = 2
	active_power_usage = 50

	var/power = 1.0
	var/code = 1.0
	var/drive_range = 50 //this is mostly irrelevant since current mass drivers throw into space, but you could make a lower-range mass driver for interstation transport or something I guess.

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	public_methods = list(
		/decl/public_access/public_method/driver_drive,
		/decl/public_access/public_method/driver_drive_delayed
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/driver = 1)

/obj/machinery/mass_driver/proc/drive(amount)
	if(stat & (BROKEN|NOPOWER))
		return
	use_power_oneoff(500)
	var/O_limit
	var/atom/target = get_edge_target_turf(src, dir)
	for(var/atom/movable/O in loc)
		if(!O.anchored)
			O_limit++
			if(O_limit >= 20)
				for(var/mob/M in hearers(src, null))
					to_chat(M, "<span class='notice'>The mass driver lets out a screech, it mustn't be able to handle any more items.</span>")
				break
			use_power_oneoff(500)
			spawn( 0 )
				O.throw_at(target, drive_range * power, power)
	flick("mass_driver1", src)
	return

/obj/machinery/mass_driver/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	drive()
	..(severity)

// This is activated by buttons. Delay is to let doors open/close.
/obj/machinery/mass_driver/proc/delayed_drive()
	set waitfor = FALSE
	sleep(2 SECONDS)
	drive()

/decl/public_access/public_method/driver_drive
	name = "launch"
	desc = "Makes the mass driver launch immediately."
	call_proc = /obj/machinery/mass_driver/proc/drive

/decl/public_access/public_method/driver_drive_delayed
	name = "delayed launch"
	desc = "Makes the mass driver launch after a short delay."
	call_proc = /obj/machinery/mass_driver/proc/delayed_drive

/decl/stock_part_preset/radio/receiver/driver
	frequency = BLAST_DOORS_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/driver_drive_delayed)

/obj/machinery/button/mass_driver
	cooldown = 10 SECONDS // Whole thing with the doors takes a while.
	stock_part_presets = list(/decl/stock_part_preset/radio/basic_transmitter/driver_button = 1)

/decl/stock_part_preset/radio/basic_transmitter/driver_button
	transmit_on_change = list(
		"open_door" = /decl/public_access/public_variable/button_active,
		"button_active" = /decl/public_access/public_variable/button_active,
		"close_door_delayed" = /decl/public_access/public_variable/button_active
	)
	frequency = BLAST_DOORS_FREQ