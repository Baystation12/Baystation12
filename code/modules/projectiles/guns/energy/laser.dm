/obj/item/weapon/gun/energy/laser
	name = "laser carbine"
	desc = "A basic weapon designed to kill with concentrated energy bolts."
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	w_class = 3.0
	matter = list("metal" = 2000)
	origin_tech = "combat=3;magnets=2"
	projectile_type = /obj/item/projectile/beam

/obj/item/weapon/gun/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/laser/practice
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice

obj/item/weapon/gun/energy/laser/retro
	name = "retro laser"
	icon_state = "retro"
	desc = "An older model of the basic lasergun, no longer used by Nanotrasen's security or military forces. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."

/obj/item/weapon/gun/energy/laser/captain
	name = "antique laser gun"
	icon_state = "caplaser"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."
	force = 10
	origin_tech = null
	self_recharge = 1


/obj/item/weapon/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	origin_tech = "combat=4;materials=3;powerstorage=3"
	projectile_type = /obj/item/projectile/beam/heavylaser
	charge_cost = 250
	fire_delay = 20

/obj/item/weapon/gun/energy/lasercannon/mounted
	self_recharge = 1
	use_external_power = 1
	recharge_time = 25

/obj/item/weapon/gun/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts."
	icon_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	origin_tech = "combat=5;materials=3;magnets=2;syndicate=2"
	projectile_type = /obj/item/projectile/beam/xray
	charge_cost = 50


////////Laser Tag////////////////////

/obj/item/weapon/gun/energy/lasertag
	name = "laser tag gun"
	desc = "Standard issue weapon of the Imperial Guard"
	origin_tech = "combat=1;magnets=2"
	self_recharge = 1
	var/required_vest

/obj/item/weapon/gun/energy/lasertag/special_check(var/mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			M << "\red You need to be wearing your laser tag vest!"
			return 0
	return ..()

/obj/item/weapon/gun/energy/lasertag/blue
	icon_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/lastertag/blue
	required_vest = /obj/item/clothing/suit/bluetag

/obj/item/weapon/gun/energy/lasertag/red
	icon_state = "redtag"
	projectile_type = /obj/item/projectile/beam/lastertag/red
	required_vest = /obj/item/clothing/suit/redtag