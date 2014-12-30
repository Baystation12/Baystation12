#define WOUND_OPEN 1
#define WOUND_RETRACTED 2
#define WOUND_SUTURED 3

/datum/wound
	var/severity
	var/status = WOUND_OPEN
	var/wound_type
	var/germ_level = 0
	var/wound_str

/datum/wound/New(var/new_wound_type = WOUND_CUT, var/new_size = 1)
	severity = new_size
	wound_type = new_wound_type
	update_wound_descriptor()

/datum/wound/proc/heal(var/healing)
	return
	// Infection/necrosis can stop a limb from healing.
	/*
	switch(germ_level)
		if(INFECTION_LEVEL_ONE to INFECTION_LEVEL_TWO)
			healing *= 0.7
		if(INFECTION_LEVEL_TWO to INFECTION_LEVEL_THREE)
			healing *= 0.5
		if(INFECTION_LEVEL_THREE to INFINITY)
			return
	if(status == WOUND_OPEN)
		healing += 0.5
	severity -= healing
	if(severity > 0)
		update_wound_descriptor()
		*/

/datum/wound/proc/update_wound_descriptor()
	switch(wound_type)
		if(WOUND_BURN)
			wound_str = "burn"
		if(WOUND_BRUISE)
			wound_str = "bruise"
		else
			wound_str = "cut"
	switch(status)
		if(WOUND_OPEN)
			wound_str = "open [wound_str]"
		if(WOUND_RETRACTED)
			wound_str = "retracted [wound_str]"
		else
			wound_str = "closed [wound_str]"

	if(germ_level > INFECTION_LEVEL_ONE)
		wound_str = "infected [wound_str]"

	switch (severity)
		if(0 to 10)
			wound_str = "minor [wound_str]"
		if(20 to INFINITY)
			wound_str = "severe [wound_str]"

/datum/wound/proc/get_wound_descriptor(var/update)
	if(!wound_str || update)
		update_wound_descriptor()
	return wound_str