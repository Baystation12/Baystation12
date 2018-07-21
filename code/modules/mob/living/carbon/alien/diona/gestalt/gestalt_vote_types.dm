/datum/gestalt_vote
	var/mob/living/carbon/alien/caller
	var/list/voted = list()
	var/descriptor = "a generic motion"
	var/vote_time = 1 MINUTE
	var/passed
	var/obj/structure/diona_gestalt/owner
	var/minimum_nymphs = 3

/datum/gestalt_vote/New(var/obj/structure/diona_gestalt/_owner, var/mob/_caller)
	owner = _owner
	caller =_caller
	addtimer(CALLBACK(src, .proc/timed_out), vote_time)

/datum/gestalt_vote/proc/timed_out()
	if(owner && !passed)
		for(var/thing in owner.nymphs)
			to_chat(thing, "<span class='notice'>\The vote to <i>[descriptor]</i> has run out of time and has failed.</span>")
	qdel(src)

/datum/gestalt_vote/Topic(href, href_list)
	. = ..()
	if(!. && href_list["voter"])
		var/mob/living/carbon/alien/diona/voter = locate(href_list["voter"])
		if(!voter.incapacitated() && voter.loc == owner && !voted[voter] && !passed && !QDELETED(src))
			voted[voter] = TRUE
			var/target_value = 0
			for(var/thing in owner.nymphs)
				var/mob/living/carbon/alien/diona/chirp = thing
				if(chirp.client)
					target_value++
			target_value = ceil(target_value/2)
			passed = (voted.len >= target_value)
			for(var/thing in owner.nymphs)
				to_chat(thing, "<span class='notice'>\The [voter] voted yes to <i>[descriptor]</i> ([voted.len]/[target_value]).</span>")
				if(passed)
					to_chat(thing, "<span class='notice'><b>Motion passed!</b></span>")
			if(passed) succeeded()
			return TRUE

/datum/gestalt_vote/Destroy()
	voted.Cut()
	caller = null
	if(owner)
		if(owner.current_vote == src)
			owner.current_vote = null
		owner = null
	. = ..()

/datum/gestalt_vote/proc/succeeded()
		return

/datum/gestalt_vote/form_change_humanoid
	descriptor = "change to a humanoid form"

/datum/gestalt_vote/form_change_humanoid/succeeded()

	var/mob/living/carbon/human/diona/humanoid_gestalt = new(get_turf(owner))
	transfer_languages(caller, humanoid_gestalt)
	if(caller.mind)
		caller.mind.transfer_to(humanoid_gestalt)
	else
		humanoid_gestalt.key = caller.key
	owner.visible_message("<span class='notice'>\The [owner] curls in on itself and bunches up, forming a humanoid shape.</span>")
	for(var/thing in owner.nymphs)
		var/mob/living/carbon/alien/diona/D = thing
		D.forceMove(humanoid_gestalt)
		to_chat(D, "<span class='notice'>\The [caller] has shaped the gestalt into a humanoid form.</span>")
	owner.nymphs.Cut()
	var/caller_instance_num = caller.instance_num
	spawn
		var/newname = sanitize(input(humanoid_gestalt, "You have become a humanoid gestalt. Choose a name for yourself.", "Gestalt Name") as null|text, MAX_NAME_LEN)
		if(!newname)
			humanoid_gestalt.fully_replace_character_name("diona gestalt ([caller_instance_num])")
		else
			humanoid_gestalt.fully_replace_character_name(newname)
	QDEL_NULL(owner)
	qdel(src)
