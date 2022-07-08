/datum/map/torch

	base_floor_type = /turf/simulated/floor/reinforced/airless
	base_floor_area = /area/torchexterior

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

//Fifth Deck (Z-0)
/area/hallway/primary/fifthdeck/fore
	name = "\improper Fifth Deck Fore Hallway"
	icon_state = "hallF"

/area/hallway/primary/fifthdeck/aft
	name = "\improper Fifth Deck Aft Hallway"
	icon_state = "hallA"

/area/maintenance/fifthdeck
	name = "Fifth Deck Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fifthdeck/aftport
	name = "Fifth Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/fifthdeck/aftstarboard
	name = "Fifth Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/fifthdeck/fore
	name = "Fifth Deck Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/substation/fifthdeck
	name = "Fifth Deck Substation"

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

/area/maintenance/fourthdeck/port
	name = "Fourth Deck Port Maintenance"
	icon_state = "pmaint"

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

/area/crew_quarters/safe_room
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/crew_quarters/safe_room/thirddeck
	name = "\improper Third Deck Safe Room"

/area/crew_quarters/laundry
	name = "\improper Laundry Room"
	icon_state = "Sleep"

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

/area/hallway/primary/seconddeck
	name = "Second Deck Central Hallway"
	icon_state = "hallC2"

/area/hallway/primary/seconddeck/center
	name = "\improper Second Deck Stairwell"

/area/hallway/primary/seconddeck/elevator
	name = "Second Deck Elevator Landing"
	icon_state = "hallC2_e"

/area/hallway/primary/seconddeck/fore
	name = "Second Deck Fore Hallway"
	icon_state = "hallF2"

/area/teleporter/seconddeck
	name = "\improper Second Deck Teleporter"
	icon_state = "teleporter"

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

/area/crew_quarters/safe_room/firstdeck
	name = "\improper First Deck Safe Room"

/area/crew_quarters/safe_room/medical
	name = "\improper Medical Safe Room"

/area/maintenance/substation/firstdeck // First Deck (Z-4)
	name = "First Deck Substation"

//Bridge (Z-5)
/area/maintenance/bridge
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/bridge/aftstarboard
	name = "Bridge Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/bridge/aftport
	name = "Bridge Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/bridge/forestarboard
	name = "Bridge Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/bridge/foreport
	name = "Bridge Fore Port Maintenance"
	icon_state = "fpmaint"

/area/hallway/primary/bridge/fore
	name = "\improper Bridge Fore Hallway"
	icon_state = "hallF"

/area/hallway/primary/bridge/aft
	name = "\improper Bridge Aft Hallway"
	icon_state = "hallA"

/area/maintenance/substation/bridge // First Deck (Z-4)
	name = "Bridge Substation"

/area/crew_quarters/safe_room/bridge
	name = "\improper Bridge Safe Room"

/area/bridge/storage
	name = "\improper Bridge Storage"
	req_access = list(access_bridge)

// Shuttles
/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "\improper Transport Shuttle Centcom"

//torch large pods
/area/shuttle/escape_pod6/station
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE
	name = "Escape Pod One"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT

/area/shuttle/escape_pod7/station
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE
	name = "Escape Pod Two"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT

/area/shuttle/escape_pod8/station
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE
	name = "Escape Pod Three"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT

/area/shuttle/escape_pod9/station
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE
	name = "Escape Pod Four"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT

/area/shuttle/escape_pod10/station
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE
	name = "Escape Pod Five"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT

/area/shuttle/escape_pod11/station
	name = "Escape Pod Six"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

//torch small pods
/area/shuttle/escape_pod12/station
	name = "Escape Pod Seven"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/shuttle/escape_pod13/station
	name = "Escape Pod Eight"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/shuttle/escape_pod15/station
	name = "Escape Pod Ten"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/shuttle/escape_pod16/station
	name = "Escape Pod Eleven"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/shuttle/escape_pod17/station
	name = "Escape Pod Twelve"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

//Charon

/area/exploration_shuttle
	name = "\improper Charon"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	base_turf_special_handling = TRUE

/area/exploration_shuttle/cockpit
	name = "\improper Charon - Cockpit"
	req_access = list(access_expedition_shuttle)

/area/exploration_shuttle/atmos
	name = "\improper Charon - Atmos Compartment"

/area/exploration_shuttle/power
	name = "\improper Charon - Power Compartment"

/area/exploration_shuttle/crew
	name = "\improper Charon - Crew Compartment"

/area/exploration_shuttle/cargo
	name = "\improper Charon - Cargo Bay"

/area/exploration_shuttle/airlock
	name = "\improper Charon - Airlock Compartment"

/area/exploration_shuttle/fuel
	name = "\improper Charon - Fuel Compartment"

/area/exploration_shuttle/medical
	name = "\improper Charon - Medical Compartment"

//Aquila

/area/aquila
	name = "\improper SEV Aquila"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/reinforced/airless
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	base_turf_special_handling = TRUE

/area/aquila/cockpit
	name = "\improper SEV Aquila - Cockpit"
	req_access = list(access_aquila)

