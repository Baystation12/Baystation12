#define ALL_VEHICLE_POSITIONS list("driver","passenger","gunner")
#define VEHICLE_LOAD_DELAY 2.5 SECONDS //This is the delay to load people onto the vehicle.

/obj/vehicles
	name = "Vehicle"
	desc = "Vehicle"
	density = 1

	//Advanced Damage Handling
	var/datum/component_profile/comp_prof = /datum/component_profile

	var/vehicle_move_delay = 1

	//Passenger Management
	var/list/occupants = list(0,1) //Contains all occupants of the vehicle including the driver. First 2 values defines max passengers /gunners. Format: [MobRef] = [PositionName]

	var/list/exposed_positions = list("driver" = 0.0,"gunner" = 0.0,"passenger" = 0.0) //Assoc. Value is the chance of hitting this position

/obj/vehicles/New()
	. = ..()
	comp_prof = new comp_prof(src)
	GLOB.processing_objects += src

/obj/vehicles/Destroy()
	GLOB.processing_objects -= src
	. = ..()

/obj/vehicles/proc/on_death()
	for(var/mob/m in occupants)
		exit_vehicle(m)
	explosion(src,-1,-1,2,5)
	qdel(src)

/obj/vehicles/process()
	if(world.time % 3)
		comp_prof.give_gunner_weapons(src)

/obj/vehicles/proc/update_object_sprites() //This is modified on a vehicle-by-vehicle basis to render mobsprites etc.

/obj/vehicles/Move()
	. = ..()
	update_object_sprites()

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
	var/can_enter = check_enter_invalid()
	if(can_enter)
		to_chat(user,"<span class = 'notice'>[can_enter]</span>")
		return 0
	if(user in occupants)
		if(occupants[user] == position)
			to_chat(user,"<span class = 'notice'>You're already a [position] of [src]</span>")
			return 0
		occupants[user] = position
		return 1

	occupants += user
	occupants[user] = position
	user.loc = contents
	contents += user
	return 1

/obj/vehicles/proc/do_seat_switch(var/mob/user,var/position)
	var/list/occ_in_pos = get_occupants_in_position(position)
	if(!occ_in_pos||occ_in_pos.len == 0)
		to_chat(user,"<span class = 'notice'>There are no [position] slots in [src]</span>")
	var/mob/occ_tradewith = pick(occ_in_pos)
	var/user_position = occupants[user]
	var/tradewith_response = alert(occ_tradewith,"[user], [user_position] wants to switch seats with you. Accept?",,"Yes","No")
	if(tradewith_response == "No")
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
	if(!istype(user))
		return
	var/position_switchto = input(user,"Enter which position?","Vehicle  Select","Cancel") in ALL_VEHICLE_POSITIONS + list("Cancel")
	if(position_switchto == "Cancel")
		return
	if(check_position_blocked(position_switchto))
		do_seat_switch(user,position_switchto)
		return
	else
		enter_as_position(user,position_switchto)

/obj/vehicles/verb/exit_vehicle(var/mob/user)
	set name = "Exit Vehicle"
	set category = "Vehicle"
	set src in view(1)

	if(!(user in occupants))
		return
	occupants -= user
	contents -= user
	user.loc = pick(src.locs)

/obj/vehicles/verb/enter_vehicle()
	set name = "Enter Vehicle"
	set category = "Vehicle"
	set src in view(1)

	var/mob/user = usr
	if(!istype(user))
		return
	var/player_pos_choice = input(user,"Enter which position?","Vehicle Entry Position Select","Cancel") in ALL_VEHICLE_POSITIONS + list("Cancel")
	if(player_pos_choice == "Cancel")
		return
	else
		enter_as_position(user,player_pos_choice)

/obj/vehicles/proc/damage_occupant(var/position,var/obj/item/projectile/P)
	var/list/occ_list = get_occupants_in_position(position)
	var/mob/mob_to_hit = pick(occ_list)
	if(isnull(mob_to_hit))
		return
	mob_to_hit.bullet_act(P)

