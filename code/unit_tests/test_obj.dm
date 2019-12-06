/obj/test
	name = "A test object. You shall never see this."
	desc = "A test object. You shall never see this."

/obj/test/New(var/atom/loc, var/is_test)
	..()
	if(!is_test)
		error("[src] as created at [loc] - [loc.x]-[loc.y]-[loc.z]")
		log_and_message_admins("created \a [src] at [loc]")
		qdel(src)
