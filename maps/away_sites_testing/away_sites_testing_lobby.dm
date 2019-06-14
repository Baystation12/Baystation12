/datum/map/away_sites_testing
	lobby_tracks = list(/music_track/absconditus)

/datum/map/away_sites_testing/New()
	..()
	buildable_exempt_machines[/obj/machinery/computer/log_printer] = SELF | SUBTYPES