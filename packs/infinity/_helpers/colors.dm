/proc/clamphex(hex, bmin, bmax=255)
	. = hex
	var/list/bgr = ReadRGB(hex)
	if(length(bgr) == 3)
		for(var/i in bgr)
			i = clamp(i, bmin, bmax)
		. = rgb(bgr[1], bgr[2], bgr[3])
