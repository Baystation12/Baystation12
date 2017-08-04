//SolGov Uniform Suits

//Service

/obj/item/clothing/suit/storage/service
	name = "service jacket"
	desc = "A uniform service jacket, plain and undecorated."
	icon_state = "blackservice"
	item_state = "blackservice"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/weapon/pen,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder,/obj/item/device/analyzer,/obj/item/device/radio,/obj/item/taperoll)
	valid_accessory_slots = list("armband","medal","decor","rank")
	restricted_accessory_slots = list("armband")

/obj/item/clothing/suit/storage/service/expeditionary
	name = "expeditionary jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps. It has silver buttons."
	icon_state = "blackservice_crew"
	item_state = "blackservice_crew"

/obj/item/clothing/suit/storage/service/expeditionary/medical
	name = "expeditionary medical jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps. It has silver buttons and blue trim."
	icon_state = "blackservice_med"
	item_state = "blackservice_med"

/obj/item/clothing/suit/storage/service/expeditionary/medical/command
	name = "expeditionary medical command jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps. It has gold buttons and blue trim."
	icon_state = "blackservice_medcom"
	item_state = "blackservice_medcom"

/obj/item/clothing/suit/storage/service/expeditionary/engineering
	name = "expeditionary engineering jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps. It has silver buttons and orange trim."
	icon_state = "blackservice_eng"
	item_state = "blackservice_eng"

/obj/item/clothing/suit/storage/service/expeditionary/engineering/command
	name = "expeditionary engineering command jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps. It has gold buttons and orange trim."
	icon_state = "blackservice_engcom"
	item_state = "blackservice_engcom"

/obj/item/clothing/suit/storage/service/expeditionary/supply
	name = "expeditionary supply jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps. It has silver buttons and brown trim."
	icon_state = "blackservice_sup"
	item_state = "blackservice_sup"

/obj/item/clothing/suit/storage/service/expeditionary/security
	name = "expeditionary security jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps. It has silver buttons and red trim."
	icon_state = "blackservice_sec"
	item_state = "blackservice_sec"

/obj/item/clothing/suit/storage/service/expeditionary/security/command
	name = "expeditionary security command jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps. It has gold buttons and red trim."
	icon_state = "blackservice_seccom"
	item_state = "blackservice_seccom"

/obj/item/clothing/suit/storage/service/expeditionary/command
	name = "expeditionary command jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps. It has gold buttons and gold trim."
	icon_state = "blackservice_com"
	item_state = "blackservice_com"


/obj/item/clothing/suit/storage/service/marine
	name = "marine coat"
	desc = "An SCG Marine Corps service coat. Green and undecorated."
	icon_state = "greenservice"
	item_state = "greenservice"

/obj/item/clothing/suit/storage/service/marine/medical
	name = "marine medical jacket"
	desc = "An SCG Marine Corps service coat. This one has blue markings."
	icon_state = "greenservice_med"
	item_state = "greenservice_med"

/obj/item/clothing/suit/storage/service/marine/medical/command
	name = "marine medical command jacket"
	desc = "An SCG Marine Corps service coat. This one has blue and gold markings."
	icon_state = "greenservice_medcom"
	item_state = "greenservice_medcom"

/obj/item/clothing/suit/storage/service/marine/engineering
	name = "marine engineering jacket"
	desc = "An SCG Marine Corps service coat. This one has orange markings."
	icon_state = "greenservice_eng"
	item_state = "greenservice_eng"

/obj/item/clothing/suit/storage/service/marine/engineering/command
	name = "marine engineering command jacket"
	desc = "An SCG Marine Corps service coat. This one has orange and gold markings."
	icon_state = "greenservice_engcom"
	item_state = "greenservice_engcom"

/obj/item/clothing/suit/storage/service/marine/supply
	name = "marine supply jacket"
	desc = "An SCG Marine Corps service coat. This one has brown markings."
	icon_state = "greenservice_sup"
	item_state = "greenservice_sup"

/obj/item/clothing/suit/storage/service/marine/security
	name = "marine security jacket"
	desc = "An SCG Marine Corps service coat. This one has red markings."
	icon_state = "greenservice_sec"
	item_state = "greenservice_sec"

/obj/item/clothing/suit/storage/service/marine/security/command
	name = "marine security command jacket"
	desc = "An SCG Marine Corps service coat. This one has red and gold markings."
	icon_state = "greenservice_seccom"
	item_state = "greenservice_seccom"

/obj/item/clothing/suit/storage/service/marine/command
	name = "marine command jacket"
	desc = "An SCG Marine Corps service coat. This one has gold markings."
	icon_state = "greenservice_com"
	item_state = "greenservice_com"

//Dress

/obj/item/clothing/suit/dress
	name = "dress jacket"
	desc = "A uniform dress jacket, fancy."
	icon_state = "greydress"
	item_state = "greydress"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/device/radio,/obj/item/weapon/pen)
	valid_accessory_slots = list("medal","rank")

/obj/item/clothing/suit/dress/expedition
	name = "expeditionary dress jacket"
	desc = "A silver and grey dress jacket belonging to the SCG Expeditionary Corps. Fashionable, for the 25th century at least."
	icon_state = "greydress"
	item_state = "greydress"

/obj/item/clothing/suit/dress/expedition/command
	name = "expeditionary officer's dress jacket"
	desc = "A gold and grey dress jacket belonging to the SCG Expeditionary Corps. The height of fashion."
	icon_state = "greydress_com"
	item_state = "greydress_com"

/obj/item/clothing/suit/storage/toggle/dress
	name = "clasped dress jacket"
	desc = "A uniform dress jacket with gold toggles."
	icon_state = "whitedress"
	//item_state = "labcoat"
	icon_open = "whitedress_open"
	icon_closed = "whitedress"
	blood_overlay_type = "coat"
	valid_accessory_slots = list("medal","rank")

/obj/item/clothing/suit/storage/toggle/dress/fleet
	name = "fleet dress jacket"
	desc = "A crisp white SCG Fleet dress jacket with blue and gold accents. Don't get near pasta sauce or vox."

/obj/item/clothing/suit/storage/toggle/dress/fleet/command
	name = "fleet officer's dress jacket"
	desc = "A crisp white SCG Fleet dress jacket dripping with gold accents. So bright it's blinding."
	icon_state = "whitedress_com"
	//item_state = "labcoat"
	icon_open = "whitedress_com_open"
	icon_closed = "whitedress_com"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/dress/marine
	name = "marine dress jacket"
	desc = "A tailored black SCG Marine Corps dress jacket with red trim. So sexy it hurts."
	icon_state = "blackdress"
	item_state = "blackdress"

/obj/item/clothing/suit/dress/marine/command
	name = "marine officer's dress jacket"
	desc = "A tailored black SCG Marine Corps dress jacket with gold trim. Smells like ceremony."
	icon_state = "blackdress_com"
	item_state = "blackdress_com"

//Misc

/obj/item/clothing/suit/storage/toggle/marshal_jacket
	name = "colonial marshal jacket"
	desc = "A black synthleather jacket. The word 'MARSHAL' is stenciled onto the back in gold lettering."
	icon_state = "marshal_jacket"
	//item_state = "brown_jacket"
	icon_open = "marshal_jacket_open"
	icon_closed = "marshal_jacket"
	body_parts_covered = UPPER_TORSO|ARMS
	valid_accessory_slots = list("decor")
