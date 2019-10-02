
/datum/shuttle/autodock/ferry/trade/geminus_innie
	name = "Rabbit Hole Base Trade Shuttle"
	shuttle_area = /area/shuttle/innie_shuttle_supply
	waypoint_station = "geminus_innie_supply"
	waypoint_offsite = "offsite_innie_supply"

/datum/shuttle/autodock/ferry/trade/geminus_innie/New()
	. = ..()
	money_account = GLOB.INSURRECTION.money_account
