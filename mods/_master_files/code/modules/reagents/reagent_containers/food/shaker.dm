/obj/item/reagent_containers/food/drinks/use_after(obj/target, mob/user)
	. = ..()
	if (!.)
		splashtarget(target, user)
		return TURE
