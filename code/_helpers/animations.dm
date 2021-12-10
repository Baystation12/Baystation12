/proc/remove_images_from_clients(image/I, list/show_to)
	for(var/client/C in show_to)
		C.images -= I
	qdel(I)

/proc/animate_speech_bubble(image/I, list/show_to, duration)
	var/matrix/M = matrix()
	M.Scale(0,0)
	I.transform = M
	I.alpha = 0
	for(var/client/C in show_to)
		C.images += I
	animate(I, transform = 0, alpha = 255, time = 2, easing = EASE_IN)
	addtimer(CALLBACK(GLOBAL_PROC, /.proc/fade_out, I, show_to), duration - 5)

/proc/fade_out(image/I, list/show_to)
	animate(I, alpha = 0, time = 5, easing = EASE_IN)
	addtimer(CALLBACK(GLOBAL_PROC, /.proc/remove_images_from_clients, I, show_to), 5)
