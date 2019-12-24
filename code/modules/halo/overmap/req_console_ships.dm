
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
	cooldown_apply = 6 MINUTES

/datum/npc_ship/experimental_unsc_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_macplatform_experimental.dmm')
	fore_dir = WEST
	map_bounds = list(2,24,49,2)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/experimental_unsc_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/experimental_unsc_combat)

/datum/spawner_choice/experimental_unsc_combat
	choice_name = "Experimental Combat MAC Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with stripped down armor, armed with a large MAC gun"
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/experimental_unsc_combat
	cooldown_apply = 8 MINUTES

/datum/npc_ship/unsc_slipspace_tender
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_tender.dmm')
	fore_dir = WEST
	map_bounds = list(2,24,49,2)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_slipspace_tender
	name = "Ship"
	ship_datums = list(/datum/npc_ship/unsc_slipspace_tender)
	ship_max_speed = 3.5//Non combat ships are provided with a speed boost to allow them to dodge combat ships more effectively.

/datum/spawner_choice/unsc_slipspace_tender
	choice_name = "Slipspace Support Ship"
	choice_category = "Shuttles"
	choice_desc = "\
One of the few ships with a slipspace drive and full medical bay,\
alongside an improved assortment of engineering supplies. Lacks weapons and has low armour."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_slipspace_tender
	cooldown_apply = 5 MINUTES

/datum/npc_ship/unsc_podcarrier
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_podcarrier.dmm')
	fore_dir = WEST
	map_bounds = list(2,24,49,2)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_podcarrier
	name = "Ship"
	ship_datums = list(/datum/npc_ship/unsc_podcarrier)

/datum/spawner_choice/unsc_podcarrier
	choice_name = "Podcarrier Transport Ship"
	choice_category = "Transport"
	choice_desc = "\
A lightly armored vessel fitted for orbital troop deployment, boarding and orbital troop support operations. Armed with deck guns."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_podcarrier
	cooldown_apply = 2 MINUTES
	ship_max_speed = 3.5

/datum/npc_ship/unsc_trooptransport
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_trooptransport.dmm')
	fore_dir = WEST
	map_bounds = list(2,24,49,2)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_trooptransport
	name = "Ship"
	ship_datums = list(/datum/npc_ship/unsc_trooptransport)
	ship_max_speed = 3.5

/datum/spawner_choice/unsc_trooptransport
	choice_name = "Troop Transport Ship"
	choice_category = "Transport"
	choice_desc = "\
A lightly armored vessel fitted for troop and vehicle deployment. Armed with deck guns."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_trooptransport
	cooldown_apply = 2 MINUTES