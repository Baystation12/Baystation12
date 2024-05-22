/datum/gear/passport/resomi
	display_name = "(Resomi) registration document"
	path = /obj/item/passport/xeno/resomi
	sort_category = "Xenowear"
	flags = 0
	whitelisted = list(SPECIES_RESOMI)
	custom_setup_proc = /obj/item/passport/proc/set_info
	cost = 0


/datum/gear/uniform/resomi
	display_name = "(Resomi) uniform, colored"
	path = /obj/item/clothing/under/resomi/white
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/uniform/resomi/smock
	display_name = "(Resomi) uniform, standart"
	path = /obj/item/clothing/under/resomi
	flags = 0

/datum/gear/uniform/resomi/smock/New()
	..()
	var/uniform = list()
	uniform["rainbow smock"]	 =	/obj/item/clothing/under/resomi/rainbow
	uniform["sport uniform"]	 =	/obj/item/clothing/under/resomi/sport
	uniform["black utility uniform"]	 =	/obj/item/clothing/under/resomi/utility
	uniform["grey utility uniform"]	 =	/obj/item/clothing/under/resomi/utility/black
	uniform["engineering smock"] =	/obj/item/clothing/under/resomi/yellow
	uniform["robotics smock"]	 =	/obj/item/clothing/under/resomi/robotics
	uniform["security smock"]	 =	/obj/item/clothing/under/resomi/red
	uniform["medical uniform"]	 =	/obj/item/clothing/under/resomi/medical
	uniform["science uniform"]	 =	/obj/item/clothing/under/resomi/science
	gear_tweaks += new/datum/gear_tweak/path(uniform)


/datum/gear/uniform/resomi/expedition
	display_name = "(Resomi) uniform, expeditionary"
	path = /obj/item/clothing/under/solgov
	flags = 0

/datum/gear/uniform/resomi/expedition/New()
	..()
	var/uniform = list()
	uniform["standart uniform"]	 =	/obj/item/clothing/under/solgov/utility/expeditionary/resomi
	uniform["pt smock"]			 =	/obj/item/clothing/under/solgov/pt/expeditionary/resomi
	uniform["officer's uniform"] =	/obj/item/clothing/under/solgov/utility/expeditionary/officer/resomi
	uniform["dress uniform"]	 =	/obj/item/clothing/under/solgov/mildress/expeditionary/resomi
	gear_tweaks += new/datum/gear_tweak/path(uniform)


/datum/gear/uniform/resomi/dress
	display_name = "(Resomi) uniform, dress"
	path = /obj/item/clothing/under/resomi/dress
	flags = GEAR_HAS_TYPE_SELECTION


/datum/gear/uniform/resomi/worksmock
	display_name = "(Resomi) uniform, work"
	path = /obj/item/clothing/under/resomi/work
	flags = GEAR_HAS_TYPE_SELECTION


/datum/gear/uniform/resomi/undercoat
	display_name = "(Resomi) uniform, undercoat"
	path = /obj/item/clothing/under/resomi/undercoat
	flags = GEAR_HAS_TYPE_SELECTION


/datum/gear/tactical/security_uniforms/resomi
	display_name = "(Resomi) uniform, Security"
	path = /obj/item/clothing/under/resomi/red
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/tactical/security_uniforms/resomi/New()
	return


/datum/gear/eyes/resomi
	display_name = "(Resomi) sun lenses"
	path = /obj/item/clothing/glasses/sunglasses/lenses
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)


/datum/gear/eyes/security/resomi
	display_name = "(Resomi) sun sechud lenses"
	path = /obj/item/clothing/glasses/sunglasses/sechud/lenses
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/eyes/security/resomi/New()
	return


/datum/gear/eyes/medical/resomi
	display_name = "(Resomi) sun medhud lenses"
	path = /obj/item/clothing/glasses/hud/health/lenses
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/eyes/medical/resomi/New()
	return


/datum/gear/accessory/resomi_mantle
	display_name = "(Resomi) small mantle"
	path = /obj/item/clothing/accessory/scarf/resomi
	flags = GEAR_HAS_COLOR_SELECTION
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)


/datum/gear/shoes/resomi
	display_name = "(Resomi) small workboots"
	path = /obj/item/clothing/shoes/workboots/resomi
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)


/datum/gear/shoes/resomi/footwraps
	display_name = "(Resomi) foots clothwraps"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/shoes/footwraps


/datum/gear/shoes/resomi/socks
	display_name = "(Resomi) koishi"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/shoes/footwraps/socks_resomi


/datum/gear/suit/resomi
	display_name = "(Resomi) cloaks, alt"
	path = /obj/item/clothing/suit/storage/resomicloak_alt
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)
	flags = GEAR_HAS_SUBTYPE_SELECTION


/datum/gear/suit/resomi/standart
	display_name = "(Resomi) cloaks, standart"
	path = /obj/item/clothing/suit/storage/resomicloak
	flags = GEAR_HAS_TYPE_SELECTION


/datum/gear/suit/resomi/belted
	display_name = "(Resomi) cloaks, belted"
	path = /obj/item/clothing/suit/storage/resomicloak_belted


/datum/gear/suit/resomi/hood
	display_name = "(Resomi) cloaks, hooded"
	path = /obj/item/clothing/suit/storage/hooded/resomi


/datum/gear/suit/resomi/labcoat
	display_name = "(Resomi) small labcoat"
	path = /obj/item/clothing/suit/storage/toggle/resomilabcoat
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/suit/resomi_coat
	display_name = "(Resomi) coats selection"
	path = /obj/item/clothing/suit/storage/toggle/resomicoat
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/suit/resomi_coat/New()
	..()
	var/resomi = list()
	resomi["black coat"] = /obj/item/clothing/suit/storage/toggle/resomicoat
	resomi["white coat"] = /obj/item/clothing/suit/storage/toggle/resomicoat/white
	gear_tweaks += new/datum/gear_tweak/path(resomi)


/datum/gear/plush_toy/New()
	toy_list["resomi plush"] = /obj/item/toy/plushie/resomi
	..()
