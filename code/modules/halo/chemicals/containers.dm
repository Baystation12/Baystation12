
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan
	name = "Field Medical Syringe"
	desc = "A potent cocktail of chemicals which allows for increased survivability in the field."
	amount_per_transfer_from_this = 20
	volume = 20
	time = 30

	New()
		..()
		reagents.add_reagent("triadrenaline",5)
		reagents.add_reagent("biofoam",5)
		reagents.add_reagent("tricordrazine",5)
		reagents.add_reagent("tramadol",5)
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/ld50_syringe/triadrenaline
	name = "Tri-Adrenaline Syringe"
	desc = "A spring-loaded syringe of tri-adrenaline. Used for resuscitation"
	amount_per_transfer_from_this = 15
	volume = 15
	visible_name = "a giant syringe"
	time = 30

	New()
		..()
		reagents.add_reagent("triadrenaline", 15)
		mode = SYRINGE_INJECT
		update_icon()



#undef SYRINGE_DRAW
#undef SYRINGE_INJECT
#undef SYRINGE_BROKEN