/area/aquila/power
	name = "\improper SEV Aquila - Engineering Compartment"
	req_access = list(access_solgov_crew)

/area/aquila/storage
	name = "\improper SEV Aquila - Storage Bay"
	req_access = list(access_solgov_crew)

/area/aquila/suits
	name = "\improper SEV Aquila - Suit Storage Compartment"
	req_access = list(access_aquila)

/area/aquila/air
	name = "\improper SEV Aquila - Life Support Compartment"

/area/aquila/crew
	name = "\improper SEV Aquila - Crew Compartment"

/area/aquila/medical
	name = "\improper SEV Aquila - Medical Compartment"
	lighting_tone = AREA_LIGHTING_COOL

/area/aquila/airlock
	name = "\improper SEV Aquila - Airlock Compartment"
	req_access = list(access_solgov_crew)

//Guppy

/area/guppy_hangar/start
	name = "\improper Guppy"
	icon_state = "shuttlered"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	req_access = list(access_guppy)
	base_turf_special_handling = TRUE


//Petrov

/area/shuttle/petrov
	name = "\improper SRV Petrov"
	requires_power = 1
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_petrov)
	lighting_tone = AREA_LIGHTING_COOL

/area/shuttle/petrov/cell1
	name = "\improper SRV Petrov - Isolation Cell 1"
	icon_state = "shuttle"
/area/shuttle/petrov/cell2
	name = "\improper SRV Petrov - Isolation Cell 2"
	icon_state = "shuttlegrn"
/area/shuttle/petrov/cell3
	name = "\improper SRV Petrov - Isolation Cell 3"
	icon_state = "shuttle"

/area/shuttle/petrov/hallwaya
	name = "\improper SRV Petrov - Lower Hallway"
	icon_state = "hallA"

/area/shuttle/petrov/control
	name = "\improper SRV Petrov - Control Room"
	icon_state = "checkpoint1"
	req_access = list(access_petrov_control)

/area/shuttle/petrov/rd
	icon_state = "heads_rd"
	name = "\improper SRV Petrov - CSO's Office"
	icon_state = "head_quarters"
	req_access = list(access_petrov_rd)

/area/shuttle/petrov/cockpit
	name = "\improper SRV Petrov - Cockpit"
	icon_state = "shuttlered"
	req_access = list(access_petrov_helm)

/area/shuttle/petrov/maint
	name = "\improper SRV Petrov - Maintenance"
	icon_state = "engine"
	req_access = list(access_petrov_maint)
	lighting_tone = AREA_LIGHTING_DEFAULT

/area/shuttle/petrov/analysis
	name = "\improper SRV Petrov - Analysis Lab"
	icon_state = "devlab"
	req_access = list(access_petrov_analysis)

/area/shuttle/petrov/toxins
	name = "\improper SRV Petrov - Toxins Lab"
	icon_state = "toxstorage"
	req_access = list(access_petrov_toxins)

/area/shuttle/petrov/rnd
	name = "\improper SRV Petrov - Fabricator Lab"
	icon_state = "devlab"

/area/shuttle/petrov/isolation
	name = "\improper SRV Petrov - Isolation Lab"
	icon_state = "xeno_lab"

/area/shuttle/petrov/phoron
	name = "\improper SRV Petrov - Sublimation Lab"
	icon_state = "toxstorage"
	req_access = list(access_petrov_phoron)

/area/shuttle/petrov/custodial
	name = "\improper SRV Petrov - Custodial"
	icon_state = "decontamination"
	lighting_tone = AREA_LIGHTING_DEFAULT

/area/shuttle/petrov/equipment
	name = "\improper SRV Petrov - Equipment Storage"
	icon_state = "locker"

/area/shuttle/petrov/eva
	name = "\improper SRV Petrov - EVA Storage"
	icon_state = "locker"

//Turbolift
/area/turbolift
	name = "\improper Turbolift"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_maint_tunnels)

/area/turbolift/start
	name = "\improper Turbolift Start"

/area/turbolift/bridge
	name = "\improper bridge"
	base_turf = /turf/simulated/open

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

/area/turbolift/cargo_lift
	name = "\improper Cargo Lift"
	icon_state = "shuttle3"
	base_turf = /turf/simulated/open

/area/turbolift/robotics_lift
	name = "\improper Robotics Lift"
	icon_state = "shuttle3"
	base_turf = /turf/simulated/open

/area/turbolift/medical_lift
	name = "\improper Medical Lift"
	icon_state = "shuttle3"
	base_turf = /turf/simulated/open
	lighting_tone = AREA_LIGHTING_COOL

//Merchant

/area/shuttle/merchant/home
	name = "\improper Merchant Vessel"
	icon_state = "shuttlegrn"
	req_access = list(access_merchant)
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

// Elevator areas.
/area/turbolift/torch_top
	name = "lift (bridge)"
	lift_floor_label = "Bridge"
	lift_floor_name = "Bridge"
	lift_announce_str = "Arriving at Command Deck: Bridge. Meeting Room. Command Offices.  AI Core. Auxiliary Hangar. Auxiliary EVA."

