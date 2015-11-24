//-------------------------------
/* 
	Spawn sync helper
 
	Helps syncronize spawn()ing multiple processes in loops.
 
	Example for using this:

	//Create new spawn_sync datum
	var/datum/spawn_sync/sync = new()

	for(var/obj/O in list)
		//Call start_worker(), passing it first the object, then a string of the name of the proc you want called, then 
		// any and all arguments you want passed to the proc. 
		sync.start_worker(O, "do_something", arg1, arg2)

	//Finally call wait_until_done()
	sync.wait_until_done()

	//Once all the workers have completed, or the failsafe has triggered, the code will continue. By default the 
	// failsafe is 10 seconds.
*/
//-------------------------------
/datum/spawn_sync
	var/count = 1
	var/safety = 10		//how many seconds before the failsafe triggers and the helper stops waiting
	var/timer

/datum/spawn_sync/New(var/failsafe = 10)
	..()
	safety = failsafe

//Opens a thread counter
/datum/spawn_sync/proc/open()
	count++

//Closes a thread counter
/datum/spawn_sync/proc/close()
	count--

//Finalizes the spawn sync by removing the original starting count
/datum/spawn_sync/proc/finalize()
	close()
	timer = TimeOfHour + safety * 10

//Resets the counter if you want to utilize the same datum multiple times
// Optional: pass the number of seconds you want for the failsafe
/datum/spawn_sync/proc/reset(var/failsafe = 10)
	count = 1
	safety = failsafe

//Check if all threads have returned
// Returns 0 if not all threads have completed
// Returns 1 if all threads have completed
/datum/spawn_sync/proc/check()
	safety_check()
	return count > 0 ? 1 : 0

//Failsafe in case something breaks horribly
/datum/spawn_sync/proc/safety_check()
	if(TimeOfHour > timer)
		count = 0

//Set failsafe check count in case you need more time
/datum/spawn_sync/proc/set_failsafe(var/failsafe)
	safety = failsafe

/datum/spawn_sync/proc/start_worker()
	//Extract the thread run proc and it's arguments from the variadic args list.
	ASSERT(args.len > 0)
	var/obj = args[1]
	var/thread_proc = args[2]
	
	//dispatch a new thread
	open()
	spawn()
		//Utilise try/catch keywords here so the code continues even if an error occurs.
		try
			call(obj, thread_proc)(arglist(args.Copy(3)))    
		catch(var/exception/e)
			error("[e] on [e.file]:[e.line]")
		close()

/datum/spawn_sync/proc/wait_until_done()
	finalize()

	//Create a while loop to check if the sync is complete yet, it will return once all the spawn threads have 
	// completed, or the failsafe timeout has expired.
	while(check())
		//Add a sleep call to delay each check.
		sleep(1)
