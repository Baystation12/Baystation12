/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "breath"
	flags = MASKCOVERSMOUTH | AIRTIGHT
	body_parts_covered = 0
	w_class = 2
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50

	sprite_sheets = list(
		"Vox" = 'icons/mob/species/vox/masks.dmi'
		)

	var/hanging = 0

	verb/toggle()
		set category = "Object"
		set name = "Adjust mask"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(!src.hanging)
				src.hanging = !src.hanging
				gas_transfer_coefficient = 1 //gas is now escaping to the turf and vice versa
				flags &= ~(MASKCOVERSMOUTH | AIRTIGHT)
				icon_state = "breathdown"
				usr << "Your mask is now hanging on your neck."

			else
				src.hanging = !src.hanging
				gas_transfer_coefficient = 0.10
				flags |= MASKCOVERSMOUTH | AIRTIGHT
				icon_state = "breath"
				usr << "You pull the mask up to cover your face."
			update_clothing_icon()

/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be connected to an air supply."
	name = "medical mask"
	icon_state = "medical"
	item_state = "medical"
	permeability_coefficient = 0.01