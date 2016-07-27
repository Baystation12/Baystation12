//SolGov uniform hats

//Utility
/obj/item/clothing/head/soft/sol
	name = "\improper Sol Central Government cap"
	desc = "It's a blue ballcap in SCG colors."
	icon_state = "solsoft"

/obj/item/clothing/head/soft/sol/expedition
	name = "\improper Expeditionary Corps cap"
	desc = "It's a black ballcap bearing the Expeditonary Corps crest."
	icon_state = "expeditionsoft"

/obj/item/clothing/head/soft/sol/fleet
	name = "fleet cap"
	desc = "It's a navy blue ballcap with the SCG Fleet crest."
	icon_state = "fleetsoft"

/obj/item/clothing/head/utility
	name = "utility cover"
	desc = "An eight-point utility cover."
	icon_state = "greyutility"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/utility/fleet
	name = "fleet utility cover"
	desc = "A navy blue utility cover bearing the crest of the SCG Fleet."
	icon_state = "navyutility"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/head/utility/marine
	name = "marine utility cover"
	desc = "A grey utility cover bearing the crest of the SCG Marine Corps."
	icon_state = "greyutility"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/utility/marine/tan
	name = "tan utility cover"
	desc = "A tan utility cover bearing the crest of the SCG Marine Corps."
	icon_state = "tanutility"

/obj/item/clothing/head/utility/marine/green
	name = "green utility cover"
	desc = "A green utility cover bearing the crest of the SCG Marine Corps."
	icon_state = "greenutility"

//Service

/obj/item/clothing/head/service
	name = "service cover"
	desc = "A service uniform cover."
	icon_state = "greenwheelcap"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/service/marine
	name = "marine wheel cover"
	desc = "A green service uniform cover with an SCG Marine Corps crest."
	icon_state = "greenwheelcap"

/obj/item/clothing/head/service/marine/command
	name = "marine officer's wheel cover"
	desc = "A green service uniform cover with an SCG Marine Corps crest and gold stripe."
	icon_state = "greenwheelcap_com"

/obj/item/clothing/head/service/marine/garrison
	name = "marine garrison cap"
	desc = "A green garrison cap belonging to the SCG Marine Corps."
	icon_state = "greengarrisoncap"

/obj/item/clothing/head/service/marine/garrison/command
	name = "marine officer's garrison cap"
	desc = "A green garrison cap belonging to the SCG Marine Corps. This one has a gold pin."
	icon_state = "greengarrisoncap_com"

/obj/item/clothing/head/service/marine/campaign
	name = "campaign cover"
	desc = "A green campaign cover with an SCG Marine Corps crest. Only found on the heads of Drill Instructors."
	icon_state = "greendrill"

//Dress

/obj/item/clothing/head/dress
	name = "dress cover"
	desc = "A dress uniform cover."
	icon_state = "greenwheelcap"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/dress/expedition
	name = "expedition dress cap"
	desc = "A peaked grey dress uniform cap belonging to the SCG Expeditionary Corps."
	icon_state = "greydresscap"

/obj/item/clothing/head/dress/expedition/command
	name = "expedition command dress cap"
	desc = "A peaked grey dress uniform cap belonging to the SCG Expeditionary Corps. This one is trimmed in gold."
	icon_state = "greydresscap_com"

/obj/item/clothing/head/dress/fleet
	name = "fleet dress wheel cover"
	desc = "A white dress uniform cover. This one has an SCG Fleet crest."
	icon_state = "whitepeakcap"

/obj/item/clothing/head/dress/fleet/command
	name = "fleet command dress wheel cover"
	desc = "A white dress uniform cover. This one has a gold stripe and an SCG Fleet crest."
	icon_state = "whitepeakcap_com"

/obj/item/clothing/head/dress/marine
	name = "marine dress wheel cover"
	desc = "A white dress uniform cover with an SCG Marine Corps crest."
	icon_state = "whitewheelcap"

/obj/item/clothing/head/dress/marine/command
	name = "marine officer's dress wheel cover"
	desc = "A white dress uniform cover with an SCG Marine Corps crest and gold stripe."
	icon_state = "whitewheelcap_com"