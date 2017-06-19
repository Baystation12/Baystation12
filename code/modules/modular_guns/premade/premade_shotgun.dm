/obj/item/weapon/gun/composite/premade/shotgun
	name = "shotgun"
	icon_state = "ballistic_shotgun"
	variant_chamber = /obj/item/gun_component/chamber/ballistic/pump
	variant_body =    /obj/item/gun_component/body/shotgun
	variant_barrel =  /obj/item/gun_component/barrel/shotgun
	variant_stock =   /obj/item/gun_component/stock/shotgun
	variant_grip =    /obj/item/gun_component/grip/shotgun

/obj/item/weapon/gun/composite/premade/shotgun/sawnoff
	name = "sawn-off shotgun"
	icon_state = "sawnoff"
	variant_barrel =  /obj/item/gun_component/barrel/shotgun/short
	variant_stock = null
	set_model = /decl/weapon_model/sawnoff_shotgun

/obj/item/weapon/gun/composite/premade/shotgun/hunting
	variant_chamber = /obj/item/gun_component/chamber/ballistic/breech/shotgun
	variant_body =    /obj/item/gun_component/body/shotgun/hunting

/obj/item/weapon/gun/composite/premade/shotgun/hunting/sawnoff
	name = "sawn-off shotgun"
	icon_state = "sawnoff"
	variant_barrel =  /obj/item/gun_component/barrel/shotgun/short
	variant_stock = null

/obj/item/weapon/gun/composite/premade/shotgun/combat
	icon_state = "combat_shotgun"
	variant_chamber = /obj/item/gun_component/chamber/ballistic/pump/combat
	variant_body =    /obj/item/gun_component/body/shotgun/combat
	variant_barrel =  /obj/item/gun_component/barrel/shotgun
	variant_stock =   /obj/item/gun_component/stock/shotgun/combat
	variant_grip =    /obj/item/gun_component/grip/shotgun/combat

/obj/item/weapon/gun/composite/premade/shotgun/combat/sawnoff
	name = "riot shotgun"
	icon_state = "combat_sawnoff"
	variant_stock =   null
	variant_barrel =  /obj/item/gun_component/barrel/shotgun/short