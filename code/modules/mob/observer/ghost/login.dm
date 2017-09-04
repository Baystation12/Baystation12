/mob/observer/ghost/Login()
	..()

	if (ghost_image)
		ghost_image.appearance = src
		ghost_image.appearance_flags = RESET_ALPHA
	updateghostimages()
