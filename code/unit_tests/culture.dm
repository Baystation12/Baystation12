/datum/unit_test/culture
	name = "CULTURE - All Species Cultural Values Shall Be Of Valid Types And Length"

/datum/unit_test/culture/start_test()
	var/fails = 0
	for(var/species_name in all_species)
		var/datum/species/species = all_species[species_name]
		if(!islist(species.default_cultural_info))
			fails++
			log_bad("Default cultural info for [species_name] is not a list.")
		else
			for(var/token in species.default_cultural_info)
				if(!(token in ALL_CULTURAL_TAGS))
					fails++
					log_bad("Default cultural info for [species_name] contains invalid tag '[token]'.")
				else
					var/val = species.default_cultural_info[token]
					if(!val)
						fails++
						log_bad("Default cultural value '[val]' for [species_name] tag '[token]' is null, must be a string.")
					else if(!istext(val))
						fails++
						log_bad("Default cultural value '[val]' for [species_name] tag '[token]' is an invalid type, must be a string.")
					else
						var/decl/cultural_info/culture = SSculture.get_culture(val)
						if(!istype(culture))
							fails++
							log_bad("Default cultural value '[val]' for [species_name] tag '[token]' is not a valid culture label.")
						else if(culture.category != token)
							fails++
							log_bad("Default cultural value '[val]' for [species_name] tag '[token]' does not match culture datum category ([culture.category] must equal [token]).")
						else if(!culture.description)
							fails++
							log_bad("Default cultural value '[val]' for [species_name] tag '[token]' does not have a description set.")

		if(!islist(species.force_cultural_info))
			fails++
			log_bad("Forced cultural info for [species_name] is not a list.")
		else
			for(var/token in species.force_cultural_info)
				if(!(token in ALL_CULTURAL_TAGS))
					fails++
					log_bad("Forced cultural info for [species_name] contains invalid tag '[token]'.")
				else
					var/val = species.force_cultural_info[token]
					if(!val)
						fails++
						log_bad("Forced cultural value for [species_name] tag '[token]' is null, must be a string.")
					else if(!istext(val))
						fails++
						log_bad("Forced cultural value for [species_name] tag '[token]' is an invalid type, must be a string.")
					else
						var/decl/cultural_info/culture = SSculture.get_culture(val)
						if(!istype(culture))
							fails++
							log_bad("Forced cultural value '[val]' for [species_name] tag '[token]' is not a valid culture label.")
						else if(culture.category != token)
							fails++
							log_bad("Forced cultural value '[val]' for [species_name] tag '[token]' does not match culture datum category ([culture.category] must equal [token]).")
						else if(!culture.description)
							fails++
							log_bad("Forced cultural value '[val]' for [species_name] tag '[token]' does not have a description set.")

		if(!islist(species.available_cultural_info))
			fails++
			log_bad("Available cultural info for [species_name] is not a list.")
		else
			for(var/token in ALL_CULTURAL_TAGS)
				if(!islist(species.available_cultural_info[token]))
					fails++
					log_bad("Available cultural info for [species_name] tag '[token]' is invalid type, must be a list.")
				else if(!LAZYLEN(species.available_cultural_info[token]))
					fails++
					log_bad("Available cultural info for [species_name] tag '[token]' is empty, must have at least one entry.")
				else
					for(var/val in species.available_cultural_info[token])
						var/decl/cultural_info/culture = SSculture.get_culture(val)
						if(!istype(culture))
							fails++
							log_bad("Available cultural value '[val]' for [species_name] tag '[token]' is not a valid culture label.")
						else if(culture.category != token)
							fails++
							log_bad("Available cultural value '[val]' for [species_name] tag '[token]' does not match culture datum category ([culture.category] must equal [token]).")
						else if(!culture.description)
							fails++
							log_bad("Available cultural value '[val]' for [species_name] tag '[token]' does not have a description set.")

	if(fails > 0)
		fail("[fails] invalid cultural value(s)")
	else
		pass("All cultural values are valid.")
	return 1

