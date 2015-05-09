/obj/item/weapon/gun/energy/laser
	name = "laser carbine"
	desc = "A common laser weapon, designed to kill with concentrated energy blasts."
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	force = 10
	matter = list("metal" = 2000)
	origin_tech = "combat=3;magnets=2"
	projectile_type = /obj/item/projectile/beam
	fire_delay = 1 //rapid fire

/obj/item/weapon/gun/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/laser/practice
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice

obj/item/weapon/gun/energy/retro
	name = "retro laser"
	icon_state = "retro"
	item_state = "retro"
	desc = "An older model of the basic lasergun, no longer used by Nanotrasen's security or military forces. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT
	w_class = 3
	projectile_type = /obj/item/projectile/beam
	fire_delay = 10 //old technology

/obj/item/weapon/gun/energy/captain
	name = "antique laser gun"
	icon_state = "caplaser"
	item_state = "caplaser"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."
	force = 5
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT
	w_class = 3
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	charge_cost = 200 //to compensate a bit for self-recharging
	self_recharge = 1

/obj/item/weapon/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	item_state = null
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	origin_tech = "combat=4;materials=3;powerstorage=3"
	slot_flags = SLOT_BELT|SLOT_BACK
	projectile_type = /obj/item/projectile/beam/heavylaser
	charge_cost = 250
	fire_delay = 20

/obj/item/weapon/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10

/obj/item/weapon/gun/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts."
	icon_state = "xray"
	item_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	origin_tech = "combat=5;materials=3;magnets=2;syndicate=2"
	projectile_type = /obj/item/projectile/beam/xray
	charge_cost = 50
	fire_delay = 1

/obj/item/weapon/gun/energy/sniperrifle
	name = "\improper L.W.A.P. sniper rifle"
	desc = "A high-power laser rifle fitted with a SMART aiming-system scope."
	icon_state = "sniper"
	item_state = "laser"
	fire_sound = 'sound/weapons/marauder.ogg'
	origin_tech = "combat=6;materials=5;powerstorage=4"
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	charge_cost = 250
	fire_delay = 35
	force = 10
	w_class = 4
	accuracy = -3 //shooting at the hip
	scoped_accuracy = 0

/obj/item/weapon/gun/energy/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

////////Laser Tag////////////////////

/obj/item/weapon/gun/energy/lasertag
	name = "laser tag gun"
	item_state = "laser"
	desc = "Standard issue weapon of the Imperial Guard"
	origin_tech = "combat=1;magnets=2"
	self_recharge = 1
	matter = list("metal" = 2000)
	fire_sound = 'sound/weapons/Laser.ogg'
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	var/required_vest

/obj/item/weapon/gun/energy/lasertag/special_check(var/mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			M << "<span class='warning'>You need to be wearing your laser tag vest!</span>"
			return 0
	return ..()

/obj/item/weapon/gun/energy/lasertag/blue
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	required_vest = /obj/item/clothing/suit/bluetag

/obj/item/weapon/gun/energy/lasertag/red
	icon_state = "redtag"
	item_state = "redtag"
	projectile_type = /obj/item/projectile/beam/lastertag/red
	required_vest = /obj/item/clothing/suit/redtag
