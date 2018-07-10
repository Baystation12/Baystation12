
#define RANDOM_RIGHT_ANGLE pick(90,180,270,0)

//Exists to handle a few global variables that change enough to justify this. Technically a parallax, but it exhibits a skybox effect.
SUBSYSTEM_DEF(skybox)
	name = "Space skybox"
	init_order = SS_INIT_SKYBOX
	flags = SS_NO_FIRE
	var/BGrot
	var/BGcolor
	var/BGpath = 'icons/turf/skybox.dmi' //Path to our background. Lets us use anything we damn well please. Skyboxes need to be 736x736
	var/BGstate = "dyable"
	var/use_stars = TRUE
	var/star_path = 'icons/turf/skybox.dmi'
	var/star_state = "stars"
	var/list/skyboxes = list() //Keep track of all existing skyboxes.

/datum/controller/subsystem/skybox/Initialize(timeofday)
	..(timeofday)
	BGcolor = RANDOM_RGB
	BGrot = RANDOM_RIGHT_ANGLE

/datum/controller/subsystem/skybox/Recover()
	BGrot = SSskybox.BGrot
	BGcolor = SSskybox.BGcolor
	skyboxes = SSskybox.skyboxes

//Update skyboxes. Called by universes, for now. Won't be going back to their original appearance in such a case... So be aware of this.
/datum/controller/subsystem/skybox/proc/reinstate_skyboxes(var/state, var/using_stars)

	use_stars = using_stars

	if(state)
		BGstate = state

	for(var/obj/skybox/P in skyboxes)
		P.color = null //We don't want the skybox to be colored.
		P.overlays.Cut(0)

		var/BG = image(BGpath, src, "background_[BGstate]")
		if(BGstate == initial(BGstate)) //Ew.
			new_color_and_rotation(1.1) //This only allows dyable states anyways. It won't look bad or anything.
		P.overlays += BG

		//Checking the subsystem deliberately, just to be safe. Allows the use of stars in universe
		//states. You'll need to VV the subsystem for this to check custom files.

		if(use_stars)
			var/image/stars = image(star_path, src, star_state)
			stars.appearance_flags = RESET_COLOR
			P.overlays += stars

//new_color_and_rotation(bool, bool, string) Where the string is to be a color in hexadecimal form. Accepts input as color.
/datum/controller/subsystem/skybox/proc/new_color_and_rotation(var/do_rotate, var/do_recolor, var/forced_color)
	if(do_rotate)
		BGrot = RANDOM_RIGHT_ANGLE
	if(do_recolor)
		BGcolor = RANDOM_RGB
	if(forced_color)
		BGcolor = forced_color
	for(var/obj/skybox/P in skyboxes)
		P.color = BGcolor
		P.DoRotate()


#undef RANDOM_RIGHT_ANGLE
