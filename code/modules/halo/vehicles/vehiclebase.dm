
/obj/vehicles
	name = "Vehicle"
	desc = "Vehicle"
	density = 1
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER

	var/active = 1
	var/guns_disabled = 0
	var/movement_destroyed = 0
	var/block_enter_exit //Set this to block entering/exiting.

	//Advanced Damage Handling
	var/datum/component_profile/comp_prof = /datum/component_profile

	var/vehicle_move_delay = 1

	var/list/sprite_offsets = list("1" = list(0,0),"2" = list(0,0),"4" = list(0,0),"8" = list(0,0)) //Handled Directionally. Numbers correspond to directions

	//Passenger Management
	var/list/occupants = list(1,1) //Contains all occupants of the vehicle including the driver. First 2 values defines max passengers /gunners. Format: [MobRef] = [PositionName]
	var/list/passengers = list()
	var/list/exposed_positions = list("driver" = 0.0,"gunner" = 0.0,"passenger" = 0.0) //Assoc. Value is the chance of hitting this position

	//Cargo
	var/used_cargo_space = 0
	var/cargo_capacity = 0
	var/capacity_flag = ITEM_SIZE_SMALL
	var/list/cargo_contents = list()

	//Vehicle ferrying//
	var/vehicle_size = ITEM_SIZE_VEHICLE//The size of the vehicle, used by vehicle cargo ferrying to determine allowed amount and allowed size.
	var/vehicle_carry_size = 0		//the max size of a carried vehicle
	var/obj/vehicles/carried_vehicle

	var/vehicle_view_modifier = 1 //The view-size modifier to apply to the occupants of the vehicle.
	var/move_sound = null

	var/datum/mobile_spawn/spawn_datum //Setting this makes this a mobile spawn point.

	light_power = 4
	light_range = 6

/obj/vehicles/proc/mobile_spawn_check(var/mob/user)
	if(spawn_datum.is_spawn_active == 0 && (guns_disabled || movement_destroyed))
		to_chat(user,"<span class = 'notice'>[src] is too damaged to lock down.</span>")
		return 0
	if(block_enter_exit == 1)
		to_chat(user,"<span class = 'notice'>Cannot deploy in this current state.</span>")
		return 0
	return 1

/obj/vehicles/proc/toggle_mobile_spawn_deploy()
	set name = "Toggle Mobile Spawn Status"
	set category = "Vehicle"
	set src in view(1)
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!mobile_spawn_check(user))
		return
	visible_message("<span class = 'notice'>[user] starts preparing [src] to act as a mobile respawn point</span>")
	if(!do_after(user,10 SECONDS))
		return
	visible_message("<span class = 'notice'>[user] prepares [src] to act as a mobile respawn point</span>")
	set_mobile_spawn_deploy(!spawn_datum.is_spawn_active)

/obj/vehicles/proc/set_mobile_spawn_deploy(var/set_to)
	spawn_datum.is_spawn_active = set_to
	visible_message("<span class = 'notice'>[src] [spawn_datum.is_spawn_active ? "locks down" : "unlocks and readies for operation"]</span>")
	icon_state = "[initial(icon_state)]_deployed"
	if(spawn_datum.is_spawn_active)
		active = 0
	else
		active = 1

/obj/vehicles/verb/toggle_headlights()
	set name = "Toggle Headlights"
	set category = "Vehicle"
	set src in view(1)
	var/mob/living/user = usr
	if(!istype(user) || !(user in get_occupants_in_position("driver")))
		to_chat(user,"<span class = 'notice'>You must be the driver of [src] to toggle the headlights.</span>")
		return

	if(light_range == 0)
		to_chat(user,"<span class = 'notice'>You toggle [src]'s headlights on.</span>")
		set_light(initial(light_range))
	else
		to_chat(user,"<span class = 'notice'>You toggle [src]'s headlights off.</span>")
		set_light(0)

/obj/vehicles/New()
	. = ..()
	comp_prof = new comp_prof(src)
	GLOB.processing_objects += src
	update_object_sprites()
	if(light_range != 0)
		verbs += /obj/vehicles/verb/toggle_headlights
		set_light(0) //Switch off at spawn.
	cargo_capacity = base_storage_capacity(capacity_flag)

