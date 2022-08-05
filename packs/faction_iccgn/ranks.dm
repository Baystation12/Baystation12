/obj/item/clothing/accessory/iccgn_rank
	abstract_type = /obj/item/clothing/accessory/iccgn_rank
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


/obj/item/clothing/accessory/iccgn_rank/get_fibers()
	return null


/obj/item/clothing/accessory/iccgn_rank/e1
	name = "rank insignia, E1 Eleve Sailor"
	desc = "Collar tabs denoting the GCN E-1 rank of Eleve Sailor."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e3
	name = "rank insignia, E3 Sailor"
	desc = "Collar tabs denoting the GCN E-3 rank of Sailor."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e4
	name = "rank insignia, E4 Bosman"
	desc = "Collar tabs denoting the GCN E-4 rank of Bosman."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e5
	name = "rank insignia, E5 Starszy Bosman"
	desc = "Collar tabs denoting the GCN E-5 rank of Starszy Bosman."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e6
	name = "rank insignia, E6 Sierzant"
	desc = "Collar tabs denoting the GCN E-6 rank of Sierzant."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e7
	name = "rank insignia, E7 Starshyna"
	desc = "Collar tabs denoting the GCN E-7 rank of Starshyna."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e8
	name = "rank insignia, E8 Adjutant"
	desc = "Collar tabs denoting the GCN E-8 rank of Adjutant."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e9
	name = "rank insignia, E9 Major"
	desc = "Collar tabs denoting the GCN E-9 rank of Major."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/o1
	name = "rank insignia, O1 Michman"
	desc = "Collar tabs denoting the GCN O-1 rank of Michman."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o2
	name = "rank insignia, O2 Sous-Leytenant"
	desc = "Collar tabs denoting the GCN O-2 rank of Sous-Leytenant."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o3
	name = "rank insignia, O3 Leytenant"
	desc = "Collar tabs denoting the GCN O-3 rank of Leytenant."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o4
	name = "rank insignia, O4 Sub-Komandor"
	desc = "Collar tabs denoting the GCN O-4 rank of Sub-Komandor."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o5
	name = "rank insignia, O5 Komandor"
	desc = "Collar tabs denoting the GCN O-5 rank of Komandor."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o6
	name = "rank insignia, O6 Kapitan"
	desc = "Collar tabs denoting the GCN O-6 rank of Kapitan."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o7
	name = "rank insignia, O7 Starszy Kapitan"
	desc = "Collar tabs denoting the GCN O-7 rank of Starszy Kapitan."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o8
	name = "rank insignia, O8 Vice-Admiral"
	desc = "Collar tabs denoting the GCN O-8 rank of Vice-Admiral."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o9
	name = "rank insignia, O9 Admiral"
	desc = "Collar tabs denoting the GCN O-9 rank of Admiral."
	icon_state = "officer"
	overlay_state = "officer_worn"
