/obj/item/storage/box/bloodpacks
	name = "blood packs box"
	desc = "This box contains blood packs."
	icon_state = "sterile"
	startswith = list(/obj/item/reagent_containers/ivbag = 7)

/obj/item/reagent_containers/ivbag
	name = "\improper IV bag"
	desc = "Flexible bag for IV injectors."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	w_class = ITEM_SIZE_TINY
	volume = 120
	possible_transfer_amounts = "0.2;1;2"
	amount_per_transfer_from_this = REM
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	var/mob/living/carbon/human/attached

/obj/item/reagent_containers/ivbag/Destroy()
	STOP_PROCESSING(SSobj,src)
	attached = null
	. = ..()

/obj/item/reagent_containers/ivbag/on_reagent_change()
	update_icon()
	if(reagents.total_volume > volume/2)
		w_class = ITEM_SIZE_SMALL
	else
		w_class = ITEM_SIZE_TINY

/obj/item/reagent_containers/ivbag/on_update_icon()
	overlays.Cut()
	var/percent = round(reagents.total_volume / volume * 100)
	if(reagents.total_volume)
		var/image/filling = image('icons/obj/bloodpack.dmi', "[round(percent,25)]")
		filling.color = reagents.get_color()
		overlays += filling
	overlays += image('icons/obj/bloodpack.dmi', "top")
	if(attached)
		overlays += image('icons/obj/bloodpack.dmi', "dongle")

/obj/item/reagent_containers/ivbag/MouseDrop(over_object, src_location, over_location)
	if(!CanMouseDrop(over_object))
		return
	if(!ismob(loc))
		return
	if(attached)
		visible_message("\The [attached] is taken off \the [src]")
		attached = null
	else if(ishuman(over_object))
		if(do_IV_hookup(over_object, usr, src))
			attached = over_object
			START_PROCESSING(SSobj,src)
	update_icon()

/obj/item/reagent_containers/ivbag/Process()
	if(!ismob(loc))
		return PROCESS_KILL

	if(attached)
		if(!loc.Adjacent(attached))
			attached = null
			visible_message("\The [attached] detaches from \the [src]")
			update_icon()
			return PROCESS_KILL
	else
		return PROCESS_KILL

	var/mob/M = loc
	if(M.l_hand != src && M.r_hand != src)
		return

	if(!reagents.total_volume)
		return

	reagents.trans_to_mob(attached, amount_per_transfer_from_this, CHEM_BLOOD)
	update_icon()

/obj/item/reagent_containers/ivbag/nanoblood/New()
	..()
	reagents.add_reagent(/datum/reagent/nanoblood, volume)

/obj/item/reagent_containers/ivbag/blood
	name = "blood pack"
	var/blood_type = null

/obj/item/reagent_containers/ivbag/blood/New()
	..()
	if(blood_type)
		name = "blood pack [blood_type]"
		reagents.add_reagent(/datum/reagent/blood, volume, list("donor" = null, "blood_DNA" = null, "blood_type" = blood_type, "trace_chem" = null))

/obj/item/reagent_containers/ivbag/blood/APlus
	blood_type = "A+"

/obj/item/reagent_containers/ivbag/blood/AMinus
	blood_type = "A-"

/obj/item/reagent_containers/ivbag/blood/BPlus
	blood_type = "B+"

/obj/item/reagent_containers/ivbag/blood/BMinus
	blood_type = "B-"

/obj/item/reagent_containers/ivbag/blood/OPlus
	blood_type = "O+"

/obj/item/reagent_containers/ivbag/blood/OMinus
	blood_type = "O-"
