/obj/screen/sting/Click(location, control, params)
	if(!usr)
		return
	if(isobserver(usr))
		return
	var/mob/living/carbon/U = usr
	U.unset_sting(usr)
