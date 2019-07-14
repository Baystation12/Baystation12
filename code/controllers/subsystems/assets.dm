//This Subsystem just calls send_assets at the end of the subsystem load order
	//This function caches icons from various things and sends them to connected clients
SUBSYSTEM_DEF(asset)
	name = "Asset"
	init_order = SS_INIT_ASSET
	flags = SS_NO_FIRE

/datum/controller/subsystem/asset/Initialize(timeofday)
	log_world("INITIALIZING ASSET SUBSYSTEM")
	send_assets()



/proc/send_assets()
	var/list/datum/asset/trivialAssets = list()
	for(var/type in typesof(/datum/asset) - list(/datum/asset, /datum/asset/simple))
		var/datum/asset/A = new type()
		if(A.isTrivial)
			trivialAssets += A
		else
			A.register()
	for(var/datum/asset/A in trivialAssets)
		A.register()

	for(var/client/C in GLOB.clients)
		// Doing this to a client too soon after they've connected can cause issues, also the proc we call sleeps.
		spawn(10)
			getFilesSlow(C, asset_cache.cache, FALSE)

	return TRUE