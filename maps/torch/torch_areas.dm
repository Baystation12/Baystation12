/datum/map/torch
	post_round_safe_areas = list (
		/area/centcom,
		/area/shuttle/escape/centcom,
		/area/shuttle/escape_pod1/centcom,
		/area/shuttle/escape_pod2/centcom,
		/area/shuttle/escape_pod3/centcom,
		/area/shuttle/escape_pod5/centcom,
		/area/shuttle/transport1/centcom,
		/area/shuttle/administration/centcom,
		/area/shuttle/specops/centcom,
	)

/area/supply/station
	base_turf = /turf/simulated/floor/plating

//Fourth Deck (Z-1)
/area/hallway/primary/fourthdeck/fore
	name = "\improper Fourth Deck Fore Hallway"
	icon_state = "hallF"

/area/hallway/primary/fourthdeck/center
	name = "\improper Fourth Deck Central Hallway"
	icon_state = "hallC3"

/area/hallway/primary/fourthdeck/aft
	name = "\improper Fourth Deck Aft Hallway"
	icon_state = "hallA"

/area/maintenance/fourthdeck
	name = "Fourth Deck Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fourthdeck/aft
	name = "Fourth Deck Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/fourthdeck/foreport
	name = "Fourth Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fourthdeck/forestarboard
	name = "Fourth Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/fourthdeck/starboard
	name = "Fourth Deck Starboard Maintenance"
	icon_state = "smaint"

/area/teleporter/fourthdeck
	name = "\improper Fourth Deck Teleporter"
	icon_state = "teleporter"

/area/maintenance/substation/fourthdeck
	name = "Fourth Deck Substation"


//Third Deck (Z-2)
/area/hallway/primary/thirddeck/fore
	name = "\improper Third Deck Fore Hallway"
	icon_state = "hallF"

/area/hallway/primary/thirddeck/center
	name = "\improper Third Deck Central Hallway"
	icon_state = "hallC3"

/area/hallway/primary/thirddeck/aft
	name = "\improper Third Deck Aft Hallway"
	icon_state = "hallA"

/area/maintenance/thirddeck
	name = "Third Deck Maintenance"
	icon_state = "maintcentral"

/area/maintenance/thirddeck/foreport
	name = "Third Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/thirddeck/forestarboard
	name = "Third Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/thirddeck/starboard
	name = "Third Deck Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/thirddeck/port
	name = "Third Deck Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/thirddeck/aftstarboard
	name = "Third Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/thirddeck/aftport
	name = "Third Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/teleporter/thirddeck
	name = "\improper Third Deck Teleporter"
	icon_state = "teleporter"

/area/maintenance/substation/thirddeck
	name = "Third Deck Substation"

/area/engineering/atmos
 	name = "\improper Atmospherics"
 	icon_state = "atmos"
 	sound_env = LARGE_ENCLOSED


//Second Deck (Z-3)
/area/maintenance/seconddeck
	name = "Second Deck Maintenance"
	icon_state = "maintcentral"

/area/maintenance/seconddeck/aftstarboard
	name = "Second Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/seconddeck/aftport
	name = "Second Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/seconddeck/foreport
	name = "Second Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/seconddeck/forestarboard
	name = "Second Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/seconddeck/central
	name = "Second Deck Central Maintenance"
	icon_state = "maintcentral"

/area/teleporter/seconddeck
	name = "\improper Second Deck Teleporter"
	icon_state = "teleporter"

/area/hallway/primary/seconddeck/center
	name = "\improper Second Deck Central Stairwell"
	icon_state = "hallC2"

/area/tcommsat/relay/seconddeck
	name = "\improper Second Deck Relay"
	icon_state = "tcomsatcham"

/area/maintenance/substation/seconddeck
	name = "Second Deck Substation"


//First Deck (Z-4)
/area/maintenance/firstdeck
	name = "First Deck Maintenance"
	icon_state = "maintcentral"