/area/turbolift/torch_fourth
	name = "lift (first deck)"
	lift_floor_label = "Deck 1"
	lift_floor_name = "Operations Deck"
	lift_announce_str = "Arriving at Operations Deck: Infirmary. Security Wing. Research Wing. Auxiliary Cryogenic Storage. Emergency Armory."

/area/turbolift/torch_third
	name = "lift (second deck)"
	lift_floor_label = "Deck 2"
	lift_floor_name = "Maintenance Deck"
	lift_announce_str = "Arriving at Maintenance Deck: Engineering. Atmospherics. Storage."

/area/turbolift/torch_second
	name = "lift (third deck)"
	lift_floor_label = "Deck 3"
	lift_floor_name = "Habitation Deck"
	lift_announce_str = "Arriving at Habitation Deck: Telecommunications. Mess Hall. Officer's Mess. Lounge. Observation. Hydroponics. Cryogenic Storage. Holodeck. Gym."

/area/turbolift/torch_first
	name = "lift (fourth deck)"
	lift_floor_label = "Deck 4"
	lift_floor_name = "Supply Deck"
	lift_announce_str = "Arriving at Supply Deck: EVA. Docking Ports. Pathfinder's Office. Cargo Storage. Supply Office. Laundry. Sanitation."

/area/turbolift/torch_ground
	name = "lift (fifth deck)"
	lift_floor_label = "Deck 5"
	lift_floor_name = "Hangar Deck"
	lift_announce_str = "Arriving at Hangar Deck: Main Hangar. Supply Warehouse. Expedition Preparation. Mineral Processing."
	base_turf = /turf/simulated/floor

// Command
/area/command
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/command/conference
	name = "Briefing Room"
	icon_state = "briefing_room"
	sound_env = MEDIUM_SOFTFLOOR

/area/command/captainmess
	name = "Officer's Mess"
	icon_state = "bar"
	sound_env = MEDIUM_SOFTFLOOR
	lighting_tone = AREA_LIGHTING_WARM

/area/command/pathfinder
	name = "\improper Pathfinder's Office"
	icon_state = "pathfinder_office"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_pathfinder)
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION

/area/command/pilot
	name = "\improper Pilot's Lounge"
	icon_state = "pilot_lounge"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_pilot)
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION

/area/command/armoury
	name = "\improper Emergency Armory"
	icon_state = "Warden"
	req_access = list(list(access_bridge, access_emergency_armory))

/area/command/armoury/access
	name = "\improper Emergency Armory - Access"

/area/command/armoury/tactical
	name = "\improper Emergency Armory - Tactical"
	icon_state = "Tactical"
	req_access = list(access_emergency_armory)

/area/command/disperser
	name = "\improper Obstruction Field Disperser"
	icon_state = "disperser"
	req_access = list(access_bridge)

/area/crew_quarters/heads
	icon_state = "heads"
	req_access = list(access_heads)

/area/crew_quarters/heads/cobed
	icon_state = "heads_cap"
	name = "\improper Command - CO's Quarters"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_captain)
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/heads/office/co
	icon_state = "heads_cap"
	name = "\improper Command - CO's Office"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_captain)
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/heads/office/xo
	icon_state = "heads_hop"
	name = "\improper Command - XO's Office"
	req_access = list(access_hop)
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/heads/office/rd
	icon_state = "heads_rd"
	name = "\improper Command - CSO's Office"
	req_access = list(access_rd)
	lighting_tone = AREA_LIGHTING_COOL

/area/crew_quarters/heads/office/cmo
	icon_state = "heads_cmo"
	name = "\improper Command - CMO's Office"
	req_access = list(access_cmo)
	lighting_tone = AREA_LIGHTING_COOL

/area/crew_quarters/heads/office/ce
	icon_state = "heads_ce"
	name = "\improper Engineering - CE's Office"
	req_access = list(access_ce)

/area/crew_quarters/heads/office/cos
	icon_state = "heads_hos"
	name = "\improper Command - CoS' Office"
	req_access = list(access_hos)

/area/crew_quarters/heads/office/cl
	icon_state = "heads_cl"
	name = "\improper Command - CL's Office"
	req_access = list(access_liaison)
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/heads/office/cl/backroom
	icon_state = "heads_cl"
	name = "\improper Command - CL's Backroom"
	req_access = list(access_liaison)

/area/crew_quarters/heads/office/sgr
	icon_state = "heads_sr"
	name = "\improper Command - SCGR's Office"
	req_access = list(access_representative)
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/heads/office/sea
	icon_state = "heads_sea"
	name = "\improper Command - SEA's Office"
	req_access = list(access_senadv)

// Engineering
/area/engineering/shieldbay
	name = "Shield Bay"
	icon_state = "engineering"
	req_access = list(access_engine, access_engine_equip)

/area/engineering/bluespace
	name = "Bluespace Drive Containment"
	icon_state = "engineering"
	color = COLOR_BLUE_LIGHT
	req_access = list(list(access_engine_equip, access_heads), access_engine, access_maint_tunnels)

/area/engineering/atmos/aux
	name = "\improper Auxiliary Atmospherics"
	icon_state = "atmos"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_atmospherics)

