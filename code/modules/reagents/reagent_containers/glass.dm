
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/glass
	name = " "
	var/base_name = " "
	desc = ""
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;60"
	volume = 60
	w_class = ITEM_SIZE_SMALL
	flags = OPENCONTAINER
	unacidable = 1 //glass doesn't dissolve in acid


	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/weapon/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/item/weapon/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/weapon/storage/secure/safe,
		/obj/machinery/iv_drip,
		/obj/machinery/disease2/incubator,
		/obj/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/machinery/computer/centrifuge,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/machinery/constructable_frame,
		/obj/machinery/radiocarbon_spectrometer
		)

	Initialize()
		. = ..()
		base_name = name

	examine(var/mob/user)
		if(!..(user, 2))
			return
		if(reagents && reagents.reagent_list.len)
			to_chat(user, "<span class='notice'>It contains [reagents.total_volume] units of liquid.</span>")
		else
			to_chat(user, "<span class='notice'>It is empty.</span>")
		if(!is_open_container())
			to_chat(user, "<span class='notice'>Airtight lid seals it completely.</span>")

	attack_self()
		..()
		if(is_open_container())
			to_chat(usr, "<span class = 'notice'>You put the lid on \the [src].</span>")
			flags ^= OPENCONTAINER
		else
			to_chat(usr, "<span class = 'notice'>You take the lid off \the [src].</span>")
			flags |= OPENCONTAINER
		update_icon()

	do_surgery(mob/living/carbon/M, mob/living/user)
		if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
			return ..()
		afterattack(M, user, 1)
		return 1

	afterattack(var/obj/target, var/mob/user, var/proximity)

		if(!is_open_container() || !proximity)
			return

		for(var/type in can_be_placed_into)
			if(istype(target, type))
				return

		if(standard_splash_mob(user, target))
			return
		if(standard_dispenser_refill(user, target))
			return
		if(standard_pour_into(user, target))
			return

		if(reagents.total_volume)
			to_chat(user, "<span class='notice'>You splash the solution onto [target].</span>")
			reagents.splash(target, reagents.total_volume)
			return

/obj/item/weapon/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	center_of_mass = "x=15;y=10"
	matter = list("glass" = 500)

	Initialize()
		. = ..()
		desc += " Can hold up to [volume] units."

	on_reagent_change()
		update_icon()

	pickup(mob/user)
		..()
		ADD_ICON_QUEUE(src)

	dropped(mob/user)
		..()
		ADD_ICON_QUEUE(src)

	attack_hand()
		..()
		update_icon()

	update_icon()
		overlays.Cut()

		if(reagents.total_volume)
			var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

			var/percent = round((reagents.total_volume / volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "[icon_state]-10"
				if(10 to 24) 	filling.icon_state = "[icon_state]10"
				if(25 to 49)	filling.icon_state = "[icon_state]25"
				if(50 to 74)	filling.icon_state = "[icon_state]50"
				if(75 to 79)	filling.icon_state = "[icon_state]75"
				if(80 to 90)	filling.icon_state = "[icon_state]80"
				if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

			filling.color = reagents.get_color()
			overlays += filling

		if (!is_open_container())
			var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
			overlays += lid

/obj/item/weapon/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	center_of_mass = "x=16;y=10"
	matter = list("glass" = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;60;120"
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	center_of_mass = "x=16;y=8"
	matter = list("glass" = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	flags = OPENCONTAINER | NOREACT

/obj/item/weapon/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	center_of_mass = "x=16;y=10"
	matter = list("glass" = 5000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;60;120;300"
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	center_of_mass = "x=15;y=8"
	matter = list("glass" = 250)
	volume = 30
	w_class = ITEM_SIZE_TINY //half the volume of a bottle, half the size
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25"
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone
	New()
		..()
		reagents.add_reagent("cryoxadone", 30)
		update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/sulphuric
	New()
		..()
		reagents.add_reagent("sacid", 60)
		update_icon()

/obj/item/weapon/reagent_containers/glass/bucket
	desc = "It's a bucket."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	center_of_mass = "x=16;y=9"
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = "10;20;30;60;120"
	volume = 120
	flags = OPENCONTAINER
	unacidable = 0

/obj/item/weapon/reagent_containers/glass/bucket/attackby(var/obj/D, mob/user as mob)

	if(isprox(D))
		to_chat(user, "You add [D] to [src].")
		qdel(D)
		user.put_in_hands(new /obj/item/weapon/bucket_sensor)
		user.drop_from_inventory(src)
		qdel(src)
		return
	else if(istype(D, /obj/item/weapon/mop))
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='warning'>\The [src] is empty!</span>")
		else
			reagents.trans_to_obj(D, 5)
			to_chat(user, "<span class='notice'>You wet \the [D] in \the [src].</span>")
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		return ..()

/obj/item/weapon/reagent_containers/glass/bucket/update_icon()
	overlays.Cut()
	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/*
/obj/item/weapon/reagent_containers/glass/blender_jug
	name = "Blender Jug"
	desc = "A blender jug, part of a blender."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "blender_jug_e"
	volume = 100

	on_reagent_change()
		switch(src.reagents.total_volume)
			if(0)
				icon_state = "blender_jug_e"
			if(1 to 75)
				icon_state = "blender_jug_h"
			if(76 to 100)
				icon_state = "blender_jug_f"

/obj/item/weapon/reagent_containers/glass/canister		//not used apparantly
	desc = "It's a canister. Mainly used for transporting fuel."
	name = "canister"
	icon = 'icons/obj/tank.dmi'
	icon_state = "canister"
	item_state = "canister"
	m_amt = 300
	g_amt = 0
	w_class = ITEM_SIZE_HUGE

	amount_per_transfer_from_this = 20
	possible_transfer_amounts = "10;20;30;60"
	volume = 120
*/
