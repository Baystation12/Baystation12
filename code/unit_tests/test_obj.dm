/obj/test
	name = "A test object. You shall never see this."
	desc = "A test object. You shall never see this."

/obj/test/New(var/atom/loc, var/is_test)
	..()
	if(!is_test)
		log_warning("Test object created!", get_turf(src))
		qdel(src)
