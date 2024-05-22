/singleton/appearance_handler
	var/priority = 15
	var/list/appearance_sources

/singleton/appearance_handler/New()
	..()
	appearance_sources = list()

/singleton/appearance_handler/proc/AddAltAppearance(source, list/images, list/viewers = list())
	if(source in appearance_sources)
		return FALSE
	appearance_sources[source] = new/datum/appearance_data(images, viewers, priority)
	GLOB.destroyed_event.register(source, src, TYPE_PROC_REF(/singleton/appearance_handler, RemoveAltAppearance))

/singleton/appearance_handler/proc/RemoveAltAppearance(source)
	var/datum/appearance_data/ad = appearance_sources[source]
	if(ad)
		GLOB.destroyed_event.unregister(source, src)
		appearance_sources -= source
		qdel(ad)

/singleton/appearance_handler/proc/DisplayAltAppearanceTo(source, viewer)
	var/datum/appearance_data/ad = appearance_sources[source]
	if(ad)
		ad.AddViewer(viewer)

/singleton/appearance_handler/proc/DisplayAllAltAppearancesTo(viewer)
	for(var/entry in appearance_sources)
		DisplayAltAppearanceTo(entry, viewer)
