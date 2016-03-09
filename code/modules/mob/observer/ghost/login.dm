/mob/observer/ghost/Login()
	..()
	if (ghostimage)
		ghostimage.icon_state = src.icon_state
	updateghostimages()
