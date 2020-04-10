
/datum/controller/process/factions
	name = "Factions Controller"
	var/quest_interval_min = 2 MINUTES
	var/quest_interval_max = 10 MINUTES
	var/time_next_quest = 0
	var/max_quests = 0
	var/list/processing_factions = list()
	var/list/all_factions
	var/list/factions_by_name
	var/list/factions_by_type
	var/list/innie_factions
	var/list/innie_factions_by_name
	var/list/criminal_factions
	var/list/criminal_factions_by_name
	var/list/npc_factions
	var/datum/npc_quest/loaded_quest_instance
	var/list/unlocked_supply_packs = list()
	var/list/active_quest_coords = list()

/datum/controller/process/factions/New()
	GLOB.factions_controller = src
	//
	all_factions = GLOB.all_factions
	factions_by_name = GLOB.factions_by_name
	factions_by_type = GLOB.factions_by_type
	innie_factions = GLOB.innie_factions
	innie_factions_by_name = GLOB.innie_factions_by_name
	criminal_factions = GLOB.criminal_factions
	criminal_factions_by_name = GLOB.criminal_factions_by_name
	npc_factions = GLOB.npc_factions
	. = ..()

/datum/controller/process/factions/setup()
	. = ..()

	//generate some criminal factions
	new /datum/faction/random_criminal()
	new /datum/faction/random_criminal()

	//generate the NPC factions
	for(var/faction_type in typesof(/datum/faction/npc) - /datum/faction/npc)
		//these factions will automatically sort themselves out
		new faction_type()

	for(var/datum/faction/F in all_factions)
		F.Initialize()

/datum/controller/process/factions/doWork()
	for(var/datum/faction/F in processing_factions)
		F.process()

