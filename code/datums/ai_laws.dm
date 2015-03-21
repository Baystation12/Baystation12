var/global/const/base_law_type = /datum/ai_laws/nanotrasen

/datum/ai_law
	var/law = ""
	var/index = 0
	var/state_law = 1

/datum/ai_law/zero
	state_law = 0

/datum/ai_law/New(law, state_law, index)
	src.law = law
	src.index = index
	src.state_law = state_law

/datum/ai_law/proc/get_index()
	return index

/datum/ai_law/ion/get_index()
	return ionnum()

/datum/ai_law/zero/get_index()
	return 0

/datum/ai_laws
	var/name = "Unknown Laws"
	var/law_header = "Prime Directives"
	var/selectable = 0
	var/datum/ai_law/zero/zeroth_law = null
	var/datum/ai_law/zero/zeroth_law_borg = null
	var/list/datum/ai_law/inherent_laws = list()
	var/list/datum/ai_law/supplied_laws = list()
	var/list/datum/ai_law/ion/ion_laws = list()
	var/list/datum/ai_law/sorted_laws = list()

/datum/ai_laws/New()
	..()
	sort_laws()

/* General ai_law functions */
/datum/ai_laws/proc/all_laws()
	sort_laws()
	return sorted_laws

/datum/ai_laws/proc/laws_to_state()
	sort_laws()
	var/list/statements = new()
	for(var/datum/ai_law/law in sorted_laws)
		if(law.state_law)
			statements += law

	return statements

/datum/ai_laws/proc/sort_laws()
	if(sorted_laws.len)
		return

	for(var/ion_law in ion_laws)
		sorted_laws += ion_law

	if(zeroth_law)
		sorted_laws += zeroth_law

	var/index = 1
	for(var/datum/ai_law/inherent_law in inherent_laws)
		inherent_law.index = index++
		if(supplied_laws.len < inherent_law.index || !istype(supplied_laws[inherent_law.index], /datum/ai_law))
			sorted_laws += inherent_law

	for(var/datum/ai_law/AL in supplied_laws)
		if(istype(AL))
			sorted_laws += AL

/datum/ai_laws/proc/sync(var/mob/living/silicon/S, var/full_sync = 1)
	S.sync_zeroth(zeroth_law, zeroth_law_borg)

	if(full_sync || ion_laws.len)
		S.clear_ion_laws()
		for (var/datum/ai_law/law in ion_laws)
			S.laws.add_ion_law(law.law, law.state_law)

	if(full_sync || inherent_laws.len)
		S.clear_inherent_laws()
		for (var/datum/ai_law/law in inherent_laws)
			S.laws.add_inherent_law(law.law, law.state_law)

	if(full_sync || supplied_laws.len)
		S.clear_supplied_laws()
		for (var/law_number in supplied_laws)
			var/datum/ai_law/law = supplied_laws[law_number]
			S.laws.add_supplied_law(law_number, law.law, law.state_law)


/mob/living/silicon/proc/sync_zeroth(var/datum/ai_law/zeroth_law, var/datum/ai_law/zeroth_law_borg)
	if (!is_special_character(src) || mind.original != src)
		if(zeroth_law_borg)
			set_zeroth_law(zeroth_law_borg.law)
		else if(zeroth_law)
			set_zeroth_law(zeroth_law.law)

/mob/living/silicon/ai/sync_zeroth(var/datum/ai_law/zeroth_law, var/datum/ai_law/zeroth_law_borg)
	if(zeroth_law)
		set_zeroth_law(zeroth_law.law, zeroth_law_borg ? zeroth_law_borg.law : null)

/****************
*	Add Laws	*
****************/
/datum/ai_laws/proc/set_zeroth_law(var/law, var/law_borg = null)
	if(!law)
		return

	src.zeroth_law = new(law)
	if(law_borg) //Making it possible for slaved borgs to see a different law 0 than their AI. --NEO
		src.zeroth_law_borg = new(law_borg)
	sorted_laws.Cut()

/datum/ai_laws/proc/add_ion_law(var/law, var/state_law = 1)
	if(!law)
		return

	src.ion_laws += new/datum/ai_law/ion(law, state_law)
	sorted_laws.Cut()

/datum/ai_laws/proc/add_inherent_law(var/law, var/state_law = 1)
	if(!law)
		return

	for(var/datum/ai_law/AL in inherent_laws)
		if(AL.law == law)
			return

	src.inherent_laws += new/datum/ai_law(law, state_law)
	sorted_laws.Cut()

/datum/ai_laws/proc/add_supplied_law(var/number, var/law, var/state_law = 1)
	if(!law)
		return

	while (src.supplied_laws.len < number)
		src.supplied_laws += ""

	src.supplied_laws[number] = new/datum/ai_law(law, state_law, number)
	sorted_laws.Cut()

/****************
*	Remove Laws	*
*****************/
/datum/ai_laws/proc/delete_law(var/datum/ai_law/law)
	if(law in all_laws())
		del(law)
	sorted_laws.Cut()

/****************
*	Clear Laws	*
****************/
/datum/ai_laws/proc/clear_zeroth_laws()
	zeroth_law = null
	zeroth_law_borg = null

/datum/ai_laws/proc/clear_inherent_laws()
	src.inherent_laws.Cut()
	sorted_laws.Cut()

/datum/ai_laws/proc/clear_supplied_laws()
	src.supplied_laws.Cut()
	sorted_laws.Cut()

/datum/ai_laws/proc/clear_ion_laws()
	src.ion_laws.Cut()
	sorted_laws.Cut()

/datum/ai_laws/proc/show_laws(var/who)
	sort_laws()
	for(var/datum/ai_law/law in sorted_laws)
		if(law == zeroth_law || law == zeroth_law_borg)
			who << "<span class='danger'>[law.get_index()]. [law.law]</span>"
		else
			who << "[law.get_index()]. [law.law]"
