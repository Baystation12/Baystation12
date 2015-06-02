/obj/item/weapon/dish
	name = "dish"
	icon = 'icons/obj/kitchen/inedible/tools.dmi'
	var/tip_word = "onto"

/obj/item/weapon/dish/New()
	..()
	create_reagents(30)

/obj/item/weapon/dish/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/weapon/reagent_containers/kitchen))
		var/obj/item/weapon/reagent_containers/kitchen/K = O
		if(!K.contents.len && !K.reagents.total_volume)
			return ..()
		for(var/obj/item/I in K.contents)
			I.loc = get_turf(src)
		K.reagents.trans_to_obj(src,K.reagents.total_volume)
		user.visible_message("<span class='notice'>\The [user] tips the contents of \the [K] [tip_word] \the [src].</span>")
		return
	return ..()

/obj/item/weapon/dish/plate
	name = "plate"
	desc = "A simple plate."
	icon_state = "plate"

/obj/item/weapon/dish/bowl
	name = "bowl"
	desc = "A simple bowl."
	icon_state = "bowl"
	tip_word = "into"

/obj/item/weapon/dish/tray
	name = "tray"
	desc = "A simple tray."
	icon_state = "tray"
	tip_word = "into"
