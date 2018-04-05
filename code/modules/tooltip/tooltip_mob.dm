/mob/MouseEntered(location, control, params)
	if(usr != src)
		openToolTip(user = usr, tip_src = src, params = params, title = get_nametag_name(usr), content = get_nametag_desc(usr))

	..()

/mob/MouseDown()
	closeToolTip(usr) //No reason not to, really

	..()

/mob/MouseExited()
	closeToolTip(usr) //No reason not to, really

	..()
