/datum/gear/challenge_coin
	display_name = "challenge coins"
	description = "A selection of challenge coins for identification, collection or simply bragging rights"
	path = /obj/item/challenge_coin
	cost = 1

/datum/gear/challenge_coin/New()
	..()
	var/cointype = list()
	cointype["SCG Fleet challenge coin"] = /obj/item/challenge_coin/scg_fleet
	cointype["SCG Army challenge coin"] = /obj/item/challenge_coin/scg_army
	cointype["SCGF Naval Armsmen challenge coin"] = /obj/item/challenge_coin/scg_naval_armsmen
	cointype["SCGDF Gaia Conflict challenge coin"] = /obj/item/challenge_coin/scg_gaia
	cointype["SCG Expeditionary Corps Observatory challenge coin"] = /obj/item/challenge_coin/expeditionary_corps_observatory
	cointype["SCG Expeditionary Corps Field Operations challenge coin"] = /obj/item/challenge_coin/expeditionary_corps_field_ops
	cointype["SEV Torch challenge coin"] = /obj/item/challenge_coin/expeditionary_corps_torch
	cointype["PCRC challenge coin"] = /obj/item/challenge_coin/pcrc
	cointype["SAARE challenge coin"] = /obj/item/challenge_coin/saare
	gear_tweaks += new/datum/gear_tweak/path(cointype)

/datum/gear/challenge_coin_iccg
	display_name = "ICCG challenge coins"
	description = "A selection of challenge coins used from the ICCG for identification, collection or simply bragging rights"
	path = /obj/item/challenge_coin
	allowed_branches = SOLGOV_MILITARY_RESTRICTED
	cost = 1

/datum/gear/challenge_coin_iccg/New()
	..()
	var/cointype = list()
	cointype["Independent Navy challenge coin"] = /obj/item/challenge_coin/iccg_navy
	cointype["Independent Surface Warfare Corps challenge coin"] = /obj/item/challenge_coin/iccg_swc
	cointype["Independent Naval Infantry challenge coin"] = /obj/item/challenge_coin/iccg_naval_infantry
	gear_tweaks += new/datum/gear_tweak/path(cointype)
