// Implements https://github.com/ParadiseSS13/byond-tracy
// Client https://github.com/wolfpld/tracy
// See docs/profiling.md for a guide to use.

#ifdef PROFILE_FROM_BOOT
/world/New()
	profiler_init()
	return ..()
#endif

GLOBAL_VAR(profiler_running)

/client/proc/profiler_init_verb()
	set name = "Start Profiler"
	set category = "Debug"
	set desc = "Starts the tracy profiler, writing a trace to disk."
	var/response = alert("Are you sure? The profiler will run until restart or stopped with the Stop Profiler verb.", null, "No", "Yes")
	if (response != "Yes")
		return
	if (GLOB.profiler_running)
		response = alert("The Tracy profiler is already running! Are you sure?", "Careful!", "No", "Yes")
	if (response != "Yes")
		return
	profiler_init()


/// Starts the profiler.
/proc/profiler_init()
	var/lib = get_tracy_lib()
	var/ret = call_ext(lib, "init")()
	if (length(ret) != 0 && ret[1] == ".") // if first character is ., then it returned the output filename
		. = ret
	else if ("0" != ret)
		to_chat(usr, "[lib] ret error: [ret]")
		return
	GLOB.profiler_running = TRUE
	log_and_message_admins("has started the Tracy profiler, writing to [.]")


/world/Del()
	if (GLOB.profiler_running)
		var/ret = call_ext(get_tracy_lib(), "destroy")()
		if (ret != "0")
			log_and_message_admins("Tracy destroy error: [ret]")
		else
			log_and_message_admins("Tracy session ended")
	return ..()


/proc/get_tracy_lib()
	switch (world.system_type)
		if (MS_WINDOWS)
			return "tracy.dll"
		if (UNIX)
			return "tracy.so"
		else
			CRASH("Tracy initialization failed: unsupported platform or DLL not found.")
