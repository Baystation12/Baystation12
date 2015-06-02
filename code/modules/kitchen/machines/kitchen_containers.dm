/obj/machinery/kitchen/attackby(var/obj/item/O, var/mob/user)

	// A spot of the old ultraviolence.
	if(istype(O, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		if(G.state < GRAB_AGGRESSIVE)
			user << "<span class='warning'>You need a better grip!</span>"
			return
		if(G.affecting)
			handle_grab(G.affecting, user)
			qdel(O)
			return

	// Accepting items for cooking.
	var/accepted_item = can_accept_item(O, user)
	if(accepted_item != 0)
		if(accepted_item == 1)
			take_item(O,user)
		return 0
	else if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/))
		user << "<span class='warning'>You need a container for \the [O.name].</span>"
		return 0
	else
		user << "You don't think you could make anything useful with \the [O]."
		return 0

// Returns -1 for no-message failure (ie. oven produces a message itself), 0 for general failure, and 1 for success.
/obj/machinery/kitchen/proc/can_accept_item(var/obj/item/I, var/mob/user)
	for(var/container_type in acceptable_containers)
		if(istype(I, container_type))
			return 1
	return 0

/obj/machinery/kitchen/proc/take_item(var/obj/item/I, var/mob/living/user)
	if(istype(user))
		user.drop_from_inventory(I)
	I.loc = src
	update_icon()
	return 1

/obj/machinery/kitchen/stove/can_accept_item(var/obj/item/I, var/mob/user)
	if(..() == 0)
		return 0
	for(var/burner in burner_contents)
		if(burner_contents[burner] == 0)
			return 1
	user << "<span class='warning'>\The [src] has no free burners!</span>"
	return -1

/obj/machinery/kitchen/stove/take_item(var/obj/item/I, var/mob/user)
	if(!..())
		return
	for(var/burner in burner_contents)
		if(burner_contents[burner] == 0)
			burner_contents[burner] = I
			user.visible_message("\The [user] puts \the [I] onto \the [src]'s [burner] burner.")
			update_icon()
			return

/obj/machinery/kitchen/oven/can_accept_item(var/obj/item/I, var/mob/user)
	if(..() == 0)
		return 0
	if(!open)
		user << "<span class='warning'>Open \the [src] first!</span>"
		return -1
	if(food_inside)
		user << "<span class='warning'>\The [src] already has \a [food_inside] inside.</span>"
		return -1
	return 1

/obj/machinery/kitchen/oven/take_item(var/obj/item/I, var/mob/user)
	if(!..())
		return
	user.visible_message("\The [user] puts \the [I] inside \the [src].")
	food_inside = I
	update_icon()
