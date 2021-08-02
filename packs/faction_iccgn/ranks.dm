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
	high_visibility = TRUE
	gender = PLURAL


/obj/item/clothing/accessory/iccgn_rank/Initialize()
	. = ..()
	INIT_SKIP_QDELETED
	INIT_DISALLOW_TYPE(/obj/item/clothing/accessory/iccgn_rank)


/obj/item/clothing/accessory/iccgn_rank/get_fibers()
	return null


/obj/item/clothing/accessory/iccgn_rank/e1
	name = "rank insignia, E1 Sailor Recruit"
	desc = "Collar tabs denoting the confederation navy E1 rank of Sailor Recruit."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e3
	name = "rank insignia, E3 Sailor"
	desc = "Collar tabs denoting the confederation navy E3 rank of Sailor."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e4
	name = "rank insignia, E4 Bosman"
	desc = "Collar tabs denoting the confederation navy E4 rank of Bosman."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e5
	name = "rank insignia, E5 Starszy Bosman"
	desc = "Collar tabs denoting the confederation navy E5 rank of Starszy Bosman."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e6
	name = "rank insignia, E6 Serzhant"
	desc = "Collar tabs denoting the confederation navy E6 rank of Serzhant."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e7
	name = "rank insignia, E7 Glavny Serzhant"
	desc = "Collar tabs denoting the confederation navy E7 rank of Glavny Serzhant."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e8
	name = "rank insignia, E8 Starshina"
	desc = "Collar tabs denoting the confederation navy E8 rank of Starshina."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/e9
	name = "rank insignia, E9 Michman"
	desc = "Collar tabs denoting the confederation navy E9 rank of Michman."
	icon_state = "enlisted"
	overlay_state = "enlisted_worn"


/obj/item/clothing/accessory/iccgn_rank/o1
	name = "rank insignia, O1 Junker"
	desc = "Collar tabs denoting the confederation navy O1 rank of Junker."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o2
	name = "rank insignia, O2 Leytenant"
	desc = "Collar tabs denoting the confederation navy O2 rank of Leytenant."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o3
	name = "rank insignia, O3 Starszy Leytenant"
	desc = "Collar tabs denoting the confederation navy O3 rank of Starszy Leytenant."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o4
	name = "rank insignia, O4 Sub-Komandor"
	desc = "Collar tabs denoting the confederation navy O4 rank of Sub-Komandor."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o5
	name = "rank insignia, O5 Komandor"
	desc = "Collar tabs denoting the confederation navy O5 rank of Komandor."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o6
	name = "rank insignia, O6 Kapitan"
	desc = "Collar tabs denoting the confederation navy O6 rank of Kapitan."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o7
	name = "rank insignia, O7 Starszy Kapitan"
	desc = "Collar tabs denoting the confederation navy O7 rank of Starszy Kapitan."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o8
	name = "rank insignia, O8 Vice-Admiral"
	desc = "Collar tabs denoting the confederation navy O8 rank of Vice-Admiral."
	icon_state = "officer"
	overlay_state = "officer_worn"


/obj/item/clothing/accessory/iccgn_rank/o9
	name = "rank insignia, O9 Admiral"
	desc = "Collar tabs denoting the confederation navy O9 rank of Admiral."
	icon_state = "officer"
	overlay_state = "officer_worn"
