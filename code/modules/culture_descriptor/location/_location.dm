/singleton/cultural_info/location
	desc_type = "Home System"
	category = TAG_HOMEWORLD
	var/distance = 0
	var/ruling_body = FACTION_SOL_CENTRAL
	var/capital

/singleton/cultural_info/location/get_text_details()
	. = list()
	// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
	// if(!isnull(capital)) // SIERRA-EDIT - ORIGINAL
		// . += "<b>Capital:</b> [capital]." // SIERRA-EDIT - ORIGINAL
	// if(!isnull(ruling_body)) // SIERRA-EDIT - ORIGINAL
		// . += "<b>Territory:</b> [ruling_body]." // SIERRA-EDIT - ORIGINAL
	// if(!isnull(distance)) // SIERRA-EDIT - ORIGINAL
		// . += "<b>Distance from Sol:</b> [distance]." // SIERRA-EDIT - ORIGINAL
	if(!isnull(capital))
		. += "<b>Столица:</b> [capital]."
	if(!isnull(ruling_body))
		. += "<b>Принадлежность:</b> [ruling_body]."
	if(!isnull(distance))
		. += "<b>Расстояние от Солнца:</b> [distance]." 
	// [/SIERRA-EDIT]
	. += ..()
