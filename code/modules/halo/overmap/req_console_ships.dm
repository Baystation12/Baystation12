
/datum/npc_ship/cheap_unsc_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_cheap.dmm')
	fore_dir = WEST
	map_bounds = list(2,24,49,2)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/cheap_unsc_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/cheap_unsc_combat)

/datum/spawner_choice/cheap_unsc_combat
	choice_name = "Combat Scout Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with standard UNSC armor, armed with missiles and deck guns."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/cheap_unsc_combat
	cooldown_apply = 2 MINUTES

/datum/npc_ship/heavyarmed_unsc_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_heavyarmed.dmm')
	fore_dir = WEST
	map_bounds = list(2,24,49,2)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/heavyarmed_unsc_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/heavyarmed_unsc_combat)

/datum/spawner_choice/heavyarmed_unsc_combat
	choice_name = "Combat MAC Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with standard UNSC armor, armed with a MAC and deck guns"
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/heavyarmed_unsc_combat
	cooldown_apply = 5 MINUTES