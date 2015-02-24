//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/weapon/storage/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."

/obj/item/weapon/storage/pill_bottle/happy/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/happy( src )
	new /obj/item/weapon/reagent_containers/pill/happy( src )
	new /obj/item/weapon/reagent_containers/pill/happy( src )
	new /obj/item/weapon/reagent_containers/pill/happy( src )
	new /obj/item/weapon/reagent_containers/pill/happy( src )
	new /obj/item/weapon/reagent_containers/pill/happy( src )
	new /obj/item/weapon/reagent_containers/pill/happy( src )

/obj/item/weapon/storage/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."

/obj/item/weapon/storage/pill_bottle/zoom/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/zoom( src )
	new /obj/item/weapon/reagent_containers/pill/zoom( src )
	new /obj/item/weapon/reagent_containers/pill/zoom( src )
	new /obj/item/weapon/reagent_containers/pill/zoom( src )
	new /obj/item/weapon/reagent_containers/pill/zoom( src )
	new /obj/item/weapon/reagent_containers/pill/zoom( src )
	new /obj/item/weapon/reagent_containers/pill/zoom( src )

/obj/item/weapon/reagent_containers/glass/beaker/vial/random
	flags = 0
	var/list/random_reagent_list = list(list("water" = 15) = 1, list("cleaner" = 15) = 1)

/obj/item/weapon/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list("mindbreaker" = 10, "space_drugs" = 20)	= 3,
		list("carpotoxin" = 15)							= 2,
		list("impedrezene" = 15)						= 2,
		list("zombiepowder" = 10)						= 1)

/obj/item/weapon/reagent_containers/glass/beaker/vial/random/New()
	..()
	if(is_open_container())
		flags ^= OPENCONTAINER

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/datum/reagent/R in reagents.reagent_list)
		names += R.name

	desc = "Contains [english_list(names)]."
	update_icon()
