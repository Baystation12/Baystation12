/obj/item/gun_component/accessory/barrel
	installs_into = COMPONENT_BARREL

/obj/item/gun_component/accessory/barrel/bayonet
	name = "bayonet"
	icon_state = "bayonet"
	weight_mod = 1
	accuracy_mod = -1
	melee_max = 15
	sharp = 1
	edge = 1

/obj/item/gun_component/accessory/barrel/grip
	name = "forward grip"
	icon_state = "grip"
	weight_mod = 1
	fire_rate_mod = 3
	accuracy_mod = 1
	two_handed = 1

/obj/item/gun_component/accessory/barrel/silencer
	name = "silencer"
	desc = "A silencer."
	weight_mod = 1

/obj/item/gun_component/accessory/barrel/silencer/apply_mod(var/obj/item/weapon/gun/composite/gun)
	..()
	gun.silenced = 1

/obj/item/gun_component/accessory/barrel/sight
	name = "laser sight"
	desc = "A laser sight."
	accuracy_mod = 2

/obj/item/gun_component/accessory/barrel/bipod
	name = "bipod"
	desc = "A bipod."
	weight_mod = 1
	recoil_mod = -1
	accuracy_mod = 2
