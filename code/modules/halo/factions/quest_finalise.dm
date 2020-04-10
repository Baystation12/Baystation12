
/datum/faction/proc/reject_quest(var/datum/npc_quest/rejected_quest,  var/faction_name)
	finalise_quest(rejected_quest, STATUS_REJECT)

/datum/faction/proc/finalise_quest(var/datum/npc_quest/Q, var/new_status = STATUS_REJECT)
	//abandon, timeout and fail can all be treated the same
	var/resolution_type = new_status
	if(resolution_type == STATUS_ABANDON)
		resolution_type = STATUS_FAIL
	else if(resolution_type == STATUS_TIMEOUT)
		resolution_type = STATUS_FAIL

	//finalise the quest
	Q.quest_status = new_status
	processing_quests.Remove(Q)

	var/rep_change = 0
	if(resolution_type == STATUS_REJECT)
		//no more cleanup is needed as this quest was never accepted, so it can disappear completely
		all_quests.Remove(Q)
		available_quests.Remove(Q)
		qdel(Q)
	else
		//certain specific outcomes
		processing_quests.Remove(Q)
		if(resolution_type == STATUS_FAIL)

			//lose a bit of faction favour
			rep_change = Q.get_fail_favour()

		else if(resolution_type == STATUS_WON)

			//deposit the credits
			if(Q.credit_reward)
				var/transaction_desc = "[pick("Mission to", "Sent to","Job at","Dispatched to","Requested at")] [Q.location_name] on behalf of [src.name] to [pick(\
					"take out the trash",\
					"do some babysitting",\
					"drop off a parcel",\
					"discipline the kids",\
					"drop the kids off",\
					"deliver a pizza",\
					"do some cleaning",\
					"handle a problem",\
					"attend a meeting",\
					"lay some pipe",\
					"investigate a noise complaint"\
					)]."
				var/datum/transaction/T = new(src.name, transaction_desc, Q.credit_reward, "UEG Terminal #[rand(100000,999999)]")
				Q.attempting_faction.money_account.transaction_log.Add(T)
				Q.attempting_faction.money_account.money += Q.credit_reward

			//gain the faction favour
			rep_change = Q.get_win_favour()

		else
			var/error_msg = "QUEST ERROR: [Q] for faction [src] finished with invalid status"
			to_debug_listeners(error_msg)
			message_admins(error_msg)

	//if our favour with faction changed, we may be rewarded or penalised
	if(rep_change)
		//add the new reputation
		add_faction_reputation(Q.attempting_faction.name, rep_change)

		//the attempting faction may gain or lose access to gear
		Q.attempting_faction.update_reputation_gear(src)

		//the offering faction may unlock an ability or passive reward
		generate_rep_rewards(get_faction_reputation(Q.attempting_faction.name))

	//we cant use the missions shuttle to go here any more
	GLOB.factions_controller.active_quest_coords.Remove(Q.coords)
	qdel(Q.coords)

	//update any comms programs that need updating
	if(new_status == STATUS_WON)
		for(var/datum/nano_module/program/innie_comms/listening_program in listening_programs)
			listening_program.quest_win(src, Q)
	else
		for(var/datum/nano_module/program/innie_comms/listening_program in listening_programs)
			listening_program.quest_lose(src, Q)
