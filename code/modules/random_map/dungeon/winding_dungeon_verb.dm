//Its different so that you can add monsters to said dungeon pretty easily.

//Works similarly to the supply drop in that you create it to use it instantly.
/client/proc/create_dungeon()
	set category = "Fun"
	set name = "Create Dungeon"
	set desc = "Create and apply a configurable dungeon to a zlevel."

	var/list/vars = list()

	vars["limit_x"] = input("What is the width of your map?") as num
	vars["limit_y"] = input("What is the height of your map?") as num
	vars["first_room_x"] = input("What should be the first room's X position be?") as num
	vars["first_room_y"] = input("What should be the first room's Y position be?") as num
	vars["first_room_width"] = input("What should be the first room's width position be?") as num
	vars["first_room_height"] = input("What should be the first room's height position be?") as num
	if(alert("Would you like to modify generated room/corridor variables?",,"No","Yes") == "Yes")
		vars["room_size_min"] = input("What is the smallest size a room should be?") as num
		vars["room_size_max"] = input("What is the largest size a room should be?") as num
		vars["chance_of_room"] = input("What is the percent chance of a room being generated versus a corridor? (From 0 to 100)") as num
		vars["chance_of_door"] = input("What is the percent chance of a room having doors? (From 0 to 100)") as num
		vars["chance_of_room_empty"] = input("What is the percent chance that a room will be empty? (From 0 to 100)") as num
	if(alert("Would you like to modify generational multipliers?",,"No","Yes") == "Yes")
		var/percent = input("What is the percent multiplier of how many features are generated? Default is 2 (WARNING HIGH NUMBERS MAY CAUSE LAG)") as num
		vars["features_multiplier"] = percent/100
		percent = input("What is the percent multiplier of how many monsters are generated? Default is 0.7 (WARNING HIGH NUMBERS MAY CAUSE LAG)") as num
		vars["monster_multiplier"] = percent/100
		percent = input("What is the percent multiplier of how much loot is generated? Default is 1 (WARNING HIGH NUMBERS MAY CAUSE LAG)") as num
		vars["loot_multiplier"] = percent/100
	var/list/common
	var/list/uncommon
	var/list/rare
	var/list/current_list
	var/mode = "room_theme"
	while(1)
		if(mode == "room_theme")
			common = list(/datum/room_theme = 10)
		else
			common = list()
		uncommon = list()
		rare = list()
		current_list = common
		switch(mode)
			if("room_theme")
				if(alert("Would you like to modify what room layouts are used?",,"No","Yes") != "Yes")
					mode = "monsters"
					continue
			if("monsters")
				if(alert("Would you like to modify what mobs get spawned?",,"No","Yes") != "Yes")
					mode = "loot"
					continue
			if("loot")
				if(alert("Would you like to modify what loot gets spawned?",,"No","Yes") !="Yes")
					break
		var/list/total_types
		switch(mode)
			if("room_theme")
				total_types = typesof(/datum/room_theme)
			if("monsters")
				total_types = subtypesof(/mob/living)
			if("loot")
				total_types = subtypesof(/obj/item)
		while(1)
			var/layout = input("Pick an item to add to the current pool. Press cancel to finish.") as null|anything in total_types
			if(!layout)
				if(current_list == common && alert("Would you like to add items to the uncommon pool?",,"No","Yes") == "Yes")
					current_list = uncommon
					continue
				else if(current_list != rare && alert("Would you like to add items to the rare pool?",, "No", "Yes") == "Yes")
					current_list = rare
					continue
				else
					break
			var/chance = input("What is the weight of this item? Higher weights get picked more frequently. Default is 10",10) as num
			if(alert("Do you want to add all subtypes of this item to the current pool as well? They will be weighted the same.",,"No","Yes") == "Yes")
				var/list/local_total = typesof(layout)
				if(alert("Do you want to only add the subtypes of this item?",,"No","Yes") == "Yes")
					local_total -= layout
				for(var/a in local_total)
					current_list[a] = chance
			else
				current_list[layout] = chance

		vars["[mode]_common"] = common.Copy()
		vars["[mode]_uncommon"] = uncommon.Copy()
		vars["[mode]_rare"] = rare.Copy()
		switch(mode)
			if("room_theme")
				mode = "monsters"
			if("monsters")
				mode = "loot"
			else
				break

	if(alert("Are you sure you want to create this? It will appear at your position.",,"No","Yes") != "Yes")
		return

	var/datum/random_map/winding_dungeon/W = /datum/random_map/winding_dungeon

	for(var/x in 1 to vars["limit_x"])
		for(var/y in 1 to vars["limit_y"])
			sleep(-1)
			var/turf/T = locate(usr.x+x-1,usr.y+y-1,usr.z)
			if(!T)
				to_chat(src, "<span class='danger'>Error, turf could not be located. Probably out of bounds.</span>")
				return
			T.ChangeTurf(initial(W.target_turf_type))
	new /datum/random_map/winding_dungeon(null,usr.x, usr.y, usr.z, variable_list = vars)
