var/repository/cameras/camera_repository = new()

/proc/invalidateCameraCache()
	camera_repository.networks.Cut()
	camera_repository.invalidated = 1
	camera_repository.camera_cache_id = (++camera_repository.camera_cache_id % 999999)

/repository/cameras
	var/list/networks
	var/invalidated = 1
	var/camera_cache_id = 1

/repository/cameras/New()
	networks = list()
	..()

/repository/cameras/proc/cameras_in_network(var/network)
	setup_cache()
	var/list/network_list = networks[network]
	return network_list

/repository/cameras/proc/setup_cache()
	if(!invalidated)
		return
	invalidated = 0

	for(var/obj/machinery/camera/C in cameranet.cameras)
		var/cam = C.nano_structure()
		for(var/network in C.network)
			if(!networks[network])
				networks[network] = list()
			var/list/netlist = networks[network]
			netlist[++netlist.len] = cam
