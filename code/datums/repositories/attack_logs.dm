var/repository/attack_logs/attack_log_repository = new()

/repository/attack_logs
	var/list/attack_logs_

/repository/attack_logs/New()
	..()
	attack_logs_ = list()

/repository/attack_logs/proc/store_attack_log(var/mob/attacker, var/mob/victim, var/action_message)
	// Newest logs first
	attack_logs_.Insert(1, new/datum/attack_log(attacker, victim, action_message))

/datum/attack_log
	var/station_time
	var/intent
	var/datum/mob_lite/attacker      // We don't store the proper mob in case it gets deleted
	var/datum/mob_lite/victim
	var/turf/location                // Turfs are forever
	var/message

/datum/attack_log/New(var/mob/mob_attacker, var/mob/mob_victim, var/action_message)
	station_time = time_stamp()

	attacker = mob_repository.get_lite_mob(mob_attacker)
	victim = mob_repository.get_lite_mob(mob_victim)

	message = "[attacker.name] [action_message] [victim.name]"
	intent = mob_attacker ? uppertext(mob_attacker.a_intent) : "N/A"
	location = mob_attacker ? get_turf(mob_attacker) : (mob_victim ? get_turf(mob_victim) : null)

/datum/attack_log/proc/mob_to_key_name(var/datum/mob_lite/M)
	return M ? M.key_name(FALSE) : "*null*"
