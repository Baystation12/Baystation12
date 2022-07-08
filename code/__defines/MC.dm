#define TICK_CHECK ( world.tick_usage > Master.current_ticklimit )

#define CHECK_TICK if TICK_CHECK stoplag()

#define MC_TICK_CHECK ( ( world.tick_usage > Master.current_ticklimit || src.state != SS_RUNNING ) ? pause() : 0 )


#define GAME_STATE 2 ** (Master.current_runlevel - 1)


#define MC_SPLIT_TICK_INIT(phase_count) var/original_tick_limit = Master.current_ticklimit; var/split_tick_phases = ##phase_count


#define MC_SPLIT_TICK \
	if(split_tick_phases > 1){\
		Master.current_ticklimit = ((original_tick_limit - world.tick_usage) / split_tick_phases) + world.tick_usage;\
		--split_tick_phases;\
	} else {\
		Master.current_ticklimit = original_tick_limit;\
	}


// Used to smooth out costs to try and avoid oscillation.
#define MC_AVERAGE_FAST(average, current) (0.7 * (average) + 0.3 * (current))

#define MC_AVERAGE(average, current) (0.8 * (average) + 0.2 * (current))

#define MC_AVERAGE_SLOW(average, current) (0.9 * (average) + 0.1 * (current))

#define MC_AVG_FAST_UP_SLOW_DOWN(average, current) (average > current ? MC_AVERAGE_SLOW(average, current) : MC_AVERAGE_FAST(average, current))

#define MC_AVG_SLOW_UP_FAST_DOWN(average, current) (average < current ? MC_AVERAGE_SLOW(average, current) : MC_AVERAGE_FAST(average, current))


/****
* Subsystem helper macros
****/

/// Attempt to ensure that the subsystem is a singleton. Do not use directly.
#define NEW_SS_GLOBAL(varname) if(varname != src){if(istype(varname)){Recover(varname);qdel(varname);}varname = src;}

/// Boilerplate for a new global subsystem object and its associated type.
#define SUBSYSTEM_DEF(X) var/global/datum/controller/subsystem/##X/SS##X;\
/datum/controller/subsystem/##X/New(){\
	NEW_SS_GLOBAL(SS##X);\
	PreInit();\
}\
/datum/controller/subsystem/##X

#define TIMER_SUBSYSTEM_DEF(X) GLOBAL_REAL(SS##X, /datum/controller/subsystem/timer/##X);\
/datum/controller/subsystem/timer/##X/New(){\
	NEW_SS_GLOBAL(SS##X);\
	PreInit();\
}\
/datum/controller/subsystem/timer/##X/fire() {..() /*just so it shows up on the profiler*/} \
/datum/controller/subsystem/timer/##X

/// Boilerplate for a new global processing subsystem object and its associated type.
#define PROCESSING_SUBSYSTEM_DEF(X) var/global/datum/controller/subsystem/processing/##X/SS##X;\
/datum/controller/subsystem/processing/##X/New(){\
	NEW_SS_GLOBAL(SS##X);\
	PreInit();\
}\
/datum/controller/subsystem/processing/##X/Recover() {\
	if(istype(SS##X.processing)) {\
		processing = SS##X.processing; \
	}\
}\
/datum/controller/subsystem/processing/##X

