/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon = 'icons/obj/kitchen/staples/meat.dmi'
	icon_state = "meat"
	filling_color = "#FF1C1C"
	bitesize = 3
	slices_to = /obj/item/weapon/reagent_containers/food/snacks/meat/rawcutlet
	slice_count = 3

/obj/item/weapon/reagent_containers/food/snacks/meat/New()
	..()
	reagents.add_reagent("protein", 9)

/obj/item/weapon/reagent_containers/food/snacks/meat/slab
	var/source_mob

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/New()
	..()
	if(source_mob)
		name = "[source_mob] [initial(name)]"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/synth
	source_mob = "synthetic"
	desc = "A synthetic slab of flesh."

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
	source_mob = "human"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/monkey
	source_mob = "monkey"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/corgi
	source_mob = "corgi"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/bear
	source_mob = "bear"
	icon_state = "bearmeat"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno
	source_mob = "xeno"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43DE18"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/carp
	source_mob = "carp"
	name = "fillet"
	desc = "A fillet of carp meat."
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"
