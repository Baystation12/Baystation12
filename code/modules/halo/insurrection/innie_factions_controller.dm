GLOBAL_DATUM(innie_factions_controller, /datum/controller/process/innie_factions)

/datum/controller/process/innie_factions
	name = "Insurrection Factions Controller"
	var/list/active_quests = list()
	var/list/complete_quests = list()
	var/quest_interval_min = 2 MINUTES
	var/quest_interval_max = 10 MINUTES
	var/time_next_quest = 0
	var/max_quests = 6
	var/list/npc_factions = list()
	var/list/npc_factions_by_name = list("United Rebel Front","Kosovics","Coral Insurgency")

/datum/controller/process/innie_factions/New()
	. = ..()
	GLOB.innie_factions_controller = src

/datum/controller/process/innie_factions/setup()
	. = ..()
	for(var/faction_name in npc_factions_by_name)
		var/datum/faction/F = GLOB.factions_by_name[faction_name]
		npc_factions_by_name[faction_name] = F
		npc_factions.Add(F)

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
