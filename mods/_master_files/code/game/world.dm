/world/save_mode(the_mode)
	var/error = rustg_file_write(the_mode, "data/mode.txt")
	if (error)
		crash_with(error)