/area/maintenance/firstdeck/aftstarboard
	name = "First Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/firstdeck/aftport
	name = "First Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/firstdeck/forestarboard
	name = "First Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/firstdeck/foreport
	name = "First Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/firstdeck/centralstarboard
	name = "First Deck Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/firstdeck/centralport
	name = "First Deck Port Maintenance"
	icon_state = "pmaint"

/area/teleporter/firstdeck
	name = "\improper First Deck Teleporter"
	icon_state = "teleporter"

/area/hallway/primary/firstdeck/fore
	name = "\improper First Deck Fore Hallway"
	icon_state = "hallF"

/area/hallway/primary/firstdeck/center
	name = "\improper First Deck Central Hallway"
	icon_state = "hallC1"

/area/hallway/primary/firstdeck/aft
	name = "\improper First Deck Aft Hallway"
	icon_state = "hallA"

/area/tcommsat/relay/firstdeck
	name = "\improper First Deck Relay"
	icon_state = "tcomsatcham"

/area/maintenance/substation/firstdeck // First Deck (Z-4)
	name = "First Deck Substation"

// Shuttles
/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "\improper Transport Shuttle Centcom"

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "\improper Transport Shuttle"

//torch large pods
/area/shuttle/escape_pod6
	name = "\improper Escape Pod One"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod6/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod6/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod6/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

/area/shuttle/escape_pod7
	name = "\improper Escape Pod Two"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod7/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod7/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod7/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

/area/shuttle/escape_pod8
	name = "\improper Escape Pod Three"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod8/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod8/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod8/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

/area/shuttle/escape_pod9
	name = "\improper Escape Pod Four"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod9/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod9/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod9/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

/area/shuttle/escape_pod10
	name = "\improper Escape Pod Five"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod10/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/plating

/area/shuttle/escape_pod10/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod10/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/east/shuttlespace_ew1

/area/shuttle/escape_pod11
	name = "\improper Escape Pod Six"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod11/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/plating

/area/shuttle/escape_pod11/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod11/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/east/shuttlespace_ew1


//torch small pods
/area/shuttle/escape_pod12
	name = "\improper Escape Pod Seven"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod12/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod12/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod12/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

/area/shuttle/escape_pod13
	name = "\improper Escape Pod Eight"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod13/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod13/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod13/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

/area/shuttle/escape_pod14
	name = "\improper Escape Pod Nine"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod14/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod14/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod14/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

/area/shuttle/escape_pod15
	name = "\improper Escape Pod Ten"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod15/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod15/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod15/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

/area/shuttle/escape_pod16
	name = "\improper Escape Pod Eleven"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod16/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod16/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod16/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

/area/shuttle/escape_pod17
	name = "\improper Escape Pod Twelve"
	flags = RAD_SHIELDED

/area/shuttle/escape_pod17/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod17/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod17/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

//Calypso

/area/calypso_hangar
	name = "\improper SEV Torch Hangar Deck"
	icon_state = "yellow"
	requires_power = 0
	lighting_use_dynamic = 1
	flags = RAD_SHIELDED

/area/calypso_hangar/start
	name = "\improper SEV Torch Hangar Deck"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating

/area/calypso_hangar/firstdeck
	name = "north of first deck"
	icon_state = "north"

/area/calypso_hangar/seconddeck
	name = "south of second deck"
	icon_state = "south"

/area/calypso_hangar/thirddeck
	name = "west of third deck"
	icon_state = "west"

/area/calypso_hangar/fourthdeck
	name = "east of fourth deck"
	icon_state = "east"

/area/calypso_hangar/salvage
	name = "debris field"
	icon_state = "shuttlered"

/area/calypso_hangar/mining
	name = "mining site"
	icon_state = "shuttlered"

/area/calypso_hangar/away
	name = "away site"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/asteroid

/area/calypso_hangar/transit
	name = "transit"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

//Guppy

