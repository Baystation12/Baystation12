/************
ranks - TCC
************/

/obj/item/clothing/accessory/terran/rank/navy
	name = "naval ranks"
	desc = "Insignia denoting naval rank of some kind. These appear blank."
	icon = 'maps/torch/icons/obj/obj_accessories_terran.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_terran.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_terran.dmi')
	icon_state = "terranrank"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_RANK
	gender = PLURAL
	high_visibility = 1

/obj/item/clothing/accessory/terran/rank/navy/enlisted
	name = "ranks (E-1 sailor recruit)"
	desc = "Insignia denoting the rank of Sailor Recruit."
	icon_state = "terranrank_enlisted"

/obj/item/clothing/accessory/terran/rank/navy/enlisted/e3
	name = "ranks (E-3 sailor)"
	desc = "Insignia denoting the rank of Crewman."

/obj/item/clothing/accessory/terran/rank/navy/enlisted/e4
	name = "ranks (E-4 bosman)"
	desc = "Insignia denoting the rank of Bosman."

/obj/item/clothing/accessory/terran/rank/navy/enlisted/e6
	name = "ranks (E-6 starszy bosman)"
	desc = "Insignia denoting the rank of Starszy Bosman."

/obj/item/clothing/accessory/terran/rank/navy/enlisted/e7
	name = "ranks (E-7 glavny starshina)"
	desc = "Insignia denoting the rank of Glavny Starshina."

/obj/item/clothing/accessory/terran/rank/navy/enlisted/e9
	name = "ranks (E-9 michman)"
	desc = "Insignia denoting the rank of Michman."

/obj/item/clothing/accessory/terran/rank/navy/enlisted/e9_alt1
	name = "ranks (E-9 michman of the independent navy)"
	desc = "Insignia denoting the rank of Michman of the Independent Navy."

/obj/item/clothing/accessory/terran/rank/navy/officer
	name = "ranks (O-1 ensign)"
	desc = "Insignia denoting the rank of Ensign."
	icon_state = "terranrank_officer"

/obj/item/clothing/accessory/terran/rank/navy/officer/o2
	name = "ranks (O-2 leytenant)"
	desc = "Insignia denoting the rank of Leytenant."

/obj/item/clothing/accessory/terran/rank/navy/officer/o3
	name = "ranks (O-3 starshy leytenant)"
	desc = "Insignia denoting the rank of Starshy Leytenant."

/obj/item/clothing/accessory/terran/rank/navy/officer/o4
	name = "ranks (O-4 corvette-komandor)"
	desc = "Insignia denoting the rank of Corvette-Komandor."

/obj/item/clothing/accessory/terran/rank/navy/officer/o5
	name = "ranks (O-5 komandor)"
	desc = "Insignia denoting the rank of Komandor."

/obj/item/clothing/accessory/terran/rank/navy/officer/o6
	name = "ranks (O-6 kapitan)"
	desc = "Insignia denoting the rank of Kapitan."
	icon_state = "terranrank_command"

/obj/item/clothing/accessory/terran/rank/navy/flag
	name = "ranks (O-7 kontradmiral)"
	desc = "Insignia denoting the rank of Kontradmiral."
	icon_state = "terranrank_command"

/obj/item/clothing/accessory/terran/rank/navy/flag/o8
	name = "ranks (O-8 wiceadmiral)"
	desc = "Insignia denoting the rank of Wiceadmiral."

/obj/item/clothing/accessory/terran/rank/navy/flag/o9
	name = "ranks (O-9 admiral)"
	desc = "Insignia denoting the rank of Admiral."

/obj/item/clothing/accessory/terran/rank/navy/flag/o10
	name = "ranks (O-10 admiral of the independent navy)"
	desc = "Insignia denoting the rank of Admiral of the Independent Navy."