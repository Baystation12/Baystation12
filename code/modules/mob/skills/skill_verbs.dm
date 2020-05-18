//Skill-related mob verbs that require skill checks to be satisfied to be added.

GLOBAL_LIST_INIT(skill_verbs, init_subtypes(/datum/skill_verb))

/datum/skillset/proc/fetch_verb_datum(given_type)
	for(var/datum/skill_verb/SV in skill_verbs)
		if(SV.type == given_type)
			return SV

/datum/skillset/proc/update_verbs()
	for(var/datum/skill_verb/SV in skill_verbs)
		SV.update_verb()

/datum/skill_verb
	var/datum/skillset/skillset   //Owner, if any.
	var/the_verb                  //The verb to keep track of. Should be a mob verb.
	var/cooldown                  //How long the verb cools down for after use. null = has no cooldown.
	var/cooling_down = 0          //Whether it's currently cooling down.

/datum/skill_verb/Destroy()
	skillset = null
	. = ..()

//Not whether it can be accessed/used; just whether the mob skillset should have this datum and check it when updating skill verbs.
/datum/skill_verb/proc/should_have_verb(datum/skillset/given_skillset)
	return 1

/datum/skill_verb/proc/give_to_skillset(datum/skillset/given_skillset)
	var/datum/skill_verb/new_verb = new type
	new_verb.skillset = given_skillset
	LAZYADD(given_skillset.skill_verbs, new_verb)

//Updates whether or not the mob has access to this verb.
/datum/skill_verb/proc/update_verb()
	if(!skillset || !skillset.owner)
		return
	. = should_see_verb()
	. ? (skillset.owner.verbs |= the_verb) : (skillset.owner.verbs -= the_verb)

/datum/skill_verb/proc/should_see_verb()
	if(cooling_down)
		return
	return 1

/datum/skill_verb/proc/remove_cooldown()
	cooling_down = 0
	update_verb()

/datum/skill_verb/proc/set_cooldown()
	if(!cooldown)
		return
	cooling_down = 1
	update_verb()
	addtimer(CALLBACK(src, .proc/remove_cooldown), cooldown)
/*
The Instruct verb. buffs untrained -> basic and requires skill in the skill training as well as leadership.
Robots and antags can instruct.
*/
/datum/skill_verb/instruct
	the_verb = /mob/proc/instruct
	cooldown = 15 MINUTES

/datum/skill_verb/instruct/should_have_verb(datum/skillset/given_skillset)
	if(!..())
		return
	if(!isliving(given_skillset.owner))
		return
	return 1

/datum/skill_verb/instruct/should_see_verb()
	if(!..())
		return
	for(var/decl/hierarchy/skill/S in GLOB.skills)
		if(skillset.owner.skill_check(S.type, SKILL_EXPERT))
			return 1

