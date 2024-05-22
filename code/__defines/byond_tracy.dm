// Implements https://github.com/mafemergency/byond-tracy
// Client https://github.com/wolfpld/tracy
// As of now, only 0.8.2 is supported as a client, this might change in the future however

// In case you need to start the capture as soon as the server boots, uncomment the following lines and recompile:

// /world/New()
// 	prof_init()
// 	. = ..()

/client/proc/profiler_start()
	set name = "Start Tracy Profiler"
	set category = "Debug"
	set desc = "Starts the tracy profiler, which will await the client connection."
	switch(alert("Are you sure? Tracy will remain active until the server restarts.", "Tracy Init", "No", "Yes"))
		if("Yes")
			prof_init()

/**
 * Starts Tracy
 */
/proc/prof_init()
	var/lib

	switch(world.system_type)
		if(MS_WINDOWS) lib = "prof.dll"
		if(UNIX) lib = "libprof.so"
		else CRASH("Tracy initialization failed: unsupported platform or DLL not found.")

	var/init = CALL_EXT(lib, "init")()
	if("0" != init) CRASH("[lib] init error: [init]")
