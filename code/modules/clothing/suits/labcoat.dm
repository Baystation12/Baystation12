/obj/item/clothing/suit/storage/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_open"
	item_state = "labcoat" //Is this even used for anything?
	icon_open = "labcoat_open"
	icon_closed = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/suit.dmi')

	/*verb/toggle()
		set name = "Toggle Labcoat Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		//Why???
		switch(icon_state)
			if("labcoat_open")
				src.icon_state = "labcoat"
				usr << "You button up the labcoat."
			if("labcoat")
				src.icon_state = "labcoat_open"
				usr << "You unbutton the labcoat."
			if("red_labcoat_open")
				src.icon_state = "red_labcoat"
				usr << "You button up the labcoat."
			if("red_labcoat")
				src.icon_state = "red_labcoat_open"
				usr << "You unbutton the labcoat."
			if("blue_labcoat_open")
				src.icon_state = "blue_labcoat"
				usr << "You button up the labcoat."
			if("blue_labcoat")
				src.icon_state = "blue_labcoat_open"
				usr << "You unbutton the labcoat."
			if("purple_labcoat_open")
				src.icon_state = "purple_labcoat"
				usr << "You button up the labcoat."
			if("purple_labcoat")
				src.icon_state = "purple_labcoat_open"
				usr << "You unbutton the labcoat."
			if("green_labcoat_open")
				src.icon_state = "green_labcoat"
				usr << "You button up the labcoat."
			if("green_labcoat")
				src.icon_state = "green_labcoat_open"
				usr << "You unbutton the labcoat."
			if("orange_labcoat_open")
				src.icon_state = "orange_labcoat"
				usr << "You button up the labcoat."
			if("orange_labcoat")
				src.icon_state = "orange_labcoat_open"
				usr << "You unbutton the labcoat."
			if("labcoat_cmo_open")
				src.icon_state = "labcoat_cmo"
				usr << "You button up the labcoat."
			if("labcoat_cmo")
				src.icon_state = "labcoat_cmo_open"
				usr << "You unbutton the labcoat."
			if("labcoat_gen_open")
				src.icon_state = "labcoat_gen"
				usr << "You button up the labcoat."
			if("labcoat_gen")
				src.icon_state = "labcoat_gen_open"
				usr << "You unbutton the labcoat."
			if("labcoat_chem_open")
				src.icon_state = "labcoat_chem"
				usr << "You button up the labcoat."
			if("labcoat_chem")
				src.icon_state = "labcoat_chem_open"
				usr << "You unbutton the labcoat."
			if("labcoat_vir_open")
				src.icon_state = "labcoat_vir"
				usr << "You button up the labcoat."
			if("labcoat_vir")
				src.icon_state = "labcoat_vir_open"
				usr << "You unbutton the labcoat."
			if("labcoat_tox_open")
				src.icon_state = "labcoat_tox"
				usr << "You button up the labcoat."
			if("labcoat_tox")
				src.icon_state = "labcoat_tox_open"
				usr << "You unbutton the labcoat."
			if("labgreen_open")
				src.icon_state = "labgreen"
				usr << "You button up the labcoat."
			if("labgreen")
				src.icon_state = "labgreen_open"
				usr << "You unbutton the labcoat."
			if("aeneasrinil")
				src.icon_state = "aeneasrinil_open"
				usr << "You unbutton the labcoat."
			if("aeneasrinil_open")
				src.icon_state = "aeneasrinil"
				usr << "You button up the labcoat."
			if("kidafrag_open")
				src.icon_state = "kidafrag_buttoned"
				src.icon_state = "kidafrag_buttoned"
				usr << "You button up the coat."
			if("kidafrag_buttoned")
				src.icon_state = "kidafrag_zipped"
				src.icon_state = "kidafrag_zipped"
				usr << "You zip up the coat."
			if("kidafrag_zipped")
				src.icon_state = "kidafrag_open"
				src.icon_state = "kidafrag_open"
				usr << "You open the coat."
			else
				usr << "You attempt to button-up the velcro on your [src], before promptly realising how silly you are."
				return
		update_clothing_icon()	//so our overlays update

/obj/item/clothing/suit/storage/labcoat/red*/
/obj/item/clothing/suit/storage/toggle/labcoat/red
	name = "red labcoat"
	desc = "A suit that protects against minor chemical spills. This one is red."
	icon_state = "red_labcoat_open"
	item_state = "red_labcoat"
	icon_open = "red_labcoat_open"
	icon_closed = "red_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/blue
	name = "blue labcoat"
	desc = "A suit that protects against minor chemical spills. This one is blue."
	icon_state = "blue_labcoat_open"
	item_state = "blue_labcoat"
	icon_open = "blue_labcoat_open"
	icon_closed = "blue_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/purple
	name = "purple labcoat"
	desc = "A suit that protects against minor chemical spills. This one is purple."
	icon_state = "purple_labcoat_open"
	item_state = "purple_labcoat"
	icon_open = "purple_labcoat_open"
	icon_closed = "purple_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/orange
	name = "orange labcoat"
	desc = "A suit that protects against minor chemical spills. This one is orange."
	icon_state = "orange_labcoat_open"
	item_state = "orange_labcoat"
	icon_open = "orange_labcoat_open"
	icon_closed = "orange_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/green
	name = "green labcoat"
	desc = "A suit that protects against minor chemical spills. This one is green."
	icon_state = "green_labcoat_open"
	item_state = "green_labcoat"
	icon_open = "green_labcoat_open"
	icon_closed = "green_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo_open"
	item_state = "labcoat_cmo"
	icon_open = "labcoat_cmo_open"
	icon_closed = "labcoat_cmo"

/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	name = "chief medical officer labcoat"
	desc = "A labcoat with command blue highlights."
	icon_state = "labcoat_cmoalt_open"
	icon_open = "labcoat_cmoalt_open"
	icon_closed = "labcoat_cmoalt"

/obj/item/clothing/suit/storage/toggle/labcoat/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen_open"
	item_state = "labgreen"
	icon_open = "labgreen_open"
	icon_closed = "labgreen"

/obj/item/clothing/suit/storage/toggle/labcoat/genetics
	name = "Geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen_open"
	icon_open = "labcoat_gen_open"
	icon_closed = "labcoat_gen"

/obj/item/clothing/suit/storage/toggle/labcoat/chemist
	name = "Chemist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem_open"
	icon_open = "labcoat_chem_open"
	icon_closed = "labcoat_chem"

/obj/item/clothing/suit/storage/toggle/labcoat/virologist
	name = "Virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir_open"
	icon_open = "labcoat_vir_open"
	icon_closed = "labcoat_vir"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 0)

/obj/item/clothing/suit/storage/toggle/labcoat/science
	name = "Scientist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a purple stripe on the shoulder."
	icon_state = "labcoat_tox_open"
	icon_open = "labcoat_tox_open"
	icon_closed = "labcoat_tox"

/obj/item/clothing/suit/storage/labcoat/robotics //Robotics Labcoat - Aeneas Rinil [APPR]
	name = "Robotics labcoat"
	desc = "A labcoat with a few markings denoting it as the labcoat of roboticist."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "aeneasrinil_open"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
