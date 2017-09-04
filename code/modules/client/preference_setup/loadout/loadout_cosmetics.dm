/datum/gear/cosmetic
	display_name = "purple comb"
	path = /obj/item/weapon/haircomb
	sort_category = "Cosmetics"

/datum/gear/cosmetic/lipstick
	display_name = "lipstick selection"
	path = /obj/item/weapon/lipstick/black

/datum/gear/cosmetic/lipstick/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/weapon/lipstick)

/datum/gear/cosmetic/mirror
	display_name = "handheld mirror"
	path = /obj/item/weapon/mirror
	path = /obj/item/weapon/mirror
