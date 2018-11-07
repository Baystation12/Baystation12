
/mob/living/carbon/human/covenant/sanshyuum/New(var/new_loc)
	..(new_loc,"San'Shyuum")
	faction = "Covenant"

/obj/item/clothing/suit/prophet_robe
	name = "San'Shyuum Robe"
	desc = "A robe shaped for a San'Shyuum."
	icon = 'code/modules/halo/icons/species/r_sanshyuum.dmi'
	icon_override = 'code/modules/halo/icons/species/r_sanshyuum.dmi'
	icon_state = "robe"
	item_state = "robe"
	species_restricted = list("San'Shyuum")
