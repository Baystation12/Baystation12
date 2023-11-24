/singleton/cultural_info
	var/nickname

/singleton/cultural_info/proc/get_nickname()
	return nickname || name
