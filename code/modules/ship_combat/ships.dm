/datum/newship
	var/title = ""
	var/teamone
	var/teamtwo
	var/teamthree
	var/teamfour
	var/minplayers = 1
	var/maxplayers = -1
	var/tier = 1
	var/path = ""


proc/createships()

	var/list/possible_ships = list()
	admin_notice("\red \b Selecting ships..", R_DEBUG)
	var/list/allships = file2list("maps/ships.txt", "newship")
	for(var/ship in allships)
		if (copytext(ship, 1, 2) == "#") continue
//		admin_notice("\blue \b Ship: [ship]", R_DEBUG)
		ship = trim(ship)
		var/list/shipdata = splittext(ship)
		var/datum/newship/to_add = new()
		for(var/data in shipdata)
			if (copytext(data, 1, 2) == "#") continue
			var/breaker = findtext(data, " ")
			var/V = copytext(data, 1, breaker)
			var/T = copytext(data, breaker)
			switch(lowertext(V))
				if("title")
					to_add.title = T
				if("teamone")
					to_add.teamone = text2num(T)
				if("teamtwo")
					to_add.teamtwo = text2num(T)
				if("teamthree")
					to_add.teamthree = text2num(T)
				if("teamfour")
					to_add.teamfour = text2num(T)
				if("minplayers")
					to_add.minplayers = text2num(T)
				if("maxplayers")
					to_add.maxplayers = text2num(T)
				if("tier")
					to_add.tier = text2num(T)
				if("path")
					to_add.path = T
		possible_ships += to_add
	admin_notice("\red \b [possible_ships.len] ships found..", R_DEBUG)
	if(possible_ships.len)
		var/player_count = 0
		for(var/mob/new_player/player in player_list)
			player_count++
		for(var/datum/newship/candidate in possible_ships)
			if(candidate.minplayers > 0 && player_count < candidate.minplayers)
				possible_ships.Remove(candidate)
				admin_notice("\blue \b Playercount too low! [candidate.minplayers]", R_DEBUG)
				continue
			if(candidate.maxplayers > 0 && (player_count/4) > candidate.maxplayers)
				possible_ships.Remove(candidate)
				admin_notice("\blue \b Playercount too high! [candidate.maxplayers]", R_DEBUG)
				continue
			if(!candidate.path)
				possible_ships.Remove(candidate)
				admin_notice("\blue \b Invalid ship ([candidate.path])", R_DEBUG)
				continue
//		var/datum/newship/to_make = pick(possible_ships)
//		changeship(to_make)





