/proc/roll_titles()
	set waitfor = 0

	for(var/mob/M in GLOB.player_list)
		M.overlay_fullscreen("fishbed",/obj/screen/fullscreen/fishbed)
		M.overlay_fullscreen("scanlines",/obj/screen/fullscreen/scanline)
		M.overlay_fullscreen("whitenoise",/obj/screen/fullscreen/noise)
		if(M.is_preference_enabled(/datum/client_preference/play_lobby_music))
			sound_to(M, sound(null, channel = 1))
			sound_to(M, sound('sound/music/THUNDERDOME.ogg', wait = 0, volume = 40, channel = 1))

	var/list/titles = list()
	var/list/cast = list()
	var/list/chunk = list()
	var/list/possible_titles = list()
	var/chunksize = 0

	/* Establish a big-ass list of potential titles for the "episode". */
	possible_titles += "THE [pick("DOWNFALL OF", "RISE OF", "TROUBLE WITH", "FINAL STAND OF", "DARK SIDE OF","BURNING","RIOT OF","NUKING OF", "GLASSING OF","REDEMPTION OF","DAMNATION OF","OUTBREAK OF","RECLAMATION OF")] [pick("SPACEMEN","HIGH CHARITY","UNSC MAINS","COVENANT MAINS","INSURRECTIONIST MAINS","COLONIST MANINS","GCPD","KS7","GCPD","VT9","THE FLOOD","GEMINUS","HALO","THE GREAT JOURNEY","111 TAURI SYSTEM","OUTER COLONIES","INNER COLONIES","THE GRAVEMIND", "HUMANITY","UNSC","URF","COVENANT","ONI","UEG", "DIGNITY", "SANITY GOES MISSING", "UNGGOY RISE UP", "VENDOMAT PRICES ARE INSANE","[uppertext(GLOB.using_map.station_name)]")]"
	possible_titles += "THE CREW GETS [pick("RACIST","TO NOT FINISH THIS FIGHT","PICKLED","GLASSED","NUKED","CONSUMED BY FLOOD", "AN INCURABLE DISEASE", "PIZZA", "A VALUABLE HISTORY LESSON", "A BREAK", "HIGH", "TO LIVE", "TO RELIVE THEIR CHILDHOOD", "EMBROILED IN CIVIL WAR", "SERIOUS ABOUT [pick("DRUG ABUSE", "TAX EVASION","CRIME", "PRODUCTIVITY", "ANCIENT AMERICAN CARTOONS", "SPACEBALL")]")]"
	possible_titles += "THE CREW LEARNS ABOUT [pick("LOVE", "DRUGS", "THE DANGERS OF BIOFOAM OD","THE DANGERS OF BULLET SHRAPNEL","THE DANGERS OF MONEY LAUNDERING","JOHN HALO", "COLONIST SENSITIVITY","MAYOR'S DRUG PROBLEM","CO'S DRUG PROBLEM","INVESTMENT FRAUD","BIOFOAM ABUSE", "KELOTANE ABUSE", "RADIATION PROTECTION", "SACRED GEOMETRY","ORION ABUSE","ONI TESTING", "STRING THEORY", "ABSTRACT MATHEMATICS", "[pick("KIG-YAR", "UNGGOY", "SANGHEILI", "JIRALHANAE", "YANME'E", "MGALEKGOLO", "HURAGOK","SAN'SHYUUM")] MATING RITUALS", "ANCIENT CHINESE MEDICINE","WHAT REALLY HAPPENED AT RAM RANCH")]"
	possible_titles += "A VERY [pick("INNIE","EXPEDITIONARY", "COVIE","GREENTIDE","ONI")] CHRISTMAS"
	possible_titles += "[pick("GUNS, GUNS EVERYWHERE","YOU FINISHED THIS PARTICULAR FIGHT","COVENANT SHIELDS BREAK AGAIN","COLONIST CAN'T MAKE PIZZA BECAUSE OF THE WAR","GREEN TIDE GEMINUS COLONY WIDE", "GCPD MAINS RISE UP", "THE LITTLEST UNGGOY","NEEDLER CAUSES SALT ONCE AGAIN","WHAT HAPPENS WHEN A DEVELOPER NERFS THE UNSC AGAIN","WHAT HAPPENS WHEN A DEVELOPER NERFS THE URF AGAIN","WHAT HAPPENS WHEN A DEVELOPER NERFS THE COVENANT AGAIN", "WHAT HAPPENS WHEN YOU MIX HIGH TAXES AND DRUNK INNIES", "WHAT HAPPENS WHEN YOU MIX HIGH TAXES AND POOR COLONIST", "ATTACK! ATTACK! ATTACK!", "SLIPSPACE CORE BOMB")]"
	possible_titles += "[pick("DONT GIVE A GIRL A PROMISE YOU CANT KEEP","THE COVENANT GET THEIR BOMB BACK","TELL THAT TO THE COVENANT","EVERYBODY LOVES DANNY","REMEMBERING FAR ISLE","JOHNNY RENO YEE'S HIS LAST HAW", "DANNY STONE STRIKES BACK","BLACKBURN LEARNS ABOUT CHILD SUPPORT", "JUVENILE DELIQUENCY", "POLITICALLY MOTIVATED","UEG RAISED THE TAXES ONCE AGAIN", "RADTACULAR SICKNASTY","RALLY POINT: WAR")]"

	titles += "<center><h1>EPISODE [rand(1,1000)]<br>[pick(possible_titles)]<h1></h1></h1></center>"
	for(var/mob/living/carbon/human/H in world)
		if(findtext(H.real_name,"(mannequin)"))
			continue
		if(H.isMonkey() && findtext(H.real_name,"[lowertext(H.species.name)]")) //no monki
			continue
		if(!cast.len && !chunksize)
			chunk += "CAST:"
		var/job = ""
		if(GetAssignment(H) != "Unassigned")
			job = ", [uppertext(GetAssignment(H))]"
		chunk += "[H.key]\t\t\tas\t\t\t[uppertext(H.real_name)][job] ([H.species.name])"
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
			corpses += "[H.real_name] the [uppertext(H.species.name)] [uppertext(GetAssignment(H))], played by [H.key]"
	if(corpses.len)
		titles += "<center>BASED ON REAL EVENTS<br>In memory of [english_list(corpses)].</center>"

	var/list/staff = list("ONI SECTION III PRODUCTION STAFF:")
	var/list/goodboys = list()
	for(var/client/C)
		if(!C.holder)
			continue
		if(C.is_stealthed())
			continue
		if(C.holder.rights & (R_DEBUG|R_ADMIN))
			staff += "[uppertext(C.holder.rank)] [C.key]"
		else if(C.holder.rights & R_MOD)
			goodboys += "[C.key]"
	titles += "<center>[jointext(staff,"<br>")]</center>"
	if(goodboys.len)
		titles += "<center>ONI'S GOOD TEST SUBJECTS:<br>[english_list(goodboys)]</center>"


	titles += "<center>Sponsored by [GLOB.using_map.company_name].<br>All rights reserved. Use for parody prohibited. Prohibited.</center>"

	for(var/part in titles)
		Show2Group4Delay(ScreenText(null, titles[part] ? titles[part] : part,"1,CENTER"), null, 60)
		sleep(65)
