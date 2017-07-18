/obj/structure/closet/secure_closet/freezer

/obj/structure/closet/secure_closet/freezer/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	req_access = list(access_kitchen)

	New()
		..()
		for(var/i = 1 to 7)
			new /obj/item/weapon/reagent_containers/food/condiment/flour(src)
		for(var/i = 1 to 2)
			new /obj/item/weapon/reagent_containers/food/condiment/sugar(src)
		return


/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()



/obj/structure/closet/secure_closet/freezer/meat
	name = "meat fridge"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridgebroken"


	New()
		..()
		for(var/i = 1 to 10)
			new /obj/item/weapon/reagent_containers/food/snacks/meat/monkey(src)
		return



/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridgebroken"


	New()
		..()
		for(var/i = 1 to 6)
			new /obj/item/weapon/reagent_containers/food/drinks/milk(src)
		for(var/i = 1 to 4)
			new /obj/item/weapon/reagent_containers/food/drinks/soymilk(src)
		for(var/i = 1 to 4)
			new /obj/item/weapon/storage/fancy/egg_box(src)
		return



/obj/structure/closet/secure_closet/freezer/money
	name = "secure locker"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridgebroken"
	req_access = list(access_heads_vault)

/obj/structure/closet/secure_closet/freezer/money/New()
	..()
	//let's make hold a substantial amount.
	var/created_size = 0
	for(var/i = 1 to 200) //sanity loop limit
		var/bundletype = pick(3; /obj/item/weapon/spacecash/bundle/c1000, 4; /obj/item/weapon/spacecash/bundle/c500, 5; /obj/item/weapon/spacecash/bundle/c200)
		var/obj/item/cash = new bundletype(null)
		var/bundle_size = content_size(cash)
		if(created_size + bundle_size <= storage_capacity)
			cash.forceMove(src)
			created_size += bundle_size
		else
			qdel(cash)
			break
