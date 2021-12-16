/mob/living/carbon/alien/exophage
	name = "exophage"
	desc = "A strange alien creature with tendrils. What IS that?"

	icon = 'icons/mob/exophage/body_sentinel.dmi'
	icon_state = "preview"
	default_pixel_x = -16
	pixel_x = -16

	language = LANGUAGE_EXOPHAGE
	species_language = LANGUAGE_EXOPHAGE
	universal_understand = FALSE
	universal_speak = FALSE
	death_msg = "quivers erratically and falls over motionless..."

	hud_type = /datum/hud/exophage

	can_pull_size = ITEM_SIZE_LARGE
	can_pull_mobs = MOB_PULL_SAME
	available_maneuvers = list(/decl/maneuver/leap)

	var/datum/exophage_build/build = /datum/exophage_build
	var/tmp/image/eyes

	var/list/drones = list()

//For grabbing the parent mob only
/mob/living/carbon/alien/exophage/New(loc, mob/living/carbon/alien/exophage/parent)
	build = new(src, parent?.build)
	. = ..()

/mob/living/carbon/alien/exophage/Initialize()
	. = ..()
	build.generate_build(src)

	//Generate eyes
	eyes = image(icon = 'icons/mob/exophage/eyes.dmi', icon_state = "")

/*	if(build.eye_color)
		eyes.color = build.eye_color*/

	icon_state = "blank"
	//Generate body
	var/list/bodyparts = list(
	"torso",
	"head",
	"groin",
	"l_leg",
	"l_foot",
	"r_leg",
	"r_foot",
	"l_arm",
	"l_hand",
	"r_arm",
	"r_hand"
	)

	for(var/bodypart in bodyparts)
		var/image/bodypart_image = image(icon = icon, icon_state = bodypart)
/*		if(build.color)
			bodypart_image.color = build.color*/
		overlays += bodypart_image
	overlays += eyes

//FUCK YOU /alien/update.icons.dm
/mob/living/carbon/alien/regenerate_icons()
	update_icons()

/mob/living/carbon/alien/exophage/update_icons()
	if(stat == DEAD)
		overlays -= eyes
	else
		return

/mob/living/carbon/alien/exophage/examine(mob/user)
	. = ..()
	if((isexophage(user) || isobserver(user))  && build.title)
		var/list/msg = list("<span class ='alien'>*---------*\n")
		msg += "This is <b>[name]</b>. "
		if(build.title)
			msg+= "You recognize it as \an <i>[build.title]</i>."
		msg+= "\n"
		for(var/datum/exophage_trait/trait in build.traits)
			if(trait.examine_desc)
				msg+= "\n"
				msg += "It <b>[trait.examine_desc]</b>.\n"
		msg += "*---------*</span>"
		to_chat(user, jointext(msg, null))


/mob/living/carbon/alien/exophage/Login()
	. = ..()
	if(!build.title)
		generate_title()

//Debug only
/mob/living/carbon/alien/exophage/verb/debug_reproduce()
	set name = "Debug Reproduce"
	set desc = "Debug a child of yourself into existence."
	set category = "Debug"

	var/mob/living/carbon/alien/exophage/X = new(loc, src)

	visible_message(SPAN_ALIEN("<B><I>\The [src] debugs \the [X] into existence! Disgusting!</I></B>"))

/mob/living/carbon/alien/exophage/get_jump_distance()
	return 4

//These are NPC followers of player-controlled exophages
/mob/living/carbon/alien/exophage/drone
	name = "exophage drone"