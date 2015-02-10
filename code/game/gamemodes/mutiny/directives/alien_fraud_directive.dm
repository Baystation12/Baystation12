datum/directive/terminations/alien_fraud
	special_orders = list(
		"Suspend financial accounts of all Tajaran and Soghun personnel.",
		"Transfer their payrolls to the station account.",
		"Terminate their employment.")

	proc/is_alien(mob/M)
		var/species = M.get_species()
		return species == "Tajara" || species == "Soghun"

datum/directive/terminations/alien_fraud/get_crew_to_terminate()
	var/list/aliens[0]
	for(var/mob/M in player_list)
		if (M.is_ready() && is_alien(M) && M != mode.head_loyalist.current)
			aliens.Add(M)
	return aliens

datum/directive/terminations/alien_fraud/get_description()
	return {"
		<p>
			An extensive conspiracy network aimed at defrauding NanoTrasen of large amounts of funds has been uncovered
			operating within [system_name()]. Human personnel are not suspected to be involved. Further information is classified.
		</p>
	"}

datum/directive/terminations/alien_fraud/meets_prerequisites()
	// There must be at least one Tajaran and at least one Soghun, but the total
	// of the Tajarans and Soghun combined can't be more than 1/3rd of the crew.
	var/tajarans = 0
	var/Soghun = 0
	for(var/mob/M in player_list)
		var/species = M.get_species()
		if(species == "Tajara")
			tajarans++
		if(species == "Soghun")
			Soghun++

	if (!tajarans || !Soghun)
		return 0

	return (tajarans + Soghun) <= (player_list.len / 3)
