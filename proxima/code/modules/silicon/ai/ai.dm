/mob/living/silicon/ai //from infinity //proxima
	var/list/announcements_variants = list(
		"Torch Voice Announcement"	=	'sound/AI/newAI.ogg',
		"TG Voice Announcement"		=	'proxima/sound/AI/newai.ogg'
		)

/mob/living/silicon/ai/on_mob_init()
	. = ..()
	INVOKE_ASYNC(src, .proc/AnnouncePresence)

/mob/living/silicon/ai/proc/AnnouncePresence()
	if(alert(src, "Do you want to announce your activation?", "Activation Announce", "Yes", "No") == "Yes")
		var/result = input(src, "Announce your presence?", "Presence.") in announcements_variants
		if(list_find(announcements_variants, result))
			var/result_sound = announcements_variants[result]
			if(isfile(result_sound))
				announcement.Announce("Новый ИИ загружен в ядро.", new_sound = result_sound)

/mob/living/silicon/ai/proc/ChangeFloorColorInArea(Color, area/Area = get_area(src))
	if(length(Color) && istype(Area))
		for(var/turf/simulated/floor/bluegrid/F in Area)
			F.color = Color
