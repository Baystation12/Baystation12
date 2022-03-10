/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = FALSE 				(defaults to 1)

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/



/area
	/// Boolean. Whether or not the area is on fire/has an active fire alarm. Used by fire alarm machinery and firedoors.
	var/fire = FALSE
	/// Integer (One of `ALARM_LEVEL_*`). The current atmosphere alarm level for the area. See `code\__defines\area.dm`.
	var/atmosalm = AREA_ALARM_SAFE
	/// Boolean. Whether or not the area is in 'party mode'. See `./proc/partyalert()`.
	var/party = FALSE
	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	plane = DEFAULT_PLANE
	layer = BASE_AREA_LAYER
	luminosity = FALSE
	mouse_opacity = 0
	/// Boolean. Whether or not the area's light switch is set to 'on' or 'off'. See `./proc/set_lightswitch()`.
	var/lightswitch = TRUE

	/// Boolean. Whether or not the area has emergency evacuation lighting effects enabled. Only used by the `/area/hallway` subtype. See `./proc/readyalert()`.
	var/eject = FALSE

	/// Boolean. Whether or not the area requires power for things inside it to operate. If `FALSE`, `powered()` always returns `TRUE` and all additional power processing for the area is disabled.
	var/requires_power = TRUE

	/// Boolean. Whether or not the area is considered to always be unpowered. Overrides all power checks except the `requires_power` var.
	var/always_unpowered = FALSE

	/// Boolean. Whether or not the `EQUIP` power channel for the area is turned on. Do not access directly.
	///   Use `./powered()` to check state. Updated automatically by `/obj/machinery/power/apc/proc/update()`.
	var/power_equip = TRUE

	/// Boolean. Whether or not the `LIGHT` power channel for the area is turned on. Do not access directly.
	///   Use `./powered()` to check state. Updated automatically by `/obj/machinery/power/apc/proc/update()`.
	var/power_light = TRUE

	/// Boolean. Whether or not the `ENVIRON` power channel for the area is turned on. Do not access directly.
	///   Use `./powered()` to check state. Updated automatically by `/obj/machinery/power/apc/proc/update()`.
	var/power_environ = TRUE

	/// Integer. The amount of continuous power drain for the `EQUIP` channel. Do not access directly. Automatically updated by `/obj/machinery`.
	var/used_equip = 0
	/// Integer. The amount of continuous power drain for the `LIGHT` channel. Do not access directly. Automatically updated by `/obj/machinery`.
	var/used_light = 0
	/// Integer. The amount of continuous power drain for the `ENVIRON` channel. Do not access directly. Automatically updated by `/obj/machinery`.
	var/used_environ = 0

	/// Integer. The amount of one-off power use for the `EQUIP` channel. Subtracted from the powernet then reset to `0` every power tick. Use `./use_power_oneoff()` to modify.
	var/oneoff_equip = 0
	/// Integer. The amount of one-off power use for the `LIGHT` channel. Subtracted from the powernet then reset to `0` every power tick. Use `./use_power_oneoff()` to modify.
	var/oneoff_light = 0
	/// Integer. The amount of one-off power use for the `ENVIRON` channel. Subtracted from the powernet then reset to `0` every power tick. Use `./use_power_oneoff()` to modify.
	var/oneoff_environ = 0

	/// Boolean. Whether or not the area has gravity. Modify using `./gravitychange()`.
	var/has_gravity = TRUE

	/// The area's APC machine.
	var/obj/machinery/power/apc/apc = null

	/// Lazylist (`/obj/machinery/door/firedoor`). A list of all firedoors in or adjacent to the area.
	var/list/all_doors = null
	/// Boolean. Whether or not firedoors are currently engaged in the area. Updated automatically by `./air_doors_close()` and `./air_doors_open()`.
	var/air_doors_activated = FALSE
	/// List (sound files). List of ambience tracks to be played to mobs in the area.
	var/list/ambience = list('sound/ambience/ambigen1.ogg','sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambigen14.ogg')
	/// Lazylist (sound files). List of ambience tracks. Not 100% sure what this is for but seems tied to some global and lobby stuff. Probably best not to touch it.
	var/list/forced_ambience = null
	/// Integer. The area's sound environment, affecting reverb. See `code\game\sound.dm`.
	var/sound_env = STANDARD_STATION
	/// The base turf type of the area, which can be used to override the z-level's base turf
	var/turf/base_turf
	/// Boolean. Whether or not the area belongs to a planet.
	var/planetary_surface = FALSE

/*-----------------------------------------------------------------------------*/

/////////
//SPACE//
/////////

/area/space
	name = "\improper Space"
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE
	dynamic_lighting = TRUE
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	has_gravity = FALSE
	area_flags = AREA_FLAG_EXTERNAL | AREA_FLAG_IS_NOT_PERSISTENT
	ambience = list('sound/ambience/ambispace1.ogg','sound/ambience/ambispace2.ogg','sound/ambience/ambispace3.ogg','sound/ambience/ambispace4.ogg','sound/ambience/ambispace5.ogg')
	secure = FALSE

