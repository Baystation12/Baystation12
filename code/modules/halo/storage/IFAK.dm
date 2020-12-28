
/obj/item/clothing/accessory/storage/IFAK
	name = "Infantry First Aid Kit"
	desc = "A tailor made pouch with partitions for specific medical supplies."
	icon = 'code/modules/halo/icons/objs/ifak.dmi'
	icon_state = "ifak"
	slots = 7
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_NORMAL
	startingitems = list(\
	/obj/item/weapon/reagent_containers/syringe/biofoam,
	/obj/item/weapon/reagent_containers/syringe/biofoam,
	/obj/item/weapon/reagent_containers/pill/bicaridine,
	/obj/item/weapon/reagent_containers/pill/dermaline,
	/obj/item/weapon/storage/pill_bottle/polypseudomorphine,
	/obj/item/weapon/reagent_containers/pill/iron,
	)

/obj/item/clothing/accessory/storage/IFAK/New()
	if(prob(50))
		startingitems += /obj/item/weapon/reagent_containers/food/snacks/chocolatebar
	else
		startingitems += /obj/item/weapon/pen/crayon/rainbow
	. = ..()
	hold.can_hold = list(\
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar,
		/obj/item/weapon/pen/crayon,
	)

/obj/item/clothing/accessory/storage/IFAK/cov
	icon_state = "cov_ifak"