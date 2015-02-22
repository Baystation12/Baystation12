/datum/wound
	var/severity = 1
	var/depth = 0
	var/status = WOUND_CLOSED
	var/wound_type = WOUND_CUT
	var/germ_level = 0
	var/wound_str
	var/obj/item/embedded              // If something is inside this wound.
	var/mob/living/carbon/human/holder // Person that this would is allocated to.

/datum/wound/New(var/mob/living/carbon/human/new_holder)
	if(!new_holder)
		del(src)
	holder = new_holder

/datum/wound/proc/expand(var/new_wound_type, var/new_size, var/new_depth)

	if(!new_size)
		new_size = 1
	if(!new_depth)
		new_depth = 1
	severity = new_size
	depth = new_depth

	if(new_wound_type)
		wound_type  = new_wound_type
	if(wound_type == WOUND_CUT)
		status = WOUND_OPEN
	update_wound_descriptor()

	if(status == WOUND_SUTURED && prob(25))
		status = WOUND_OPEN

/datum/wound/proc/heal(var/healing)

	var/remainder = max(0,healing-severity)
	// Infections have a nasty impact on healing.
	switch(germ_level)
		if(INFECTION_LEVEL_ONE to INFECTION_LEVEL_TWO)
			healing *= 0.7
		if(INFECTION_LEVEL_TWO to INFECTION_LEVEL_THREE)
			healing *= 0.5
		if(INFECTION_LEVEL_THREE to INFINITY)
			return
	// Being an open wound slows healing right down.
	if(status == WOUND_OPEN)
		healing *= 0.5
	severity -= healing
	if(severity > 0)
		update_wound_descriptor()
	return remainder

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
			wound_str = "narrow [wound_str]"
		if(20 to INFINITY)
			wound_str = "gaping [wound_str]"

	switch(depth)
		if(1)
			wound_str = "shallow [wound_str]"
		if(3 to INFINITY)
			wound_str = "deep [wound_str]"

/datum/wound/proc/get_wound_descriptor(var/update)
	if(!wound_str || update)
		update_wound_descriptor()
	return wound_str
