GLOBAL_DATUM(innie_factions_controller, /datum/controller/process/innie_factions)

/datum/controller/process/innie_factions
	name = "Insurrection Factions Controller"
	var/list/active_quests = list()
	var/list/complete_quests = list()
	var/quest_interval_min = 2 MINUTES
	var/quest_interval_max = 10 MINUTES
	var/time_next_quest = 0
	var/max_quests = 0
	var/list/npc_factions = list()
	var/list/npc_factions_by_name = list()
	var/list/npc_factions_by_type = list(/datum/faction/urf, /datum/faction/kosovo, /datum/faction/coral)

/datum/controller/process/innie_factions/New()
	GLOB.innie_factions_controller = src

	. = ..()

/datum/controller/process/innie_factions/setup()
	. = ..()
	for(var/faction_type in npc_factions_by_type)
		var/datum/faction/F = new faction_type()
		npc_factions_by_type[faction_type] = F
		npc_factions_by_name.Add(F.name)
		npc_factions_by_name[F.name] = F
		npc_factions.Add(F)


/datum/controller/process/innie_factions/proc/begin_processing()
	generate_quest()
	generate_quest()
	generate_quest()
	time_next_quest = world.time + quest_interval_max
	max_quests = rand(4,10)

/datum/controller/process/innie_factions/doWork()
	//check if we need to generate a new quest
	if(active_quests.len < max_quests && world.time > time_next_quest)
		generate_quest()

/datum/controller/process/innie_factions/proc/generate_quest()
	var/datum/faction/F = pick(npc_factions)
	var/datum/npc_quest/Q = F.generate_quest()
	active_quests.Add(Q)

	//tell the faction about the new NPC quest
	for(var/obj/machinery/computer/innie_comms/C in GLOB.innie_comms_computers)
		C.new_quest(Q)

/datum/controller/process/innie_factions/proc/complete_quest(var/datum/npc_quest/Q)
	active_quests -= Q
	complete_quests += Q
	time_next_quest = world.time + rand(quest_interval_min, quest_interval_max)
	max_quests = rand(3,10)

	//tell the faction about the finished NPC quest
	for(var/obj/machinery/computer/innie_comms/C in GLOB.innie_comms_computers)
		C.quest_finished(Q)
