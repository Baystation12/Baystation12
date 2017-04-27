/obj/item/clothing/head/helmet/space/void/bogani
	name = "strange hardsuit helmet"
	desc = "An unusual hardsuit helmet."
	icon = 'icons/obj/clothing/species/bogani/hats.dmi'
	icon_state = "boghelm"
	armor = list(melee = 80, bullet = 60, laser = 60,energy = 25, bomb = 50, bio = 100, rad = 100)
	siemens_coefficient = 0.6
	species_restricted = list("Bogani", "Egyno")

/obj/item/clothing/head/helmet/space/void/bogani/refit_for_species()
	// Humans think they can wear Bogani stuff? Try again.
	return

/obj/item/clothing/suit/space/void/bogani
	name = "strange hardsuit"
	desc = "An unusual hardsuit."
	icon = 'icons/obj/clothing/species/bogani/suits.dmi'
	icon_state = "bogsuit"
	armor = list(melee = 80, bullet = 60, laser = 60,energy = 25, bomb = 50, bio = 100, rad = 100)
	siemens_coefficient = 0.6
	species_restricted = list("Bogani", "Egyno")

/obj/item/clothing/suit/space/void/bogani/refit_for_species()
	// Humans think they can wear Bogani stuff? Try again.
	return

/obj/item/clothing/suit/space/void/bogani/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/bogani
	boots = new /obj/item/clothing/shoes/magboots

/obj/item/clothing/head/helmet/space/void/bogani/advanced
	name = "advanced strange hardsuit helmet"
	desc = "An unusual hardsuit helmet. This one seems to have more advanced technology installed."
	icon_state = "highboghelm"
	armor = list(melee = 120, bullet = 100, laser = 100,energy = 65, bomb = 90, bio = 140, rad = 140)

/obj/item/clothing/suit/space/void/bogani/advanced
	name = "advanced strange hardsuit"
	desc = "An unusual hardsuit. This one seems to have more advanced technology installed."
	icon_state = "highbogsuit"
	armor = list(melee = 120, bullet = 100, laser = 100,energy = 65, bomb = 90, bio = 140, rad = 140)

/obj/item/clothing/suit/space/void/bogani/advanced/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/bogani/advanced
	boots = new /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/bogani/armored
	name = "strange armored hardsuit"
	desc = "An unusual hardsuit. This one seems to have a considerable amount of armoring."
	icon_state = "bogarmor"
	armor = list(melee = 120, bullet = 100, laser = 100,energy = 65, bomb = 90, bio = 140, rad = 140)

/obj/item/clothing/suit/space/void/bogani/armored/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/bogani
	boots = new /obj/item/clothing/shoes/magboots
