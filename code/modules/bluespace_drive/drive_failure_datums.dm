/decl/drive_failure
	var/failure_period = 10 SECONDS

/decl/drive_failure/proc/invoke(var/obj/machinery/drive_core/failing)
	announce_failure()
	failing.destroyed = TRUE
	failing.set_light(0)
	failing.update_icon()
	GLOB.bluespace_drive_collapsing++
	addtimer(CALLBACK(src, /decl/drive_failure/proc/failed_callback, failing), failure_period)

/decl/drive_failure/proc/announce_failure()
	return

/decl/drive_failure/proc/failed_callback(var/obj/machinery/drive_core/failing)
	. = failing && !QDELETED(failing)
	GLOB.bluespace_drive_collapsing--

/decl/drive_failure/minor/announce_failure()
	priority_announcement.Announce("Power fluctuations within the bluespace drive core are exceeding safety boundaries. Emergency drive cutoff commencing. All hands, brace for electromagnetic interference.", "Drive Monitor")

/decl/drive_failure/minor/failed_callback(var/obj/machinery/drive_core/failing)
	. = ..()
	if(.)
		empulse(failing, 30, 40) // TODO better numbers

/decl/drive_failure/moderate/announce_failure()
	priority_announcement.Announce("Unexpected electrical surge detected within drive power systems. Conduit failure imminent. All hands, brace for drive detonation.", "Drive Monitor")

/decl/drive_failure/moderate/failed_callback(var/obj/machinery/drive_core/failing)
	. = ..()
	if(.)
		explosion(failing, 3, 6, 9, 20, 0) // TODO better numbers

/decl/drive_failure/major/announce_failure()
	priority_announcement.Announce("Alert: runtime error in drive monitoring systems. Gravitational wave output increasing expontentially. Containment failure imminent. All hands, brace for drive collapse.", "Drive Monitor")

/decl/drive_failure/major/failed_callback(var/obj/machinery/drive_core/failing)
	. = ..()
	if(.)
		new /obj/singularity(get_turf(failing), 50) // TODO better singulo
