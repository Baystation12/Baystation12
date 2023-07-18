/* CENTCOM AREAS
 * =============
 */
/area/centcom/control
	name = "Centcom Control"

/area/centcom/creed
	name = "Creed's Office"
	req_access = list(access_cent_creed)

/area/centcom/living
	name = "Centcom Living Quarters"
	req_access = list(access_cent_living)

/* HOLODECK AREAS
 * ==============
 */
/area/holodeck/alphadeck
	name = "Holodeck Alpha"

/area/holodeck/source_plating
	name = "Holodeck - Off"

/area/holodeck/source_emptycourt
	name = "Holodeck - Empty Court"
	sound_env = ARENA

/area/holodeck/source_boxingcourt
	name = "Holodeck - Boxing Court"
	sound_env = ARENA

/area/holodeck/source_basketball
	name = "Holodeck - Basketball Court"
	sound_env = ARENA

/area/holodeck/source_thunderdomecourt
	name = "Holodeck - Thunderdome Court"
	sound_env = ARENA

/area/holodeck/source_courtroom
	name = "Holodeck - Courtroom"
	sound_env = AUDITORIUM

/area/holodeck/source_beach
	name = "Holodeck - Beach"
	sound_env = PLAIN

/area/holodeck/source_wildlife
	name = "Holodeck - Wildlife Simulation"

/area/holodeck/source_military
	name = "Holodeck - Military Parade Ground"
	sound_env = AUDITORIUM

/area/holodeck/source_meetinghall
	name = "Holodeck - Meeting Hall"
	sound_env = AUDITORIUM

/area/holodeck/source_theatre
	name = "Holodeck - Theatre"
	sound_env = CONCERT_HALL

/area/holodeck/source_picnicarea
	name = "Holodeck - Picnic Area"
	sound_env = PLAIN

/area/holodeck/source_snowfield
	name = "Holodeck - Snow Field"
	sound_env = FOREST

/area/holodeck/source_desert
	name = "Holodeck - Desert"
	sound_env = PLAIN

/area/holodeck/source_space
	name = "Holodeck - Space"
	has_gravity = 0
	sound_env = SPACE

/area/holodeck/source_cafe
	name = "Holodeck - Cafe"
	sound_env = PLAIN

/area/holodeck/source_volleyball
	name = "Holodeck - Volleyball"
	sound_env = PLAIN

/area/holodeck/source_temple
	name = "Holodeck - Temple"
	sound_env = SMALL_ENCLOSED

/area/holodeck/source_plaza
	name = "Holodeck - Plaza"
	sound_env = SMALL_ENCLOSED

// Shuttles
/area/shuttle/administration/centcom
	name = "Administration Shuttle"
	icon_state = "shuttlered"
	req_access = list(access_cent_general)

/area/supply/dock
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0
	req_access = list(access_cent_storage)

/* ACTORS GUILD
 * ============
 */
/area/acting
	name = "Centcom Acting Guild"
	icon_state = "red"
	dynamic_lighting = 0
	requires_power = 0

/area/acting/backstage
	name = "Backstage"

/area/acting/stage
	name = "Stage"
	dynamic_lighting = 1
	icon_state = "yellow"

/* THUNDERDOME
 * ===========
 */
/area/tdome
	name = "Thunderdome"
	icon_state = "thunder"
	requires_power = 0
	dynamic_lighting = 0
	sound_env = ARENA
	req_access = list(access_cent_thunder)

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "Thunderdome (Observer.)"
	icon_state = "purple"

/area/tdome/testing
	name = "Thunderdome (TESTING AREA)"
	icon_state = "purple"

/area/tdome/testing/engineering
	requires_power = 0
	dynamic_lighting = 1

/area/tdome/testing/engineering/unpowered
	requires_power = 1
