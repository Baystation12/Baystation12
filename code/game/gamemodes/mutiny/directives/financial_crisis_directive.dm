datum/directive/terminations/financial_crisis
	special_orders = list(
		"Suspend financial accounts of all civilian personnel, excluding the Head of Personnel.",
		"Transfer their payrolls to the station account.",
		"Terminate their employment.")

datum/directive/terminations/financial_crisis/get_crew_to_terminate()
	var/list/civilians[0]
	var/list/candidates = civilian_positions - "Head of Personnel"
	for(var/mob/M in player_list)
		if (candidates.Find(M.mind.assigned_role) && M.is_ready())
			civilians.Add(M)
	return civilians

datum/directive/terminations/financial_crisis/get_description()
	return {"
		<p>
			Tau Ceti system banks in financial crisis. Local emergency situation ongoing.
			NT Funds redistributed, impact upon civilian department expected.
			Further information is classified.
		</p>
	"}

datum/directive/terminations/financial_crisis/meets_prerequisites()
	var/list/civilians = get_crew_to_terminate()
	return civilians.len >= 5
