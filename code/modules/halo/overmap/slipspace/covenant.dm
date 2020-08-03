
//FACTION SUBTYPES//
/obj/machinery/slipspace_engine/covenant
	name = "\improper Slipspace Traversal Drive"
	desc = "A self-contained device allowing for traversal of slipspace, providing methods of quick travel across large distances without sacrificing accuracy. Can perform slipspace jumps within the gravity wells of large objects."
	icon = 'code/modules/halo/overmap/slipspace/slipspace_drive_cov.dmi'
	core_to_spawn = /obj/payload/slipspace_core/cov
	precise_jump = TRUE
	req_access = list(access_covenant_command)

/obj/machinery/slipspace_engine/covenant/allowed(var/mob/user)
	if(!is_covenant_mob(user))
		src.visible_message("<span class='warning'>[src] is all gibberish to you.</span>")
		return FALSE

	return ..()

/obj/payload/slipspace_core/cov
	icon = 'code/modules/halo/overmap/slipspace/slipspace_drive_cov.dmi'
