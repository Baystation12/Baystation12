/area/hallway/primary/seconddeck/fore
	name = "Second Deck - Hallway - Fore "
	icon_state = "hallF"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/seconddeck/center
	name = "Second Deck - Hallway - Central"
	icon_state = "hallC3"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/seconddeck/aft
	name = "Second Deck - Hallway - Aft"
	icon_state = "hallA"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/seconddeck/central_stairwell
	name = "Second Deck - Stairwell - Central "
	icon_state = "hallC2"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/seconddeck/aft_stairwell
	name = "Second Deck - Stairwell - Fore "
	icon_state = "hallA"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/maintenance/seconddeck
	name = "Second Deck - Maintenance"
	icon_state = "maintcentral"

/area/maintenance/seconddeck/xenobio
	name = "Second Deck - Maintenance - Xenobio"
	icon_state = "maintcentral"

/area/maintenance/seconddeck/emergency
	name = "Second Deck - Emergency Storage"
	icon_state = "emergencystorage"

/area/maintenance/seconddeck/foreport
	name = "Second Deck - Maintenance - Fore-Port "
	icon_state = "fpmaint"

/area/maintenance/seconddeck/forestarboard
	name = "Second Deck - Maintenance - Fore-Starboard "
	icon_state = "fsmaint"

/area/maintenance/seconddeck/starboard
	name = "Second Deck - Maintenance - Starboard "
	icon_state = "smaint"

/area/maintenance/seconddeck/port
	name = "Second Deck - Maintenance - Port"
	icon_state = "pmaint"

/area/maintenance/seconddeck/aftstarboard
	name = "Second Deck - Maintenance - Aft-Starboard "
	icon_state = "asmaint"

/area/maintenance/seconddeck/aftport
	name = "Second Deck - Maintenance - Aft-Port"
	icon_state = "apmaint"

/area/crew_quarters/safe_room/seconddeck
	name = "Second Deck - Safe Room"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/maintenance/substation/seconddeck
	name = "Second Deck - Substation"

/area/crew_quarters/laundry
	name = "Second Deck - Laundry Room"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/maintenance/abandoned_hydroponics
	name = "Second Deck - Abandoned - Hydroponics"
	icon_state = "hydro"
	turf_initializer = /singleton/turf_initializer/maintenance/heavy

/* RND AREAS
 * =========
 */

/area/rnd/xenobiology/entry
	name = "Xenobiology Access"
	icon_state = "xeno_lab"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/xenobiology/storage2
	name = "Xenobiology Access"
	icon_state = "xeno_lab"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/xenobiology/level1
	name = "Xenobiology Level One"
	icon_state = "xeno_lab"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/xenobiology/atmos
	name = "Xenobiology - Atmos Hub"
	icon_state = "xeno_lab"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/xenobiology/water_cell
	name = "Xenobiology - Water Cell"
	icon_state = "xeno_lab"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/assembly/chargebay
	name = "Second Deck - RND - Mech Bay"
	icon_state = "mechbay"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/assembly/robotics
	name = "Second Deck - RND - Robotics Lab"
	icon_state = "robotics"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/toxins
	name = "Second Deck - RND - Toxins Lab"
	icon_state = "toxstorage"
	req_access = list(access_tox_storage)
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/toxins/storage
	name = "Second Deck - RND - Canister Storage"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/* VACANT AREAS
 * ============
 */
/area/vacant/gambling
	name = "Second Deck - Gambling Room"
	icon_state = "restrooms"
	sound_env = MEDIUM_SOFTFLOOR

/area/vacant/dungeon
	name = "Second Deck - Dungeon"
	icon_state = "restrooms"
	sound_env = MEDIUM_SOFTFLOOR

/area/vacant/sauna
	name = "Second Deck - Unused Sauna"
	icon_state = "restrooms"
	sound_env = MEDIUM_SOFTFLOOR

/area/maintenance/seconddeck/hangar
	name = "Second Deck - Auxiliary Hangar"
	icon_state = "hangar"

// Holodecks
/area/holodeck
	name = "Second Deck - Holodeck"
	icon_state = "Holodeck"
	dynamic_lighting = 0
	sound_env = LARGE_ENCLOSED

