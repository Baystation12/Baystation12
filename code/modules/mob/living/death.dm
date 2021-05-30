/mob/living/death()
	if(hiding)
		hiding = FALSE
	var/list/l = GLOB.mobs_in_sectors["[last_z]"]
	if(!isnull(l))
		l -= src
	. = ..()
