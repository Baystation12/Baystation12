/*/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "breath"
	flags = FPRINT | TABLEPASS | MASKCOVERSMOUTH | MASKINTERNALS
	w_class = 2
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	*/
/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | HEADCOVERSMOUTH
	item_state = "breath"
	w_class = 2
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	var/hanging = 1

	attack_self()
		toggle()

	verb/toggle()
		set category = "Object"
		set name = "Adjust breath mask"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(!src.hanging)
				src.hanging = !src.hanging
				gas_transfer_coefficient = 0.90
				src.flags |= MASKCOVERSMOUTH | MASKINTERNALS
				icon_state = "breath"
				usr << "You pull the mask up to cover your mouth."
			else
				src.hanging = !src.hanging
				gas_transfer_coefficient = 0.10
				src.flags &= ~MASKCOVERSMOUTH | MASKINTERNALS
				icon_state = "breathdown"
				usr << "You pull the mask down to hang on your neck."
			usr.update_inv_head()


/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be connected to an air supply."
	name = "medical mask"
	icon_state = "medical"
	item_state = "medical"