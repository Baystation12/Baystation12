/proc/roll_titles()
	set waitfor = 0

	for(var/mob/M in GLOB.player_list)
		M.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
		M.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)
		M.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)
		if(M.is_preference_enabled(/datum/client_preference/play_admin_midis))
			sound_to(M, sound('sound/music/THUNDERDOME.ogg', repeat = 1, wait = 0, volume = 65, channel = 4))

	var/list/titles = list()
	var/list/cast = list()
	var/list/chunk = list()
	var/chunksize = 0
	titles += "<center><h1>EPISODE [rand(1,1000)]<br>THE [pick("DOWNFALL OF","RISE OF","TROUBLE WITH","FINAL STAND OF","DARK SIDE OF")]<br>[pick("SPACEMEN","HUMANITY","DIGNITY","SANITY","THE CHIMPANZEES","THE VENDOMAT PRICES","[uppertext(GLOB.using_map.station_name)]")]</h1></center>"
	for(var/mob/living/carbon/human/H in world)
		for(findtext(H.real_name,"(mannequin)"))
			continue
		if(!cast.len && !chunksize)
			chunk += "CAST:"
		var/job = ""
		if(GetAssignment(H) != "Unassigned")
			job = ", [GetAssignment(H)]"
		chunk += "[H.species.get_random_name(H.gender)]\t\t\tas\t\t\t[uppertext(H.real_name)][job]"
		chunksize++
		if(chunksize > 9)
			cast += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0
	if(chunk.len)
		cast += "<center>[jointext(chunk,"<br>")]</center>"
	titles += cast
	var/list/corpses = list()
	for(var/mob/living/carbon/human/H in GLOB.dead_mob_list_)
		if(H.real_name)
			corpses += H.real_name
	if(corpses.len)
		titles += "<center>BASED ON REAL EVENTS<br>In memory of [english_list(corpses)].</center>"

	var/list/staff = list("PRODUCTION STAFF:")
	var/list/goodboys = list()
	for(var/client/C)
		if(!C.holder)
			continue
		if((C.holder.rights & R_MOD) && !(C.holder.rights & R_DEBUG|R_ADMIN))
			goodboys += "[C.ckey]"
		else
			var/datum/species/S = all_species[pick(all_species)]
			var/g = prob(50) ? MALE : FEMALE
			staff += "[S.get_random_name(g)] a.k.a. '[C.key]'"
	titles += "<center>[jointext(staff,"<br>")]</center>"
	if(goodboys.len)
		titles += "<center>STAFF'S GOOD BOYS:<br>[english_list(goodboys)]</center>"


	titles += "<center>Sponsored by [GLOB.using_map.company_name].<br>All rights reserved. Use for parody prohibited. Prohibited.</center>"

	for(var/part in titles)
		Show2Group4Delay(ScreenText(null, titles[part] ? titles[part] : part,"1,CENTER"), null, 60)
		sleep(65)
