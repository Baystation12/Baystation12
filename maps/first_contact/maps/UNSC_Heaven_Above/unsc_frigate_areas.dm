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
	name = "UNSC Heavens Above Bridge"
	icon_state = "bridge"

/area/unscfrigate/mac
	name = "UNSC Heavens Above MAC Cannon Maintenance"

/area/unscfrigate/mac/cannon
	name = "UNSC Heavens Above MAC Cannon"

//Engineering

/area/unscfrigate/aft_port_engineering
	name = "UNSC Heavens Above Aft Port Engineering"
	icon_state = "engineering_workshop"

/area/unscfrigate/aft_starb_engineering
	name = "UNSC Heavens Above Aft Starboard Engineering"
	icon_state = "engineering_storage"

/area/unscfrigate/mid_port_engineering
	name = "UNSC Heavens Above Mid Port Engineering"
	icon_state = "substation"

/area/unscfrigate/mid_starb_engineering
	name = "UNSC Heavens Above Mid Starboard Engineering"
	icon_state = "substation"

/area/unscfrigate/aft_engineering
	name = "UNSC Heavens Above Aft Engineering"
	icon_state = "engine_monitoring"

/area/unscfrigate/central_cooling
	name = "UNSC Heavens Above Central Cooling"
	icon_state = "engine_waste"

/area/unscfrigate/reactor1
	name = "UNSC Heavens Above Reactor One"
	icon_state = "engine"

/area/unscfrigate/reactor2
	name = "UNSC Heavens Above Reactor Two"
	icon_state = "engine"

/area/unscfrigate/reactor3
	name = "UNSC Heavens Above Reactor Three"
	icon_state = "engine"

/area/unscfrigate/reactor4
	name = "UNSC Heavens Above Reactor Four"
	icon_state = "engine"

/area/unscfrigate/engine_power_storage
	name = "UNSC Heavens Above Engine Power Storage"

//Misc

/area/unscfrigate/tcomms
	name = "UNSC Heavens Above Telecomms"
	icon_state = "tcomsatcham"

/area/unscfrigate/central
	name = "UNSC Heavens Above Central"
	icon_state = "hallC1"

/area/unscfrigate/crewmess
	name = "UNSC Heavens Above Crew Mess"
	icon_state = "kitchen"

/area/unscfrigate/battlebridge
	name = "UNSC Heavens Above Battle Bridge"
	icon_state = "bridge"

/area/unscfrigate/brig
	name = "UNSC Heavens Above Naval Security Compound"
	icon_state = "security"

/area/unscfrigate/port_dorms
	name = "UNSC Heavens Above Port Crew Dormitories"
	icon_state = "crew_quarters"

/area/unscfrigate/starb_dorms
	name = "UNSC Heavens Above Starboard Crew Dormitories"
	icon_state = "crew_quarters"


// Hangar, mechanics, flight crew

/area/unscfrigate/flight/vehicle_shop
	name = "UNSC Heavens Above Vehicle Shop"
	icon_state = "vehicleshop"

/area/unscfrigate/flight/office
	name = "UNSC Heavens Above Flight Crew Office"
	icon_state = "flightoffice"

//Strike craft hangars

/area/unscfrigate/hangar_port
	name = "UNSC Heavens Above Port Hangar"
	icon_state = "porthang"

/area/unscfrigate/hangar_port/berth1
	name = "UNSC Heavens Above Berth1"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth2
	name = "UNSC Heavens Above Berth2"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth3
	name = "UNSC Heavens Above Berth3"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth4
	name = "UNSC Heavens Above Berth4"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth5
	name = "UNSC Heavens Above Berth5"
	icon_state = "hangar"

/area/unscfrigate/hangar_port/berth6
	name = "UNSC Heavens Above Berth6"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb
	name = "UNSC Heavens Above Starboard Hangar"
	icon_state = "starhang"

/area/unscfrigate/hangar_starb/berth1
	name = "UNSC Heavens Above Berth1"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth2
	name = "UNSC Heavens Above Berth2"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth3
	name = "UNSC Heavens Above Berth3"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth4
	name = "UNSC Heavens Above Berth4"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth5
	name = "UNSC Heavens Above Berth5"
	icon_state = "hangar"

/area/unscfrigate/hangar_starb/berth6
	name = "UNSC Heavens Above Berth6"
	icon_state = "hangar"