/obj/vehicles/Initialize()
	. = ..()
	if(spawn_datum)
		spawn_datum = new spawn_datum
		verbs += /obj/vehicles/proc/toggle_mobile_spawn_deploy

/obj/vehicles/attack_generic(var/mob/living/simple_animal/attacker,var/damage,var/text)
	visible_message("<span class = 'danger'>[attacker] [text] [src]</span>")
	var/pos_to_dam = should_damage_occ()
	if(!isnull(pos_to_dam))
		var/list/occ_list = get_occupants_in_position(pos_to_dam)
		if(isnull(occ_list) || !occ_list.len)
			return 1
		var/mob/mob_to_hit = pick(occ_list)
		if(isnull(mob_to_hit))
			return 1
		attacker.UnarmedAttack(mob_to_hit)
	comp_prof.take_component_damage(damage,"brute")

/obj/vehicles/examine(var/mob/user)
	. = ..()
	if(!active)
		to_chat(user,"[src]'s engine is inactive.")
	if(guns_disabled)
		to_chat(user,"[src]'s guns are damaged beyond use.")
	if(movement_destroyed)
		to_chat(user,"[src]'s movement is damaged beyond use.")
	if(cargo_capacity)
		if(!src.Adjacent(user))
			if(used_cargo_space > 0)
				to_chat(user,"<span>It looks like there is something in the cargo hold.</span>")
		else
			to_chat(user,"<span>It's cargo hold contains [used_cargo_space] of [cargo_capacity] units of cargo ([round(100*used_cargo_space/cargo_capacity)]% full).</span>")
	if(carried_vehicle)
		to_chat(user,"<span>It has a [carried_vehicle] mounted on it.</span>")

	show_occupants_contained(user)

/obj/vehicles/proc/pick_valid_exit_loc()
	var/list/valid_exit_locs = list()
	for(var/turf/t in locs)
		for(var/turf/t_2 in range(1,t))
			if(!(t_2 in locs) && t_2.density == 0)
				valid_exit_locs |= t
				break
	if(valid_exit_locs.len == 0)
		return null
	return pick(valid_exit_locs)

/obj/vehicles/Destroy()
	GLOB.processing_objects -= src
	. = ..()

/obj/vehicles/proc/on_death()
	explosion(loc,-1,-1,2,5)
	movement_destroyed = 1
	guns_disabled = 1
	icon_state = "[initial(icon_state)]_destroyed"
	if(spawn_datum)
		spawn_datum.is_spawn_active = 0

/obj/vehicles/proc/inactive_pilot_effects() //Overriden on a vehicle-by-vehicle basis.

/obj/vehicles/process()
	if(world.time % 3)
		comp_prof.give_gunner_weapons(src)
		update_object_sprites()
		if(active)
			var/list/drivers = get_occupants_in_position("driver")
			if(!drivers.len || isnull(drivers) || movement_destroyed)
				inactive_pilot_effects()
	if(spawn_datum)
		spawn_datum.process_resource_regen()

/obj/vehicles/proc/update_object_sprites() //This is modified on a vehicle-by-vehicle basis to render mobsprites etc, a basic render of playerheads in the top right is used if no overidden.
	underlays.Cut()
	overlays.Cut()
	var/occupant_counter = 0
	for(var/mob/living/carbon/human/h in occupants)
		occupant_counter++
		var/gender_suffix = "m"
		if(h.gender == "female")
			gender_suffix = "f"
		var/image/head_bg = image('code/modules/halo/vehicles/headrep_base.dmi',"base")
		var/image/mob_head = image(h.species.icobase,icon_state = "head_[gender_suffix]",dir = SOUTH)
		var/shift_by
		if(occupant_counter*9 >= bound_width) //Don't bother with more than one line of heads
			return
		if(occupant_counter*9 >= bound_width/2) //Handles basic occupant representation by creating small images of their heads and then shifting them in the top left corner of the icon.
			shift_by = (occupant_counter*9) - 16 //*9 multiplier is applied to lower the amount of overlap on the head icons.
		else
			shift_by = -16 + (occupant_counter*9)
		var/icon/mob_head_icon = new(mob_head.icon,mob_head.icon_state,SOUTH)
		var/extra_shiftby_y = 0
		if(mob_head_icon.Height() > 32)
			extra_shiftby_y = mob_head_icon.Height() - 32
		mob_head.pixel_y = ((bound_height-(32 + extra_shiftby_y)) + 3) + h.species.pixel_offset_y
		head_bg.pixel_y = (bound_height-32) + 3 + h.species.pixel_offset_y
		mob_head.pixel_x = shift_by + h.species.pixel_offset_x
		head_bg.pixel_x = shift_by + h.species.pixel_offset_x
		overlays += head_bg
		overlays += mob_head

