/obj/item/weapon/engine
	name = "engine"
	desc = "An engine used to power a small vehicle."
	icon = 'icons/obj/objects.dmi'
	w_class = ITEM_SIZE_HUGE
	var/stat = 0
	var/trail_type
	var/cost_per_move = 5

/obj/item/weapon/engine/proc/get_trail()
	if(trail_type)
		return new trail_type
	return null

/obj/item/weapon/engine/proc/prefill()
	return

/obj/item/weapon/engine/proc/use_power()
	return 0

/obj/item/weapon/engine/proc/rev_engine(var/atom/movable/M)
	return

/obj/item/weapon/engine/proc/putter(var/atom/movable/M)
	return

/obj/item/weapon/engine/electric
	name = "electric engine"
	desc = "A battery-powered engine used to power a small vehicle."
	icon_state = "engine_electric"
	trail_type = /datum/effect/effect/system/trail/ion
	cost_per_move = 200	// W
	var/obj/item/weapon/cell/cell

/obj/item/weapon/engine/electric/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/weapon/cell))
		if(cell)
			to_chat(user, "<span class='warning'>There is already a cell in \the [src].</span>")
		else
			cell = I
			user.drop_from_inventory(I)
			I.forceMove(src)
		return 1
	else if(istype(I,/obj/item/weapon/crowbar))
		if(cell)
			to_chat(user, "You pry out \the [cell].")
			cell.forceMove(get_turf(src))
			cell = null
			return 1
	..()

/obj/item/weapon/engine/electric/prefill()
	cell = new /obj/item/weapon/cell/high(src.loc)

/obj/item/weapon/engine/electric/use_power()
	if(!cell)
		return 0
	return cell.use(cost_per_move * CELLRATE)

/obj/item/weapon/engine/electric/rev_engine(var/atom/movable/M)
	M.audible_message("\The [M] beeps, spinning up.")

/obj/item/weapon/engine/electric/putter(var/atom/movable/M)
	M.audible_message("\The [M] makes one depressed beep before winding down.")

/obj/item/weapon/engine/electric/emp_act(var/severity)
	if(cell)
		cell.emp_act(severity)
	..()

/obj/item/weapon/engine/thermal
	name = "thermal engine"
	desc = "A fuel-powered engine used to power a small vehicle."
	icon_state = "engine_fuel"
	trail_type = /datum/effect/effect/system/trail/thermal
	flags = OPENCONTAINER
	var/obj/temp_reagents_holder
	var/fuel_points = 0
	//fuel points are determined by differing reagents

/obj/item/weapon/engine/thermal/prefill()
	fuel_points = 5000

/obj/item/weapon/engine/thermal/Initialize()
	. = ..()
	create_reagents(500)
	temp_reagents_holder = new()
	temp_reagents_holder.create_reagents(15)
	temp_reagents_holder.flags |= OPENCONTAINER

/obj/item/weapon/engine/thermal/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/weapon/reagent_containers) && I.is_open_container())
		if(istype(I,/obj/item/weapon/reagent_containers/food/snacks) || istype(I,/obj/item/weapon/reagent_containers/pill))
			return 0
		var/obj/item/weapon/reagent_containers/C = I
		C.standard_pour_into(user,src)
		return 1
	..()

/obj/item/weapon/engine/thermal/use_power()
	if(fuel_points >= cost_per_move)
		fuel_points -= cost_per_move
		return 1
	if(!reagents || reagents.total_volume <= 0 || stat)
		return 0

	reagents.trans_to(temp_reagents_holder,min(reagents.total_volume,15))
	var/multiplier = 1
	var/actually_flameable = 0
	for(var/datum/reagent/R in temp_reagents_holder.reagents.reagent_list)
		var/new_multiplier = 1
		if(istype(R,/datum/reagent/ethanol))
			var/datum/reagent/ethanol/E = R
			new_multiplier = (10/E.strength)
			actually_flameable = 1
		else if(istype(R,/datum/reagent/hydrazine))
			new_multiplier = 1.25
			actually_flameable = 1
		else if(istype(R,/datum/reagent/fuel))
			actually_flameable = 1
		else if(istype(R,/datum/reagent/toxin/phoron))
			new_multiplier = 2
			actually_flameable = 1
		else if(istype(R,/datum/reagent/frostoil))
			new_multiplier = 0.1
		else if(istype(R,/datum/reagent/water))
			new_multiplier = 0.4
		else if(istype(R,/datum/reagent/sugar)  && R.volume > 1)
			stat = DEAD
			explosion(get_turf(src),-1,0,2,3,0)
			return 0
		multiplier = (multiplier + new_multiplier)/2
	if(!actually_flameable)
		return 0
	fuel_points += 20 * multiplier * temp_reagents_holder.reagents.total_volume
	temp_reagents_holder.reagents.clear_reagents()
	return use_power()

/obj/item/weapon/engine/thermal/rev_engine(var/atom/movable/M)
	M.audible_message("\The [M] rumbles to life.")

/obj/item/weapon/engine/electric/putter(var/atom/movable/M)
	M.audible_message("\The [M] putters before turning off.")