/area/guppy_hangar
	name = "\improper SEV Torch Hangar Deck"
	icon_state = "yellow"
	requires_power = 0
	lighting_use_dynamic = 1
	flags = RAD_SHIELDED


/area/guppy_hangar/start
	name = "\improper SEV Torch Hangar Deck"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating

/area/guppy_hangar/firstdeck
	name = "east of first deck"
	icon_state = "east"

/area/guppy_hangar/seconddeck
	name = "west of second deck"
	icon_state = "west"

/area/guppy_hangar/thirddeck
	name = "south of third deck"
	icon_state = "south"

/area/guppy_hangar/fourthdeck
	name = "north of fourth deck"
	icon_state = "north"

/area/guppy_hangar/salvage
	name = "debris field"
	icon_state = "shuttlered"

/area/guppy_hangar/mining
	name = "mining site"
	icon_state = "shuttlered"

/area/guppy_hangar/transit
	name = "transit"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north/shuttlespace_ns1

//Turbolift
/area/turbolift
	name = "\improper Turbolift"
	icon_state = "shuttle"
	requires_power = 0
	lighting_use_dynamic = 1
	flags = RAD_SHIELDED

/area/turbolift/start
	name = "\improper Turbolift Start"

/area/turbolift/firstdeck
	name = "\improper first deck"
	base_turf = /turf/simulated/open

/area/turbolift/seconddeck
	name = "\improper second deck"
	base_turf = /turf/simulated/open

/area/turbolift/thirddeck
	name = "\improper third deck"
	base_turf = /turf/simulated/open

/area/turbolift/fourthdeck
	name = "\improper fourth deck"
	base_turf = /turf/simulated/floor/plating

// Ninja areas
/area/ninja_dojo
	name = "\improper Ninja Base"
	icon_state = "green"
	requires_power = 0
	lighting_use_dynamic = 1
	flags = RAD_SHIELDED

/area/ninja_dojo/dojo
	name = "\improper Clan Dojo"
	lighting_use_dynamic = 0

/area/ninja_dojo/start
	name = "\improper Clan Dojo"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating

/area/ninja_dojo/firstdeck
	name = "south of first deck"
	icon_state = "south"

/area/ninja_dojo/seconddeck
	name = "north of second deck"
	icon_state = "north"

/area/ninja_dojo/thirddeck
	name = "east of third deck"
	icon_state = "east"

/area/ninja_dojo/fourthdeck
	name = "west of fourth deck"
	icon_state = "west"

/area/ninja_dojo/mining
	name = "mining site"
	icon_state = "shuttlered"

/area/ninja_dojo/salvage
	name = "debris field"
	icon_state = "shuttlered"

/area/ninja_dojo/away
	name = "away site"
	icon_state = "shuttlered"

/area/ninja_dojo/transit
	name = "bluespace"
	icon_state = "shuttle"
	base_turf = /turf/space/bluespace

//Merchant

/area/shuttle/merchant
	icon_state = "shuttlegrn"

/area/shuttle/merchant/home
	name = "\improper Merchant Vessel - Home"

/area/shuttle/merchant/away
	name = "\improper Merchant Vessel - Away"


//Merc

/area/syndicate_mothership
	name = "\improper Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	lighting_use_dynamic = 0

/area/syndicate_station
	name = "\improper Independant Station"
	icon_state = "yellow"
	requires_power = 0
	flags = RAD_SHIELDED

/area/syndicate_station/start
	name = "\improper Mercenary Forward Operating Base"
	icon_state = "yellow"

/area/syndicate_station/firstdeck
	name = "north-east of first deck"
	icon_state = "northeast"

/area/syndicate_station/seconddeck
	name = "south-east of second deck"
	icon_state = "southeast"

/area/syndicate_station/thirddeck
	name = "south of third deck"
	icon_state = "south"

/area/syndicate_station/fourthdeck
	name = "north-west of fourth deck"
	icon_state = "northwest"

