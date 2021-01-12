
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/weapon/reagent_containers/syringe/ld50_syringe/spartan
	name = "Field Medical Syringe"
	desc = "A potent cocktail of chemicals which allows for increased survivability in the field. Contains biofoam, Tricordrazine and Polypseudomorphine. Biofoam component will not function unless 15 seconds has passed between injections."
	amount_per_transfer_from_this = 15
	volume = 15
	time = 30

	New()
		..() //There was Tri-Adrenaline here. It led to lots of scorespam.
		reagents.add_reagent(/datum/reagent/biofoam,5)
		reagents.add_reagent(/datum/reagent/tricordrazine,5)
		reagents.add_reagent(/datum/reagent/polypseudomorphine,5)
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/biofoam
	name = "Biofoam Syringe"
	desc = "A syringe filled with biofoam, used to quickly fix internal and external injuries. Only inject a second dose after 15 seconds has passed, as remnants of previous injections interferes with the processing of future ones until fully processed."
	amount_per_transfer_from_this = 10


	New()
		..()
		reagents.add_reagent(/datum/reagent/biofoam, 10)
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
		reagents.add_reagent(/datum/reagent/triadrenaline, 10)
		reagents.add_reagent(/datum/reagent/polypseudomorphine, 5)
		mode = SYRINGE_INJECT
		update_icon()

//Iron pills + bottle define//
/obj/item/weapon/reagent_containers/pill/iron
	name = "Iron pill (20u)"
	desc = "Used to increase the speed of blood replenishment."
	icon_state = "pill18"
	New()
		..()
		reagents.add_reagent(/datum/reagent/iron, 20)

/obj/item/weapon/storage/pill_bottle/iron
	name = "bottle of Iron pills"
	desc = "Contains pills used to assist in blood replenishment."

	startswith = list(/obj/item/weapon/reagent_containers/pill/iron = 7)

/obj/item/weapon/reagent_containers/pill/hyronalin
	name = "Hyronalin pill (5u)"
	desc = "Used to remove radiation poisoning."
	icon_state = "pill17"
	New()
		..()
		reagents.add_reagent(/datum/reagent/hyronalin, 5)

/obj/item/weapon/storage/pill_bottle/hyronalin
	name = "bottle of Hyronalin pills"
	desc = "Contains pills used to assist in radiation damage."

	startswith = list(/obj/item/weapon/reagent_containers/pill/hyronalin = 7)

/obj/item/weapon/reagent_containers/pill/polypseudomorphine
	name = "Polypseudomorphine pill (10u)"
	desc = "Used to kill pain and in higher doses, sedate people. Do not exceed 10u unless attempting sedation."
	icon_state = "pill17"
	New()
		..()
		reagents.add_reagent(/datum/reagent/polypseudomorphine, 10)

/obj/item/weapon/storage/pill_bottle/polypseudomorphine
	name = "bottle of polypseudomorphine pills"
	desc = "Contains pills used to kill pain and in higher doses, sedate people. Do not exceed 10u."

	startswith = list(/obj/item/weapon/reagent_containers/pill/polypseudomorphine = 7)


#undef SYRINGE_DRAW
#undef SYRINGE_INJECT
#undef SYRINGE_BROKEN
