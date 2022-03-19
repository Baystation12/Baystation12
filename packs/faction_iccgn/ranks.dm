/obj/item/clothing/accessory/iccgn_rank
	name = "base rank insignia, ICCGN"
	desc = "You should not see this."
	icon = 'packs/faction_iccgn/ranks.dmi'
	accessory_icons = list(
		slot_w_uniform_str = 'packs/faction_iccgn/ranks.dmi',
		slot_wear_suit_str = 'packs/faction_iccgn/ranks.dmi'
	)
	icon_state = "error"
	on_rolled = list(
		"down" = "none"
	)
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_RANK
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY
	gender = PLURAL


/obj/item/clothing/accessory/iccgn_rank/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/accessory/iccgn_rank)


/obj/item/clothing/accessory/iccgn_rank/get_fibers()
	return null


/obj/item/clothing/accessory/iccgn_rank/e1
	name = "rank insignia, E1 Guardian Recruit"
	desc = "Collar tabs that denote the Confederation Navy E1 rank of Guardian Recruit."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e3
	name = "rank insignia, E3 Guardian"
	desc = "Collar tabs denoting the Confederation Navy E3 rank of Guardian."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e4
	name = "rank insignia, E4 Corporal"
	desc = "Collar tabs denoting the Confederation Navy E4 rank of Corporal."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e5
	name = "rank insignia, E5 Star Corporal"
	desc = "Collar tabs denoting the Confederation Navy E5 rank of Star Corporal."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e6
	name = "rank insignia, E6 Sergeant"
	desc = "Collar tabs denoting the Confederation Navy E6 rank of Sergeant."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e7
	name = "rank insignia, E7 Laserey Sergeant"
	desc = "Collar tabs denoting the Confederation Navy E7 rank of Laserey Sergeant."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e8
	name = "rank insignia, E8 Master Sergeant"
	desc = "Collar tabs denoting the Confederation Navy E8 rank of Master Sergeant."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e9
	name = "rank insignia, E9 Command Master Sergeant"
	desc = "Collar tabs denoting the Confederation Navy E9 rank of Command Master Sergeant."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/o1
	name = "rank insignia, O1 Junker"
	desc = "Collar tabs denoting the Confederation Navy O1 rank of Junker."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o2
	name = "rank insignia, O2 Leftenant"
	desc = "Collar tabs denoting the Confederation Navy O2 rank of Leftenant."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o3
	name = "rank insignia, O3 Star Leftenant"
	desc = "Collar tabs denoting the Confederation Navy O3 rank of Star Leftenant."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o4
	name = "rank insignia, O4 Commander"
	desc = "Collar tabs denoting the Confederation Navy O4 rank of Commander."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o5
	name = "rank insignia, O5 Star Commander"
	desc = "Collar tabs denoting the Confederation Navy O5 rank of Star Commander."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o6
	name = "rank insignia, O6 Captain"
	desc = "Collar tabs denoting the Confederation Navy O6 rank of Captain."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o7
	name = "rank insignia, O7 Star Captain"
	desc = "Collar tabs denoting the Confederation Navy O7 rank of Star Captain."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o8
	name = "rank insignia, O8 Vice-Admiral"
	desc = "Collar tabs denoting the Confederation Navy O8 rank of Vice-Admiral."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o9
	name = "rank insignia, O9 Admiral"
	desc = "Collar tabs denoting the Confederation Navy O9 rank of Admiral."
	icon_state = "officer"
	overlay_state = "officer_worn"
