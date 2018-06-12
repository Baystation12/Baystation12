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
The Motivate verb.
*/
/datum/skill_verb/motivate
	the_verb = /mob/living/carbon/human/proc/motivate
	cooldown = 15 MINUTES

/datum/skill_verb/motivate/should_have_verb(datum/skillset/given_skillset)
	if(!ishuman(given_skillset.owner))
		return
	return ..()

/datum/skill_verb/motivate/should_see_verb()
	if(!..())
		return
	var/mob/owner = skillset.owner
	if(owner.mind && player_is_antag(owner.mind))
		return
	if(!owner.skill_check(SKILL_MANAGEMENT, SKILL_BASIC))
		return
	return 1

/mob/living/carbon/human/proc/motivate(mob/living/carbon/human/target as mob in oview())
	set category = "IC"
	set name = "Motivate"
	set src = usr

	var/datum/skill_verb/motivate/SV = skillset.fetch_verb_datum(/datum/skill_verb/motivate)
	if(!SV || !istype(target))
		return
	if(src == target)
		return

	var/datum/skill_buff/motivate/buff = new //For doing checks with
	if(buff.too_many_buffs(target))
		to_chat(src, "<span class='notice'>\The [target] appears to be highly motivated already.</span>")
		return

	var/options = list()
	var/own_leadership = get_skill_value(SKILL_MANAGEMENT)
	for(var/decl/hierarchy/skill/S in GLOB.skills)
		if(istype(S, SKILL_MANAGEMENT))
			continue //No buffing leadership to avoid exploits.
		if(!target.skill_check(S.type, own_leadership)) //only buff skills below our leadership value.
			options[S.name] = S
	var/choice = input(src, "Select skill to motivate \the [target] in:", "Skill select") as null|anything in options

	if(!(choice in options) || !(target in view())) //Check again, might have moved.
		return
	if(buff.too_many_buffs(target))
		to_chat(src, "<span class='notice'>\The [target] appears to be highly motivated already.</span>")
		return
	var/decl/hierarchy/skill/skill = options[choice]
	if(target.skill_check(skill.type, own_leadership))
		return //Maybe they got buffed while we waited for input.

	target.buff_skill(list(skill.type = 1), 45 MINUTES, /datum/skill_buff/motivate)
	visible_message(motivate_message(target, skill))
	SV.set_cooldown()

/mob/living/carbon/human/proc/motivate_message(mob/living/carbon/human/target, decl/hierarchy/skill/skill)
	. = list()
	. += "\The [src] gives \the [target] a"
	. += pick("n inspiring", " riveting", " stirring", " moving")
	. += " speech, urging them to focus on [skill.name]. The speech features appeals to "
	var/list/dat = list()
	if(religion == target.religion)
		if(religion != "None")
			dat += "their common religion ([religion])"
		else
			dat += "their common lack of spirituality"
	if(home_system == target.home_system)
		dat += "their shared home system of [home_system]"
	if(personal_faction == target.personal_faction)
		dat += "their commitment to [personal_faction]"
	if(citizenship == target.citizenship)
		dat += "their [citizenship] citizenship"
	if(species == target.species)
		if(species != all_species[SPECIES_HUMAN])
			dat += "their [species] heritage"
		else
			dat += "their humanity"
	if(char_branch == target.char_branch)
		dat += "their experiences in \the [char_branch.name]"
	switch(target.age)
		if(0 to 20)
			dat += "\the [target]'s youth and sense of adventure"
		if(21 to 35)
			dat += "\the [target]'s competence and ambition"
		else
			dat += "\the [target]'s age and experience"
	dat += "\the [target]'s sense of duty"
	dat += "\the [target]'s commitment to the mission"
	dat = shuffle(dat)
	dat.Cut(4)
	. += english_list(dat)
	. += ". \The [src]'s tone is "
	. += pick("warm", "steely", "no-bullshit", "caring", "nostalgic", "angry")
	. += ", and \the [target] appears "
	. += pick("captivated", "moved", "indifferent", "stoic", "encouraged", "heartened")
	. += "."
	. = "<span class='notice'>[JOINTEXT(.)]</span>"

/datum/skill_buff/motivate/
	limit = 2

/datum/skill_buff/motivate/can_buff(mob/target)
	if(!..())
		return
	if(!ishuman(target))
		return
	if(target.mind && player_is_antag(target.mind))
		return //No motivating antags.
	return 1

/datum/skill_buff/motivate/remove()
	to_chat(skillset.owner, "<span class='notice'>You feel some of your motivation wearing off.</span>")
	..()
/*
The Call to Attention verb
*/
/datum/skill_verb/attention
	the_verb = /mob/living/carbon/human/proc/attention
	cooldown = 5 MINUTES

/datum/skill_verb/attention/should_have_verb(datum/skillset/given_skillset)
	if(!ishuman(given_skillset.owner))
		return
	return ..()

/datum/skill_verb/attention/should_see_verb()
	if(!..())
		return
	var/mob/owner = skillset.owner
	if(owner.mind && player_is_antag(owner.mind))
		return
	if(!owner.skill_check(SKILL_MANAGEMENT, SKILL_PROF))
		return
	return 1

/mob/living/carbon/human/proc/attention()
	set category = "IC"
	set name = "Call To Attention"
	set src = usr

	var/datum/skill_verb/attention/SV = skillset.fetch_verb_datum(/datum/skill_verb/attention)
	if(!SV)
		return

	usr.visible_message("<span class='danger'><font size=3>\The [src] calls for attention!</font></span>")
	for(var/mob/living/carbon/human/H in oview())
		if(!H.incapacitated())
			H.set_dir(get_dir(H, src))
		if(H.mind && player_is_antag(H.mind))
			continue //No mass stunning the antags, but they do get distracted.
		if(!H.skill_check(SKILL_MANAGEMENT, SKILL_PROF))
			H.Stun(5)
			H.silent += 10 SECONDS

	SV.set_cooldown()