proc/createRandomZlevel()
	if(GLOB.awaydestinations.len)	//crude, but it saves another var!
		return

	if(!fexists("maps/RandomZLevels/fileList.txt"))
		return

	var/list/potentialRandomZlevels = list()
	admin_notice("<span class='danger'>Searching for away missions...</span>", R_DEBUG)
	var/list/Lines = file2list("maps/RandomZLevels/fileList.txt")
	if(!Lines.len)	return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
	//	var/value = null

		if (pos)
			// No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		//	value = copytext(t, pos + 1)
		else
			// No, don't do lowertext here, that breaks paths on linux
			name = t

		if (!name)
			continue

		potentialRandomZlevels.Add(name)


	if(potentialRandomZlevels.len)
		admin_notice("<span class='danger'>Loading away mission...</span>", R_DEBUG)

		var/map = pick(potentialRandomZlevels)
		var/file = file(map)
		if(isfile(file))
			maploader.load_map(file)
			log_debug("away mission loaded: [map]")

		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name != "awaystart")
				continue
			GLOB.awaydestinations.Add(L)

		admin_notice("<span class='danger'>Away mission loaded.</span>", R_DEBUG)

	else
		admin_notice("<span class='danger'>No away missions found.</span>", R_DEBUG)
		return
