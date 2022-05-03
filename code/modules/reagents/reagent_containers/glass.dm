
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/glass
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
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = TRUE


	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master,
		/obj/machinery/chem_master/condimaster,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/hygiene/sink,
		/obj/item/storage,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/item/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/storage/secure/safe,
		/obj/structure/iv_drip,
		/obj/machinery/disposal,
		/mob/living/simple_animal/passive/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge,
		/obj/machinery/biogenerator,
		/obj/machinery/constructable_frame,
		/obj/machinery/radiocarbon_spectrometer
	)

/obj/item/reagent_containers/glass/New()
	..()
	base_name = name

/obj/item/reagent_containers/glass/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return

	if(reagents && reagents.reagent_list.len)
		to_chat(user, "<span class='notice'>It contains [reagents.total_volume] units of liquid.</span>")
	else
		to_chat(user, "<span class='notice'>It is empty.</span>")
	if(!is_open_container())
		to_chat(user, "<span class='notice'>The airtight lid seals it completely.</span>")

/obj/item/reagent_containers/glass/attack_self()
	..()
	if(is_open_container())
		to_chat(usr, "<span class = 'notice'>You put the lid on \the [src].</span>")
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	else
		to_chat(usr, "<span class = 'notice'>You take the lid off \the [src].</span>")
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	update_icon()

/obj/item/reagent_containers/glass/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(item_flags & ITEM_FLAG_NO_BLUDGEON) && user.a_intent == I_HURT)
		return	..()
	if(standard_feed_mob(user, M))
		return
	return 0

/obj/item/reagent_containers/glass/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to open \the [src] first.</span>")
		return 1
	if(user.a_intent == I_HURT)
		return 1
	return ..()

/obj/item/reagent_containers/glass/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow a gulp from \the [src].</span>")
	if(user.has_personal_goal(/datum/goal/achievement/specific_object/drink))
		for(var/datum/reagent/R in reagents.reagent_list)
			user.update_personal_goal(/datum/goal/achievement/specific_object/drink, R.type)

/obj/item/reagent_containers/glass/throw_impact(atom/hit_atom)
	if (QDELETED(src))
		return
	if (!LAZYISIN(matter, MATERIAL_GLASS))
		return

	if (prob(80))
		if (reagents.reagent_list.len > 0)
			visible_message(
				SPAN_DANGER("\The [src] shatters from the impact and spills all its contents!"),
				SPAN_DANGER("You hear the sound of glass shattering!")
			)
			reagents.splash(hit_atom, reagents.total_volume)
		else
			visible_message(
				SPAN_DANGER("\The [src] shatters from the impact!"),
				SPAN_DANGER("You hear the sound of glass shattering!")
			)
		playsound(src.loc, pick(GLOB.shatter_sound), 100)
		new /obj/item/material/shard(src.loc)
		qdel(src)
	else
		if (reagents.reagent_list.len > 0)
			visible_message(
				SPAN_DANGER("\The [src] bounces and spills all its contents!"),
				SPAN_WARNING("You hear the sound of glass hitting something.")
			)
			reagents.splash(hit_atom, reagents.total_volume)
		else
			visible_message(
				SPAN_WARNING("\The [src] bounces dangerously. Luckily it didn't break."),
				SPAN_WARNING("You hear the sound of glass hitting something.")
			)
		playsound(src.loc, "sound/effects/Glasshit.ogg", 50)

/obj/item/reagent_containers/glass/afterattack(obj/target, mob/user, proximity)
	if (!proximity || (target.type in can_be_placed_into) || standard_dispenser_refill(user, target) || standard_pour_into(user, target))
		return TRUE
	splashtarget(target, user)


/obj/item/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	center_of_mass = "x=15;y=10"
	matter = list(MATERIAL_GLASS = 500)


/obj/item/reagent_containers/glass/beaker/New()
	..()
	desc += " It can hold up to [volume] units."


/obj/item/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()


/obj/item/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	update_icon()


