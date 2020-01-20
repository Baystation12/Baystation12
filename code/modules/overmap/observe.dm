
/obj/effect/overmap/proc/observe_space(var/mob/user)
	if(!(user in my_observers))
		my_observers.Add(user)
	user.set_machine(src)
	user.reset_view(src, 0)
	if(user.client)
		user.client.view = 7

/obj/effect/overmap/check_eye(var/mob/user)
	//a player is trying to manually look out the window
	//todo: remove duplicate code here with /obj/machinery/computer/helm/check_eye()
	if(user && user.client)
		if(user in my_observers)
			//let them watch us on the overmap if they aren't already
			if(user.client.eye != src)
				user.reset_view(src, 0)
			return 0

		//reset some custom view settings for spaceships
		user.client.pixel_x = 0
		user.client.pixel_y = 0

	//tell the mob to reset their entire view
	return -1

/obj/effect/overmap/proc/cancel_camera(var/mob/user)
	my_observers.Remove(user)
	user.reset_view(null)

	if(user.client)
		user.client.pixel_x = 0
		user.client.pixel_y = 0

	//don't unset crew of vehicles so they can retain control
	/*
	if(!istype(user.loc, /obj/machinery/overmap_vehicle))
		user.unset_machine()
		*/

	//we've handled everything ourself so we don't need our ancestor proc (/mob/verb/cancel_camera) to do anything
	return 1