/area/syndicate_station/mining
	name = "mining site"
	icon_state = "shuttlered"

/area/syndicate_station/salvage
	name = "debris field"
	icon_state = "shuttlered"

/area/syndicate_station/away
	name = "away site"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/asteroid

/area/syndicate_station/transit
	name = " bluespace"
	icon_state = "shuttle"
	base_turf = /turf/space/bluespace

/area/syndicate_station/arrivals_dock
	name = "\improper docked with SEV Torch"
	icon_state = "shuttle"

//Skipjack

/area/skipjack_station
	name = "Raider Outpost"
	icon_state = "yellow"
	requires_power = 0

/area/skipjack_station/transit
	name = "bluespace"
	icon_state = "shuttle"
	base_turf = /turf/space/bluespace

/area/skipjack_station/firstdeck
	name = "north-west of first deck"
	icon_state = "northwest"

/area/skipjack_station/seconddeck
	name = "south-west of second deck"
	icon_state = "southwest"

/area/skipjack_station/thirddeck
	name = "south-east of third deck"
	icon_state = "southeast"

/area/skipjack_station/fourthdeck
	name = "north-east of fourth deck"
	icon_state = "northeast"

/area/skipjack_station/mining
	name = "mining site"
	icon_state = "shuttlered"

/area/skipjack_station/salvage
	name = "debris field"
	icon_state = "shuttlered"

/area/skipjack_station/away
	name = "away site"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/asteroid

/area/skipjack_station/arrivals_dock
	name = "\improper docked with SEV Torch"
	icon_state = "shuttle"

//NT rescue shuttle

/area/rescue_base
	name = "\improper Response Team Base"
	icon_state = "yellow"
	requires_power = 0
	lighting_use_dynamic = 1
	flags = RAD_SHIELDED

/area/rescue_base/base
	name = "\improper Barracks"
	icon_state = "yellow"
	lighting_use_dynamic = 0

/area/rescue_base/start
	name = "\improper Response Team Base"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor/rescue_base

/area/rescue_base/firstdeck
	name = "south-west of first deck"
	icon_state = "southwest"

/area/rescue_base/seconddeck
	name = "north-west of second deck"
	icon_state = "northwest"

/area/rescue_base/thirddeck
	name = "north of third deck"
	icon_state = "north"

/area/rescue_base/fourthdeck
	name = "south-east of fourth deck"
	icon_state = "southeast"

/area/rescue_base/away
	name = "away site"
	icon_state = "shuttlered"

/area/rescue_base/salvage
	name = "debris field"
	icon_state = "shuttlered"

/area/rescue_base/mining
	name = "mining site"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/asteroid

/area/rescue_base/arrivals_dock
	name = "\improper docked with SEV Torch"
	icon_state = "shuttle"

/area/rescue_base/transit
	name = "bluespace"
	icon_state = "shuttle"
	base_turf = /turf/space/bluespace

// Elevator areas.
/area/shuttle/turbolift/torch_top
	name = "First Deck"
	lift_announce_str = "Arriving at Operations Deck: Bridge. Command Offices. Emergency Armory. Infirmary. Research Wing."

/area/shuttle/turbolift/torch_second
	name = "Second Deck"
	lift_announce_str = "Arriving at Maintenance Deck: Engineering. Atmospherics. AI Core. Sanitation."

/area/shuttle/turbolift/torch_first
	name = "Third Deck"
	lift_announce_str = "Arriving at Habitation Deck: EVA. Security Wing. Telecommunications. Hydroponics. Mess Hall. Cryogenic Storage."

/area/shuttle/turbolift/torch_ground
	name = "Fourth Deck"
	lift_announce_str = "Arriving at Hangar Deck: Shuttle Docks. Storage. Main Hangar. Supply Office."
	base_turf = /turf/simulated/floor

// Command
/area/crew_quarters/heads
	icon_state = "head_quarters"