/area/engineering/auxpower
	name = "\improper Auxiliary Power Storage"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip)

/area/engineering/hardstorage
	name = "\improper Engineering Hard Storage"
	icon_state = "engineering_storage"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip)

/area/engineering/hardstorage/aux
	name = "\improper Auxiliary Engineering Hard Storage"
	icon_state = "engineering_storage"

//Vacant Areas
/area/vacant
	name = "\improper Vacant Area"
	icon_state = "construction"

/area/vacant/armory
	name = "\improper Vacant Armory"
	icon_state = "Tactical"

/area/vacant/cabin
	name = "\improper Vacant Cabins"
	icon_state = "crew_quarters"

/area/vacant/mess
	name = "\improper Old Mess"
	icon_state = "bar"
	lighting_tone = AREA_LIGHTING_WARM

/area/vacant/chapel
	name = "\improper Unused Chapel"
	icon_state = "chapel"

/area/vacant/infirmary
	name = "\improper Auxiliary Infirmary"
	icon_state = "medbay"
	lighting_tone = AREA_LIGHTING_COOL

/area/vacant/monitoring
	name = "\improper Auxiliary Monitoring Room"
	icon_state = "engine_monitoring"

/area/vacant/prototype
	req_access = list(access_engine)

/area/vacant/prototype/control
	name = "\improper Prototype Fusion Reactor Control Room"
	icon_state = "engine_monitoring"

/area/vacant/prototype/engine
	name = "\improper Prototype Fusion Reactor Chamber"
	icon_state = "rust_reactor"

/area/vacant/cargo
	name = "\improper Requisitions Office"
	icon_state = "quart"
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/vacant/brig
	name = "\improper Permanent Brig"
	icon_state = "brig"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/vacant/bar
	name = "\improper Hidden Bar"
	icon_state = "bar"
	lighting_tone = AREA_LIGHTING_WARM

// Storage
/area/storage/auxillary
	req_access = list(access_cargo)

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
	req_access = list(access_cargo)
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/storage/medical
	name = "Medical Storage"
	icon_state = "medbay4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_medical)
	lighting_tone = AREA_LIGHTING_COOL
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/storage/research
	name = "Research Storage"
	icon_state = "toxstorage"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_research)
	lighting_tone = AREA_LIGHTING_COOL
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

// Supply

/area/quartermaster
	req_access = list(access_cargo)
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/quartermaster/office
	name = "\improper Supply Office"
	icon_state = "quartoffice"

/area/quartermaster/storage
	name = "\improper Supply Warehouse"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/quartermaster/sorting
	name ="\improper Supply Sorting"
	icon_state = "quartstorage"

/area/quartermaster/storage/upper
	name = "\improper Supply Upper Warehouse"

/area/quartermaster/deckchief
	name = "\improper Deck Chief's Office"
	icon_state = "quart"
	req_access = list(access_qm)

/area/quartermaster/expedition
	name = "\improper Expedition Preparation"
	icon_state = "mining"
	req_access = list(list(access_mining, access_nanotrasen, access_xenoarch))

/area/quartermaster/expedition/eva
	name = "\improper Expedition EVA"
	icon_state = "mining"
	req_access = list(list(access_mining, access_xenoarch))

/area/quartermaster/expedition/storage
	name = "\improper Hangar Expedition Storage"
	icon_state = "mining"
	req_access = list(list(access_mining, access_explorer, access_xenoarch))

/area/quartermaster/expedition/atmos
	name = "\improper Hangar Atmospheric Storage"
	icon_state = "mining"
	req_access = list(list(access_mining, access_explorer, access_xenoarch))

/area/quartermaster/exploration
	name = "\improper Exploration Equipment"
	icon_state = "exploration"
	req_access = list(list(access_explorer, access_pathfinder, access_pilot))
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION

/area/quartermaster/shuttlefuel
	name = "\improper Shuttle Fuel Bay"
	icon_state = "toxstorage"
	req_access = list(list(access_hangar, access_cargo))

/area/quartermaster/hangar
	name = "\improper Hangar Deck"
	icon_state = "hangar"
	sound_env = LARGE_ENCLOSED
	req_access = list(access_hangar)

/area/quartermaster/hangar/catwalks_port
	name = "\improper Hangar Port Upper Walkway"
	req_access = list()
	icon_state = "hangar_catwalk_p"

/area/quartermaster/hangar/catwalks_starboard
	name = "\improper Hangar Starboard Upper Walkway"
	req_access = list()
	icon_state = "hangar_catwalk_s"

// Research
/area/rnd/canister
	name = "\improper Canister Storage"
	icon_state = "toxstorage"
	req_access = list(access_tox_storage)

/area/rnd/development
	name = "\improper Fabricator Lab"
	icon_state = "devlab"

/area/rnd/office
	name = "\improper Research Paperwork Office"
	icon_state = "devlab"

/area/rnd/entry
	name = "\improper Research and Development Access"
	icon_state = "decontamination"
	req_access = list()

/area/rnd/locker
	name = "\improper Research Locker Room"
	icon_state = "locker"

