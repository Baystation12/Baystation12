/datum/controller/subsystem
	// Metadata; you should define these.
	name = "fire coderbus"               //name of the subsystem
	var/init_order = SS_INIT_DEFAULT  //order of initialization. Higher numbers are initialized first, lower numbers later. Use defines in __DEFINES/subsystems.dm for easy understanding of order.
	var/wait = 20                        //time to wait (in deciseconds) between each call to fire(). Must be a positive integer.
	var/priority = SS_PRIORITY_DEFAULT //When mutiple subsystems need to run in the same tick, higher priority subsystems will run first and be given a higher share of the tick before MC_TICK_CHECK triggers a sleep

	var/flags = 0                        //see MC.dm in __DEFINES Most flags must be set on world start to take full effect. (You can also restart the mc to force them to process again)
	// Similar to can_fire, but intended explicitly for subsystems that are asleep. Using this var instead of can_fire
	//	 allows admins to disable subsystems without them re-enabling themselves.
	var/suspended = FALSE

	var/initialized = FALSE	//set to TRUE after it has been initialized, will obviously never be set if the subsystem doesn't initialize

	//set to 0 to prevent fire() calls, mostly for admin use or subsystems that may be resumed later
	//	use the SS_NO_FIRE flag instead for systems that never fire to keep it from even being added to the list
	var/can_fire = TRUE

	// Bookkeeping variables; probably shouldn't mess with these.
	var/last_fire = 0     //last world.time we called fire()
	var/next_fire = 0     //scheduled world.time for next fire()
	var/cost = 0          //average time to execute
	var/tick_usage = 0    //average tick usage
	var/tick_overrun = 0  //average tick overrun
	var/state = SS_IDLE   //tracks the current state of the ss, running, paused, etc.
	var/paused_ticks = 0  //ticks this ss is taking to run right now.
	var/paused_tick_usage //total tick_usage of all of our runs while pausing this run
	var/ticks = 1         //how many ticks does this ss take to run on avg.
	var/times_fired = 0   //number of times we have called fire()
	var/queued_time = 0   //time we entered the queue, (for timing and priority reasons)
	var/queued_priority   //we keep a running total to make the math easier, if priority changes mid-fire that would break our running total, so we store it here
	//linked list stuff for the queue
	var/datum/controller/subsystem/queue_next
	var/datum/controller/subsystem/queue_prev

	// Subsystem startup accounting - these variables cannot be trusted if the subsystem has crashed and been Recover()'d.
	var/init_state = SS_INITSTATE_NONE // The current initialization state of this SS - this might be invalid if the subsystem has been Recover()'d.
	var/init_time = 0                  // How long the subsystem took to initialize, in seconds.
	var/init_start = 0                 // What timeofday did we start initializing?
	var/init_finish                    // What timeofday did we finish initializing?

	var/runlevels = RUNLEVELS_DEFAULT	//points of the game at which the SS can fire

	var/static/list/failure_strikes //How many times we suspect a subsystem type has crashed the MC, 3 strikes and you're out!

//Do not override
///datum/controller/subsystem/New()

// Used to initialize the subsystem BEFORE the map has loaded
// Called AFTER Recover if that is called
// Prefer to use Initialize if possible
/datum/controller/subsystem/proc/PreInit()
	return

//This is used so the mc knows when the subsystem sleeps. do not override.
/datum/controller/subsystem/proc/ignite(resumed = 0)
	set waitfor = 0
	. = SS_SLEEPING
	fire(resumed)
	. = state
	if (state == SS_SLEEPING)
		state = SS_IDLE
	if (state == SS_PAUSING)
		var/QT = queued_time
		enqueue()
		state = SS_PAUSED
		queued_time = QT

