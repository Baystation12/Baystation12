/proc/roll_titles()
	set waitfor = 0
	for(var/client/C)
		if(C.mob)
			C.mob.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
			C.mob.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)
			C.mob.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)

	to_world('sound/music/THUNDERDOME.ogg')
	var/list/titles = list()
	var/list/cast = list()
	var/list/chunk = list()
	var/list/possible_titles = list()
	var/chunksize = 0

	/* Establish a big-ass list of potential titles for the "episode". */
	possible_titles += "THE [pick("DOWNFALL OF", "RISE OF", "TROUBLE WITH", "FINAL STAND OF", "DARK SIDE OF")] [pick("SPACEMEN", "HUMANITY", "DIGNITY", "SANITY", "THE CHIMPANZEES", "THE VENDOMAT PRICES","[uppertext(GLOB.using_map.station_name)]")]"
	possible_titles += "THE CREW GETS [pick("RACIST", "PICKLED", "AN INCURABLE DISEASE", "PIZZA", "A VALUABLE HISTORY LESSON", "A BREAK", "HIGH", "TO LIVE", "TO RELIVE THEIR CHILDHOOD", "EMBROILED IN CIVIL WAR", "SERIOUS ABOUT [pick("DRUG ABUSE", "CRIME", "PRODUCTIVITY", "ANCIENT AMERICAN CARTOONS", "SPACEBALL")]")]"
	possible_titles += "THE CREW LEARNS ABOUT [pick("LOVE", "DRUGS", "THE DANGERS OF MONEY LAUNDERING", "XENIC SENSITIVITY", "INVESTMENT FRAUD", "KELOTANE ABUSE", "RADIATION PROTECTION", "SACRED GEOMETRY", "STRING THEORY", "ABSTRACT MATHEMATICS", "[pick("TAJARAN", "UNATHI", "SKRELLIAN", "DIONAN", "KHAARMANI", "VOX", "SERPENTID")] MATING RITUALS", "ANCIENT CHINESE MEDICINE")]"
	possible_titles += "A VERY [pick("NANOTRASEN", "EXPEDITIONARY", "DIONA", "PHORON", "MARTIAN")] CHRISTMAS"
	possible_titles += "[pick("GUNS, GUNS EVERYWHERE", "THE LITTLEST ARMALIS", "WHAT HAPPENS WHEN YOU MIX MAINTENANCE DRONES AND COMMERCIAL-GRADE PACKING FOAM", "ATTACK! ATTACK! ATTACK!", "SEX BOMB")]"
	possible_titles += "[pick("SPACE", "SEXY", "DRAGON", "WARLOCK", "LAUNDRY", "GUN", "ADVERTISING", "DOG", "CARBON MONOXIDE", "NINJA", "WIZARD", "SOCRATIC", "JUVENILE DELIQUENCY", "POLITICALLY MOTIVATED", "RADTACULAR SICKNASTY")] [pick("QUEST", "FORCE", "ADVENTURE")]"

	/* And then assign one at random! */
	titles += "<center><h1>EPISODE [rand(1, 1000)] - [pick(possible_titles)]</h1></center>"

	for(var/mob/living/carbon/human/H in world)
		if(!cast.len && !chunksize)
			chunk += "CAST:"
		chunk += "[H.species.get_random_name(H.gender)]\t\t\tas\t\t\t[uppertext(H.real_name)]"
		chunksize++
		if(chunksize > 4)
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
	for(var/client/C in GLOB.admins)
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
