/datum/map/unsc_frigate
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/unscfrigate = NO_SCRUBBER|NO_VENT,
		/area/unscfrigate/logistics = NO_SCRUBBER|NO_VENT,
		/area/unscfrigate/medbay = NO_SCRUBBER|NO_VENT,
		/area/unscfrigate/medbay/surgery1 = 0,
		/area/unscfrigate/medbay/surgery2 = 0,
		/area/unscfrigate/medbay/patient2 = 0,
		/area/unscfrigate/medbay/recovery = NO_VENT,
		/area/unscfrigate/medbay/exam = 0,
		/area/unscfrigate/medbay/patient1 = 0,
		/area/unscfrigate/logistics/hangar_aftstarb = NO_SCRUBBER,
		/area/unscfrigate/logistics/hangar_forestarb = NO_SCRUBBER,
		/area/unscfrigate/medbay/surgeryprep = NO_SCRUBBER,
		/area/unscfrigate/logistics/hangar_aftport = NO_SCRUBBER,
		/area/unscfrigate/logistics/hangar_foreport = NO_SCRUBBER,
		/area/unscfrigate/hangar_starb = NO_SCRUBBER,
		/area/unscfrigate/central = NO_SCRUBBER|NO_VENT,
		/area/unscfrigate/hangar_port = NO_SCRUBBER,
		/area/unscfrigate/tcomms = NO_SCRUBBER,
		/area/unscfrigate/bridge = NO_SCRUBBER,
		/area/unscfrigate/mac/cannon = NO_SCRUBBER|NO_VENT,
		/area/turbolift = NO_SCRUBBER|NO_VENT|NO_APC
	)
//Top Deck

/area/unscfrigate/bridge
	name = "Bridge"
	icon_state = "bridge"

/area/unscfrigate/mac
	name = "MAC Cannon Maintenance"

/area/unscfrigate/mac/cannon
	name = "MAC Cannon"

//Engineering

/area/unscfrigate/aft_port_engineering
	name = "Aft Port Engineering"
	icon_state = "engineering_workshop"

/area/unscfrigate/aft_starb_engineering
	name = "Aft Starboard Engineering"
	icon_state = "engineering_storage"

/area/unscfrigate/mid_port_engineering
	name = "Mid Port Engineering"
	icon_state = "substation"

/area/unscfrigate/mid_starb_engineering
	name = "Mid Starboard Engineering"
	icon_state = "substation"

/area/unscfrigate/aft_engineering
	name = "Aft Engineering"
	icon_state = "engine_monitoring"

/area/unscfrigate/central_cooling
	name = "Central Cooling"
	icon_state = "engine_waste"

/area/unscfrigate/reactor1
	name = "Reactor One"
	icon_state = "engine"

/area/unscfrigate/reactor2
	name = "Reactor Two"
	icon_state = "engine"

/area/unscfrigate/reactor3
	name = "Reactor Three"
	icon_state = "engine"

/area/unscfrigate/reactor4
	name = "Reactor Four"
	icon_state = "engine"

/area/unscfrigate/engine_power_storage
	name = "Engine Power Storage"

//Misc

/area/unscfrigate/tcomms
	name = "Telecomms"
	icon_state = "tcomsatcham"

/area/unscfrigate/central
	name = "Central"
	icon_state = "hallC1"

/area/unscfrigate/crewmess
	name = "Crew Mess"
	icon_state = "kitchen"

/area/unscfrigate/battlebridge
	name = "Battle Bridge"
	icon_state = "bridge"

/area/unscfrigate/brig
	name = "Naval Security Compound"
	icon_state = "security"

/area/unscfrigate/port_dorms
	name = "Port Crew Dormitories"
	icon_state = "crew_quarters"

/area/unscfrigate/starb_dorms
	name = "Starboard Crew Dormitories"
	icon_state = "crew_quarters"


// Hangar, mechanics, flight crew

/area/unscfrigate/flight/vehicle_shop
	name = "Vehicle Shop"
	icon_state = "vehicleshop"

/area/unscfrigate/flight/office
	name = "Flight Crew Office"
	icon_state = "flightoffice"