/obj/vehicles/Move()
	if(anchored)
		anchored = 0
		. = ..()
		anchored = 1
	else
		. = ..()
	update_object_sprites()

/obj/vehicles/bullet_act(var/obj/item/projectile/P, var/def_zone)
	var/pos_to_dam = should_damage_occ()
	var/mob/mob_to_dam
	if(movement_destroyed)
		var/list/mobs = list()
		for(var/mob/m in occupants)
			mobs += m
		if(mobs.len == 0)
			return
		mob_to_dam = pick(mobs)
		if(!isnull(mob_to_dam))
			mob_to_dam.bullet_act(P)
			return
	if(!isnull(pos_to_dam))
		var/should_continue = damage_occupant(pos_to_dam,P)
		if(!should_continue)
			return
	comp_prof.take_component_damage(P.get_structure_damage(),P.damtype)
	visible_message("<span class = 'danger'>[P] hits [src]!</span>")

/obj/vehicles/ex_act(var/severity)
	comp_prof.take_comp_explosion_dam(severity)
	for(var/position in exposed_positions)
		for(var/mob/living/m in get_occupants_in_position(position))
			m.apply_damage((250/severity)*(exposed_positions[position]/100),BRUTE,,m.run_armor_check(null,"bomb"))

//TODO: REIMPLEMENT SPEED BASED MOVEMENT
/obj/vehicles/relaymove(var/mob/user, var/direction)
	if(movement_destroyed)
		to_chat(user,"<span class = 'notice'>[src] is in no state to move!</span>")
		return
	if(!active)
		to_chat(user,"<span class = 'notice'>[src] needs to be active to move!</span>")
		return
	var/turf/new_loc = get_step(src.loc,direction)
	var/list/driver_list = get_occupants_in_position("driver")
	var/is_driver = FALSE
	for(var/mob/driver in driver_list)
		if(user == driver)
			is_driver = TRUE
			break
	if(!is_driver)
		return
	. = Move(new_loc,direction)
	if(move_sound && world.time % 2 == 0)
		playsound(loc,move_sound,75,0,4)
	user.client.move_delay = world.time + vehicle_move_delay

/obj/vehicles/verb/verb_inspect_components()
	set name = "Inspect Components"
	set category = "Vehicle"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return

	comp_prof.inspect_components(user)

/obj/vehicles/attack_hand(var/mob/user)
	if(user.a_intent != "harm")
		if(spawn_datum && spawn_datum.is_spawn_active == 1)
			spawn_datum.handle_requisition(user,src)
		else
			if(!enter_as_position(user,"driver"))
				if(!enter_as_position(user,"gunner"))
					enter_as_position(user,"passenger")
	else
		. = ..()

/obj/vehicles/attack_ghost(var/mob/observer/ghost/user)
	if(spawn_datum && spawn_datum.is_spawn_active)
		spawn_datum.handle_spawn(user,src)

/obj/vehicles/attackby(var/obj/item/I,var/mob/user)
	if(elevation > user.elevation || elevation > I.elevation)
		to_chat(user,"<span class = 'notice'>[name] is too far away to interact with!</span>")
		return
	if(!istype(I))
		return
	if(istype(I,/obj/item/grab))
		handle_grab_attack(I,user)
		return
	if(user.a_intent == I_HURT)
		if(comp_prof.is_repair_tool(I))
			comp_prof.repair_inspected_with_tool(I,user)
			return
		if(istype(I,/obj/item/stack))
			comp_prof.repair_inspected_with_sheet(I,user)
			return
		. = ..()
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		var/pos_to_dam = should_damage_occ()
		if(!isnull(pos_to_dam))
			damage_occupant(pos_to_dam,I,user)
			return
		comp_prof.take_component_damage(I.force,I.damtype)
		return
	put_cargo_item(user,I)
