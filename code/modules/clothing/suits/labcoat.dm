/obj/item/clothing/suit/storage/toggle/labcoat
	name = "labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon_state = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/device/scanner/gas,/obj/item/stack/medical,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,/obj/item/device/scanner/health,/obj/item/device/flashlight/pen,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle,/obj/item/paper)
	armor = list(
		bio = ARMOR_BIO_RESISTANT
		)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_RANK)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/toggle/labcoat/cmo
	name = "chief medical officer's labcoat"
	desc = "Bluer than the standard model."
	icon_state = "labcoat_cmo"

/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	name = "chief medical officer's labcoat"
	desc = "A labcoat with command blue highlights."
	icon_state = "labcoat_cmoalt"

/obj/item/clothing/suit/storage/toggle/labcoat/mad
	name = "The Mad's labcoat"
	desc = "It makes you look capable of konking someone on the noggin and shooting them into space."
	icon_state = "labgreen"

/obj/item/clothing/suit/storage/toggle/labcoat/genetics
	name = "geneticist labcoat"
	desc = "A suit that protects against minor chemical spills. Has a blue stripe on the shoulder."
	icon_state = "labcoat_gen"

/obj/item/clothing/suit/storage/toggle/labcoat/chemist
	name = "pharmacist labcoat"
	desc = "A suit that protects against minor chemical spills. Has an orange stripe on the shoulder."
	icon_state = "labcoat_chem"

/obj/item/clothing/suit/storage/toggle/labcoat/virologist
	name = "virologist labcoat"
	desc = "A suit that protects against minor chemical spills. Offers slightly more protection against biohazards than the standard model. Has a green stripe on the shoulder."
	icon_state = "labcoat_vir"

/obj/item/clothing/suit/storage/toggle/labcoat/blue
	name = "blue-edged labcoat"
	desc = "A suit that protects against minor chemical spills. This one has blue trim."
	icon_state = "blue_edge_labcoat"

/obj/item/clothing/suit/storage/toggle/labcoat/coat
	name = "coat"
	desc = "A cozy overcoat."
	color = "#292929"

/obj/item/clothing/suit/storage/toggle/labcoat/xyn_machine
	name = "\improper Xynergy labcoat"
	desc = "A stiffened, stylised labcoat designed to fit IPCs. It has blue and purple trim, denoting it as a Xynergy labcoat."
	icon_state = "labcoat_xy"
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bio = ARMOR_BIO_MINOR
		)
	species_restricted = list(SPECIES_IPC, SPECIES_SHELL)

/obj/item/clothing/suit/storage/toggle/labcoat/foundation
	name = "\improper Foundation labcoat"
	desc = "A medical labcoat with a Cuchulain Foundation crest stencilled on the back."
	icon_state = "labcoat_foundation"

/obj/item/clothing/suit/storage/toggle/labcoat/science
	name = "\improper EXO labcoat"
	desc = "A coat that protects against minor chemical spills. It has a green stripe on the shoulder and green trim on the sleeves, denoting it as a Expeditionary Corps Organisation labcoat."
	icon_state = "labcoat_TL"

/obj/item/clothing/suit/storage/toggle/labcoat/science/ec
	name = "\improper EC labcoat"
	desc = "A coat that protects against minor chemical spills. It has purple stripes on the shoulders denoting it as an Expeditionary Corps labcoat."
	icon_state = "labcoat_tox"

/obj/item/clothing/suit/storage/toggle/labcoat/science/nanotrasen
	name = "\improper NanoTrasen labcoat"
	desc = "A suit that protects against minor chemical spills. it has a red stripe on the shoulder and red trim on the sleeves, denoting it as a NanoTrasen labcoat."
	icon_state = "labcoat_nt"

/obj/item/clothing/suit/storage/toggle/labcoat/science/heph
	name = "\improper Hephaestus Industries labcoat"
	desc = "A suit that protects against minor chemical spills. It has a cyan stripe on the shoulder and cyan trim on the sleeves, denoting it as a Hephaestus Industries labcoat."
	icon_state = "labcoat_heph"

/obj/item/clothing/suit/storage/toggle/labcoat/science/zeng
	name = "\improper Zeng-Hu labcoat"
	desc = "A suit that protects against minor chemical spills. It has a cyan stripe on the shoulder and cyan trim on the sleeves, denoting it as a Zeng-Hu Pharmaceuticals labcoat."
	icon_state = "labcoat_zeng"

/obj/item/clothing/suit/storage/toggle/labcoat/science/morpheus
	name = "\improper Morpheus Cyberkinetics labcoat"
	desc = "A suit that protects against minor chemical spills. It has a gray stripe on the shoulder and gray trim on the sleeves, denoting it as a Morpheus Cyberkinetics labcoat."
	icon_state = "labcoat_morpheus"

/obj/item/clothing/suit/storage/toggle/labcoat/science/xynergy
	name = "\improper Xynergy labcoat"
	desc = "A suit that protects against minor chemical spills. It is coloured magenta and cyan, as well as sporting the Xynergy logo, denoting it as a Xynergy labcoat."
	icon_state = "labcoat_xynergy"

/obj/item/clothing/suit/storage/toggle/labcoat/science/dais
	name = "\improper DAIS labcoat"
	desc = "A labcoat with a the logo of Deimos Advanced Information Systems emblazoned on the back. It has a stylish blue \
	trim and the pockets are reinforced to hold tools. It seems to have an insulated material woven in to prevent static shocks."
	icon_state = "labcoat_dais"
	armor = list(
		melee = ARMOR_MELEE_MINOR
	)//They don't need to protect against the environment very much.
	siemens_coefficient = 0.5 //These guys work with electronics. DAIS's labcoats shouldn't conduct very well.

/obj/item/clothing/suit/storage/toggle/labcoat/rd
	name = "research director's labcoat"
	desc = "A full-body labcoat covered in green and black designs, denoting it as an Expeditionary Corps Organisation management coat. Judging by the amount of designs on it, it is only to be worn by the most enthusiastic of employees."
	icon_state = "labcoat_rd"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/toggle/labcoat/rd/nanotrasen
	name = "\improper NT research director's labcoat"
	desc = "A full-body labcoat covered in red and black designs, denoting it as a NanoTrasen management coat. Judging by the amount of designs on it, it is only to be worn by the most enthusiastic of employees."
	icon_state = "labcoat_rd_nt"

/obj/item/clothing/suit/storage/toggle/labcoat/rd/heph
	name = "\improper HI research director's labcoat"
	desc = "A full-body labcoat covered in cyan and black designs, denoting it as a Hephaestus Industries management coat. Judging by the amount of designs on it, it is only to be worn by the most enthusiastic of employees."
	icon_state = "labcoat_rd_heph"

/obj/item/clothing/suit/storage/toggle/labcoat/rd/zeng
	name = "\improper Z-H research director's labcoat"
	desc = "A full-body labcoat covered in cyan and black designs, denoting it as a Zeng-Hu Pharmaceuticals management coat. Judging by the amount of designs on it, it is only to be worn by the most enthusiastic of employees."
	icon_state = "labcoat_rd_zeng"

/obj/item/clothing/suit/storage/toggle/labcoat/rd/ec
	name = "chief science officer's labcoat"
	desc = "A coat that protects against minor chemical spills. It has purple stripes on the shoulders denoting it as an Expeditionary Corps labcoat, and purple trim to indicate a Chief Science Officer."
	icon_state = "labcoat_cso"
	body_parts_covered = UPPER_TORSO|ARMS
