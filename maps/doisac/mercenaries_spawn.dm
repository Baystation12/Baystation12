
/datum/game_mode/packwar/proc/refresh_mercenaries()

	var/list/boulder_mercs = list()
	var/list/ram_mercs = list()
	var/datum/job/packwar_merc/merc

	available_champions = 1
	merc = job_master.occupations_by_title["Boulder Clan Mercenary - T-Voan Champion"]
	boulder_mercs[merc.title] = merc
	merc.available_hires = available_champions
	merc = job_master.occupations_by_title["Ram Clan Mercenary - T-Voan Champion"]
	ram_mercs[merc.title] = merc
	merc.available_hires = available_champions

	available_murmillos = pick(2,3)
	merc = job_master.occupations_by_title["Boulder Clan Mercenary - T-Voan Murmillo"]
	boulder_mercs[merc.title] = merc
	merc.available_hires = available_murmillos
	merc = job_master.occupations_by_title["Ram Clan Mercenary - T-Voan Murmillo"]
	ram_mercs[merc.title] = merc
	merc.available_hires = available_murmillos

	available_defenders = pick(3,4)
	merc = job_master.occupations_by_title["Boulder Clan Mercenary - Ruutian Defender"]
	boulder_mercs[merc.title] = merc
	merc.available_hires = available_defenders
	merc = job_master.occupations_by_title["Ram Clan Mercenary - Ruutian Defender"]
	ram_mercs[merc.title] = merc
	merc.available_hires = available_defenders

	available_snipers = pick(1,2,3)
	merc = job_master.occupations_by_title["Boulder Clan Mercenary - Ruutian Sniper"]
	boulder_mercs[merc.title] = merc
	merc.available_hires = available_snipers
	merc = job_master.occupations_by_title["Ram Clan Mercenary - Ruutian Sniper"]
	ram_mercs[merc.title] = merc
	merc.available_hires = available_snipers

	for(var/obj/structure/kigyar_merc_console/console in world)
		if(console.faction == "Ram Clan")
			console.update_merc_listing_all()
		else
			console.update_merc_listing_all()

	//announce over radio
	GLOB.global_announcer.autosay("I've just arrived in the system. My crew is available for hire as mercenaries.", \
		"Kig\'Yar Pirate", "System", "Sangheili")

/obj/structure/merc_dropship
	name = "Type-25 \"Spirit\" Troop Carrier"
	desc = "A large, tuning fork shaped ship with a underslung heavy plasma cannon."
	icon = 'code/modules/halo/vehicles/types/spirit.dmi'
	icon_state = "base"
	density = 1

	bound_height = 128
	bound_width = 128

/area/doisac_ram_mercenary_ship
	name =  "Ram Clan Mercenaries"
	icon_state = "blue2"
	has_gravity = 1
	dynamic_lighting = 0

/area/doisac_boulder_mercenary_ship
	name =  "Boulder Clan Mercenaries"
	icon_state = "red2"
	has_gravity = 1
	dynamic_lighting = 0

/obj/effect/landmark/mercspawn
	name = "Ram Clan Mercenary Ship Spawn"
	var/merc_respawn_wave = 15 SECONDS
	var/duration_at_planet = 5 SECONDS
	var/time_merc_dropoff = 0
	var/time_leave_planet = 0
	var/clan_name = "Ram"
	var/radio_channel = "RamNet"
	var/ship_area_type = /area/doisac_ram_mercenary_ship
	var/area/ship_area
	var/obj/structure/merc_dropship/dropship

/obj/effect/landmark/mercspawn/New()
	. = ..()
	ship_area = locate(ship_area_type) in world
	GLOB.processing_objects.Add(src)
	dropship = new(src)

/obj/effect/landmark/mercspawn/ram

/obj/effect/landmark/mercspawn/boulder
	name = "Boulder Clan Mercenary Ship Spawn"
	clan_name = "Boulder"
	radio_channel = "BoulderNet"
	ship_area_type = /area/doisac_boulder_mercenary_ship

/obj/effect/landmark/mercspawn/process()
	if(time_merc_dropoff && world.time > time_merc_dropoff)
		arrive_planet()

	if(time_leave_planet && world.time > time_leave_planet)
		leave_planet()

/obj/effect/landmark/mercspawn/proc/merc_has_spawned()
	if(!time_merc_dropoff)
		time_merc_dropoff = world.time + merc_respawn_wave
		spawn(10)
			GLOB.global_announcer.autosay(\
				"I've dispatched some of the mercenaries you hired and they will arrive in [merc_respawn_wave] seconds. \
				Good hunting, [pick("[clan_name] clan","apes","hair balls","brutes")].", \
				"Kig\'Yar Pirate", radio_channel, "Sangheili")

/obj/effect/landmark/mercspawn/proc/arrive_planet()
	time_merc_dropoff = 0
	time_leave_planet = world.time + duration_at_planet
	dropship.loc = src.loc
	dropship.visible_message("\icon[src] <span class='notice'>[src] touches down to let off a squad of mercenaries.</span>")
	if(ship_area)
		for(var/mob/M in ship_area)
			M.loc = src.loc
			to_chat(M,"<span class='notice'>You have been ejected from the dropship as you have arrived at your destination.</span>")

/obj/effect/landmark/mercspawn/proc/leave_planet()
	time_leave_planet = 0
	dropship.visible_message("\icon[dropship] <span class='notice'>[dropship] takes off back to the kig\'yar mercenary ship</span>")
	dropship.loc = src
