/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/



/area
	/// Boolean. Whether or not the area has an active fire alarm. Do not modify directly; Use `./fire_alert()` and `./fire_reset()` instead.
	var/fire = null
	/// Integer (`0`, `1`, or `2`). Whether or not the area has an active atmosphere alarm and the level of the atmosphere alarm. Do not modify directly; Use `./atmosalert()` instead.
	var/atmosalm = 0
	/// Boolean. Whether or not the area is in 'party light' mode. Do not modify directly; Use `./partyalert()` or `./partyreset()` instead.
	var/party = null
	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	plane = DEFAULT_PLANE
	layer = BASE_AREA_LAYER
	luminosity = 0
	mouse_opacity = 0
	/// Boolean. Whether or not the area's lightswitch is switched to 'On' or 'Off'. Used to synchronize lightswitch buttons. Do not modify directly; Use `./set_lightswitch()` instead.
	var/lightswitch = 1

	/// Boolean. Whether or not the area is in the 'Evacuation' alert state. Do not modify directly; Use `./readyalert()` or `./readyreset()` instead.
	var/eject = null

	/// Boolean. Whether or not the area requires power to be considered powered, bypassing all other checks if `TRUE`. This takes priority over `always_unpowered`.
	var/requires_power = 1
	/// Boolean. Whether or not the area is always considered to be unpowered, bypassing all other area checks if `TRUE`.
	var/always_unpowered = 0

	/// Boolean. Whether or not the `EQUIP` power channel is enabled for the area. Updated and used by APCs.
	var/power_equip = 1
	/// Boolean. Whether or not the `LIGHT` power channel is enabled for the area. Updated and used by APCs.
	var/power_light = 1
	/// Boolean. Whether or not the `ENVIRON` power channel is enabled for the area. Updated and used by APCs.
	var/power_environ = 1
	/// Integer. Amount of constant use power drain from the `EQUIP` power channel. Do not modify; Use `./power_use_change()` instead.
	var/used_equip = 0
	/// Integer. Amount of constant use power drain from the `LIGHT` power channel. Do not modify; Use `./power_use_change()` instead.
	var/used_light = 0
	/// Integer. Amount of constant use power drain from the `ENVIRON` power channel. Do not modify; Use `./power_use_change()` instead.
	var/used_environ = 0
	/// Integer. Amount of power to drain from the `EQUIP` channel on the next power tick. Do not modify directly; Use `./use_power_oneoff()` instead. This is reset to `0` every power tick after processing power use.
	var/oneoff_equip   = 0
	/// Integer. Amount of power to drain from the `LIGHT` channel on the next power tick. Do not modify directly; Use `./use_power_oneoff()` instead. This is reset to `0` every power tick after processing power use.
	var/oneoff_light   = 0
	/// Integer. Amount of power to drain from the `ENVIRON` channel on the next power tick. Do not modify directly; Use `./use_power_oneoff()` instead. This is reset to `0` every power tick after processing power use.
	var/oneoff_environ = 0

	/// Boolean. Whether or not the area has gravity. Do not set directly; Use `./gravitychange()` instead.
	var/has_gravity = 1
	/// Direct reference to the APC installed in the area, if it exists. Automatically updated during the APC's `Initialize()` and `Destroy()` calls.
	var/obj/machinery/power/apc/apc = null
	/// LAZYLIST (`/obj/machinery/door/firedoor`). Contains a list of all firedoors within and adjacent to this area. Updated during a firedoor's `Initialize()` and `Destroy()` calls. Do not modify directly.
	var/list/all_doors = null
	/// Boolean. Whether or not the area's firedoors are activated (closed). Tied to area alarm processing. Do not modify directly; Use `air_doors_close()` or `air_doors_open()` instead.
	var/air_doors_activated = 0
	/// List (`file (sounds)`). List of sounds that can be played to mobs in the area as ambience. See `./play_ambience()`.
	var/list/ambience = list('sound/ambience/ambigen1.ogg','sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambigen14.ogg')
	/// LAZYLIST (`file (sounds)`). Additional ambience files. These are always played instead of only on probability, are set to loop, and are slightly louder than `ambience` sound files. See `./play_ambience()`.
	var/list/forced_ambience = null
	/// Integer (One of the environments defined in `code\game\sound.dm`). Sound environment used for modification of sounds played to mobs in the area.
	var/sound_env = STANDARD_STATION
	/// The base turf type of the area, which can be used to override the z-level's `base_turf` for floor deconstruction.
	var/turf/base_turf
	/// Boolean. Whether or not the area belongs to a planet.
	var/planetary_surface = FALSE
	/// Boolean. Some base_turfs might cause issues with changing turfs, this flags it as a special case. See `/proc/get_base_turf_by_area()`.
	var/base_turf_special_handling = FALSE

/*-----------------------------------------------------------------------------*/

/////////
//SPACE//
/////////

/area/space
	name = "\improper Space"
	icon_state = "space"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	has_gravity = 0
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
	requires_power = 0
	dynamic_lighting = 0
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

/area/rnd/xenobiology/cell_1
	name = "\improper Xenobiology Containment Cell 1"
	icon_state = "xeno_lab_cell_1"
	req_access = list(access_xenobiology, access_research)

/area/rnd/xenobiology/cell_2
	name = "\improper Xenobiology Containment Cell 2"
	icon_state = "xeno_lab_cell_2"
	req_access = list(access_xenobiology, access_research)

/area/rnd/xenobiology/cell_3
	name = "\improper Xenobiology Containment Cell 3"
	icon_state = "xeno_lab_cell_3"
	req_access = list(access_xenobiology, access_research)

/area/rnd/xenobiology/cell_4
	name = "\improper Xenobiology Containment Cell 4"
	icon_state = "xeno_lab_cell_4"
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
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

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
	requires_power = 0
	sound_env = SMALL_ENCLOSED
	base_turf = /turf/space
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	base_turf_special_handling = TRUE

/*
* Special Areas
*/
/area/beach
	name = "Keelin's private beach"
	icon_state = "beach"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = 0
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
