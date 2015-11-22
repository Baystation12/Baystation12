//-------------------------------
/* Spawn sync helper
 
   Helps syncronize spawn()ing multiple processes in loops.
 
   Example for using this:

	//Create new spawn_sync datum
	var/datum/spawn_sync/sync = new()

	for(var/obj/O in list)
		//Open a sync counter before a spawn call
		sync.open()
		spawn()
			//Utilise try/catch keywords here so the code continues even if an error occurs
			try
				//code to do stuff goes here
				O.do_stuff()
			catch

			//Close the sync counter
			sync.close()

	//Call sync.finalize() after the last spawn call to finalize the syncronize process
	sync.finalize()

	//Create a while loop to check if the sync is complete yet, it will return true once all the spawn threads have completed
	while(sync.check())
		//Add a sleep call to delay each check
		sleep(1)

	//Once all the threads have closed, or the failsafe has triggered, the code will continue
*/
//-------------------------------
/datum/spawn_sync
	var/count = 1
	var/safety = 100	//aprox 10 seconds

//Opens a thread counter
/datum/spawn_sync/proc/open()
	count++

//Closes a thread counter
/datum/spawn_sync/proc/close()
	count--

//Finalizes the spawn sync by removing the original starting count
/datum/spawn_sync/proc/finalize()
	close()

//Resets the counter if you want to utilize the same datum multiple times
/datum/spawn_sync/proc/reset()
	count = 1
	safety = 100

//Check if all threads have returned
// Returns 0 if not all threads have completed
// Returns 1 if all threads have completed
/datum/spawn_sync/proc/check()
	safety_check()
	return count > 0 ? 1 : 0

//Failsafe in case something breaks horribly
/datum/spawn_sync/proc/safety_check()
	safety--
	if(safety < 1)
		count = 0

//Set failsafe check count in case you need more
/datum/spawn_sync/proc/set_safety_check(var/num)
	safety = num
