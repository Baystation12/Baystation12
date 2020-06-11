GLOBAL_VAR_INIT(max_overpop, 0.25)
GLOBAL_VAR_INIT(round_no_balance_time, 5 MINUTES)
GLOBAL_VAR_INIT(last_admin_notice_overpop, 0)

/datum/game_mode
	//put the faction types in here that you want to be balanced
	var/list/faction_balance = list()
