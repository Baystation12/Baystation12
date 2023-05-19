GLOBAL_VAR(round_counter)
GLOBAL_VAR(last_played_date)

/hook/startup/proc/InitTgs()
	world.TgsNew(new /datum/tgs_event_handler/impl, TGS_SECURITY_TRUSTED)
	revdata.load_tgs_info()
	return TRUE

/world/New()
	. = ..()

	if(fexists(RESTART_COUNTER_PATH))
		var/list/tmp = file2list(RESTART_COUNTER_PATH, " | ")
		GLOB.last_played_date = tmp[1]
		GLOB.round_counter = text2num_or_default(trim(tmp[2]), 0)
		fdel(RESTART_COUNTER_PATH)
	else
		GLOB.round_counter = 0

	world.TgsInitializationComplete()

/world/Reboot()
	text2file("[time2text(world.realtime, "DD-MM-YYYY")] | [++GLOB.round_counter]", RESTART_COUNTER_PATH)

	TgsReboot()
	..()

/world/Topic()
	TGS_TOPIC
	..()

#undef RUNWAITERROLEID
#undef ROUNDWAITERROLEID
#undef RESTART_COUNTER_PATH
#undef NON_BYOND_URL
