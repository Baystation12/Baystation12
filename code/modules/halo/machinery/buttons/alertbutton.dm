
/obj/machinery/button/toggle/alarm_button
	var/area/area_base = null
	var/alert_message = "Red Alert! All hands to combat stations!"
	var/un_alert_message = "Red Alert lifted."
	var/alarm_color_string = "#ff0000"
	var/sound/alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop.ogg'
	var/alarm_loop_time = 5.875 SECONDS //The amount of time it takes for the alarm sound to end. Used for restarting the sound.
	var/currently_alarming

/obj/machinery/button/toggle/alarm_button/activate(var/mob/user)
	if(operating)
		return
	operating = 1
	active = !active
	use_power(5)
	if(active)
		toggle_alert(1)
	else
		toggle_alert(0)
	update_icon()
	operating = 0

/obj/machinery/button/toggle/alarm_button/corvette
	area_base = /area/corvette/unscironwill

/obj/machinery/button/toggle/alarm_button/corvette/v2
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j1.ogg'
	alarm_loop_time = 4.898 SECONDS //The amount of time it takes for the alarm sound to end. Used for restarting the sound.

/obj/machinery/button/toggle/alarm_button/corvette/v3
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j2.ogg'
	alarm_loop_time = 6.535 SECONDS

/obj/machinery/button/toggle/alarm_button/corvette/v4
	alarm_sound = 'code/modules/halo/sounds/r_alert_alarm_loop_j3.ogg'
	alarm_loop_time = 15.267 SECONDS

/obj/machinery/button/toggle/alarm_button/proc/toggle_alert(var/on = 1)
	//First, tell all players in the ship-area that an alert has started.
	for(var/mob/m in GLOB.player_list)
		if(isturf(m.loc) && istype(m.loc.loc,area_base))
			var/message_using = on ? alert_message : un_alert_message
			to_chat(m,"<span class = 'danger'>[message_using]</span>")
	//Then, sound the alarm.
	if(on)
		currently_alarming = 1
		spawn(-1)
			while(currently_alarming)
				playsound(src, alarm_sound, 150, 0, 500, 0,1)
				sleep(alarm_loop_time)
	else
		currently_alarming = 0
	//Then, switch all lights to ominous red.
	for(var/obj/machinery/light/l in GLOB.machines)
		if(!istype(l.loc.loc,area_base))
			continue
		if(on && l.brightness_color == "#FFFFFF") //Only switch the color of lights that haven't been touched already.
			l.brightness_color = alarm_color_string
		else
			l.brightness_color = "#FFFFFF" //The base light-color.
		l.update()

/obj/random_corvette_alarm_button
	name = "Random Corvette Alarm Button"

/obj/random_corvette_alarm_button/New()
	var/obj/to_spawn = pick(list(\
	/obj/machinery/button/toggle/alarm_button/corvette = 75,/obj/machinery/button/toggle/alarm_button/corvette/v2 = 10,\
	/obj/machinery/button/toggle/alarm_button/corvette/v2 = 10,/obj/machinery/button/toggle/alarm_button/corvette/v4 = 5
	))
	new to_spawn (loc)

/obj/random_corvette_alarm_button/Initialize()
	return INITIALIZE_HINT_QDEL