//Strike craft hangars

/area/unscfrigate/hangar_port
	name = "Port Hangar"
	icon_state = "aux_hangar"

/area/unscfrigate/hangar_port/berth1
	name = "Berth1"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth2
	name = "Berth2"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth3
	name = "Berth3"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth4
	name = "Berth4"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth5
	name = "Berth5"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth6
	name = "Berth6"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb
	name = "Starboard Hangar"
	icon_state = "aux_hangar"

/area/unscfrigate/hangar_starb/berth1
	name = "Berth1"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth2
	name = "Berth2"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth3
	name = "Berth3"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth4
	name = "Berth4"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth5
	name = "Berth5"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth6
	name = "Berth6"
	icon_state = "hangar"


//Miscellaneous

/area/unscfrigate/ai_core
	name = "AI Core"
	icon_state = "ai"

/area/unscfrigate/officer_quarters
	name = "Officer's Quarters"
	icon_state = "head_quarters"

/area/unscfrigate/armoury
	name = "Marine Armoury"
	icon_state = "Warden"



// Hangar, cargo and mechanics

/area/unscfrigate/logistics/hangar_aftport
	name = "huttle Hangar Aft Port"
	icon_state = "shuttlegrn"

/area/unscfrigate/logistics/hangar_foreport
	name = "huttle Hangar Fore Port"
	icon_state = "shuttlegrn"

/area/unscfrigate/logistics/hangar_aftstarb
	name = "Shuttle Hangar Aft Starboard"
	icon_state = "shuttle"

/area/unscfrigate/logistics/hangar_forestarb
	name = "Shuttle Hangar Fore Starboard"
	icon_state = "shuttle"

/area/unscfrigate/logistics/transit
	name = "Transit"
	icon_state = "hallC2"

/area/unscfrigate/logistics/recieving_port
	name = "Port Recieving"
	icon_state = "yellow"

/area/unscfrigate/logistics/recieving_starb
	name = "Starboard Recieving"
	icon_state = "yellow"

/area/unscfrigate/logistics/hub
	name = "Hub"
	icon_state = "entry_1"

/area/unscfrigate/logistics/office
	name = "Hub"
	icon_state = "quartoffice"

/area/unscfrigate/logistics/store
	name = "Logistics Storage"
	icon_state = "quartstorage"

//Medbay

/area/unscfrigate/medbay
	name = "Medbay"
	icon_state = "medbay"

/area/unscfrigate/medbay/recovery
	name = "Surgery Recovery"
	icon_state = "medbay3"

/area/unscfrigate/medbay/surgeryprep
	name = "Surgery preparation"
	icon_state = "medbay2"

/area/unscfrigate/medbay/surgery1
	name = "Surgery One"
	icon_state = "surgery"

/area/unscfrigate/medbay/surgery2
	name = "Surgery Two"
	icon_state = "surgery"

/area/unscfrigate/medbay/exam
	name = "Examination"
	icon_state = "exam_room"

/area/unscfrigate/medbay/patient1
	name = "Patient Room One"
	icon_state = "Sleep"

/area/unscfrigate/medbay/patient2
	name = "Patient Room Two"
	icon_state = "Sleep"

/area/unscfrigate/medbay/pharmacy
	name = "Pharmacy"
	icon_state = "chem"

/area/unscfrigate/medbay/storage
	name = "Storage"
	icon_state = "medbay4"

//Marines

/area/unscfrigate/marine_dorms
	name = "Marine Dormitories"
	icon_state = "marine"

/area/unscfrigate/garage_4
	name = "Primary Vehicle Garage"
	icon_state = "garage"

/area/unscfrigate/odstcountry
	name = "ODST Country"
	icon_state = "marine"

/area/unscfrigate/portguns
	name = "Port weapon emplacement"

/area/unscfrigate/starboardguns
	name = "Starboard weapon emplacement"


//Overmap Weapon Console Defines//

/obj/machinery/overmap_weapon_console/deck_gun_control/local/frigate
	deck_gun_area = /area/unscfrigate/portguns

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/frigate
	deck_gun_area = /area/unscfrigate/starboardguns