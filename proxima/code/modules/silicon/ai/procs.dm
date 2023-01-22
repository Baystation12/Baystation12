/mob/living/silicon/ai/proc/show_crew_monitor() //from infinity //proxima
	set category = "Silicon Commands"
	set name = "CREW: Show Crew Lifesigns Monitor"

	open_subsystem(/datum/nano_module/crew_monitor)

/mob/living/silicon/ai/proc/show_crew_records()
	set category = "Silicon Commands"
	set name = "CREW: Show Crew Records"

	open_subsystem(/datum/nano_module/records)

/mob/living/silicon/ai/proc/show_crew_manifest()
	set category = "Silicon Commands"
	set name = "CREW: Show Crew Manifest"

	open_subsystem(/datum/nano_module/crew_manifest)

/mob/living/silicon/ai/proc/change_floor()
	set category = "Silicon Commands"
	set name = "MOOD: Change Floor"

	var/n_color = input("Choose your color, dark colors are not recommended!") as color
	ChangeFloorColorInArea(n_color)
	to_chat(src, "Proccessing strata color was changed to <font color='[n_color]'>color</font>.")
