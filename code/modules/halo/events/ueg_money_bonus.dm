
/datum/event/ueg_money_bonus
	var/amount = 0
	var/list/target_factions = list("UNSC","ONI")
	var/datum/faction/affecting_faction
	var/announce_text
	var/announcer
	var/transaction_desc

/datum/event/ueg_money_bonus/setup()
	var/target_faction_name = pick(target_factions)
	affecting_faction = GLOB.factions_by_name[target_faction_name]
	announcer = "UEG Financial Committee"
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			amount = rand(1,5) * 100
			announce_text = "We have discovered a clerical error and reimbursed a sum of money into the local \
				[affecting_faction.name] operations account"
			transaction_desc = "Clerical Error/Refund"
		if(EVENT_LEVEL_MODERATE)
			amount = 500 * rand(1,3)
			announce_text = "A funding grant has been approved for local [affecting_faction.name] operations"
			transaction_desc = "Funding Grant"
		if(EVENT_LEVEL_MAJOR)
			amount = 500 * rand(3,10)
			announce_text = "CENTCOMM has declared your system a priority defence and increased the local \
				[affecting_faction.name] operations budget accordingly"
			transaction_desc = "Priority Defence Allocation"

/datum/event/ueg_money_bonus/start()
	var/datum/transaction/T = new(announcer, "[transaction_desc]", amount, "Sol Terminal #E[rand(100000,999999)]")
	affecting_faction.money_account.transaction_log.Add(T)
	affecting_faction.money_account.money += amount

/datum/event/ueg_money_bonus/announce()
	GLOB.HUMAN_CIV.AnnounceUpdate(announce_text, announcer)
