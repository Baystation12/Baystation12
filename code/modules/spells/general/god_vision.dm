/spell/camera_connection/god_vision
	name = "All Seeing Eye"
	desc = "See what your master sees."

	charge_max = 10
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE

	eye_type = /mob/observer/eye

	hud_state = "gen_mind"

/spell/camera_connection/god_vision/set_connected_god(var/mob/living/deity/god)
	..()
	vision.visualnet = god.eyeobj.visualnet

/spell/camera_connection/god_vision/Destroy()
	vision.visualnet = null
	return ..()