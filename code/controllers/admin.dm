// Clickable stat() button.
/obj/effect/statclick
	name = "Initializing..."
	var/target

INITIALIZE_IMMEDIATE(/obj/effect/statclick)

/obj/effect/statclick/Initialize(mapload, text, target) //Don't port this to Initialize it's too critical
	. = ..()
	name = text
	src.target = target

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click()
	if(!usr.client.holder || !target)
		return
	if(!class)
		if(istype(target, /datum/controller/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")


// Debug verbs.
/client/proc/restart_controller(controller in list("Master", "Failsafe"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	switch(controller)
		if("Master")
			Recreate_MC()
		if("Failsafe")
			new /datum/controller/failsafe()

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")

/client/proc/run_weather()
	set category = "Admin"
	set name = "Run Weather"
	set desc = "Triggers a weather event on the z-level you choose."

	if(!holder)
		return

	var/weather_type = input("Choose a weather", "Weather")  as null|anything in sortList(subtypesof(/datum/weather))
	if(!weather_type)
		return

	var/turf/T = get_turf(mob)
	var/z_level = input("Z-Level to target?", "Z-Level", T?.z) as num|null
	if(!isnum(z_level))
		return

	SSweather.run_weather(weather_type, z_level)

	message_admins("[key_name_admin(usr)] started weather of type [weather_type] on the z-level [z_level].")
	log_admin("[key_name(usr)] started weather of type [weather_type] on the z-level [z_level].")