/area/rnd/xenobiology/entry
	name = "\improper Xenobiology Access"
	icon_state = "xeno_lab"
	req_access = list() // This is a separate vestibule thing, needs low access.

// Crew areas
/area/crew_quarters
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR
	req_access = list(access_kitchen)
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/cryolocker
	name = "\improper Cryogenic Storage Wardrobe"
	icon_state = "locker"

/area/crew_quarters/head
	name = "\improper Third Deck Head"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/head/aux
	name = "\improper First Deck Head"

/area/crew_quarters/head/sauna
	name = "\improper Sauna"
	icon_state = "sauna"

/area/crew_quarters/gym
	name = "\improper Gym"
	icon_state = "fitness"

/area/crew_quarters/mess
	name = "\improper Mess Hall"
	icon_state = "cafeteria"
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/recreation
	name = "\improper Recreation"
	icon_state = "crew_quarters"
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/observation
	name = "\improper Observation"
	icon_state = "fitness"

/area/crew_quarters/galley
	name = "\improper Galley"
	icon_state = "kitchen"
	req_access = list(access_kitchen)
	lighting_tone = AREA_LIGHTING_COOL

/area/crew_quarters/galleybackroom
	name = "\improper Galley Cold Storage"
	icon_state = "kitchen"
	req_access = list(access_kitchen)
	lighting_tone = AREA_LIGHTING_COOL

/area/crew_quarters/commissary
	name = "\improper Commissary"
	icon_state = "crew_quarters"
	req_access = list(access_commissary)

/area/crew_quarters/lounge
	name = "\improper Lounge"
	icon_state = "crew_quarters"
	sound_env = MEDIUM_SOFTFLOOR
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/safe_room
	name = "\improper Safe Room"
	icon_state = "crew_quarters"
	sound_env = SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/crew_quarters/sleep/bunk
	name = "\improper Bunk Room"
	icon_state = "Sleep"
	sound_env = SMALL_SOFTFLOOR
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	lighting_tone = AREA_LIGHTING_WARM

/area/crew_quarters/sleep/cryo/aux
	name = "\improper First Deck Cryogenic Storage"
	icon_state = "Sleep"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/crew_quarters/adherent
	name = "\improper Adherent Maintenence"
	icon_state = "robotics"

/area/crew_quarters/office
	name = "\improper Computer Lab"
	icon_state = "conference"

/area/holocontrol
	name = "\improper Holodeck Control"
	icon_state = "Holodeck"

/area/hydroponics/storage
	name = "\improper Hydroponics Storage"

// Tcomms
/area/tcommsat/storage
	name = "\improper Telecoms Storage"
	icon_state = "tcomsatstore"

// Borg Upload ((now synth's storage -- evie))

/area/synth/borg_upload
	name = "\improper Synthetic Storage"
	icon_state = "ai_upload"
	ambience = list('sound/ambience/ambimalf.ogg')
	req_access = list(access_ai_upload)

// Security

/area/security/bo
	name = "\improper Security - Brig Chief"
	icon_state = "Warden"
	req_access = list(access_armory)

/area/security/storage
	name = "\improper Security - Equipment Storage"
	icon_state = "security"
	req_access = list(access_brig)

/area/security/armoury
	name = "\improper Security - Armory"
	icon_state = "Warden"
	req_access = list(access_armory)

/area/security/detectives_office
	name = "\improper Security - Investigations Office"
	icon_state = "detective"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_forensics_lockers)
	lighting_tone = AREA_LIGHTING_COOL

/area/security/locker
	name = "\improper Security - Locker Room"
	icon_state = "security"

/area/security/evidence
	name = "\improper Security - Evidence Storage"
	icon_state = "security"

/area/security/processing
	name = "\improper Security - Processing"
	icon_state = "security"

/area/security/questioning
	name = "\improper Security - Interview Room"
	icon_state = "security"

/area/security/wing
	name = "\improper Security Wing"
	icon_state = "security"

/area/security/bridgecheck
	name = "\improper Bridge Deck Security Checkpoint"
	icon_state = "checkpoint"

//area/security/opscheck
	//name = "\improper First Deck Security Checkpoint"
	//icon_state = "checkpoint"  unused

/area/security/habcheck
	name = "\improper Third Deck Security Checkpoint"
	icon_state = "checkpoint"

/area/security/hangcheck
	name = "\improper Fourth Deck Security Checkpoint"
	icon_state = "checkpoint"

// AI
/area/turret_protected/ai_foyer
	name = "\improper AI Chamber Foyer"
	icon_state = "ai_foyer"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_ai_upload)

/area/turret_protected/ai_outer_chamber
	name = "\improper Outer AI Chamber"
	icon_state = "ai_chamber"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_ai_upload)

// Medbay

/area/medical/equipstorage
	name = "\improper Medical Equipment Storage"
	icon_state = "medbay4"
	ambience = list('sound/ambience/signal.ogg')
	req_access = list(access_medical_equip)

/area/medical/medicalhallway
	name = "\improper Medical Public Hallway"
	icon_state = "medbay"

/area/medical/foyer
	name = "\improper Medical Foyer"
	icon_state = "medbay"
	req_access = list(list(access_medical,access_morgue,access_forensics_lockers))

