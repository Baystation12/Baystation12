
/obj/vehicles/verb/verb_exit_vehicle()
	set name = "Exit Vehicle"
	set category = "Vehicle"
	set src in view(1)

	exit_vehicle(usr)

/obj/vehicles/proc/exit_vehicle(var/mob/user,var/ignore_incap_check = 0)
	if(user.loc != src)
		to_chat(user,"<span class = 'notice'>You must be inside [src] to exit it.</span>")
		return
	if(user.incapacitated() && !ignore_incap_check)
		to_chat(user,"<span class='warning'>You cannot do that when you are incapacitated!</span>")
		return
	var/loc_moveto = pick_valid_exit_loc()
	if(isnull(loc_moveto))
		to_chat(user,"<span class = 'notice'>There is no valid location to exit at.</span>")
		return
	occupants -= user
	contents -= user
	user.forceMove(loc_moveto)
	update_object_sprites()
	update_user_view(user,1)
	return

/obj/vehicles/verb/enter_vehicle()
	set name = "Enter Vehicle"
	set category = "Vehicle"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user) || !src.Adjacent(user) || user.incapacitated())
		return
	var/player_pos_choice
	var/list/L = ALL_VEHICLE_POSITIONS
	if(L.len == 1)
		player_pos_choice = L[1]
	else
		player_pos_choice = input(user,"Enter which position?","Vehicle Entry Position Select","Cancel") in ALL_VEHICLE_POSITIONS + list("Cancel")
	if(player_pos_choice == "Cancel")
		return
	else
		enter_as_position(user,player_pos_choice)

/obj/vehicles/proc/show_occupants_contained(var/mob/user)
	var/has_passengers = 0
	for(var/mob/M in occupants)
		has_passengers = 1
		break
	if(has_passengers)
		to_chat(user,"<span class = 'notice'>Its visible occupants are:</span>")
		for(var/mob/M in occupants)
			if(occupants[M] in exposed_positions)
				M.examine(user)

/obj/vehicles/proc/kick_occupants()
	for(var/mob/m in occupants)
		exit_vehicle(m,1)

/obj/vehicles/proc/get_occupants_in_position(var/position = null)
	var/list/to_return = list()
	for(var/mob/occupant in occupants)
		if(occupants[occupant] == position)
			to_return += occupant
	return to_return

/obj/vehicles/proc/get_occupant_amount()
	return (occupants.len - 2)

//Returns null to allow the enter, a string to disallow.
/obj/vehicles/proc/check_enter_invalid()
	if(get_occupant_amount() + 1 > (1 + occupants[1] + occupants[2]))
		return "[src] is full!"
	return

/obj/vehicles/proc/check_position_blocked(var/position)
	if(block_enter_exit)
		return 1
	var/list/occupants_in_pos = get_occupants_in_position(position)
	if(position == "passenger" && occupants_in_pos.len + 1 > occupants[1])
		return 1
	if(position == "gunner" && occupants_in_pos.len + 1 > occupants[2])
		return 1
	if(position == "driver" && occupants_in_pos.len >= 1)
		return 1
	return 0

/obj/vehicles/proc/enter_as_position(var/mob/user,var/position = "passenger")
	if(check_position_blocked(position))
		to_chat(user,"<span class = 'notice'>No [position] spaces in [src]</span>")
		return 0
	var/mob/living/h_test = user
	if(!istype(h_test) && position == "driver")
		to_chat(user,"<span class = 'notice'>You don't know how to drive that.</span>") //Let's assume non-living mobs can't drive.
		return
	var/can_enter = check_enter_invalid()
	if(can_enter)
		to_chat(user,"<span class = 'notice'>[can_enter]</span>")
		return 0
	if(user in occupants)
		if(occupants[user] == position)
			to_chat(user,"<span class = 'notice'>You're already a [position] of [src]</span>")
			return 0
		occupants[user] = position
		visible_message("<span class = 'notice'>[user] enters [src] as [position]</span>")
		update_object_sprites()
		return 1

	occupants += user
	occupants[user] = position
	user.loc = contents
	contents += user
	update_object_sprites()
	update_user_view(user)
	visible_message("<span class = 'notice'>[user] enters the [position] position of [src].</span>")
	to_chat(user,"<span class = 'info'>You are now in the [position] position of [src].</span>")
	return 1

/obj/vehicles/proc/do_seat_switch(var/mob/user,var/position)
	var/list/occ_in_pos = get_occupants_in_position(position)
	if(!occ_in_pos||occ_in_pos.len == 0)
		to_chat(user,"<span class = 'notice'>There are no [position] slots in [src]</span>")
	var/mob/occ_tradewith = pick(occ_in_pos)
	var/user_position = occupants[user]
	var/tradewith_response = alert(occ_tradewith,"[user], [user_position] wants to switch seats with you. Accept?",,"Yes","No")
	if(tradewith_response == "No" || isnull(tradewith_response))
		to_chat(user,"<span class = 'warning'>[occ_tradewith] denied your seat-switch request.</span>")
		return
	occupants[user] = "Awaiting Trade" //Used to allow for debugging if anything goes wrong during seat switch
	occupants[occ_tradewith] = "Awaiting Trade"
	enter_as_position(user,position)
	enter_as_position(occ_tradewith,user_position)

/obj/vehicles/verb/switch_seats()
	set name = "Switch Seats"
	set category = "Vehicle"
	set src in view(1)
	var/mob/user = usr
	if(!istype(user) || !src.Adjacent(user))
		return
	var/position_switchto = input(user,"Enter which position?","Vehicle Position Select","Cancel") in ALL_VEHICLE_POSITIONS + list("Cancel")
	if(position_switchto == "Cancel")
		return
	if(check_position_blocked(position_switchto))
		do_seat_switch(user,position_switchto)
		return
	else
		enter_as_position(user,position_switchto)
	update_object_sprites()

/obj/vehicles/proc/damage_occupant(var/position,var/obj/item/P,var/mob/user = null)
	var/list/occ_list = get_occupants_in_position(position)
	if(isnull(occ_list) || !occ_list.len)
		return 1
	var/mob/mob_to_hit = pick(occ_list)
	if(isnull(mob_to_hit))
		return 1
	if(user)
		mob_to_hit.attackby(P,user)
		return 0
	else
		mob_to_hit.bullet_act(P)
		return 0

/obj/vehicles/proc/should_damage_occ()
	for(var/position in exposed_positions)
		var/hit_chance = exposed_positions[position]
		if(isnull(hit_chance))
			continue
		if(prob(hit_chance))
			return position
	return null

/obj/vehicles/proc/update_user_view(var/mob/user,var/reset = 0)
	if(user.client)
		if(reset)
			user.client.view = world.view
			user.client.pixel_x = 0
			user.client.pixel_y = 0
		else
			user.client.view *= vehicle_view_modifier
