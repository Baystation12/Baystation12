/* SURGERY STEPS */

/datum/surgery_step
	var/priority = 0	//steps with higher priority would be attempted first

	// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools = null
	// type paths referencing mutantraces that this step applies to.
	var/list/allowed_species = null
	var/list/disallowed_species = null

	// duration of the step
	var/min_duration = 0
	var/max_duration = 0

	// evil infection stuff that will make everyone hate me
	var/can_infect = 0
	//How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0

	//returns how well tool is suited for this step
	proc/tool_quality(obj/item/tool)
		for (var/T in allowed_tools)
			if (istype(tool,T))
				return allowed_tools[T]
		return 0

	// Checks if this step applies to the user mob at all
	proc/is_valid_target(mob/living/carbon/human/target)
		if(!hasorgans(target))
			return 0

		if(allowed_species)
			for(var/species in allowed_species)
				if(target.species.name == species)
					return 1

		if(disallowed_species)
			for(var/species in disallowed_species)
				if(target.species.name == species)
					return 0

		return 1


	// checks whether this step can be applied with the given user and target
	proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return 0

	// does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
	proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/datum/organ/external/affected = target.get_organ(target_zone)
		if (can_infect && affected)
			spread_germs_to_organ(affected, user)
		if (ishuman(user) && prob(60))
			var/mob/living/carbon/human/H = user
			if (blood_level)
				H.bloody_hands(target,0)
			if (blood_level > 1)
				H.bloody_body(target,0)
		return

	// does stuff to end the step, which is normally print a message + do whatever this step changes
	proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return

	// stuff that happens when the step fails
	proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return null

proc/spread_germs_to_organ(datum/organ/external/E, mob/living/carbon/human/user)
	if(!istype(user) || !istype(E)) return

	var/germ_level = user.germ_level
	if(user.gloves)
		germ_level = user.gloves.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

proc/do_surgery(mob/living/carbon/M, mob/living/user, obj/item/tool)
	if(!istype(M))
		return 0
	if (user.a_intent == "harm")	//check for Hippocratic Oath
		return 0
	if(M.op_stage.in_progress) //Can't operate on someone repeatedly.
		user << "\red You can't operate on the patient while surgery is already in progress."
		return 1

	for(var/datum/surgery_step/S in surgery_steps)
		//check if tool is right or close enough and if this step is possible
		if(S.tool_quality(tool))
			var/step_is_valid = S.can_use(user, M, user.zone_sel.selecting, tool)
			if(step_is_valid && S.is_valid_target(M))
				if(step_is_valid == 2) // This is a failure that already has a message for failing.
					return 1
				M.op_stage.in_progress = 1
				S.begin_step(user, M, user.zone_sel.selecting, tool)		//start on it
				//We had proper tools! (or RNG smiled.) and user did not move or change hands.
				if(prob(S.tool_quality(tool)) &&  do_mob(user, M, rand(S.min_duration, S.max_duration)))
					S.end_step(user, M, user.zone_sel.selecting, tool)		//finish successfully
				else if (tool in user.contents && user.Adjacent(M))			//or
					S.fail_step(user, M, user.zone_sel.selecting, tool)		//malpractice~
				else // This failing silently was a pain.
					user << "\red You must remain close to your patient to conduct surgery."
				M.op_stage.in_progress = 0 									// Clear the in-progress flag.
				return	1	  												//don't want to do weapony things after surgery

	if (user.a_intent == "help")
		user << "\red You can't see any useful way to use [tool] on [M]."
		return 1
	return 0

proc/sort_surgeries()
	var/gap = surgery_steps.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.247330950103979)
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= surgery_steps.len; i++)
			var/datum/surgery_step/l = surgery_steps[i]		//Fucking hate
			var/datum/surgery_step/r = surgery_steps[gap+i]	//how lists work here
			if(l.priority < r.priority)
				surgery_steps.Swap(i, gap + i)
				swapped = 1

/datum/surgery_status/
	var/eyes	=	0
	var/face	=	0
	var/head_reattach = 0
	var/current_organ = "organ"
	var/in_progress = 0