/obj/item/weapon/reagent_containers/kitchen/mixingbowl
	name = "mixing bowl"
	desc = "A valuable aid in mixing things."
	icon_state = "mixingbowl"
	max_items = 4
	processes = 0
	cooking_method = METHOD_MIXING

/obj/item/weapon/reagent_containers/kitchen/mixingbowl/recieve_heat()
	return

// Creates a 'mix' object that can be transferred to other containers.
/obj/item/weapon/reagent_containers/kitchen/mixingbowl/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg) && is_open_container() && O.reagents)
		user << "You crack \the [O] into \the [src]."
		O.reagents.trans_to(src, O.reagents.total_volume)
		user.drop_from_inventory(O)
		qdel(O)
		return
	else if(istype(O,/obj/item/weapon/material/kitchen))
		stirred(user,O)
		return
	return ..(O, user)

/obj/item/weapon/reagent_containers/kitchen/mixingbowl/proc/stirred(var/mob/user, var/obj/item/weapon/O)
	var/turf/T = get_turf(src)
	if(!(contents || (reagents && reagents.total_volume)))
		user << "<span class='notice'>There is nothing else to mix in \the [src].</span>"
		return
	T.visible_message("<span class='notice'>\The [user] briskly stirs \the [src] with \the [O].")
	var/datum/food_transition/F = get_food_transition(null, cooking_method, 0, reagents, src)
	if(F)
		// Clear out the reagent list if they were used up by something being cooked.
		for(var/reagent_tag in F.req_reagents)
			reagents.remove_reagent(reagent_tag,F.req_reagents[reagent_tag])
		// Make the food object.
		var/obj/item/food = F.get_output_product(src)
		food.loc = src
		T.visible_message("\The [food] in \the [src] [F.cooking_message ? F.cooking_message : "is ready"].")
	else
		var/obj/item/weapon/reagent_containers/food/snacks/ingredient_mix/D = locate() in src.contents
		if(!D)
			user << "<span class='warning'>There's nothing in \the [src] that will mix together.</span>"
			return
		var/added_something
		if(reagents && reagents.total_volume)
			reagents.trans_to_obj(D, reagents.total_volume)
			added_something = 1
		for(var/obj/item/I in src.contents)
			if(I == D)
				continue
			if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/ingredient_mix))
				for(var/obj/item/subitem in I.contents)
					subitem.loc = D
					qdel(subitem)
				qdel(I)
			else
				I.loc = D
			added_something = 1
		if(added_something)
			T.visible_message("<span class='notice'>\The [user] folds the contents of \the [src] into \the [D].</span>")
			D.update_from_contents()
		else
			user << "<span class='warning'>There's nothing else to mix in \the [src].</span>"
		return