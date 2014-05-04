
/obj/item/weapon/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."

	New()
		..()
		new /obj/item/weapon/dice( src )
		new /obj/item/weapon/dice/d20( src )
