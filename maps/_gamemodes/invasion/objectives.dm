
// OC + variant specific objective, GM linked//

/datum/objective/phase2_scan
	short_text = "Successfully scan the colony for the holy relic."
	explanation_text = "Deploy scanners at the marked locations, and protect them. The scan will reveal the location of the relic."
	win_points = 50

/datum/objective/phase2_scan/check_completion()
	var/datum/game_mode/outer_colonies/gm = ticker.mode
	if(!istype(gm))
		return 0
	if(gm.scan_percent >= 100)
		return 1

/datum/objective/phase2_scan_unsc
	short_text = "Stop the Covenant from scanning the colony."
	explanation_text = "Search and destroy for Covenant scanners. Eliminating enough will disrupt their scans permenantly and cause a rout."
	win_points = 100

/datum/objective/phase2_scan_unsc/check_completion()
	var/datum/game_mode/outer_colonies/gm = ticker.mode
	if(!istype(gm))
		return 0
	if(gm.scan_percent < 100)
		return 1