/area/medical/foyer/storeroom
	name = "\improper Medical Storeroom"
	icon_state = "medbay"

/area/medical/locker
	name = "\improper Medical Locker Room"
	icon_state = "locker"
	req_access = list(access_medical_equip)

/area/medical/medpaperworkoffice
	name = "\improper Medical Paperwork Office"
	icon_state = "locker"
	req_access = list(access_medical)

/area/medical/washroom
	name = "\improper Medical Washroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED
	req_access = list()

/area/medical/counselor
	name = "\improper Counselor's Office"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')
	req_access = list(access_psychiatrist)
	sound_env = SMALL_SOFTFLOOR

/area/medical/counselor/therapy
	name = "\improper Counselor's Therapy Room"
	icon_state = "medbay3"
	lighting_tone = AREA_LIGHTING_WARM

/area/medical/sleeper
	name = "\improper Emergency Treatment Centre"
	icon_state = "exam_room"

/area/medical/surgery
	name = "\improper Operating Theatre 1"
	icon_state = "surgery"
	req_access = list(access_surgery)

/area/medical/surgery2
	name = "\improper Operating Theatre 2"
	icon_state = "surgery"
	req_access = list(access_surgery)

/area/medical/staging
	name = "\improper Infirmary Staging"
	icon_state = "patients"
	req_access = list(access_medical)

/area/medical/chemistry
	name = "\improper Chemistry"
	icon_state = "chem"
	req_access = list(access_chemistry)

/area/medical/exam_room
	name = "\improper Exam Room"
	icon_state = "exam_room"

/area/medical/morgue
	name = "\improper Morgue"
	icon_state = "morgue"
	ambience = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg','sound/music/main.ogg')
	req_access = list(list(access_morgue,access_forensics_lockers))

/area/medical/morgue/autopsy
	name = "\improper Autopsy"
	icon_state = "autopsy"

// Shield Rooms

/area/shield
	name = "\improper Shield Generator"
	icon_state = "engineering"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/shield/bridge
	name = "\improper Bridge Shield Generator"

// Misc
/area/teleporter
	name = "\improper Teleporter"
	icon_state = "teleporter"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_teleporter)
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/maintenance/auxsolarbridge
	name = "Solar Maintenance - Bridge"
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_AIRLOCK

/area/solar/bridge
	name = "\improper Bridge Solar Array"
	icon_state = "panelsS"

/area/eva
	name = "\improper EVA Storage"
	icon_state = "eva"
	req_access = list(access_eva)
	holomap_color = HOLOMAP_AREACOLOR_AIRLOCK

/area/aux_eva
	name = "\improper Command EVA Storage"
	icon_state = "eva"
	req_access = list(access_eva)
	holomap_color = HOLOMAP_AREACOLOR_AIRLOCK

/area/thruster
	icon_state = "thruster"
	req_access = list(access_engine)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/thruster/d1port
	name = "\improper First Deck Port Nacelle"

/area/thruster/d1starboard
	name = "\improper First Deck Starboard Nacelle"

/area/thruster/d3port
	name = "\improper Third Deck Port Nacelle"

/area/thruster/d3starboard
	name = "\improper Third Deck Starboard Nacelle"

/area/engineering/fuelbay
	name = "\improper Fuel Bay"
	icon_state = "engineering"
	req_access = list(access_construction)

/area/engineering/fuelbay/aux
	name = "\improper Auxiliary Fuel Bay"
	icon_state = "engineering"
	req_access = list(access_construction)

/area/engineering/wastetank
	name = "\improper Waste Tank"
	icon_state = "engineering"
	req_access = list(access_atmospherics)

// Command

/area/bridge
	name = "\improper SEV Torch Bridge"
	icon_state = "bridge"
	req_access = list(access_bridge)
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/bridge/hallway
	name = "\improper Bridge Access Hallway"
	icon_state = "bridge_hallway"
	req_access = list(access_solgov_crew)

/area/bridge/hallway/port
	name = "\improper Bridge Port Access Hallway"

/area/bridge/hallway/starboard
	name = "\improper Bridge Starboard Access Hallway"

/area/bridge/meeting_room
	name = "\improper Command Meeting Room"
	icon_state = "bridge_meeting"
	ambience = list()
	sound_env = MEDIUM_SOFTFLOOR

/area/bridge/disciplinary_board_room
	name = "\improper Disciplinary Board Room"
	sound_env = SMALL_ENCLOSED

/area/bridge/disciplinary_board_room/deliberation
	name = "\improper Deliberation Room"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/heads
	icon_state = "head_quarters"
	req_access = list(access_heads)

/area/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/torchexterior
	name = "\improper Exterior Reinforcements"
	icon_state = "maint_exterior"
	area_flags = AREA_FLAG_EXTERNAL
	has_gravity = FALSE
	turf_initializer = /decl/turf_initializer/maintenance/space
	req_access = list(access_external_airlocks, access_maint_tunnels)

// CentCom

/area/centcom/control
	name = "\improper Centcom Control"

/area/centcom/creed
	name = "Creed's Office"