//previously, this would have been named 'process()' but that name is used everywhere for different things!
//fire() seems more suitable. This is the procedure that gets called every 'wait' deciseconds.
//Sleeping in here prevents future fires until returned.
/datum/controller/subsystem/proc/fire(resumed = 0)
	flags |= SS_NO_FIRE
	throw EXCEPTION("Subsystem [src]([type]) does not fire() but did not set the SS_NO_FIRE flag. Please add the SS_NO_FIRE flag to any subsystem that doesn't fire so it doesn't get added to the processing list and waste cpu.")

/datum/controller/subsystem/Destroy()
	dequeue()
	can_fire = 0
	flags |= SS_NO_FIRE
	Master.subsystems -= src
	return ..()

//Queue it to run.
//	(we loop thru a linked list until we get to the end or find the right point)
//	(this lets us sort our run order correctly without having to re-sort the entire already sorted list)
/datum/controller/subsystem/proc/enqueue()
	var/SS_priority = priority
	var/SS_flags = flags
	var/datum/controller/subsystem/queue_node
	var/queue_node_priority
	var/queue_node_flags

	for (queue_node = Master.queue_head; queue_node; queue_node = queue_node.queue_next)
		queue_node_priority = queue_node.queued_priority
		queue_node_flags = queue_node.flags

		if (queue_node_flags & SS_TICKER)
			if (!(SS_flags & SS_TICKER))
				continue
			if (queue_node_priority < SS_priority)
				break

		else if (queue_node_flags & SS_BACKGROUND)
			if (!(SS_flags & SS_BACKGROUND))
				break
			if (queue_node_priority < SS_priority)
				break

		else
			if (SS_flags & SS_BACKGROUND)
				continue
			if (SS_flags & SS_TICKER)
				break
			if (queue_node_priority < SS_priority)
				break

	queued_time = world.time
	queued_priority = SS_priority
	state = SS_QUEUED
	if (SS_flags & SS_BACKGROUND) //update our running total
		Master.queue_priority_count_bg += SS_priority
	else
		Master.queue_priority_count += SS_priority

	queue_next = queue_node
	if (!queue_node)//we stopped at the end, add to tail
		queue_prev = Master.queue_tail
		if (Master.queue_tail)
			Master.queue_tail.queue_next = src
		else //empty queue, we also need to set the head
			Master.queue_head = src
		Master.queue_tail = src

	else if (queue_node == Master.queue_head)//insert at start of list
		Master.queue_head.queue_prev = src
		Master.queue_head = src
		queue_prev = null
	else
		queue_node.queue_prev.queue_next = src
		queue_prev = queue_node.queue_prev
		queue_node.queue_prev = src


/datum/controller/subsystem/proc/dequeue()
	if (queue_next)
		queue_next.queue_prev = queue_prev
	if (queue_prev)
		queue_prev.queue_next = queue_next
	if (src == Master.queue_tail)
		Master.queue_tail = queue_prev
	if (src == Master.queue_head)
		Master.queue_head = queue_next
	queued_time = 0
	if (state == SS_QUEUED)
		state = SS_IDLE


/datum/controller/subsystem/proc/pause()
	. = 1
	switch(state)
		if(SS_RUNNING)
			state = SS_PAUSED
		if(SS_SLEEPING)
			state = SS_PAUSING


// Wrapper so things continue to work even in the case of a SS that doesn't call parent.
/datum/controller/subsystem/proc/DoInitialize(timeofday)
	init_state = SS_INITSTATE_STARTED
	init_start = timeofday
	Initialize(timeofday)
	init_finish = REALTIMEOFDAY
	. = (REALTIMEOFDAY - timeofday)/10
	var/msg = "Initialized [name] subsystem within [.] second[. == 1 ? "" : "s"]!"
	to_chat(world, "<span class='boldannounce'>[msg]</span>")
	log_world(msg)

	init_state = SS_INITSTATE_DONE
	initialized = TRUE	// Legacy.

//used to initialize the subsystem AFTER the map has loaded
/datum/controller/subsystem/Initialize(start_timeofday)
	// Stub, no default behavior here please.

