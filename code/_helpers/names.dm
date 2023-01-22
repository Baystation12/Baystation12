/proc/generate_system_name()
	return "[pick("Vega", "Arcturus", "Gilese", "GSC", "Luyten", "GJ", "HD", "SCGECO", "Fomalhaut ", "Polaris", "Mira", "Spica", "Sirius", "Cephei", "Aurigae", "Alaska", "Nona", "Toliman")][prob(10) ? " Eridani" : ""] [rand(100,999)]"

/proc/generate_planet_name()
	return "[capitalize(pick(GLOB.last_names))]-[pick(GLOB.greek_letters)]"

/proc/generate_planet_type()
	return pick("terrestial planet", "ice planet", "dwarf planet", "desert planet", "ocean planet", "lava planet", "gas giant", "forest planet")

/proc/station_name()
	if(!GLOB.using_map)
		return server_name
	if (GLOB.using_map.station_name)
		return GLOB.using_map.station_name

	var/random = rand(1,5)
	var/name = ""

	//Rare: Pre-Prefix
	if (prob(10))
		name = pick(GLOB.station_prefixes)
		GLOB.using_map.station_name = name + " "

	// Prefix
	name = pick(GLOB.station_names)
	if(name)
		GLOB.using_map.station_name += name + " "

	// Suffix
	name = pick(GLOB.station_suffixes)
	GLOB.using_map.station_name += name + " "

	// ID Number
	switch(random)
		if(1)
			GLOB.using_map.station_name += "[rand(1, 99)]"
		if(2)
			GLOB.using_map.station_name += pick(GLOB.greek_letters)
		if(3)
			GLOB.using_map.station_name += "\Roman[rand(1,99)]"
		if(4)
			GLOB.using_map.station_name += pick(GLOB.phonetic_alphabet)
		if(5)
			GLOB.using_map.station_name += pick(GLOB.numbers_as_words)
		if(13)
			GLOB.using_map.station_name += pick("13","XIII","Thirteen")


	if (config && config.server_name)
		world.name = "[config.server_name]: [name]"
	else
		world.name = GLOB.using_map.station_name

	return GLOB.using_map.station_name

/proc/world_name(var/name)
	GLOB.using_map.station_name = name

	if (config && config.server_name)
		world.name = "[config.server_name]: [name]"
	else
		world.name = name

	return name


/proc/generate_code_phrase()//Proc is used for phrase and response in subsystem init.

	var/code_phrase = ""//What is returned when the proc finishes.
	var/words = pick(//How many words there will be. Minimum of two. 2, 4 and 5 have a lesser chance of being selected. 3 is the most likely.
		50; 2,
		200; 3,
		50; 4,
		25; 5
	)

	var/safety[] = list(1,2,3)//Tells the proc which options to remove later on.
	var/nouns[] = list("любовь","ненависть","гнев","мир","война","гордость","честь","симпатия","храбрость","лояльность","честность","целостность","сочувствие","благотворительность","успех","отвага","обман","умение","красота","ум","боль","горе","верования","мечты","справедливость","истина","вера","свобода","знание","мысль","информация","культура","доверие","посвящение","прогресс","образование","гостеприимство","досуг","проблема","дружба", "отдых") //bos translate
	var/drinks[] = list("водка и тоник","шипучий джин","багама мама","манхэттан","чёрный русский","виски сода","чай лонг айленд","маргарита","ирландский кофе","мужественный дварф","ирландские сливки","услада доктора","бипским смэш","текилла санрайз","храбрый бык","горлодёр","кровавая мэри","виски кола","белый русский","водка мартини","мартини","куба либре","кахлуа","водка","вино","лунный свет") //bos translate
	var/locations[] = length(stationlocs) ? stationlocs : drinks//if null, defaults to drinks instead.

	var/names[] = list()
	for(var/datum/computer_file/report/crew_record/t in GLOB.all_crew_records)//Picks from crew manifest.
		names += t.get_name()

	var/maxwords = words//Extra var to check for duplicates.

	for(words,words>0,words--)//Randomly picks from one of the choices below.

		if(words==1&&(1 in safety)&&(2 in safety))//If there is only one word remaining and choice 1 or 2 have not been selected.
			safety = list(pick(1,2))//Select choice 1 or 2.
		else if(words==1&&maxwords==2)//Else if there is only one word remaining (and there were two originally), and 1 or 2 were chosen,
			safety = list(3)//Default to list 3

		switch(pick(safety))//Chance based on the safety list.
			if(1)//1 and 2 can only be selected once each to prevent more than two specific names/places/etc.
				switch(rand(1,2))//Mainly to add more options later.
					if(1)
						if(names.len&&prob(70))
							code_phrase += pick(names)
						else
							code_phrase += pick(pick(GLOB.first_names_male,GLOB.first_names_female))
							code_phrase += " "
							code_phrase += pick(GLOB.last_names)
					if(2)
						code_phrase += pick(SSjobs.titles_to_datums) //Returns a job.
				safety -= 1
			if(2)
				switch(rand(1,2))//Places or things.
					if(1)
						code_phrase += pick(drinks)
					if(2)
						code_phrase += pick(locations)
				safety -= 2
			if(3)
				switch(rand(1,3))//Nouns, adjectives, verbs. Can be selected more than once.
					if(1)
						code_phrase += pick(nouns)
					if(2)
						code_phrase += pick(GLOB.adjectives)
					if(3)
						code_phrase += pick(GLOB.verbs)
		if(words==1)
			code_phrase += "."
		else
			code_phrase += ", "

	return code_phrase

/proc/get_name(var/atom/A)
	return A.name

/proc/get_name_and_coordinates(var/atom/A)
	return "[A.name] \[[A.x],[A.y],[A.z]\]"