/area/centcom/evac
	name = "\improper Centcom Emergency Shuttle"

/area/centcom/ferry
	name = "\improper Centcom Transport Shuttle"

/area/centcom/living
	name = "\improper Centcom Living Quarters"

/area/centcom/suppy
	name = "\improper Centcom Supply Shuttle"

/area/centcom/test
	name = "\improper Centcom Testing Facility"

// Solars
/area/maintenance/auxsolarport
	name = "Solar Maintenance - Port"
	icon_state = "SolarcontrolP"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip, access_maint_tunnels)
	holomap_color = HOLOMAP_AREACOLOR_AIRLOCK

/area/maintenance/auxsolarstarboard
	name = "Solar Maintenance - Starboard"
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip, access_maint_tunnels)
	holomap_color = HOLOMAP_AREACOLOR_AIRLOCK

/area/solar
	area_flags = AREA_FLAG_EXTERNAL
	requires_power = 1
	always_unpowered = 1
	has_gravity = FALSE
	base_turf = /turf/space
	req_access = list(access_engine_equip)

/area/solar/auxstarboard
	name = "\improper Fore Starboard Solar Array"
	icon_state = "panelsA"

/area/solar/port
	name = "\improper Port Auxiliary Solar Array"
	icon_state = "panelsP"

// Maintenance

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/incinerator
	name = "\improper Incinerator"
	icon_state = "disposal"
	req_access = list(list(access_engine, access_medical, access_cargo))

/area/maintenance/waterstore
	name = "\improper Cistern"
	icon_state = "disposal"

// Storage

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "storage"
	req_access = list(access_tech_storage)

/area/storage/tools
	name = "Auxiliary Tool Storage"
	icon_state = "auxstorage"

// Holodecks

/area/holodeck
	name = "\improper Holodeck"
	icon_state = "Holodeck"
	dynamic_lighting = 0
	sound_env = LARGE_ENCLOSED
	area_flags = AREA_FLAG_NO_MODIFY

/area/holodeck/alphadeck
	name = "\improper Holodeck Alpha"

/area/holodeck/source_plating
	name = "\improper Holodeck - Off"

/area/holodeck/source_emptycourt
	name = "\improper Holodeck - Empty Court"
	sound_env = ARENA

/area/holodeck/source_boxingcourt
	name = "\improper Holodeck - Boxing Court"
	sound_env = ARENA

/area/holodeck/source_basketball
	name = "\improper Holodeck - Basketball Court"
	sound_env = ARENA

/area/holodeck/source_thunderdomecourt
	name = "\improper Holodeck - Thunderdome Court"
	sound_env = ARENA

/area/holodeck/source_courtroom
	name = "\improper Holodeck - Courtroom"
	sound_env = AUDITORIUM

/area/holodeck/source_beach
	name = "\improper Holodeck - Beach"
	sound_env = PLAIN

/area/holodeck/source_wildlife
	name = "\improper Holodeck - Wildlife Simulation"

/area/holodeck/source_meetinghall
	name = "\improper Holodeck - Meeting Hall"
	sound_env = AUDITORIUM

/area/holodeck/source_theatre
	name = "\improper Holodeck - Theatre"
	sound_env = CONCERT_HALL

/area/holodeck/source_picnicarea
	name = "\improper Holodeck - Picnic Area"
	sound_env = PLAIN

/area/holodeck/source_snowfield
	name = "\improper Holodeck - Snow Field"
	sound_env = FOREST

/area/holodeck/source_desert
	name = "\improper Holodeck - Desert"
	sound_env = PLAIN

/area/holodeck/source_space
	name = "\improper Holodeck - Space"
	has_gravity = 0
	sound_env = SPACE

/area/holodeck/source_cafe
	name = "\improper Holodeck - Cafe"
	sound_env = PLAIN

/area/holodeck/source_volleyball
	name = "\improper Holodeck - Volleyball"
	sound_env = PLAIN

/area/holodeck/source_temple
	name = "\improper Holodeck - Temple"
	sound_env = SMALL_ENCLOSED

/area/holodeck/source_plaza
	name = "\improper Holodeck - Plaza"
	sound_env = SMALL_ENCLOSED

// Engineering

/area/engineering/atmos/storage
	name = "\improper Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_atmospherics)

/area/engineering/engine_room
	name = "\improper Engine Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	req_access = list(access_engine, access_engine_equip)

/area/engineering/drone_fabrication
	name = "\improper Engineering Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_robotics)

/area/engineering/engine_monitoring
	name = "\improper Engine Monitoring Room"
	icon_state = "engine_monitoring"
	req_access = list(access_engine, access_engine_equip)

/area/engineering/engine_smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine, access_engine_equip)

/area/engineering/foyer
	name = "\improper Engineering Foyer"
	icon_state = "engineering_foyer"
	req_access = list()

/area/engineering/engineering_bay
	name = "\improper Engineering Bay"
	icon_state = "engineering_locker"
	req_access = list(access_engine)

/area/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "engineering_storage"
	req_access = list()

/area/engineering/atmos
	name = "\improper Atmospherics"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED
	req_access = list(access_atmospherics)