//Miscellaneous

/area/unscfrigate/ai_core
	name = "UNSC Heavens Above AI Core"
	icon_state = "ai"

/area/unscfrigate/vault
	name = "UNSC Heavens Above Vault"
	icon_state = "Vault"

/area/unscfrigate/officer_quarters
	name = "UNSC Heavens Above Officer's Quarters"
	icon_state = "head_quarters"

/area/unscfrigate/armoury
	name = "UNSC Heavens Above Marine Armoury"
	icon_state = "Warden"



// Hangar, cargo and mechanics

/area/unscfrigate/logistics/hangar_aftport
	name = "UNSC Heavens Above Shuttle Hangar Aft Port"
	icon_state = "shuttlegrn"

/area/unscfrigate/logistics/hangar_foreport
	name = "UNSC Heavens Above Shuttle Hangar Fore Port"
	icon_state = "shuttlegrn"

/area/unscfrigate/logistics/hangar_aftstarb
	name = "UNSC Heavens Above Shuttle Hangar Aft Starboard"
	icon_state = "shuttle"

/area/unscfrigate/logistics/hangar_forestarb
	name = "UNSC Heavens Above Shuttle Hangar Fore Starboard"
	icon_state = "shuttle"

/area/unscfrigate/logistics/transit
	name = "UNSC Heavens Above Transit"
	icon_state = "hallC2"

/area/unscfrigate/logistics/recieving_port
	name = "UNSC Heavens Above Port Recieving"
	icon_state = "yellow"

/area/unscfrigate/logistics/recieving_starb
	name = "UNSC Heavens Above Starboard Recieving"
	icon_state = "yellow"

/area/unscfrigate/logistics/hub
	name = "UNSC Heavens Above Hub"
	icon_state = "entry_1"

/area/unscfrigate/logistics/office
	name = "UNSC Heavens Above Hub"
	icon_state = "quartoffice"

/area/unscfrigate/logistics/store
	name = "UNSC Heavens Above Logistics Storage"
	icon_state = "quartstorage"

//Medbay

/area/unscfrigate/medbay
	name = "UNSC Heavens Above Medbay"
	icon_state = "medbay"

/area/unscfrigate/medbay/recovery
	name = "UNSC Heavens Above Surgery Recovery"
	icon_state = "medbay3"

/area/unscfrigate/medbay/surgeryprep
	name = "UNSC Heavens Above Surgery preparation"
	icon_state = "medbay2"

/area/unscfrigate/medbay/surgery1
	name = "UNSC Heavens Above Surgery One"
	icon_state = "surgery"

/area/unscfrigate/medbay/surgery2
	name = "UNSC Heavens Above Surgery Two"
	icon_state = "surgery"

/area/unscfrigate/medbay/exam
	name = "UNSC Heavens Above Examination"
	icon_state = "exam_room"

/area/unscfrigate/medbay/patient1
	name = "UNSC Heavens Above Patient Room One"
	icon_state = "Sleep"

/area/unscfrigate/medbay/patient2
	name = "UNSC Heavens Above Patient Room Two"
	icon_state = "Sleep"

/area/unscfrigate/medbay/pharmacy
	name = "UNSC Heavens Above Pharmacy"
	icon_state = "chem"

/area/unscfrigate/medbay/storage
	name = "UNSC Heavens Above Storage"
	icon_state = "medbay4"

//Marines

/area/unscfrigate/marine_dorms
	name = "UNSC Heavens Above Marine Dormitories"
	icon_state = "marinebunks"

/area/unscfrigate/garage_4
	name = "UNSC Heavens Above Primary Vehicle Garage"
	icon_state = "garage"

/area/unscfrigate/odstcountry
	name = "UNSC Heavens Above ODST Country"
	icon_state = "odst"

/area/unscfrigate/portguns
	name = "UNSC Heavens Above Port weapon emplacement"

/area/unscfrigate/starboardguns
	name = "UNSC Heavens Above Starboard weapon emplacement"


//Overmap Weapon Console Defines//

/obj/machinery/overmap_weapon_console/deck_gun_control/local/frigate
	deck_gun_area = /area/unscfrigate/portguns

/obj/machinery/overmap_weapon_console/deck_gun_control/local/missile_control/frigate
	deck_gun_area = /area/unscfrigate/starboardguns