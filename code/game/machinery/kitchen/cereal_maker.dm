/obj/machinery/cerealmaker
	name = "Cereal Maker"
	icon = 'icons/obj/cooking_machines.dmi'
	desc = "Now with Dann O's available!"
	icon_state = "cereal_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = 0 // Is it making cereal already?

/obj/machinery/cerealmaker/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(on)
		user << "The machine is already processing, please wait."
		return
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/))
		var/obj/item/weapon/reagent_containers/food/snacks/food = O
		user << "You put [food] into [src]."
		on = 1
		user.drop_item()
		food.loc = src
		O.loc = src
		icon_state = "cereal_on"
		sleep(200)
		icon_state = "cereal_off"
		var/obj/item/weapon/reagent_containers/food/snacks/cereal/S = new(get_turf(src))
		var/image/I = new(food.icon, food.icon_state)
		I.transform *= 0.7
		S.color = food.filling_color
		food.reagents.trans_to(S, food.reagents.total_volume)
		S.overlays += I
		S.name = "box of [food] cereal"
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		on = 0
		del(food)
		return

