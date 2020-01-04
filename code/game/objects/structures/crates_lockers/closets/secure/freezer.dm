/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	req_access = list()

/obj/structure/closet/secure_closet/freezer/kitchen/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/condiment/flour = 7,
		/obj/item/weapon/reagent_containers/food/condiment/sugar = 4,
		/obj/item/weapon/reagent_containers/food/condiment/enzyme = 2
	)
/obj/structure/closet/secure_closet/freezer/kitchen/Initialize()
	. = ..()
	var/grown_list = list(\
	"tomato" = 7,
	"cherry" = 7,
	"cocoa" = 5,
	"lime" = 6,
	"orange" = 6,
	"lemon" = 6,
	"rice" = 8,
	"wheat" = 8,
	"soybean" = 5,
	"potato" = 8,
	"banana" = 8,
	"cabbage" = 6,
	"grapes" = 6,
	"mushrooms" = 6,
	"apple" = 5,
	"berries" = 5,
	"blueberries" = 5,
	"chili" = 6,
	"icechili" = 4
	)
	for(var/name in grown_list)
		for(var/i = 0,i < grown_list[name],i++)
			contents += new /obj/item/weapon/reagent_containers/food/snacks/grown (src,name)

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

/obj/structure/closet/secure_closet/freezer/meat/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey = 15
	)

/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridgebroken"

/obj/structure/closet/secure_closet/freezer/fridge/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/drinks/milk = 6,
		/obj/item/weapon/reagent_containers/food/drinks/soymilk = 4,
		/obj/item/weapon/storage/fancy/egg_box = 4
	)

/obj/structure/closet/secure_closet/freezer/money
	name = "secure locker"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridgebroken"
	req_access = list()

/obj/structure/closet/secure_closet/freezer/money/Initialize()
	. = ..()
	//let's make hold a substantial amount.
	var/created_size = 0
	for(var/i = 1 to 200) //sanity loop limit
		var/obj/item/cash_type = pick(3; /obj/item/weapon/spacecash/bundle/credits1000, 4; /obj/item/weapon/spacecash/bundle/credits500, 5; /obj/item/weapon/spacecash/bundle/credits200)
		var/bundle_size = initial(cash_type.w_class) / 2
		if(created_size + bundle_size <= storage_capacity)
			created_size += bundle_size
			new cash_type(src)
		else
			break
