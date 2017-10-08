// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear or slot_l_ear as the slot, or else players will spawn with no headset.
/datum/gear/ears
	display_name = "earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	sort_category = "Earwear"

/datum/gear/headphones
	display_name = "headphones"
	path = /obj/item/clothing/ears/earmuffs/headphones
	sort_category = "Earwear"

/datum/gear/earrings
	display_name = "earrings"
	path = /obj/item/clothing/ears/earring
	sort_category = "Earwear"

/datum/gear/earrings/New()
	..()
	var/earrings = list()
	earrings["stud, pearl"] = /obj/item/clothing/ears/earring/stud
	earrings["stud, glass"] = /obj/item/clothing/ears/earring/stud/material/glass
	earrings["stud, wood"] = /obj/item/clothing/ears/earring/stud/material/wood
	earrings["stud, iron"] = /obj/item/clothing/ears/earring/stud/material/iron
	earrings["stud, steel"] = /obj/item/clothing/ears/earring/stud/material/steel
	earrings["stud, plasteel"] = /obj/item/clothing/ears/earring/stud/material/plasteel
	earrings["stud, titanium"] = /obj/item/clothing/ears/earring/stud/material/titanium
	earrings["stud, silver"] = /obj/item/clothing/ears/earring/stud/material/silver
	earrings["stud, gold"] = /obj/item/clothing/ears/earring/stud/material/gold
	earrings["stud, platinum"] = /obj/item/clothing/ears/earring/stud/material/platinum
	earrings["stud, diamond"] = /obj/item/clothing/ears/earring/stud/material/diamond
	earrings["dangle, glass"] = /obj/item/clothing/ears/earring/dangle/material/glass
	earrings["dangle, wood"] = /obj/item/clothing/ears/earring/dangle/material/wood
	earrings["dangle, iron"] = /obj/item/clothing/ears/earring/dangle/material/iron
	earrings["dangle, steel"] = /obj/item/clothing/ears/earring/dangle/material/steel
	earrings["dangle, plasteel"] = /obj/item/clothing/ears/earring/dangle/material/plasteel
	earrings["dangle, titanium"] = /obj/item/clothing/ears/earring/dangle/material/titanium
	earrings["dangle, silver"] = /obj/item/clothing/ears/earring/dangle/material/silver
	earrings["dangle, gold"] = /obj/item/clothing/ears/earring/dangle/material/gold
	earrings["dangle, platinum"] = /obj/item/clothing/ears/earring/dangle/material/platinum
	earrings["dangle, diamond"] = /obj/item/clothing/ears/earring/dangle/material/diamond
	gear_tweaks += new/datum/gear_tweak/path(earrings)