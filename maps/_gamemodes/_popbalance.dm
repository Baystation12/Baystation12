//GLOBAL_VAR_INIT(max_overpop, 0.5)		//now a config var
GLOBAL_VAR_INIT(round_no_balance_time, 2.9 MINUTES)//Just below roundstart. We're doing this so people don't have issues setting up occupations preround.
GLOBAL_VAR_INIT(last_admin_notice_overpop, 0)
GLOBAL_VAR_INIT(min_players_balance, 3)

/datum/game_mode
	//put the faction types in here that you want to be balanced
	var/list/faction_balance = list()
	//Tracks factions that have recently failed the poplock; to avoid a deadlock situation.
	var/list/last_checked_lock = list()
