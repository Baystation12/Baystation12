/obj/item/weapon/gun/composite/premade/laser_cannon
	name = "laser cannon"
	icon_state = "laser_cannon"
	variant_chamber = /obj/item/gun_component/chamber/laser/cannon
	variant_stock =   /obj/item/gun_component/stock/cannon/laser
	variant_grip =    /obj/item/gun_component/grip/cannon/laser
	variant_body =    /obj/item/gun_component/body/cannon/laser
	variant_barrel =  /obj/item/gun_component/barrel/laser/cannon

/obj/item/weapon/gun/composite/premade/laser_smg
	name = "laser submachine gun"
	icon_state = "laser_smg"
	variant_chamber = /obj/item/gun_component/chamber/laser/smg
	variant_stock =   /obj/item/gun_component/stock/smg/laser
	variant_grip =    /obj/item/gun_component/grip/smg/laser
	variant_body =    /obj/item/gun_component/body/smg/laser
	variant_barrel =  /obj/item/gun_component/barrel/laser/variable/smg

/obj/item/weapon/gun/composite/premade/laser_pistol
	name = "laser pistol"
	icon_state = "laser_pistol"
	variant_chamber = /obj/item/gun_component/chamber/laser/pistol
	variant_stock =   /obj/item/gun_component/stock/pistol/laser
	variant_grip =    /obj/item/gun_component/grip/pistol/laser
	variant_body =    /obj/item/gun_component/body/pistol/laser
	variant_barrel =  /obj/item/gun_component/barrel/laser/variable

/obj/item/weapon/gun/composite/premade/taser_pistol
	name = "taser pistol"
	icon_state = "laser_pistol"
	variant_chamber = /obj/item/gun_component/chamber/laser/pistol
	variant_stock =   /obj/item/gun_component/stock/pistol/laser
	variant_grip =    /obj/item/gun_component/grip/pistol/laser
	variant_body =    /obj/item/gun_component/body/pistol/laser
	variant_barrel =  /obj/item/gun_component/barrel/laser/taser

/obj/item/weapon/gun/composite/premade/laser_rifle
	name = "laser rifle"
	icon_state = "laser_rifle"
	variant_chamber = /obj/item/gun_component/chamber/laser/rifle
	variant_stock =   /obj/item/gun_component/stock/rifle/laser
	variant_grip =    /obj/item/gun_component/grip/rifle/laser
	variant_body =    /obj/item/gun_component/body/rifle/laser
	variant_barrel =  /obj/item/gun_component/barrel/laser/rifle

/obj/item/weapon/gun/composite/premade/laser_rifle/New()
	new /obj/item/gun_component/accessory/chamber/scope(src)
	..()

/obj/item/weapon/gun/composite/premade/laser_shotgun
	name = "laser shotgun"
	icon_state = "laser_shotgun"
	variant_chamber = /obj/item/gun_component/chamber/laser/burst
	variant_stock =   /obj/item/gun_component/stock/shotgun/laser
	variant_grip =    /obj/item/gun_component/grip/shotgun/laser
	variant_body =    /obj/item/gun_component/body/shotgun/laser
	variant_barrel =  /obj/item/gun_component/barrel/laser/shotgun/burst

/obj/item/weapon/gun/composite/premade/laser_assault
	name = "laser assault rifle"
	icon_state = "laser_assault"
	variant_chamber = /obj/item/gun_component/chamber/laser/assault
	variant_stock =   /obj/item/gun_component/stock/assault/laser
	variant_grip =    /obj/item/gun_component/grip/assault/laser
	variant_body =    /obj/item/gun_component/body/assault/laser
	variant_barrel =  /obj/item/gun_component/barrel/laser/variable/assault

/obj/item/weapon/gun/composite/premade/laser_assault/practice
	name = "practice laser assault rifle"
	variant_barrel =  /obj/item/gun_component/barrel/laser/assault_practice