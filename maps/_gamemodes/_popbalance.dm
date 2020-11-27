//GLOBAL_VAR_INIT(max_overpop, 0.5)		//now a config var
GLOBAL_VAR_INIT(round_no_balance_time, 4 MINUTES) //Pregame + 1 min
GLOBAL_VAR_INIT(last_admin_notice_overpop, 0)
GLOBAL_VAR_INIT(min_players_balance, 4)

/datum/game_mode
	//put the faction types in here that you want to be balanced
	var/list/faction_balance = list()
