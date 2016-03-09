var/const/GHOST_IMAGE_DARKNESS = 1
var/const/GHOST_IMAGE_SIGHTLESS = 2
var/const/GHOST_IMAGE_ALL = 3

/mob/observer
	density = 0
	layer = FLY_LAYER
	sight = SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
	simulated = FALSE
	stat = DEAD
	status_flags = GODMODE
	var/ghost_image_flag = GHOST_IMAGE_DARKNESS
	var/image/ghost_image = null //this mobs ghost image, for deleting and stuff

/mob/observer/New()
	..()
	ghost_image = image(src.icon)
	ghost_image.appearance = src
	if(ghost_image_flag & GHOST_IMAGE_DARKNESS)
		ghost_darkness_images |= ghost_image //so ghosts can see the eye when they disable darkness
	if(ghost_image_flag & GHOST_IMAGE_SIGHTLESS)
		ghost_sightless_images |= ghost_image //so ghosts can see the eye when they disable ghost sight
	updateallghostimages()

/mob/observer/Destroy()
	if (ghost_image)
		ghost_darkness_images -= ghost_image
		ghost_sightless_images -= ghost_image
		qdel(ghost_image)
		ghost_image = null
		updateallghostimages()
	. = ..()

mob/observer/check_airflow_movable()
	return FALSE

/mob/observer/CanPass()
	return TRUE

/proc/updateallghostimages()
	for (var/mob/observer/ghost/O in player_list)
		O.updateghostimages()
