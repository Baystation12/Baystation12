// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear or slot_l_ear as the slot, or else players will spawn with no headset.
/datum/gear/ears
	display_name = "orejeras"
	path = /obj/item/clothing/ears/earmuffs
	sort_category = "Earwear"

/datum/gear/headphones
	display_name = "auriculares"
	path = /obj/item/clothing/ears/headphones
	sort_category = "Earwear"

/datum/gear/earrings
	display_name = "aretes"
	path = /obj/item/clothing/ears/earring
	sort_category = "Earwear"

/datum/gear/earrings/New()
	..()
	var/earrings = list()
	earrings["clavo, perla"] = /obj/item/clothing/ears/earring/stud
	earrings["clavo, cristal"] = /obj/item/clothing/ears/earring/stud/glass
	earrings["clavo, madera"] = /obj/item/clothing/ears/earring/stud/wood
	earrings["clavo, hierro"] = /obj/item/clothing/ears/earring/stud/iron
	earrings["clavo, acero"] = /obj/item/clothing/ears/earring/stud/steel
	earrings["clavo, plata"] = /obj/item/clothing/ears/earring/stud/silver
	earrings["clavo, oro"] = /obj/item/clothing/ears/earring/stud/gold
	earrings["clavo, platino"] = /obj/item/clothing/ears/earring/stud/platinum
	earrings["clavo, diamante"] = /obj/item/clothing/ears/earring/stud/diamond
	earrings["colgante, cristal"] = /obj/item/clothing/ears/earring/dangle/glass
	earrings["colgante, madera"] = /obj/item/clothing/ears/earring/dangle/wood
	earrings["colgante, hierro"] = /obj/item/clothing/ears/earring/dangle/iron
	earrings["colgante, acero"] = /obj/item/clothing/ears/earring/dangle/steel
	earrings["colgante, plata"] = /obj/item/clothing/ears/earring/dangle/silver
	earrings["colgante, oro"] = /obj/item/clothing/ears/earring/dangle/gold
	earrings["colgante, platino"] = /obj/item/clothing/ears/earring/dangle/platinum
	earrings["colgante, diamante"] = /obj/item/clothing/ears/earring/dangle/diamond
	gear_tweaks += new/datum/gear_tweak/path(earrings)
