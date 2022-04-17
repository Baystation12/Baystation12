/obj/machinery/rotating_alarm/hangar_warning_beacon
	name = "hangar docking operations warning beacon"
	desc = "A rotating alarm light that indicates hangar launch and landing operations are in progress."
	icon_state = "alarm"
	alarm_light_color = COLOR_AMBER
	var/shuttle_tags = list()
	var/waiting = 0

/obj/machinery/rotating_alarm/hangar_warning_beacon/torch_hangar
	name = "Torch hangar docking operations warning beacon"
	shuttle_tags = list("supplydrone", "charon", "guppy")

/obj/machinery/rotating_alarm/hangar_warning_beacon/torch_petrov
	name = "Petrov docking operations warning beacon"
	shuttle_tags = list("petrov")

/obj/machinery/rotating_alarm/hangar_warning_beacon/torch_aquilla
	name = "Aquilla docking operations warning beacon"
	shuttle_tags = list("aquilla")

/obj/machinery/rotating_alarm/hangar_warning_beacon/proc/set_alert(beacon_state, operating_shuttle_tag)
	if(operating_shuttle_tag in shuttle_tags)
		switch (beacon_state)
			if ("off")
				set_off()
			if ("on")
				set_on()
