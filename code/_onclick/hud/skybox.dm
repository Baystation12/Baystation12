/obj/skybox
	name = "skybox"
	mouse_opacity = 0
	anchored = TRUE
	simulated = FALSE
	screen_loc = "CENTER:-224,CENTER:-224"
/client
	var/obj/skybox/skybox

/client/New()
	..()
	update_skybox()

/client/proc/update_skybox()
	if(!skybox)
		skybox = new()
		screen |= skybox
	var/turf/T = get_turf(eye)
	if(T)
		skybox.appearance = SSskybox.get_skybox_appearance(T.z)
		skybox.screen_loc = "CENTER:[-224 - T.x],CENTER:[-224 - T.y]"

/mob/Move()
	. = ..()
	if(. && client)
		client.update_skybox()

/mob/forceMove()
	. = ..()
	if(. && client)
		client.update_skybox()
