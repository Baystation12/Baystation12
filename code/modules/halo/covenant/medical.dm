//Medkits

/obj/item/weapon/storage/firstaid/erk/cov
	desc = "A hull breach kit for Covenant damage control teams. It appears to be bulkier than general medical kits."
	icon = 'code/modules/halo/covenant/medical.dmi'
	icon_state = "purplefirstaid"

/obj/item/weapon/storage/firstaid/unsc/cov
	name = "Covenant medkit"
	desc = "A general medical kit for Covenant personnel and installations."
	icon = 'code/modules/halo/covenant/medical.dmi'
	icon_state = "purplefirstaid"

/obj/item/weapon/storage/firstaid/combat/unsc/cov
	icon = 'code/modules/halo/covenant/medical.dmi'
	icon_state = "purplefirstaid"


//Sleepers & Body Scanners

/obj/machinery/sleeper/covenant
	icon = 'code/modules/halo/covenant/medical.dmi'

/obj/machinery/bodyscanner/covenant
	icon = 'code/modules/halo/covenant/medical.dmi'

/obj/machinery/body_scanconsole/covenant
	name = "Body Scanner Console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = 1


/obj/machinery/body_scanconsole/covenant/New()
	. = ..()
	spawn( 5 )
		src.connected = locate(/obj/machinery/bodyscanner/covenant, get_step(src, WEST))
		return
	return


//Roller Beds

/obj/structure/bed/roller/covenant
	icon = 'code/modules/halo/covenant/medical.dmi'

/obj/structure/bed/roller/covenant/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench) || istype(W,/obj/item/stack) || istype(W, /obj/item/weapon/wirecutters))
		return
	else if(istype(W,/obj/item/roller_holder))
		if(buckled_mob)
			user_unbuckle_mob(user)
		else
			visible_message("[user] collapses \the [src.name].")
			new/obj/item/roller/covenant(get_turf(src))
			spawn(0)
				qdel(src)
		return
	..()

/obj/structure/bed/roller/covenant/MouseDrop(over_object, src_location, over_location)
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(buckled_mob)	return 0
		visible_message("[usr] collapses \the [src.name].")
		new/obj/item/roller/covenant(get_turf(src))
		spawn(0)
			qdel(src)
		return

/obj/item/roller/covenant
	icon = 'code/modules/halo/covenant/medical.dmi'

/obj/item/roller/covenant/attack_self(mob/user)
		var/obj/structure/bed/roller/covenant/R = new /obj/structure/bed/roller/covenant(user.loc)
		R.add_fingerprint(user)
		qdel(src)

//Cryo(Stasis)Bags

/obj/item/bodybag/cryobag/covenant
	icon = 'code/modules/halo/covenant/medical.dmi'
	icon_state = "bodybag_folded"

/obj/item/bodybag/cryobag/covenant/attack_self(mob/user)
	var/obj/structure/closet/body_bag/cryobag/covenant/R = new /obj/structure/closet/body_bag/cryobag/covenant(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/closet/body_bag/cryobag/covenant
	icon = 'code/modules/halo/covenant/medical.dmi'
	item_path = /obj/item/bodybag/cryobag/covenant

/obj/structure/closet/body_bag/cryobag/covenant/Entered(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.in_stasis = 1
		src.used = 1
	..()

/obj/item/usedcryobag/covenant
	icon = 'code/modules/halo/covenant/medical.dmi'

/obj/machinery/chem_master/covenant
	icon = 'code/modules/halo/covenant/medical.dmi'
	icon_state = "mixer0"

//Chemical Containers

//Covenant syringes located in syringes.dm

/obj/item/weapon/storage/box/covenantsyringes
	name = "box of covenant syringes"
	desc = "A box full of Covenant syringes."
	icon_state = "covsyringebox"
	startswith = list(/obj/item/weapon/reagent_containers/syringe/covenant = 7)

/obj/machinery/iv_drip/covenant
	name = "Covenant IV drip"
	icon = 'code/modules/halo/covenant/medical.dmi'
	icon_state = "cov_unhooked"
/obj/machinery/iv_drip/update_icon()
	if(src.attached)
		icon_state = "cov_hooked"
	else
		icon_state = "cov_unhooked"

	overlays = null

	if(beaker)
		var/datum/reagents/reagents = beaker.reagents
		var/percent = round((reagents.total_volume / beaker.volume) * 100)
		if(reagents.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "reagent")

			switch(percent)
				if(0 to 9)		filling.icon_state = "reagent0"
				if(10 to 24) 	filling.icon_state = "reagent10"
				if(25 to 49)	filling.icon_state = "reagent25"
				if(50 to 74)	filling.icon_state = "reagent50"
				if(75 to 79)	filling.icon_state = "reagent75"
				if(80 to 90)	filling.icon_state = "reagent80"
				if(91 to INFINITY)	filling.icon_state = "reagent100"
			filling.icon += reagents.get_color()
			overlays += filling

/obj/item/weapon/reagent_containers/glass/bottle/bottlecov
	name = "Nanolaminate Bottle"
	desc = "A nanolaminate treated bottle."
	icon = 'code/modules/halo/covenant/medical.dmi'
	icon_state = "bottle_cov"

/obj/item/weapon/reagent_containers/glass/beaker/bluespace/covenant
	name = "Nanolaminate Beaker"
	desc = "A large nanolaminate treated beaker, capable of storing large amounts of chemicals."
	icon = 'code/modules/halo/covenant/medical.dmi'
	icon_state = "cov_beaker"