
/obj/item/weapon/pinpointer/artifact
	name = "Artifact Pinpointer"
	desc = "Seems to point towards Forerunner Artifacts..."
	var/obj/machinery/artifact/artif = null
	var/list/artifs = list()
	var/index = 0

/obj/item/weapon/pinpointer/artifact/attack_self(mob/user as mob)
	active = 1
	if(artifs.len == 0)
		for(var/obj/machinery/artifact/artifact_find in world)
			artifs += artifact_find
			if(isnull(artif))
				artif = artifact_find
	else
		index++
		if(index > artifs.len)
			index = 0
		visible_message("<span class = 'notice'>[src] switches target.</span>")
	if(!workdisk())
		active = 0
		icon_state = "pinoff"
		to_chat(user, "<span class='notice'>You deactivate the pinpointer.</span>")


/obj/item/weapon/pinpointer/artifact/workdisk()
	if(!active) return 0
	if(!artif)
		artif = artifs[index]
	if(!artif)
		icon_state = "pinonnull"
		return 0
	else
		var/turf/artif_turf = get_turf(artif)
		var/turf/our_turf = get_turf(src)
		var/obj/artif_om = map_sectors["[artif_turf.z]"]
		if(artif_turf && our_turf && map_sectors["[our_turf.z]"] != artif_om && world.time % 2 == 0)
			visible_message("<span class = 'notice'>Artifact is not located on the current overmap object. Artifact Location:[artif_om.name].</span>")
			artif = null
			index++
			return 0
	. = 1
	set_dir(get_dir(src,artif))
	switch(get_dist(src,artif))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"
	spawn(5) .()
