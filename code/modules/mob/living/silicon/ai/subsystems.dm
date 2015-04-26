/mob/living/silicon/ai
	var/list/ai_verbs_subsystems = list(
		/mob/living/silicon/ai/proc/subsystem_crew_monitor,
		/mob/living/silicon/ai/proc/subsystem_power_monitor,
		/mob/living/silicon/ai/proc/subsystem_rcon
	)

	var/obj/nano_module/crew_monitor/crew_monitor
	var/obj/nano_module/rcon/rcon
	var/obj/nano_module/power_monitor/power_monitor

/mob/living/silicon/ai/init_subsystems()
	..()
	qdel(alarm_monitor)
	alarm_monitor = new/obj/nano_module/alarm_monitor/ai(src)
	crew_monitor = new(src)
	rcon = new(src)
	power_monitor = new(src)

/mob/living/silicon/ai/proc/subsystem_crew_monitor()
	set category = "Subystems"
	set name = "Crew Monitor"

	crew_monitor.ui_interact(usr)

/mob/living/silicon/ai/proc/subsystem_power_monitor()
	set category = "Subystems"
	set name = "Power Monitor"

	power_monitor.ui_interact(usr)

/mob/living/silicon/ai/proc/subsystem_rcon()
	set category = "Subystems"
	set name = "RCON"

	rcon.ui_interact(usr)
