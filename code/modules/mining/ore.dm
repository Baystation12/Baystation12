/obj/item/weapon/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"
	var/datum/geosample/geologic_data
	var/oretag

/obj/item/weapon/ore/uranium
	name = "pitchblende"
	icon_state = "Uranium ore"
	origin_tech = "materials=5"
	oretag = "uranium"

/obj/item/weapon/ore/iron
	name = "hematite"
	icon_state = "Iron ore"
	origin_tech = "materials=1"
	oretag = "hematite"

/obj/item/weapon/ore/coal
	name = "carbonaceous rock"
	icon_state = "Coal ore"
	origin_tech = "materials=1"
	oretag = "coal"

/obj/item/weapon/ore/glass
	name = "impure silicates"
	icon_state = "Glass ore"
	origin_tech = "materials=1"
	oretag = "sand"

/obj/item/weapon/ore/phoron
	name = "phoron crystals"
	icon_state = "Phoron ore"
	origin_tech = "materials=2"
	oretag = "phoron"

/obj/item/weapon/ore/silver
	name = "native silver ore"
	icon_state = "Silver ore"
	origin_tech = "materials=3"
	oretag = "silver"

/obj/item/weapon/ore/gold
	name = "native gold ore"
	icon_state = "Gold ore"
	origin_tech = "materials=4"
	oretag = "gold"

/obj/item/weapon/ore/diamond
	name = "diamonds"
	icon_state = "Diamond ore"
	origin_tech = "materials=6"
	oretag = "diamond"

/obj/item/weapon/ore/osmium
	name = "raw platinum"
	icon_state = "Platinum ore"
	oretag = "platinum"

/obj/item/weapon/ore/hydrogen
	name = "raw hydrogen"
	icon_state = "Phazon"
	oretag = "hydrogen"

/obj/item/weapon/ore/slag
	name = "Slag"
	desc = "Completely useless"
	icon_state = "slag"
	oretag = "slag"

/obj/item/weapon/ore/New()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/weapon/ore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()