// Research
/area/assembly
	req_access = list(access_robotics)

/area/assembly/chargebay
	name = "\improper Mech Bay"
	icon_state = "mechbay"

/area/assembly/robotics
	name = "\improper Robotics Workshop"
	icon_state = "robotics"

/area/assembly/robotics/laboratory
	name = "\improper Robotics Laboratory"
	req_access = list(list(access_medical,access_robotics))

/area/assembly/robotics/office
	name = "\improper Robotics Office"

/area/assembly/robotics/surgery
	name = "\improper Robotics Operating Theatre"
	lighting_tone = AREA_LIGHTING_COOL

/area/rnd/misc_lab
	name = "\improper Miscellaneous Research"
	icon_state = "misclab"

/area/rnd/rnd_sec
	name = "\improper Research Checkpoint"
	icon_state = "rnd_sec"
	req_access = list(list(access_liaison, access_research_security))

/area/rnd/research
	name = "\improper Research Hallway"
	icon_state = "research"

// Shuttles
/area/shuttle/administration/centcom
	name = "\improper Administration Shuttle"
	icon_state = "shuttlered"
	req_access = list(access_cent_general)
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/shuttle/escape_pod1/centcom
	icon_state = "shuttle"
	req_access = list(access_cent_general)

/area/shuttle/escape_pod2/centcom
	icon_state = "shuttle"
	req_access = list(access_cent_general)

/area/shuttle/escape_pod3/centcom
	icon_state = "shuttle"
	req_access = list(access_cent_general)

/area/shuttle/escape_pod5/centcom
	icon_state = "shuttle"
	req_access = list(access_cent_general)

/area/supply/dock
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0
	req_access = list(access_cent_storage)

// Secure

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"
	req_access = list(access_brig)

/area/security/nuke_storage
	name = "\improper Vault"
	icon_state = "nuke_storage"
	area_flags = AREA_FLAG_IS_NOT_PERSISTENT
	req_access = list(access_heads_vault)

// Crew

/area/crew_quarters/sleep/cryo
	name = "\improper Third Deck Cryogenic Storage"
	icon_state = "Sleep"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/hydroponics
	name = "\improper Hydroponics"
	icon_state = "hydro"
	lighting_tone = AREA_LIGHTING_COOL

/area/janitor
	name = "\improper Custodial Closet"
	icon_state = "janitor"
	req_access = list(access_janitor)

/area/janitor/storage
	name = "\improper Custodial Storage Closet"

// Tcomm
/area/tcommsat
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')
	req_access = list(access_tcomsat)

/area/tcommsat/chamber
	name = "\improper Telecoms Central Compartment"
	icon_state = "tcomsatcham"

/area/tcommsat/computer
	name = "\improper Telecoms Control Room"
	icon_state = "tcomsatcomp"

// AI

///area/ai_monitored
	//name = "AI Monitored Area" unused proxima

//area/ai_monitored/storage/eva
	//name = "\improper EVA Storage"
//	icon_state = "eva"
//	req_access = list(access_eva) unused proxima

/area/turret_protected/ai
	name = "\improper AI Chamber"
	icon_state = "ai_chamber"
	ambience = list('sound/ambience/ambimalf.ogg')
	req_access = list(access_ai_upload)

/area/turret_protected/ai_upload
	name = "\improper AI Upload Chamber"
	icon_state = "ai_upload"
	ambience = list('sound/ambience/ambimalf.ogg')
	req_access = list(access_ai_upload)

/area/turret_protected/ai_upload_foyer
	name = "\improper  AI Upload Access"
	icon_state = "ai_foyer"
	ambience = list('sound/ambience/ambimalf.ogg')
	sound_env = SMALL_ENCLOSED
	req_access = list(access_ai_upload)

// Chapel

/area/chapel/main
	name = "\improper Chapel"
	icon_state = "chapel"
	ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg','sound/music/traitor.ogg')
	sound_env = LARGE_ENCLOSED

/area/chapel/office
	name = "\improper Chaplain's Office"
	req_access = list(access_chapel_office)
	color = COLOR_GRAY80
	sound_env = SMALL_SOFTFLOOR

/area/chapel/memorial
	name = "\improper Memorial Room"
	color = COLOR_GRAY80
	sound_env = SMALL_SOFTFLOOR

// Merchant

/area/merchant_station
	name = "\improper Merchant Station"
	icon_state = "LP"
	req_access = list(access_merchant)

// ACTORS GUILD
/area/acting
	name = "\improper Centcom Acting Guild"
	icon_state = "red"
	dynamic_lighting = 0
	requires_power = 0

/area/acting/backstage
	name = "\improper Backstage"

/area/acting/stage
	name = "\improper Stage"
	dynamic_lighting = 1
	icon_state = "yellow"

// Thunderdome

/area/tdome
	name = "\improper Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	dynamic_lighting = 0
	sound_env = ARENA
	req_access = list(access_cent_thunder)

/area/tdome/tdome1
	name = "\improper Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "\improper Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "\improper Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "\improper Thunderdome (Observer.)"
	icon_state = "purple"