/// Register a datum to be processed with a processing subsystem.
#define START_PROCESSING(Processor, Datum) \
if (Datum.is_processing) {\
	if(Datum.is_processing != #Processor)\
	{\
		crash_with("Failed to start processing. [log_info_line(Datum)] is already being processed by [Datum.is_processing] but queue attempt occured on [#Processor]."); \
	}\
} else {\
	Datum.is_processing = #Processor;\
	Processor.processing += Datum;\
}

/// Unregister a datum with a processing subsystem.
#define STOP_PROCESSING(Processor, Datum) \
if(Datum.is_processing) {\
	if(Processor.processing.Remove(Datum)) {\
		Datum.is_processing = null;\
	} else {\
		crash_with("Failed to stop processing. [log_info_line(Datum)] is being processed by [Datum.is_processing] but de-queue attempt occured on [#Processor]."); \
	}\
}

/// START specific to SSmachines
#define START_PROCESSING_MACHINE(machine, flag)\
	if(!istype(machine, /obj/machinery)) CRASH("A non-machine [log_info_line(machine)] was queued to process on the machinery subsystem.");\
	machine.processing_flags |= flag;\
	START_PROCESSING(SSmachines, machine)

/// STOP specific to SSmachines
#define STOP_PROCESSING_MACHINE(machine, flag)\
	machine.processing_flags &= ~flag;\
	if(machine.processing_flags == 0) STOP_PROCESSING(SSmachines, machine)


/****
* Subsystem Flags
****/

/// The subsystem's Initialize() will not be called.
#define SS_NO_INIT FLAG(0)

/// The subsystem's fire() will not be called. This is preferable to can_fire = FALSE because it will not be added to the MC's list of active systems.
#define SS_NO_FIRE FLAG(1)

/// The subsystem runs on spare CPU time, after all non-background subsystems have run that tick. Priority is considered against other SS_BACKGROUND subsystems.
#define SS_BACKGROUND FLAG(2)

/// The subsystem does not tick check and should not run unless enough time can be guaranteed or it must to stay current.
#define SS_NO_TICK_CHECK FLAG(3)

/// Treat the value of the subsystem's wait as ticks, not time. Forces it to run in the first tick. Implicitly has all runlevels. Ignores SS_BACKGROUND if set. Intended for systems that act like a mini-MC, like timers.
#define SS_TICKER FLAG(4)

/// Attempt to keep the subsystem's timing real-world regular by adjusting fire timing to be earlier the later it previously ran.
#define SS_KEEP_TIMING FLAG(5)

/// Calculate the subsystem's next fire time from when it finished, not when it started.
#define SS_POST_FIRE_TIMING FLAG(6)

/// Run Shutdown() on server shutdown so the SS can finalize state.
#define SS_NEEDS_SHUTDOWN FLAG(7)


/****
* Subsystem states
****/

/// The subsystem is not running.
#define SS_IDLE 0

/// The subsystem is queued to be run.
#define SS_QUEUED 1

/// The subsystem is currently being run.
#define SS_RUNNING 2

/// The subsystem's run is paused by MC_TICK_CHECK and will resume later.
#define SS_PAUSED 3

/// The subsystem is sleeping during its run.
#define SS_SLEEPING 4

/// The subsystem is in the process of being paused.
#define SS_PAUSING 5

/****
* Subsystem initialization states
****/

#define SS_INITSTATE_NONE 0

#define SS_INITSTATE_STARTED 1

#define SS_INITSTATE_DONE 2


/****
* SStimer
****/

/// Create a hash from the timer's configuration and don't run it if one already exists.
#define TIMER_UNIQUE FLAG(0)

/// For timers with TIMER_UNIQUE, do not include the timer's delay as part of its uniquenes.
#define TIMER_NO_HASH_WAIT FLAG(4)

/// For timers with TIMER_UNIQUE, replace the old timer instead of discarding the new one.
#define TIMER_OVERRIDE FLAG(1)

/// Use real world time instead of server time. More expensive and should be reserved for client display like animations and sounds.
#define TIMER_CLIENT_TIME FLAG(2)

/// The call to addtimer() will return a timer ID which may be passed to deltimer() to stop it if it still exists.
#define TIMER_STOPPABLE FLAG(3)

/// Repeat the timer until it's deleted or the parent is destroyed.
#define TIMER_LOOP FLAG(5)

///Delete the timer on parent datum Destroy() and when deltimer'd
#define TIMER_DELETE_ME FLAG(6)

/// The default timer ID.
#define TIMER_ID_NULL -1

/// Automatically adding filename and line to the timer's arguments for debugging purposes.
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)
