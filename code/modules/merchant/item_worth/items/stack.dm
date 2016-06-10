/obj/item/stack
	item_worth = 5

/obj/item/stack/get_worth()
	return initial(item_worth) * amount

/obj/item/stack/material/get_worth()
	if(!material)
		return ..()
	return material.material_worth * amount


/obj/item/stack/medical
	item_worth = 15

/obj/item/stack/medical/advanced/bruise_pack
	item_worth = 30

/obj/item/stack/medical/advanced/ointment
	item_worth = 40

/obj/item/stack/medical/splint
	item_worth = 25

/obj/item/stack/nanopaste
	item_worth = 30

/obj/item/stack/rods
	item_worth = 5

/obj/item/stack/telecrystal
	item_worth = 100

/obj/item/stack/wax
	item_worth = 5

//For NPC prices
/obj/item/stack/material
	item_worth = 5

/obj/item/stack/material/marble
	item_worth = 20

/obj/item/stack/material/diamond
	item_worth = 60

/obj/item/stack/material/uranium
	item_worth = 120

/obj/item/stack/material/plastic
	item_worth = 15

/obj/item/stack/material/gold
	item_worth = 55

/obj/item/stack/material/silver
	item_worth = 45

/obj/item/stack/material/platinum
	item_worth = 95

/obj/item/stack/material/mhydrogen
	item_worth = 110

/obj/item/stack/material/tritium
	item_worth = 100

/obj/item/stack/material/osmium
	item_worth = 100

/obj/item/stack/material/plasteel
	item_worth = 40

/obj/item/stack/material/wood
	item_worth = 2

/obj/item/stack/material/cloth
	item_worth = 3

/obj/item/stack/material/cardboard
	item_worth = 1

/obj/item/stack/material/glass/reinforced
	item_worth = 12

/obj/item/stack/material/glass/phoronglass
	item_worth = 35

/obj/item/stack/material/glass/phoronrglass
	item_worth = 65
