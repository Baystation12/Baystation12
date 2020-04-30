
//UNSC//
/datum/npc_ship/cheap_unsc_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_cheap.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/cheap_unsc_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/cheap_unsc_combat)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_combat.dmi')

/datum/spawner_choice/cheap_unsc_combat
	choice_name = "UNSC Combat Scout Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with standard UNSC armor, armed with missiles and deck guns."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/cheap_unsc_combat
	cooldown_apply = 4 MINUTES

/datum/npc_ship/heavyarmed_unsc_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_heavyarmed.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/heavyarmed_unsc_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/heavyarmed_unsc_combat)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_heavyarmed.dmi')

/datum/spawner_choice/heavyarmed_unsc_combat
	choice_name = "UNSC Combat MAC Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with standard UNSC armor, armed with a MAC and deck guns"
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/heavyarmed_unsc_combat
	cooldown_apply = 7 MINUTES

/datum/npc_ship/experimental_unsc_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_macplatform_experimental.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/experimental_unsc_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/experimental_unsc_combat)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_macplatform.dmi')

/datum/spawner_choice/experimental_unsc_combat
	choice_name = "UNSC Experimental Combat MAC Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with stripped down armor, armed with a large MAC gun"
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/experimental_unsc_combat
	cooldown_apply = 9 MINUTES

/datum/npc_ship/unsc_slipspace_tender
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_tender.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_slipspace_tender
	name = "Ship"
	ship_datums = list(/datum/npc_ship/unsc_slipspace_tender)
	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED + 0.5//Non combat ships are provided with a speed boost to allow them to dodge combat ships more effectively.
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_tender.dmi')

/datum/spawner_choice/unsc_slipspace_tender
	choice_name = "UNSC Slipspace Support Ship"
	choice_category = "Shuttles"
	choice_desc = "\
One of the few ships with a slipspace drive and full medical bay,\
alongside an improved assortment of engineering supplies. Lacks weapons and has low armour."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_slipspace_tender
	cooldown_apply = 5 MINUTES

/datum/npc_ship/unsc_podcarrier
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_podcarrier.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_podcarrier
	name = "Ship"
	ship_datums = list(/datum/npc_ship/unsc_podcarrier)
	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED + 0.5
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_podcarrier.dmi')

/datum/spawner_choice/unsc_podcarrier
	choice_name = "UNSC Podcarrier Transport Ship"
	choice_category = "Transport"
	choice_desc = "\
A lightly armored vessel fitted for orbital troop deployment, boarding and orbital troop support operations. Armed with deck guns."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_podcarrier
	cooldown_apply = 2 MINUTES

/datum/npc_ship/unsc_trooptransport
	mapfile_links = list('maps/npc_ships/req_console_ships/unsc_trooptransport.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_trooptransport
	name = "Ship"
	ship_datums = list(/datum/npc_ship/unsc_trooptransport)
	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED + 0.5
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_trooptransport.dmi')

/datum/spawner_choice/unsc_trooptransport
	choice_name = "UNSC Troop Transport Ship"
	choice_category = "Transport"
	choice_desc = "\
A lightly armored vessel fitted for troop and vehicle deployment. Armed with deck guns."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/unsc_trooptransport
	cooldown_apply = 2 MINUTES

//COVENANT//
/datum/npc_ship/cheap_cov_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/cov_cheap.dmm')
	fore_dir = WEST
	map_bounds = list(15,36,61,14)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/cheap_cov_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/cheap_cov_combat)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/covshuttle2.dmi') //Until we get specially made ones, use the same sprite for all

/datum/spawner_choice/cheap_cov_combat
	choice_name = "Covenant Combat Scout Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with standard Covenant ship plating, armed with plasma torpedoes and pulse lasers."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/cheap_cov_combat
	cooldown_apply = 4 MINUTES

/datum/npc_ship/heavyarmed_cov_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/cov_heavyarmed.dmm')
	fore_dir = WEST
	map_bounds = list(15,36,61,14)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/heavyarmed_cov_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/heavyarmed_cov_combat)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/covshuttle2.dmi')

/datum/spawner_choice/heavyarmed_cov_combat
	choice_name = "Combat Energy Projector Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with standard Covenant ship plating, armed with an Energy  Projector and pulse lasers"
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/heavyarmed_cov_combat
	cooldown_apply = 7 MINUTES

/datum/npc_ship/experimental_cov_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/cov_laserplatform_experimental.dmm')
	fore_dir = WEST
	map_bounds = list(15,36,61,14)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/experimental_cov_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/experimental_cov_combat)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/covshuttle2.dmi')

/datum/spawner_choice/experimental_cov_combat
	choice_name = "Experimental Combat Energy Projector Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with stripped down armor, armed soely with two Energy Projectors."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/experimental_cov_combat
	cooldown_apply = 9 MINUTES

/datum/npc_ship/cov_slipspace_tender
	mapfile_links = list('maps/npc_ships/req_console_ships/cov_tender.dmm')
	fore_dir = WEST
	map_bounds = list(15,36,61,14)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/cov_slipspace_tender
	name = "Ship"
	ship_datums = list(/datum/npc_ship/cov_slipspace_tender)
	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED + 0.5 //Non combat ships are provided with a speed boost to allow them to dodge combat ships more effectively.
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/covshuttle2.dmi')

