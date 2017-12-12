
/datum/spawnpoint/crash_site
	msg = "Has mysteriously appeared"
	display_name = "Crash Site"

/datum/spawnpoint/crash_site/New()
	turfs = GLOB.latejoin
	return ..()