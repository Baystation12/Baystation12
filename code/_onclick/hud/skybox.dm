#define SKYBOX_DIMENSION 736

/obj/skybox
	name = "skybox"
	mouse_opacity = 0
	anchored = TRUE
	simulated = FALSE
	screen_loc = "CENTER,CENTER"
	plane = SKYBOX_PLANE
	var/dimension_x = SKYBOX_DIMENSION
	var/dimension_y = SKYBOX_DIMENSION

/client
	var/obj/skybox/skybox

/client/proc/update_skybox_offsets()
	if(!skybox)
		update_skybox(TRUE)
		return

	var/list/viewsize = getviewsize(view)
	var/view_x = viewsize[1]
	var/view_y = viewsize[2]
	skybox.screen_loc = "CENTER:-[((view_x - 1) / 2) * world.icon_size],CENTER:-[((view_y - 1) / 2) * world.icon_size]"
	skybox.dimension_x = SKYBOX_DIMENSION - (view_x * world.icon_size)
	skybox.dimension_y = SKYBOX_DIMENSION - (view_y * world.icon_size)

	update_skybox()

/client/proc/update_skybox(rebuild)
	var/turf/T = get_turf(eye)
	if(!T)
		return

	if(!skybox)
		skybox = new()
		screen += skybox
		rebuild = TRUE

	if(rebuild)
		skybox.ClearOverlays()
		skybox.AddOverlays(SSskybox.get_skybox(T.z))
		screen |= skybox
		update_skybox_offsets()
		return

	var/matrix/M = matrix()
	var/x_translate = -((T.x/world.maxx)) * skybox.dimension_x
	var/y_translate = -((T.y/world.maxy)) * skybox.dimension_y
	M.Translate(x_translate, y_translate)
	skybox.transform = M

/client/proc/deferred_skybox_update(rebuild)
	set waitfor = FALSE
	sleep(1)
	update_skybox(rebuild)


/mob/Move()
	var/old_z = get_z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != get_z(src))

/mob/forceMove()
	var/old_z = get_z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != get_z(src))