/area/crew_quarters/heads/cobed
	name = "\improper Command - CO's Quarters"
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/heads/office/co
	name = "\improper Command - CO's Office"
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/heads/office/xo
	name = "\improper Command - XO's Office"

/area/crew_quarters/heads/office/rd
	name = "\improper Command - RD's Office"

/area/crew_quarters/heads/office/cmo
	name = "\improper Command - CMO's Office"

/area/crew_quarters/heads/office/ce
	name = "\improper Engineering - CE's Office"

/area/crew_quarters/heads/office/cos
	name = "\improper Command - CoS' Office"

/area/crew_quarters/heads/office/cl
	name = "\improper Command - CL's Office"

/area/crew_quarters/heads/office/sgr
	name = "\improper Command - SCGR's Office"

// Engineering

/area/engineering/atmos/aux
	name = "\improper Auxiliary Atmospherics"
	icon_state = "atmos"
	sound_env = SMALL_ENCLOSED

/area/engineering/auxpower
	name = "\improper Auxiliary Power Storage"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "engineering_workshop"

/area/engineering/hardstorage
	name = "\improper Engineering Hard Storage"
	icon_state = "engineering_storage"

//Vacant Areas
/area/vacant
	name = "\improper Vacant Area"
	icon_state = "construction"

/area/vacant/armory
	name = "\improper Marine Armory"
	icon_state = "Tactical"

/area/vacant/cabin
	name = "\improper Vacant Cabins"
	icon_state = "crew_quarters"

/area/vacant/chapel
	name = "\improper Unused Chapel"
	icon_state = "chapel"

/area/vacant/infirmary
	name = "\improper Auxiliary Infirmary"
	icon_state = "medbay"

/area/vacant/monitoring
	name = "\improper Auxiliary Monitoring Room"
	icon_state = "engine_monitoring"

/area/vacant/cannon
	name = "\improper Main Gun"
	icon_state = "firingrange"

/area/vacant/cargo
	name = "\improper Requisitions Office"
	icon_state = "quart"

/area/vacant/briefing
	name = "\improper Briefing Room"
	icon_state = "conference"

/area/vacant/mess
	name = "\improper Officer's Mess"
	icon_state = "bar"

/area/vacant/missile
	name = "\improper Third Deck Port Missile Pod"
	icon_state = "firingrange"

/area/vacant/brig
	name = "\improper Permanent Brig"
	icon_state = "brig"

// Storage
/area/storage/auxillary/port
	name = "Port Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/auxillary/starboard
	name = "Starboard Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/cargo
	name = "Cargo Storage"
	icon_state = "quartstorage"
	sound_env = SMALL_ENCLOSED

/area/storage/expedition
	name = "Expedition Storage"
	icon_state = "storage"
	sound_env = SMALL_ENCLOSED

/area/storage/medical
	name = "Medical Storage"
	icon_state = "medbay4"
	sound_env = SMALL_ENCLOSED

/area/storage/research
	name = "Research Storage"
	icon_state = "toxstorage"
	sound_env = SMALL_ENCLOSED

//DJSTATION

/area/djstation
	name = "\improper Listening Post"
	icon_state = "LP"

// Cargo

/area/quartermaster/deckofficer
	name = "\improper Deck Officer"
	icon_state = "quart"

/area/quartermaster/expedition
	name = "\improper Expedition Preparation"
	icon_state = "mining"

/area/quartermaster/expedition/eva
	name = "\improper Expedition EVA"
	icon_state = "mining"

/area/quartermaster/expedition/storage
	name = "\improper Expedition Storage"
	icon_state = "mining"

/area/quartermaster/hangar
	name = "\improper Hangar Deck"
	icon_state = "mining"
	sound_env = LARGE_ENCLOSED

// Research
/area/rnd/anom
	name = "\improper Anomalous Materials"
	icon_state = "toxmisc"

/area/rnd/canister
	name = "\improper Canister Storage"
	icon_state = "toxstorage"

