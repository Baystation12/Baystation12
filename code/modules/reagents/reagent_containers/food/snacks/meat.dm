/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	New()
		..()
		reagents.add_reagent("protein", 9)
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/meat/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchenknife))
		new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(src)
		user << "You cut the meat into thin strips."
		del(src)
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/weapon/reagent_containers/food/snacks/meat/human
/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well, you know."