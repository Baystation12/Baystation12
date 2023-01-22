/obj/machinery/rotating_alarm/security_alarm
	name = "security level signal"
	desc = "A rotating alarm light that changes color to indicate a ship-wide alert."
	icon_state = "code green"
	alarm_light_color = COLOR_GREEN


/obj/machinery/rotating_alarm/security_alarm/proc/set_alert(icon_state, alert_level, alert_color)
	set_color(alert_color)
	set_icon_state(icon_state)
	switch (alert_level)
		if ("off")
			set_off()
		if ("on")
			set_on()
