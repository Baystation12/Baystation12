var/list/spawntypes = list()

/proc/populate_spawn_points()
	spawntypes = list()
	for(var/type in typesof(/datum/spawnpoint)-/datum/spawnpoint)
		var/datum/spawnpoint/S = new type()
		spawntypes[S.display_name] = S

/datum/spawnpoint
	var/msg          //Message to display on the arrivals computer.
	var/list/turfs   //List of turfs to spawn on.
	var/display_name //Name used in preference setup.
	var/list/restrict_job = null
	var/list/disallow_job = null

	proc/check_job_spawning(job)
		if(restrict_job && !(job in restrict_job))
			return 0

		if(disallow_job && (job in disallow_job))
			return 0

		return 1

/datum/spawnpoint/arrivals
	display_name = "Arrivals Shuttle"
	msg = "has arrived on the station"

/datum/spawnpoint/arrivals/New()
	..()
	turfs = latejoin

/datum/spawnpoint/gateway
	display_name = "Gateway"
	msg = "has completed translation from offsite gateway"
	disallow_job = list("Sheriff","Deputy","Frontier Doctor","Hotel Manager","Hotel Maid","Solar Field Engineer","Settler","Merchant")

/datum/spawnpoint/gateway/New()
	..()
	turfs = latejoin_gateway

/datum/spawnpoint/cryo
	display_name = "Cryogenic Storage"
	msg = "has completed cryogenic revival"
	disallow_job = list("Cyborg","Sheriff","Deputy","Frontier Doctor","Hotel Manager","Hotel Maid","Solar Field Engineer","Settler","Merchant")

/datum/spawnpoint/cryo/New()
	..()
	turfs = latejoin_cryo

/datum/spawnpoint/cyborg
	display_name = "Cyborg Storage"
	msg = "has been activated from storage"
	restrict_job = list("Cyborg")
	disallow_job = list("Sheriff","Deputy","Frontier Doctor","Hotel Manager","Hotel Maid","Solar Field Engineer","Settler","Merchant")

/datum/spawnpoint/cyborg/New()
	..()
	turfs = latejoin_cyborg

/datum/spawnpoint/wander
	display_name = "Wander the Wastes"
	msg = "Has wandered the wastes to arrive at Sunset"
	restrict_job = list("Sheriff","Deputy","Frontier Doctor","Hotel Manager","Hotel Maid","Solar Field Engineer","Settler","Merchant")

/datum/spawnpoint/wander/New()
	..()
	turfs = latejoin_wander