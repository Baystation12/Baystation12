
/proc/switch_maps(var/new_map_name)
	//warning: no safety checks here

	//switch over the world executable
	fdel("baystation12.dmb")
	fcopy("[new_map_name].dmb","baystation12.dmb")

	//switch over the resource file
	fdel("baystation12.rsc")
	fcopy("[new_map_name].rsc","baystation12.rsc")

	if(blackbox)	blackbox.save_all_data_to_sql()
	sleep(50)

	//formulate the command to manually restart the world
	/*
	var/exec_cmd = "DreamDaemon [world.name].dmb [world.port]"
	for(var/cur_param in world.params)
		exec_cmd += " -[cur_param]"
	shell(exec_cmd)
	*/

	//just reboot as we've kept the same DMB name
	world.Reboot()
