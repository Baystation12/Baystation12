/obj/machinery/foodgrill
	name = "Grill"
	icon = 'icons/obj/cooking_machines.dmi'
	desc = "Backyard grilling, IN SPACE."
	icon_state = "grill_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = 0 // Is it grilling food already?

/obj/machinery/foodgrill/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(on)
		user << "The machine is already processing, please wait."
		return
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/))
		var/obj/item/weapon/reagent_containers/food/snacks/food = O
		user << "You put [food] onto [src]."
		on = 1
		user.drop_item()
		food.loc = src
		O.loc = src
		icon_state = "grill_on"
		var/image/I = new(food.icon, food.icon_state)
		I.pixel_y = 5
		overlays += I
		sleep(200)
		overlays.Cut()
		I.color = "#754719"
		I.pixel_y = 5
		overlays += I
		world << "stage 1"
		sleep(200)
		overlays.Cut()
		I.color = "#522900"
		I.pixel_y = 5
		overlays += I
		sleep(50)
		overlays.Cut()
		on = 0
		icon_state = "grill_off"
		O.reagents.del_reagent("rawfood")
		O.reagents.add_reagent("nutriment", 10)
		O.loc = get_turf(src)
		O.loc = get_turf(src)
		O.color = "#522900"
		var/tempname = O.name
		O.name = "grilled [tempname]"
		return