/datum/spawner_choice/cov_slipspace_tender
	choice_name = "Covenant Slipspace Support Ship"
	choice_category = "Shuttles"
	choice_desc = "\
One of the few ships with a slipspace drive and full medical bay,\
alongside an improved assortment of engineering supplies. Lacks weapons and has low armour."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/cov_slipspace_tender
	cooldown_apply = 5 MINUTES

/datum/npc_ship/cov_podcarrier
	mapfile_links = list('maps/npc_ships/req_console_ships/cov_podcarrier.dmm')
	fore_dir = WEST
	map_bounds = list(15,36,61,14)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/cov_podcarrier
	name = "Ship"
	ship_datums = list(/datum/npc_ship/cov_podcarrier)
	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED + 0.5
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/covshuttle2.dmi')

/datum/spawner_choice/cov_podcarrier
	choice_name = "Covenant Podcarrier Transport Ship"
	choice_category = "Transport"
	choice_desc = "\
A lightly armored vessel fitted for orbital troop deployment, boarding and orbital troop support operations. Armed with pulse lasers."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/cov_podcarrier
	cooldown_apply = 2 MINUTES

/datum/npc_ship/cov_trooptransport
	mapfile_links = list('maps/npc_ships/req_console_ships/cov_trooptransport.dmm')
	fore_dir = WEST
	map_bounds = list(15,36,61,14)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/cov_trooptransport
	name = "Ship"
	ship_datums = list(/datum/npc_ship/cov_trooptransport)
	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED + 0.5
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/covshuttle2.dmi')

/datum/spawner_choice/cov_trooptransport
	choice_name = "Covenant Troop Transport Ship"
	choice_category = "Transport"
	choice_desc = "\
A lightly armored vessel fitted for troop and vehicle deployment. Armed with pulse lasers."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/cov_trooptransport
	cooldown_apply = 2 MINUTES

//URF//
/datum/npc_ship/cheap_urf_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/urf_cheap.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/cheap_urf_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/cheap_urf_combat)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_combat.dmi')

/datum/spawner_choice/cheap_urf_combat
	choice_name = "URF Combat Scout Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with standard URF armor, armed with missiles and deck guns."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/cheap_urf_combat
	cooldown_apply = 4 MINUTES

/datum/npc_ship/heavyarmed_urf_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/urf_heavyarmed.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/heavyarmed_urf_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/heavyarmed_urf_combat)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_heavyarmed.dmi')

/datum/spawner_choice/heavyarmed_urf_combat
	choice_name = "URF Combat MAC Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with standard URF armor, armed with a MAC and deck guns"
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/heavyarmed_urf_combat
	cooldown_apply = 7 MINUTES

/datum/npc_ship/experimental_urf_combat
	mapfile_links = list('maps/npc_ships/req_console_ships/urf_macplatform_experimental.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/experimental_urf_combat
	name = "Ship"
	ship_datums = list(/datum/npc_ship/experimental_urf_combat)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_macplatform.dmi')

/datum/spawner_choice/experimental_urf_combat
	choice_name = "URF Experimental Combat MAC Ship"
	choice_category = "Gunboats"
	choice_desc = "A ship with stripped down armor, armed with a large MAC gun"
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/experimental_urf_combat
	cooldown_apply = 9 MINUTES

/datum/npc_ship/urf_slipspace_tender
	mapfile_links = list('maps/npc_ships/req_console_ships/urf_tender.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/urf_slipspace_tender
	name = "Ship"
	ship_datums = list(/datum/npc_ship/urf_slipspace_tender)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_tender.dmi')
	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED + 0.5//Non combat ships are provided with a speed boost to allow them to dodge combat ships more effectively.

/datum/spawner_choice/urf_slipspace_tender
	choice_name = "URF Slipspace Support Ship"
	choice_category = "Shuttles"
	choice_desc = "\
One of the few ships with a slipspace drive and full medical bay,\
alongside an improved assortment of engineering supplies. Lacks weapons and has low armour."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/urf_slipspace_tender
	cooldown_apply = 5 MINUTES

/datum/npc_ship/urf_podcarrier
	mapfile_links = list('maps/npc_ships/req_console_ships/urf_podcarrier.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/urf_podcarrier
	name = "Ship"
	ship_datums = list(/datum/npc_ship/urf_podcarrier)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_podcarrier.dmi')
	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED + 0.5

/datum/spawner_choice/urf_podcarrier
	choice_name = "URF Podcarrier Transport Ship"
	choice_category = "Transport"
	choice_desc = "\
A lightly armored vessel fitted for orbital troop deployment, boarding and orbital troop support operations. Armed with deck guns."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/urf_podcarrier
	cooldown_apply = 2 MINUTES

/datum/npc_ship/urf_trooptransport
	mapfile_links = list('maps/npc_ships/req_console_ships/urf_trooptransport.dmm')
	fore_dir = WEST
	map_bounds = list(12,38,63,12)

/obj/effect/overmap/ship/npc_ship/shuttlecraft/urf_trooptransport
	name = "Ship"
	ship_datums = list(/datum/npc_ship/urf_trooptransport)
	icons_pickfrom_list = list('code/modules/halo/icons/overmap/req_trooptransport.dmi')
	ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED + 0.5

/datum/spawner_choice/urf_trooptransport
	choice_name = "URF Troop Transport Ship"
	choice_category = "Transport"
	choice_desc = "\
A lightly armored vessel fitted for troop and vehicle deployment. Armed with deck guns."
	spawned_ship = /obj/effect/overmap/ship/npc_ship/shuttlecraft/urf_trooptransport
	cooldown_apply = 2 MINUTES

