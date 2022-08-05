SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = SS_PRIORITY_MOB
	flags = SS_NO_INIT | SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 2 SECONDS
	var/static/list/mob_list = list()
	var/static/list/queue = list()


/datum/controller/subsystem/mobs/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Mobs: [mob_list.len] \
		Run Empty Levels: [config.run_empty_levels ? "Y" : "N"]\
	"})


/datum/controller/subsystem/mobs/Recover()
	queue.Cut()


/datum/controller/subsystem/mobs/fire(resume, no_mc_tick)
	if (!resume)
		queue = mob_list.Copy()
	var/mob/mob
	for (var/i = queue.len to 1 step -1)
		mob = queue[i]
		if (QDELETED(mob))
			continue
		if (!config.run_empty_levels && !SSpresence.population(get_z(mob)))
			continue
		mob.Life()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


#define START_PROCESSING_MOB(MOB) \
if (MOB.is_processing) {\
	if (MOB.is_processing != SSmobs) {\
		crash_with("Failed to start processing mob. Already being processed by [MOB.is_processing].")\
	}\
}\
else {\
	MOB.is_processing = SSmobs;\
	SSmobs.mob_list += MOB;\
}


#define STOP_PROCESSING_MOB(MOB) \
if(MOB.is_processing == SSmobs) {\
	MOB.is_processing = null;\
	SSmobs.mob_list -= MOB;\
}\
else if (MOB.is_processing) {\
	crash_with("Failed to stop processing mob. Being processed by [MOB.is_processing] instead.")\
}


/mob/dview/Initialize()
	. = ..()
	STOP_PROCESSING_MOB(src)
