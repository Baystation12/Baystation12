

/// Builds a list of z-level populations to allow for easier pauses on processing when nobody is around to care
SUBSYSTEM_DEF(presence)
	name = "Player Presence"
	priority = SS_PRIORITY_PRESENCE
	runlevels = RUNLEVEL_GAME
	wait = 10 SECONDS
	var/static/tmp/list/levels = list()
	var/static/tmp/list/queue = list()
	var/static/tmp/list/build


/datum/controller/subsystem/presence/Recover()
	queue.Cut()


/datum/controller/subsystem/presence/fire(resume, no_mc_tick)
	if (!resume)
		queue = GLOB.player_list.Copy()
		build = list()
	var/mob/living/player
	for (var/i = queue.len to 1 step -1)
		player = queue[i]
		if (QDELETED(player) || !istype(player))
			continue
		++build["[player.z]"]
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return
	levels = build


#ifndef UNIT_TEST

/datum/controller/subsystem/presence/flags = SS_NO_INIT

/hook/roundstart/proc/update_presence_subsystem()
	SSpresence.fire(FALSE, TRUE)

/// 0, or the number of living players on level
/datum/controller/subsystem/presence/proc/population(level)
	return levels["[level]"] || 0

#else

/datum/controller/subsystem/presence/flags = SS_NO_INIT | SS_NO_FIRE

/datum/controller/subsystem/presence/proc/population(level)
	return 1

#endif


/// Convenience shortcut to use with atoms that want this info, like: if (!LEVEL_HAS_PLAYERS) return
#define LEVEL_HAS_PLAYERS (SSpresence.levels["[src.z]"])
