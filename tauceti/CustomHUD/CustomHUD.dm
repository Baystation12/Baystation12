/proc/sanitize_hudalpha(var/alpha)
	if(alpha < 256 && alpha >49)
		return alpha
	return