/area/holocontrol
	name = "Second Deck - Holodeck Control"
	icon_state = "Holodeck"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/* CREW AREAS
 * ==========
 */

/area/janitor
	name = "Second Deck - Service - Custodial Closet"
	icon_state = "janitor"
	req_access = list(access_janitor)
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/hydroponics
	name = "Second Deck - Service - Hydroponics"
	icon_state = "hydro"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/galley
	name = "Second Deck - Service - Galley"
	icon_state = "kitchen"
	req_access = list(list(access_kitchen, access_bar))
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/galley/backroom
	name = "Second Deck - Service - Galley Backroom"
	icon_state = "kitchen"
	req_access = list(list(access_kitchen, access_bar))
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/galley/freezer
	name = "Second Deck - Service - Galley Cold Storage"
	icon_state = "kitchen"
	req_access = list(list(access_kitchen, access_bar))
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/cafe/upper
	name = "Second Deck - Living - Cafe"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/sauna
	name = "Second Deck - Living - Sauna"
	icon_state = "sauna"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/head
	name = "Second Deck - Living - Restroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/garden_room
	name = "Second deck - living - Lounge"
	icon_state = "game_room_inf"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/gym
	name = "Second Deck - Living - Gym"
	icon_state = "fitness"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/actor
	name = "Second Deck - Service - Actor"
	icon_state = "Theatre"
	sound_env = SMALL_SOFTFLOOR
	req_access = list(access_actor)
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/actor/stage
	name = "Second Deck - Service - Stage"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/lounge
	name = "Second Deck - Living - Lounge"
	sound_env = MEDIUM_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/sleep/bunk
	name = "Second Deck - Living - Dormitory"
	icon_state = "Sleep"
	sound_env = SMALL_SOFTFLOOR
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/sleep/cryo
	name = "Second Deck - Living - Cryogenic Storage"
	icon = 'maps/sierra/icons/turf/areas.dmi'
	icon_state = "cryo"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/sleep/cryo/south
	name = "Second Deck - Living - Cryogenic Storage - South"
	icon_state = "cryo_south"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/adherent
	name = "Second Deck - Living - Adherent Maintenence"
	icon_state = "robotics"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/chapel/main
	name = "Second Deck - Chapel"
	icon_state = "chapel"
	ambience = list(
		'maps/sierra/sound/ambience/chapel1.ogg',
		'maps/sierra/sound/ambience/chapel2.ogg',
		'maps/sierra/sound/ambience/chapel3.ogg',
		'maps/sierra/sound/ambience/chapel4.ogg'
	)
	sound_env = LARGE_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/chapel/office
	name = "Second Deck - Chapel - Chaplain's Office"
	req_access = list(access_chapel_office)
	color = COLOR_GRAY80
	sound_env = SMALL_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/chapel/mortuary
	name = "Second Deck - Chapel - Morgue"
	req_access = list(access_chapel_office)
	color = COLOR_GRAY80
	holomap_color = HOLOMAP_AREACOLOR_CREW


/* MEDBAY AREAS
 * ============
 */

/area/medical/ward
	name = "Second Deck - Patient Ward - Patients"
	icon_state = "patients"

/area/medical/wardhallway
	name = "Second Deck - Patient Ward - Hallway"
	icon_state = "medbay2"

/area/medical/maintenance_equipstorage
	name = "Second Deck - Infirmary - Lower Storage"
	icon_state = "medbay4"
	req_access = list(access_medical_equip)

/area/medical/morgue
	name = "Second Deck - Infirmary - Morgue"
	icon_state = "morgue"
	ambience = list(
		'sound/ambience/ambimo1.ogg',
		'sound/ambience/ambimo2.ogg',
		'sound/music/main.ogg'
	)
	req_access = list(access_morgue)

// Virology

/area/medical/virology
	name = "Second Deck - Virology"
	icon_state = "decontamination"
	req_access = list(access_virology)

/area/medical/virology/atmos
	name = "Second Deck - Virology - Atmospherics Storage"
	icon_state = "atmos"

/area/medical/virology/lab
	name = "Second Deck - Virology - Laboratory"

/area/medical/virology/ward
	name = "Second Deck - Virology - Isolation"