/mob/proc/instruct(mob/living/carbon/human/target as mob in oview(2))
	set category = "IC"
	set name = "Instruct"
	set src = usr

	var/datum/skill_verb/instruct/SV = skillset.fetch_verb_datum(/datum/skill_verb/instruct)
	if(!SV || !istype(target))
		return
	if(src == target)
		to_chat(src, "<span class='notice'>Cannot instruct yourself.</span>")
		return
	if(incapacitated() || target.incapacitated())
		to_chat(src, "<span class='notice'>[incapacitated() ? "You are in no state to teach right now!" : "\the [target] is in no state to be taught right now!"]</span>")
		return

	if(target.too_many_buffs(/datum/skill_buff/instruct))
		to_chat(src, "<span class='notice'>\The [target] exhausted from all the training \he recieved.</span>")
		return

	var/options = list()
	for(var/decl/hierarchy/skill/S in GLOB.skills)
		if(!target.skill_check(S.type, SKILL_BASIC) && skill_check(S.type, SKILL_EXPERT))
			options[S.name] = S
	if(!length(options))
		to_chat(src, "<span class='notice'>There is nothing you can teach \the [target].</span>")
	var/choice = input(src, "Select skill to instruct \the [target] in:", "Skill select") as null|anything in options
	if(!(choice in options) || !(target in view(2)))
		return
	var/decl/hierarchy/skill/skill = options[choice]

	if(!do_skilled(6 SECONDS, skill.type, target))
		return
	if(incapacitated() || target.incapacitated())
		to_chat(src, "<span class='notice'>[incapacitated() ? "You are in no state to teach right now!" : "\the [target] is in no state to be taught right now!"]</span>")
		return
	if(target.too_many_buffs(/datum/skill_buff/instruct))
		to_chat(src, "<span class='notice'>\The [target] exhausted from all the training \he recieved.</span>")
		return
	if(target.skill_check(skill.type, SKILL_BASIC))
		to_chat(src, "<span class='notice'>\The [target] is too skilled to gain any benefit from a short lesson.</span>")
		return
	if(!skill_check(skill.type, SKILL_EXPERT))
		return

	target.buff_skill(list(skill.type = 1), buff_type = /datum/skill_buff/instruct)
	visible_message("<span class='notice'>\The [src] trained \the [target] in the basics of \the [skill.name].</span>")
	SV.set_cooldown()

/datum/skill_buff/instruct/
	limit = 3

/datum/skill_buff/motivate/can_buff(mob/target)
	if(!..())
		return
	if(!ishuman(target))
		return
	return 1
/*
The Appraise verb. Used on objects to estimate their value.
*/
/datum/skill_verb/appraise
	the_verb = /mob/proc/appraise

/datum/skill_verb/appraise/should_have_verb(datum/skillset/given_skillset)
	if(!..())
		return
	if(!isliving(given_skillset.owner))
		return
	return 1

/datum/skill_verb/appraise/should_see_verb()
	if(!..())
		return
	if(!skillset.owner.skill_check(SKILL_FINANCE, SKILL_BASIC))
		return
	return 1

/mob/proc/appraise(obj/item as obj in get_equipped_items(1))
	set category = "IC"
	set name = "Appraise"
	set src = usr
	set popup_menu = 0

	if(incapacitated() || !istype(item))
		return
	var/value = get_value(item)
	var/message
	if(!value)
		message = "\The [item] seems worthless."
	else
		var/multiple = round(log(10, value))
		if(multiple < 0)
			message = "\The [item] seems worthless."
		else
			var/level = get_appraise_level(get_skill_value(SKILL_FINANCE))
			level *= 10 ** (max(multiple - 1, 0))
			var/low = level * round(value/level)  //low and high bracket the value between multiples of level
			var/high = low + level
			if(!low && multiple >= 2)
				low = 10 ** (multiple - 1) //Adjusts the lowball estimate away from 0 if the item has a high upper estimate.
			message = "You appraise the item to be worth between [low] and [high] [GLOB.using_map.local_currency_name]."
	to_chat(src, message)

/proc/get_appraise_level(skill)
	switch(skill)
		if(SKILL_MAX)
			return 5
		if(SKILL_EXPERT)
			return 10
		if(SKILL_ADEPT)
			return 20
		else
			return 50

/datum/skill_verb/noirvision
	the_verb = /mob/proc/noirvision

/datum/skill_verb/noirvision/should_have_verb(datum/skillset/given_skillset)
	if(!..())
		return
	if(!isliving(given_skillset.owner))
		return
	return 1

/datum/skill_verb/noirvision/should_see_verb()
	if(!..())
		return
	if(!skillset.owner.skill_check(SKILL_FORENSICS, SKILL_PROF))
		return
	return 1

/mob/proc/noirvision()
	set category = "IC"
	set name = "Detective instinct"
	set src = usr
	set popup_menu = 0

	if(incapacitated())
		return

	if(!remove_client_color(/datum/client_color/noir))
		to_chat(src, "You clear your mind and focus on the scene before you.")
		add_client_color(/datum/client_color/noir)
	else
		to_chat(src, "You stop looking for clues.")