/area/rnd/development
	name = "\improper Development Lab"
	icon_state = "toxlab"

/area/rnd/entry
	name = "\improper Research and Development Access"
	icon_state = "decontamination"

/area/rnd/equipment
	name = "\improper Equipment Storage"
	icon_state = "toxstorage"

/area/rnd/locker
	name = "\improper Research Locker Room"
	icon_state = "locker"

/area/rnd/wing
	name = "\improper Lab Wing"
	icon_state = "toxlab"

/area/rnd/xenobiology/entry
	name = "\improper Xenobiology Access"
	icon_state = "xeno_lab"

// Crew areas
/area/crew_quarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR

/area/crew_quarters/cryolocker
	name = "\improper Cryogenic Storage Wardrobe"
	icon_state = "locker"

/area/crew_quarters/head
	name = "\improper Head"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/mess
	name = "\improper Mess Hall"
	icon_state = "cafeteria"

/area/crew_quarters/galley
	name = "\improper Galley"
	icon_state = "kitchen"

/area/crew_quarters/galleybackroom
	name = "\improper Galley Cold Storage"
	icon_state = "kitchen"

/area/crew_quarters/lounge
	name = "\improper Lounge"
	icon_state = "crew_quarters"
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/safe_room/
	name = "\improper Safe Room"
	icon_state = "crew_quarters"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/safe_room/thirddeck
	name = "\improper Third Deck Safe Room"

/area/crew_quarters/sleep/bunk
	name = "\improper Bunk Room"
	icon_state = "Sleep"
	sound_env = SMALL_SOFTFLOOR

/area/crew_quarters/sleep/cryo/aux
	name = "\improper Auxiliary Cryogenic Storage"
	icon_state = "Sleep"

/area/holocontrol
	name = "\improper Holodeck Control"
	icon_state = "Holodeck"

/area/hydroponics/storage
	name = "\improper Hydroponics Storage"

// Tcomms
/area/tcommsat/storage
	name = "\improper Telecoms Storage"
	icon_state = "tcomsatstore"

// Security

/area/rnd/checkpoint
	name = "\improper Research Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/armourybridge
	name = "\improper Bridge - Armory"
	icon_state = "Warden"

/area/security/armourybridgeaccess
	name = "\improper bridge - Armory Access"
	icon_state = "Warden"

/area/security/bo
	name = "\improper Security - Brig Officer"
	icon_state = "Warden"

/area/security/equipment
	name = "\improper Security Equipment"
	icon_state = "security"

/area/security/evidence
	name = "\improper Security Evidence Storage"
	icon_state = "security"

/area/security/processing
	name = "\improper Security Processing"
	icon_state = "security"

/area/security/wing
	name = "\improper Security Wing"
	icon_state = "security"

// AI
/area/turret_protected/ai_foyer
	name = "\improper AI Chamber Foyer"
	icon_state = "ai_foyer"
	sound_env = SMALL_ENCLOSED

/area/turret_protected/ai_outer_chamber
	name = "\improper Outer AI Chamber"
	icon_state = "ai_chamber"
	sound_env = SMALL_ENCLOSED

// Medbay

/area/medical/equipstorage
	name = "\improper Equipment Storage"
	icon_state = "medbay4"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/infirmary
	name = "\improper Infirmary Hallway"
	icon_state = "medbay"

/area/medical/infirmreception
	name = "\improper Infirmary Reception"
	icon_state = "medbay2"
	ambience = list('sound/ambience/signal.ogg')

/area/medical/locker
	name = "\improper Infirmary Locker Room"
	icon_state = "locker"

/area/medical/subacute
	name = "\improper Sub-Acute Ward"
	icon_state = "patients"

/area/medical/mentalhealth
	name = "\improper Mental Health"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')

// Chapel
/area/chapel/crematorium
	name = "\improper Crematorium"
	icon_state = "chapel"
	sound_env = SMALL_ENCLOSED
