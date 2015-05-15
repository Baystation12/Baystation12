
/obj/item/clothing/neck/goldchain
	name = "Gold Chain"
	desc = "A Beutiful Gold Chain"
	icon_state = "gchain"
	item_state = "gchain"
	siemens_coefficient = 0.5


/obj/item/clothing/neck/silverchain
	name = "Silver Chain"
	desc = "A Beutiful Silver Chain"
	icon_state = "schain"
	item_state = "schain"
	siemens_coefficient = 0.5

/obj/item/clothing/neck/dollarchain
	name = "Gold $ Chain"
	desc = "A Gangsta Chain"
	icon_state = "dchain"
	item_state = "dchain"
	siemens_coefficient = 0.5

/obj/item/clothing/neck/emeraldneck
	name = "Emerald Necklace"
	desc = "A Gold Chain with an Emerald on it."
	icon_state = "Eneck"
	item_state = "Eneck"
	siemens_coefficient = 0.5

/obj/item/clothing/neck/rubyneck
	name = "Ruby Necklace"
	desc = "A Gold Chain with an Ruby on it."
	icon_state = "Rneck"
	item_state = "Rneck"
	siemens_coefficient = 0.5


/obj/item/clothing/neck/neckerchief_blue
	name = "Blue Neckerchief"
	desc = "A Blue Neckerchief with SS03 embroidered on it."
	icon_state = "Bnecker"

	item_state = "Bnecker"
	siemens_coefficient = 0.5

/obj/item/clothing/neck/redbandana
	name = "Red Bandana"
	desc = "A Red Bandana with a nice embroidery."
	icon_state = "Rbandana"


	slot_ SLOT_NECK
	siemens_coefficient = 0.5
	var/hanging = 1

	verb/toggle()
		set category = "Object"
		set name = "Adjust mask"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(!src.hanging)
				src.hanging = !src.hanging
				flags_inv = null
				icon_state = "Rbandana"
				usr << "Your mask is now hanging on your neck."
				usr.update_inv_neck()

			else
				src.hanging = !src.hanging
				icon_state = "Rbandana3"
				flags = BLOCKHAIR
				flags_inv = HIDEMASK|HIDEFACE
				usr << "You pull the mask up to cover your face."
				usr.update_inv_neck()

/obj/item/clothing/neck/greenbandana
	name = "Green Bandana"
	desc = "A Green Bandana with a nice embroidery."
	icon_state = "Gbandana"
	siemens_coefficient = 0.5
	var/hanging = 1

	verb/toggle()
		set category = "Object"
		set name = "Adjust mask"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(!src.hanging)
				src.hanging = !src.hanging
				flags_inv = null
				icon_state = "Gbandana"
				usr << "Your mask is now hanging on your neck."
				usr.update_inv_neck()

			else
				src.hanging = !src.hanging
				icon_state = "Gbandana3"
				flags = BLOCKHAIR
				flags_inv = HIDEMASK|HIDEFACE
				usr << "You pull the mask up to cover your face."
				usr.update_inv_neck()

/obj/item/clothing/neck/bluebandana
	name = "Blue Bandana"
	desc = "A Blue Bandana with a nice embroidery."
	icon_state = "Bbandana"
	siemens_coefficient = 0.5
	var/hanging = 1

	verb/toggle()
		set category = "Object"
		set name = "Adjust mask"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(!src.hanging)
				src.hanging = !src.hanging
				flags_inv = null
				icon_state = "Bbandana"
				usr << "Your mask is now hanging on your neck."
				usr.update_inv_neck()

			else
				src.hanging = !src.hanging
				icon_state = "Bbandana3"
				flags = BLOCKHAIR
				flags_inv = HIDEMASK|HIDEFACE
				usr << "You pull the mask up to cover your face."
				usr.update_inv_neck()

/obj/item/clothing/neck/greybandana
	name = "Grey Bandana"
	desc = "A Grey Bandana with a nice embroidery."
	icon_state = "Grbandana"
	siemens_coefficient = 0.5
	var/hanging = 1

	verb/toggle()
		set category = "Object"
		set name = "Adjust mask"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(!src.hanging)
				src.hanging = !src.hanging
				flags_inv = null
				icon_state = "Grbandana"
				usr << "Your mask is now hanging on your neck."
				usr.update_inv_neck()

			else
				src.hanging = !src.hanging
				icon_state = "Grbandana3"
				flags = BLOCKHAIR
				flags_inv = HIDEMASK|HIDEFACE
				usr << "You pull the mask up to cover your face."
				usr.update_inv_neck()

/obj/item/clothing/neck/purplebandana
	name = "Purple Bandana"
	desc = "A Purple Bandana with a nice embroidery."
	icon_state = "Pubandana"
	siemens_coefficient = 0.5
	var/hanging = 1

	verb/toggle()
		set category = "Object"
		set name = "Adjust mask"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(!src.hanging)
				src.hanging = !src.hanging
				flags_inv = null
				icon_state = "Pubandana"
				usr << "Your mask is now hanging on your neck."
				usr.update_inv_neck()

			else
				src.hanging = !src.hanging
				icon_state = "Pubandana3"
				flags = BLOCKHAIR
				flags_inv = HIDEMASK|HIDEFACE
				usr << "You pull the mask up to cover your face."
				usr.update_inv_neck()

/obj/item/clothing/neck/piratebandana
	name = "Pirate Bandana"
	desc = "A Dark Red Bandana with a Pirate embroidery."
	icon_state = "Pbandana"
	siemens_coefficient = 0.5
	var/hanging = 1

	verb/toggle()
		set category = "Object"
		set name = "Adjust mask"
		set src in usr

		if(usr.canmove && !usr.stat && !usr.restrained())
			if(!src.hanging)
				src.hanging = !src.hanging
				flags_inv = null
				icon_state = "Pbandana"
				usr << "Your mask is now hanging on your neck."
				usr.update_inv_neck()

			else
				src.hanging = !src.hanging
				icon_state = "Pbandana3"
				flags = BLOCKHAIR
				flags_inv = HIDEMASK|HIDEFACE
				usr << "You pull the mask up to cover your face."
				usr.update_inv_neck()

/obj/item/clothing/neck/Avischain
	name = "Aviskree Medallion"
	desc = "A Silver Medallion on a chain, a name is written on it in Aviachirp"
	icon_state = "Aneck"
	item_state = "Aneck"
	siemens_coefficient = 0.5