/datum/admin_secret_item/fun_secret/make_all_areas_unpowered
	name = "Make All Areas Unpowered"

/datum/admin_secret_item/fun_secret/make_all_areas_unpowered/execute(mob/user)
	. = ..()
	if(.)
		power_failure()
