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