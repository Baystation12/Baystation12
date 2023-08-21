
/obj/item/reagent_containers/food/drinks/afterattack(obj/target, mob/user, proximity)
	if (!proximity || standard_dispenser_refill(user, target) || standard_pour_into(user, target))
		return TRUE
	splashtarget(target, user)
