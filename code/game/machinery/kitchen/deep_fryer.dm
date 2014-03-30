/obj/machinery/deepfryer
	name = "Deep Fryer"
	icon = 'icons/obj/cooking_machines.dmi'
	desc = "Deep fried /everything/."
	icon_state = "fryer_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = 0 // Is it deep frying already?

/obj/machinery/deepfryer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(on)
		user << "The machine is already active, please wait."
		return
	if(!emagged && istype(O, /obj/item/weapon/card/emag/))
		user << "You emag the Deep Fryer, disabling it's Anti-Non-Foods lock."
		emagged = 1
		return
	if(emagged)
		var/obj/item/object = O
		user << "You put [object] into [src]."
		on = 1
		user.drop_item()
		object.loc = src
		O.loc = src
		icon_state = "fryer_on"
		sleep(200)
		icon_state = "fryer_off"
		on = 0
		var/obj/item/weapon/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
		if(istype(O, /obj/item/weapon/reagent_containers/))
			var/obj/item/weapon/reagent_containers/food/snacks/food = object
			food.reagents.trans_to(S, food.reagents.total_volume)
			del(food)
		S.color = "#FFAD33"
		S.filling_color = "#FFAD33"
		S.icon = object.icon
		S.icon_state = object.icon_state
		S.name = "deep fried [object.name]"
		S.desc = object.desc
		if(emagged)
			S.reagents.add_reagent("notfood", 2)
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		del(O)
		del(object)
		return
	else if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/))
		var/obj/item/weapon/reagent_containers/food/snacks/food = O
		if(food.deepfried)
			user << "You have not yet learned the majestic Recursive Frying Technique."
			return
		user << "You put [food] into [src]."
		on = 1
		user.drop_item()
		food.loc = src
		O.loc = src
		icon_state = "fryer_on"
		sleep(200)
		icon_state = "fryer_off"
		on = 0
		var/obj/item/weapon/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
		food.reagents.trans_to(S, food.reagents.total_volume)
		S.color = "#FFAD33"
		S.filling_color = "#FFAD33"
		S.icon = food.icon
		S.icon_state = food.icon_state
		S.name = "deep fried [food.name]"
		S.desc = food.desc
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		del(food)
		del(O)
		return