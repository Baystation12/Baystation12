/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	health = 180
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 3


/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

/obj/item/weapon/reagent_containers/food/snacks/meat/human
	name = "-meat"
	var/subjectname = ""
	var/subjectjob = null


/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well you know..."

//Grutor
//zombies yum...
/obj/item/weapon/reagent_containers/food/snacks/meat/undead
	name = "Rotten flesh"
	desc = "You really shouldn't..."
	icon = 'icons/obj/food.dmi'
	icon_state = "rottenmeat"

	attack(mob/M as mob, mob/user as mob, def_zone)
		if(..())
			M << "You are starting to have regrets..." //If you seeing this message twice, remove this one.

	New()
		..()
		reagents.add_reagent("carpotoxin", 6)
		reagents.add_reagent("zmeat", 20)
