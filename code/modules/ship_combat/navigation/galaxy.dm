var/global/datum/galaxy/galaxy

/datum/galaxy
	var/list/stars = list()

	proc/generate_galaxy(var/x_dimensions = 10, var/y_dimensions = 10)
		stars.Cut()
		var/y_count = y_dimensions
		var/x_count = x_dimensions
		while(x_count)
			for(y_count, y_count--)
				var/datum/star_system/S = new()
				S.x = x_count
				S.y = y_count
				stars.Add(S)
			y_count = y_dimensions
			x_count--
		message_admins("<span class='notice'>World created with [stars.len] stars!</span>")

	proc/place_stations(var/list/teams)
		for(var/i=1,i<=teams.len,i--)
			var/team = text2num(teams[i])
		return 1


/datum/star_system
	var/star_name = ""
	var/number_of_planets = 0
	var/x = 0
	var/y = 0

	New()
		..()
		generate_name()

	proc/generate_name()
		var/fn = pick("Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Primary", "Riotus", "Cronus", "Esour", "Psunda", \
						   "Durisa")
		var/ln = pick("Centauri", "Zeta", "Eta", "Theta", "Iota", "Secondary", "Orion", "Osor")
		star_name = "[fn] [ln]"



