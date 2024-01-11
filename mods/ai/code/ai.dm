// Access

/mob/living/silicon/ai
	idcard = /obj/item/card/id/all/ai

/obj/item/card/id/all/ai
	job_access_type = /datum/job/ai

/datum/job/ai/get_access()
	return get_all_station_access()

// Languages

/mob/living/silicon/ai/Initialize(mapload, datum/ai_laws/L, obj/item/device/mmi/B, safety = FALSE)
	. = ..()
	add_language(LANGUAGE_SIIK_MAAS, TRUE)
	add_language(LANGUAGE_LEGALESE, TRUE)


// New verbs

/mob/living/silicon/ai/proc/ai_take_image()
	set name = "Take Photo"
	set desc = "Activates the given subsystem"
	set category = "Silicon Commands"

	silicon_camera.toggle_camera_mode()

/mob/living/silicon/ai/proc/ai_view_images()
	set name = "View Photo"
	set desc = "Activates the given subsystem"
	set category = "Silicon Commands"

	silicon_camera.viewpictures()

/mob/living/silicon/ai/proc/change_floor()
	set name = "Change Grid Color"
	set category = "Silicon Commands"

	var/f_color = input("Choose your color, dark colors are not recommended!") as color
	if(!f_color)
		return

	for (var/color in GetHexColors(f_color))
		if (color <= 80)
			to_chat(usr, SPAN_WARNING("Color \"[f_color]\" is not allowed!"))
			return

	var/area/A = get_area(usr)
	for(var/turf/simulated/floor/bluegrid/F in A)
		F.color = f_color
	to_chat(usr, SPAN_NOTICE("Proccessing strata color was change to [f_color]"))

/mob/living/silicon/ai/proc/show_crew_manifest()
	set category = "Silicon Commands"
	set name = "Show Crew Manifest"

	open_subsystem(/datum/nano_module/crew_manifest)

/mob/living/silicon/ai/proc/show_crew_monitor()
	set category = "Silicon Commands"
	set name = "Show Crew Lifesigns Monitor"

	open_subsystem(/datum/nano_module/crew_monitor)

/mob/living/silicon/ai/proc/show_crew_records()
	set category = "Silicon Commands"
	set name = "Show Crew Records"

	open_subsystem(/datum/nano_module/records)
