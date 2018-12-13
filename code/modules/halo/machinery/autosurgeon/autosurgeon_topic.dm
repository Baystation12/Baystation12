
	//update_use_power(2)

/obj/machinery/autosurgeon/Topic(href, href_list)
	if(href_list["toggle_active"])
		set_active(!active)

	if(href_list["toggle_start_delay"])
		do_start_delay = !do_start_delay

	if(href_list["set_start_delay"])
		var/mob/living/carbon/user = locate(href_list["user"])
		var/new_delay = input(user,"Choose the delay in seconds for [src] to start up.","[src] start delay",start_delay/10) as num
		new_delay = max(new_delay, 0)
		new_delay = min(new_delay, 99)
		start_delay = new_delay * 10

	if(href_list["release_patient"])
		if(buckled_mob)
			src.visible_message("<span class='info'>[buckled_mob] has been released from [src].</span>")
			unbuckle_mob()
