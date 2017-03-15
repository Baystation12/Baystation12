/datum/gear/uniform/casual_pants
    display_name = "casual pants selection"
    path = /obj/item/clothing/under/casual_pants

/datum/gear/uniform/casual_pants/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/under/casual_pants)

/datum/gear/uniform/formal_pants
    display_name = "formal pants selection"
    path = /obj/item/clothing/under/formal_pants

/datum/gear/uniform/formal_pants/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/under/formal_pants)

/datum/gear/uniform/shorts
	display_name = "shorts selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/under/shorts/jeans)
