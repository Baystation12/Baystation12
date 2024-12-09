/obj/item/gun/energy/lasertag
	name = "laser tag gun"
	icon = 'packs/lasertag/gun.dmi'
	icon_state = "bluetag"
	item_state = "laser"
	desc = "Standard issue weapon of the Imperial Guard."
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	self_recharge = 1
	matter = list(MATERIAL_STEEL = 2000)
	projectile_type = /obj/item/projectile/beam/lasertag/blue
	var/required_vest


/obj/item/gun/energy/lasertag/special_check(mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			to_chat(M, SPAN_WARNING("You need to be wearing your laser tag vest!"))
			return 0
	return ..()


/obj/item/gun/energy/lasertag/blue
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/lasertag/blue
	required_vest = /obj/item/clothing/suit/bluetag


/obj/item/gun/energy/lasertag/red
	icon_state = "redtag"
	item_state = "redtag"
	projectile_type = /obj/item/projectile/beam/lasertag/red
	required_vest = /obj/item/clothing/suit/redtag