/area/space/atmosalert()
	return

/area/space/fire_alert()
	return

/area/space/fire_reset()
	return

/area/space/readyalert()
	return

/area/space/partyalert()
	return

//////////////////////
//AREAS USED BY CODE//
//////////////////////
/area/centcom
	name = "\improper Centcom"
	icon_state = "centcom"
	requires_power = FALSE
	dynamic_lighting = FALSE
	req_access = list(access_cent_general)

/area/centcom/holding
	name = "\improper Holding Facility"

/area/chapel
	name = "\improper Chapel"
	icon_state = "chapel"
	lighting_tone = AREA_LIGHTING_WARM

/area/centcom/specops
	name = "\improper Centcom Special Ops"
	req_access = list(access_cent_specops)

/area/hallway
	name = "hallway"

/area/medical
	req_access = list(access_medical)
	lighting_tone = AREA_LIGHTING_COOL

/area/security
	req_access = list(access_sec_doors)

/area/security/brig
	name = "\improper Security - Brig"
	icon_state = "brig"
	req_access = list(access_brig)

/area/security/prison
	name = "\improper Security - Prison Wing"
	icon_state = "sec_prison"
	req_access = list(access_brig)

/area/maintenance
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_env = TUNNEL_ENCLOSED
	turf_initializer = /decl/turf_initializer/maintenance
	forced_ambience = list('sound/ambience/maintambience.ogg')
	req_access = list(access_maint_tunnels)

/area/rnd
	req_access = list(access_research)
	lighting_tone = AREA_LIGHTING_COOL

/area/rnd/xenobiology
	name = "\improper Xenobiology Lab"
	icon_state = "xeno_lab"
	req_access = list(access_xenobiology, access_research)

/area/rnd/xenobiology/xenoflora
	name = "\improper Xenoflora Lab"
	icon_state = "xeno_f_lab"

/area/rnd/xenobiology/xenoflora_storage
	name = "\improper Xenoflora Storage"
	icon_state = "xeno_f_store"

/area/shuttle/escape/centcom
	name = "\improper Emergency Shuttle Centcom"
	icon_state = "shuttle"
	req_access = list(access_cent_general)

/area/shuttle/specops/centcom
	icon_state = "shuttlered"
	req_access = list(access_cent_specops)
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/shuttle/syndicate_elite/mothership
	icon_state = "shuttlered"
	req_access = list(access_syndicate)

/area/shuttle/syndicate_elite/station
	icon_state = "shuttlered2"
	req_access = list(access_syndicate)

/area/supply
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	req_access = list(access_cargo)

/area/syndicate_elite_squad
	name = "\improper Elite Mercenary Squad"
	icon_state = "syndie-elite"
	req_access = list(access_syndicate)

////////////
//SHUTTLES//
////////////
//shuttles only need starting area, movement is handled by landmarks
//All shuttles should now be under shuttle since we have smooth-wall code.

/area/shuttle
	requires_power = FALSE
	sound_env = SMALL_ENCLOSED
	base_turf = /turf/space

/*
* Special Areas
*/
/area/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = TRUE
	dynamic_lighting = FALSE
	requires_power = FALSE
	var/sound/mysound = null

/area/beach/New()
	..()
	var/sound/S = new/sound()
	mysound = S
	S.file = 'sound/ambience/shore.ogg'
	S.repeat = 1
	S.wait = 0
	S.channel = GLOB.sound_channels.RequestChannel(/area/beach)
	S.volume = 100
	S.priority = 255
	S.status = SOUND_UPDATE
	process()

/area/beach/Entered(atom/movable/Obj,atom/OldLoc)
	. = ..()
	if(ismob(Obj))
		var/mob/M = Obj
		if(M.client)
			mysound.status = SOUND_UPDATE
			sound_to(M, mysound)

/area/beach/Exited(atom/movable/Obj)
	. = ..()
	if(ismob(Obj))
		var/mob/M = Obj
		if(M.client)
			mysound.status = SOUND_PAUSED | SOUND_UPDATE
			sound_to(M, mysound)

/area/beach/proc/process()
	set background = 1

	var/sound/S = null
	var/sound_delay = 0
	if(prob(25))
		S = sound(file=pick('sound/ambience/seag1.ogg','sound/ambience/seag2.ogg','sound/ambience/seag3.ogg'), volume=100)
		sound_delay = rand(0, 50)

	for(var/mob/living/carbon/human/H in src)
		if(H.client)
			mysound.status = SOUND_UPDATE
			if(S)
				spawn(sound_delay)
					sound_to(H, S)

	spawn(60) .()