/obj/item/reagent_containers/glass/beaker/attack_hand()
	..()
	update_icon()


/obj/item/reagent_containers/glass/beaker/on_update_icon()
	overlays.Cut()
	if (reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if (0 to 9)
				filling.icon_state = "[icon_state]-10"
			if (10 to 24)
				filling.icon_state = "[icon_state]10"
			if (25 to 49)
				filling.icon_state = "[icon_state]25"
			if (50 to 74)
				filling.icon_state = "[icon_state]50"
			if (75 to 79)
				filling.icon_state = "[icon_state]75"
			if (80 to 90)
				filling.icon_state = "[icon_state]80"
			if (91 to INFINITY)
				filling.icon_state = "[icon_state]100"
		filling.color = reagents.get_color()
		overlays += filling
	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid


/obj/item/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	center_of_mass = "x=16;y=10"
	matter = list(MATERIAL_GLASS = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;60;120"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/glass/beaker/bowl
	name = "mixing bowl"
	desc = "A large mixing bowl."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mixingbowl"
	center_of_mass = "x=16;y=10"
	matter = list(MATERIAL_STEEL = 300)
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;60;180"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = FALSE

/obj/item/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	center_of_mass = "x=16;y=8"
	matter = list(MATERIAL_GLASS = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT

/obj/item/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	center_of_mass = "x=16;y=10"
	matter = list(MATERIAL_GLASS = 5000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;60;120;150;200;250;300"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	center_of_mass = "x=15;y=8"
	matter = list(MATERIAL_GLASS = 250)
	volume = 30
	w_class = ITEM_SIZE_TINY //half the volume of a bottle, half the size
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;30"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/glass/beaker/insulated
	name = "insulated beaker"
	desc = "A glass beaker surrounded with black insulation."
	icon_state = "insulated"
	center_of_mass = "x=15;y=8"
	matter = list(MATERIAL_GLASS = 500, MATERIAL_PLASTIC = 250)
	possible_transfer_amounts = "5;10;15;30"
	atom_flags = null
	temperature_coefficient = 1

/obj/item/reagent_containers/glass/beaker/insulated/large
	name = "large insulated beaker"
	icon_state = "insulatedlarge"
	center_of_mass = "x=16;y=10"
	matter = list(MATERIAL_GLASS = 5000, MATERIAL_PLASTIC = 2500)
	volume = 120


/obj/item/reagent_containers/glass/beaker/cryoxadone/New()
	..()
	reagents.add_reagent(/datum/reagent/cryoxadone, 30)
	update_icon()


/obj/item/reagent_containers/glass/beaker/sulphuric/New()
	..()
	reagents.add_reagent(/datum/reagent/acid, 60)
	update_icon()


/obj/item/reagent_containers/glass/bucket
	name = "bucket"
	desc = "It's a bucket."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	center_of_mass = "x=16;y=9"
	matter = list(MATERIAL_PLASTIC = 280)
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = "10;20;30;60;120;150;180"
	volume = 180
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = FALSE

/obj/item/reagent_containers/glass/bucket/wood
	name = "bucket"
	desc = "It's a wooden bucket. How rustic."
	icon_state = "wbucket"
	item_state = "wbucket"
	matter = list(MATERIAL_WOOD = 280)
	volume = 200

/obj/item/reagent_containers/glass/bucket/attackby(var/obj/D, mob/user as mob)
	if(istype(D, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='warning'>\The [src] is empty!</span>")
		else
			reagents.trans_to_obj(D, 5)
			to_chat(user, "<span class='notice'>You wet \the [D] in \the [src].</span>")
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		return ..()

/obj/item/reagent_containers/glass/bucket/on_update_icon()
	overlays.Cut()
	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid
	else if(reagents.total_volume && round((reagents.total_volume / volume) * 100) > 80)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "bucket")
		filling.color = reagents.get_color()
		overlays += filling

/*
/obj/item/reagent_containers/glass/blender_jug
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

/obj/item/reagent_containers/glass/canister		//not used apparantly
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
