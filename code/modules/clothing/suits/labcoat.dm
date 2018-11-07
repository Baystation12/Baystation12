/obj/item/clothing/suit/storage/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat_open"
	//item_state = "labcoat" //Is this even used for anything?
	icon_open = "labcoat_open"
	icon_closed = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/toggle/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo_open"
	//item_state = "labcoat_cmo"
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
	//item_state = "labgreen"
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

/obj/item/clothing/suit/storage/toggle/labcoat/blue
	name = "blue-edged labcoat"
	desc = "A suit that protects against minor chemical spills. This one has blue trim."
	icon_state = "blue_edge_labcoat_open"
	icon_open = "blue_edge_labcoat_open"
	icon_closed = "blue_edge_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/coat
	name = "coat"
	desc = "A cozy overcoat."
	color = "#292929"

/obj/item/clothing/suit/storage/toggle/labcoat/xyn_machine
	name = "\improper Xynergy labcoat"
	desc = "A stiffened, stylised labcoat designed to fit IPCs. It has blue and purple trim, denoting it as a Xynergy labcoat."
	icon_state = "labcoat_xy"
	icon_open = "labcoat_xy_open"
	icon_closed = "labcoat_xy"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 20, rad = 0)
	species_restricted = list(SPECIES_IPC)

/obj/item/clothing/suit/storage/toggle/labcoat/science
	name = "\improper EXO labcoat"
	desc = "A coat that protects against minor chemical spills. It has a green stripe on the shoulder and green trim on the sleeves, denoting it as a Expeditionary Corps Organisation labcoat."
	icon_state = "labcoat_TL_open"
	icon_open = "labcoat_TL_open"
	icon_closed = "labcoat_TL"

/obj/item/clothing/suit/storage/toggle/labcoat/science/nanotrasen
	name = "\improper NanoTrasen labcoat"
	desc = "A suit that protects against minor chemical spills. it has a red stripe on the shoulder and red trim on the sleeves, denoting it as a NanoTrasen labcoat."
	icon_state = "labcoat_nt_open"
	icon_open = "labcoat_nt_open"
	icon_closed = "labcoat_nt"

/obj/item/clothing/suit/storage/toggle/labcoat/science/heph
	name = "\improper Hephaestus Industries labcoat"
	desc = "A suit that protects against minor chemical spills. It has a cyan stripe on the shoulder and cyan trim on the sleeves, denoting it as a Hephaestus Industries labcoat."
	icon_state = "labcoat_heph_open"
	icon_open = "labcoat_heph_open"
	icon_closed = "labcoat_heph"

/obj/item/clothing/suit/storage/toggle/labcoat/science/dais
	name = "\improper DAIS labcoat"
	desc = "A labcoat with a the logo of Deimos Advanced Information Systems emblazoned on the back. It has a stylish blue \
	trim and the pockets are reinforced to hold tools. It seems to have an insulated material woven in to prevent static shocks."
	icon_state = "labcoat_dais"
	icon_open = "labcoat_dais_open"
	icon_closed = "labcoat_dais"
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 5, bomb = 0, bio = 0, rad = 0)//They don't need to protect against the environment very much.
	siemens_coefficient = 0.5 //These guys work with electronics. DAIS's labcoats shouldn't conduct very well.

/obj/item/clothing/suit/storage/toggle/labcoat/rd
	name = "research director's labcoat"
	desc = "A full-body labcoat covered in green and black designs, denoting it as a Expeditionary Corps Organisation management coat. Judging by the amount of designs on it, it is only to be worn by the most enthusiastic of employees."
	icon_state = "labcoat_rd_open"
	icon_open = "labcoat_rd_open"
	icon_closed = "labcoat_rd"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/toggle/labcoat/rd/nanotrasen
	name = "\improper NT research director's labcoat"
	desc = "A full-body labcoat covered in red and black designs, denoting it as a NanoTrasen management coat. Judging by the amount of designs on it, it is only to be worn by the most enthusiastic of employees."
	icon_state = "labcoat_rd_nt_open"
	icon_open = "labcoat_rd_nt_open"
	icon_closed = "labcoat_rd_nt"

/obj/item/clothing/suit/storage/toggle/labcoat/rd/heph
	name = "\improper HI research director's labcoat"
	desc = "A full-body labcoat covered in cyan and black designs, denoting it as a corporate management coat. Judging by the amount of designs on it, it is only to be worn by the most enthusiastic of employees."
	icon_state = "labcoat_rd_heph_open"
	icon_open = "labcoat_rd_heph_open"
	icon_closed = "labcoat_rd_heph"
