SUBSYSTEM_DEF(culture)
	name = "Culture"
	init_order = SS_INIT_CULTURE
	flags = SS_NO_FIRE

	var/list/cultural_info_by_name =      list()
	var/list/cultural_info_by_path =      list()
	var/list/tagged_info =                list()
	var/list/dreams = list(
		"a familiar face", "voices from all around", "a traitor", "an ally",
		"darkness", "light", "a catastrophe", "a loved one", "warmth", "freezing",
		"a hat", "air", "a blue light", "blood", "healing", "power", "respect",
		"riches", "a crash", "happiness", "pride", "a fall", "water", "flames",
		"ice", "flying", "a voice", "the cold", "the rain", "a creature built completely of stolen flesh",
		"a being made of light", "an old friend", "the tower", "the man with no face",
		"an old home", "right behind you", "standing above you", "someone near by", "a place forgotten"
	)

	var/list/credits_other =           list("ATTACK! ATTACK! ATTACK!")
	var/list/credits_adventure_names = list("QUEST", "FORCE", "ADVENTURE")
	var/list/credits_crew_names =      list("EVERYONE")
	var/list/credits_holidays =        list("HOLIDAY", "VACATION")
	var/list/credits_adjectives =      list("SEXY", "ARCANE", "POLITICALLY MOTIVATED")
	var/list/credits_crew_outcomes =   list("PICKLED", "A VALUABLE HISTORY LESSON", "A BREAK", "HIGH", "TO LIVE", "TO RELIVE THEIR CHILDHOOD")
	var/list/credits_topics =          list("SACRED GEOMETRY","ABSTRACT MATHEMATICS","LOVE","DRUGS","CRIME","PRODUCTIVITY","LAUNDRY")
	var/list/credits_nouns =           list("DIGNITY", "SANITY")


/datum/controller/subsystem/culture/UpdateStat(time)
	return


/datum/controller/subsystem/culture/proc/get_all_entries_tagged_with(token)
	return tagged_info[token]

/datum/controller/subsystem/culture/Initialize(start_uptime)

	for(var/ftype in subtypesof(/singleton/cultural_info))
		var/singleton/cultural_info/culture = ftype
		if(!initial(culture.name))
			continue
		culture = new culture
		if(cultural_info_by_name[culture.name])
			crash_with("Duplicate cultural datum ID - [culture.name] - [ftype]")
		cultural_info_by_name[culture.name] = culture
		cultural_info_by_path[ftype] = culture
		if(culture.category && !culture.hidden)
			if(!tagged_info[culture.category])
				tagged_info[culture.category] = list()
			var/list/tag_list = tagged_info[culture.category]
			tag_list[culture.name] = culture


/datum/controller/subsystem/culture/proc/get_culture(culture_ident)
	return cultural_info_by_name[culture_ident] ? cultural_info_by_name[culture_ident] : cultural_info_by_path[culture_ident]
