
//if this is not set to null, the job assignment code will check the alien whitelist (whether text or sql) for a 'species' that matches the value below
//see also /proc/jobban_isbanned(mob/M, rank,whitelist_check = 0, var/datum/job/job) in code/modules/admin/banjob.dm line 17
//see also /mob/new_player/proc/IsJobAvailable(var/datum/job/job) in code/modules/mob/new_player/new_player.dm line 285
/datum/job/var/faction_whitelist
