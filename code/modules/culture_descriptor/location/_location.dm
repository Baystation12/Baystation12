/decl/cultural_info/location
	desc_type = "Home System"
	category = TAG_HOMEWORLD
	var/distance = 0
	var/ruling_body = FACTION_SOL_CENTRAL
	var/capital
	var/system

/decl/cultural_info/location/get_text_details()
	. = list()
	if(!isnull(capital))
		. += "<b>Capital:</b> [capital]."
	if(!isnull(system))
		. += "<b>System:</b> [system]."
	if(!isnull(ruling_body))
		. += "<b>Territory:</b> [ruling_body]."
	if(!isnull(distance))
		. += "<b>Distance from Sol:</b> [distance]."
	. += ..()
