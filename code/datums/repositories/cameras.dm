var/global/repository/cameras/camera_repository = new()

/proc/invalidateCameraCache()
	camera_repository.networks.Cut()
	camera_repository.invalidated = 1
	camera_repository.camera_cache_id = ++camera_repository.camera_cache_id

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

	for(var/sc in cameranet.cameras)
		var/obj/machinery/camera/C = sc
		var/cam = C.nano_structure()
		for(var/network in C.network)
			if(!networks[network])
				ADD_SORTED(networks, network, /proc/cmp_text_asc)
				networks[network] = list()
			var/list/netlist = networks[network]
			netlist[++netlist.len] = cam