/obj/vehicles/proc/should_damage_occ()
	for(var/position in exposed_positions)
		var/hit_chance = exposed_positions[position]
		if(isnull(hit_chance))
			continue
		if(prob(hit_chance))
			return position
	return null

//TODO: VEHICLE HEALTH DETERMINED BY COMPONENTS
/obj/vehicles/bullet_act(var/obj/item/projectile/P, var/def_zone)
	var/pos_to_dam = should_damage_occ()
	if(!isnull(pos_to_dam))
		damage_occupant(pos_to_dam,P)
		return
	comp_prof.take_component_damage(P)

//TODO: REIMPLEMENT SPEED BASED MOVEMENT
/obj/vehicles/relaymove(var/mob/user, var/direction)
	var/turf/new_loc = get_step(src.loc,direction)
	var/list/driver_list = get_occupants_in_position("driver")
	var/is_driver = FALSE
	for(var/mob/driver in driver_list)
		if(user == driver)
			is_driver = TRUE
			break
	if(!is_driver)
		return
	Move(new_loc,direction)
	user.client.move_delay = world.time + vehicle_move_delay

//TODO: CARGO SYSTEM
/obj/vehicles/proc/put_cargo_item(var/mob/user,var/obj/item/O)
	var/confirm = alert(user,"Place [O.name] into [src.name]'s storage?",,"Yes","No")
	if(confirm != "Yes")
		return
	if(!comp_prof.can_put_cargo(O.w_class))
		to_chat(user,"<span class = 'notice'>[src.name] is too full to fit [O.name]</span>")
		return
	user.drop_from_inventory(O)
	comp_prof.cargo_transfer(O)

/obj/vehicles/verb/get_cargo_item()
	set name = "Retrieve Cargo"
	set category = "Vehicle"
	set src in view(1)

	var/mob/user = usr
	if(!istype(user))
		return

	var/list/cargo_list_names = list()
	for(var/obj/item in comp_prof.current_cargo)
		cargo_list_names += comp_prof.current_cargo[item.name]
		comp_prof.current_cargo[item.name] = item
	if(isnull(cargo_list_names) || !cargo_list_names.len)
		to_chat(user,"<span class = 'notice'>[src.name]'s cargo hold is empty!</span>")
		return
	var/item_name_remove = input(user,"Pick an item to remove","Item removal selection","Cancel") in cargo_list_names + list("Cancel")
	if(item_name_remove == "Cancel")
		return
	var/obj/object_removed = comp_prof.cargo_transfer(cargo_list_names[item_name_remove],1)
	var/mob/living/carbon/human/H = user
	if(istype(object_removed) && istype(H))
		H.put_in_hands(object_removed)

/obj/vehicles/proc/handle_grab_attack(var/obj/item/grab/I, var/mob/user)
	var/mob/living/grabbed_mob = I.affecting
	if(!istype(grabbed_mob))
		return
	if(user.a_intent != I_HURT && grabbed_mob.stat == CONSCIOUS)
		if(!do_after(user, VEHICLE_LOAD_DELAY,grabbed_mob,1,1,,1))
			return
	var/enter_result = enter_as_position(grabbed_mob,"passenger")
	if(enter_result == 0)
		to_chat(user,"<span class = 'notice'>Something stops you putting [grabbed_mob] in [src.name]'s passenger seat.</span>")
	return

/obj/vehicles/attackby(var/obj/item/I,var/mob/user)
	if(!istype(I))
		return
	if(istype(I,/obj/item/grab))
		handle_grab_attack(I,user)
	if(user.a_intent == I_HURT)
		return //TODO: SETUP HIT DAMAGE
	put_cargo_item(user,I)

#undef ALL_VEHICLE_POSITIONS
#undef VEHICLE_LOAD_DELAY
