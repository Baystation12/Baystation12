
/obj/item/reagent_containers/glass/bottle/robot
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;50;100"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 60
	var/reagent = ""


/obj/item/reagent_containers/glass/bottle/robot/inaprovaline
	name = "internal inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	reagent = /datum/reagent/inaprovaline

	New()
		..()
		reagents.add_reagent(/datum/reagent/inaprovaline, 60)
		update_icon()


/obj/item/reagent_containers/glass/bottle/robot/antitoxin
	name = "internal anti-toxin bottle"
	desc = "A small bottle of Anti-toxins. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"
	reagent = /datum/reagent/dylovene

	New()
		..()
		reagents.add_reagent(/datum/reagent/dylovene, 60)
		update_icon()