//hook for printing stats to the "MC" statuspanel for admins to see performance and related stats etc.
/datum/controller/subsystem/stat_entry(text, force)
	if (!stat_line)
		stat_line = new (null, src)
	IF_UPDATE_STAT
		if (Master.initializing)
			text = "[stat_entry_init()]\t[text]"
			var/letter = init_state_letter()
			if (letter)
				text = "\[[letter]] [text]"
		else
			text = "[stat_entry_run()]\t[text]"
			if (can_fire && !suspended && !(flags & SS_NO_FIRE))
				text = "\[[state_letter()]] [text]"
		stat_line.name = text
	stat(name, stat_line)

/datum/controller/subsystem/proc/stat_entry_init()
	if (init_state == SS_INITSTATE_DONE)
		. = "DONE ([init_time]s)"
	else if (flags & SS_NO_INIT)
		. = "NO INIT"
	else if (init_state == SS_INITSTATE_STARTED)
		if (init_start)
			. = "LOAD ([(REALTIMEOFDAY - init_start)/10]s)"
		else
			. = "LOAD"
	else
		. = "WAIT"

// Generates the message shown before a subsystem during normal MC operation.
/datum/controller/subsystem/proc/stat_entry_run()
	if (flags & SS_NO_FIRE)
		. = "NO FIRE"
	else if (can_fire && !suspended)
		. = "[round(cost,1)]ms|[round(tick_usage,1)]%([round(tick_overrun,1)]%)|[round(ticks,0.1)]"
	else if (!can_fire)
		. = "OFFLINE"
	else
		. = "SUSPEND"

/datum/controller/subsystem/proc/init_state_letter()
	if (flags & SS_NO_INIT)
		return
	switch (init_state)
		if (SS_INITSTATE_NONE)
			. = "W"
		if (SS_INITSTATE_STARTED)
			. = "L"
		if (SS_INITSTATE_DONE)
			. = "D"

/datum/controller/subsystem/proc/state_letter()
	switch (state)
		if (SS_RUNNING)
			. = "R"
		if (SS_QUEUED)
			. = "Q"
		if (SS_PAUSED, SS_PAUSING)
			. = "P"
		if (SS_SLEEPING)
			. = "S"
		if (SS_IDLE)
			. = "  "

//could be used to postpone a costly subsystem for (default one) var/cycles, cycles
//for instance, during cpu intensive operations like explosions
/datum/controller/subsystem/proc/postpone(cycles = 1)
	if(next_fire - world.time < wait)
		next_fire += (wait*cycles)

//usually called via datum/controller/subsystem/New() when replacing a subsystem (i.e. due to a recurring crash)
//should attempt to salvage what it can from the old instance of subsystem
/datum/controller/subsystem/Recover()

// Admin-disables this subsystem. Will show as OFFLINE in MC panel.
/datum/controller/subsystem/proc/disable()
	can_fire = FALSE

// Admin-enables this subsystem.
/datum/controller/subsystem/proc/enable()
	if (!can_fire)
		next_fire = world.time + wait
		can_fire = TRUE

// Suspends this subsystem. Functionally identical to disable(), but shows SUSPEND in MC panel.
// 	Preferred over disable() for self-disabling subsystems.
/datum/controller/subsystem/proc/suspend()
	suspended = TRUE

// Wakes a suspended subsystem.
/datum/controller/subsystem/proc/wake()
	if (suspended)
		suspended = FALSE
		if (can_fire)
			next_fire = world.time + wait

/datum/controller/subsystem/VV_static()
	return ..() + list("queued_priority", "suspended")

/decl/vv_set_handler/subsystem_handler
	handled_type = /datum/controller/subsystem
	handled_vars = list("can_fire")
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/subsystem_handler/handle_set_var(var/datum/controller/subsystem/SS, variable, var_value, client)
	if (var_value)
		SS.enable()
	else
		SS.disable()
