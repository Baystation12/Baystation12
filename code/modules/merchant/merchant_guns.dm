/obj/item/weapon/gun/projectile/pistol/sec/MK
	desc = "The SI-2 handgun, produced on the frontier systems for easy access to defend against pirates by Serent Industries."
	jam_chance = 35

/obj/item/weapon/gun/projectile/heavysniper/ant
	name = "anti-material rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells. This replica however fires pistol rounds."
	ammo_type = /obj/item/ammo_magazine/pistol/small
	caliber = CALIBER_PISTOL_SMALL

/obj/item/weapon/gun/energy/laser/dogan
	desc = "This is an extremely outdated NE-10 model by Nelwen Electronics. Bulkier, less reliable, and more likely to explode in your face. Does it still even work?" //removed reference to Dogan, since only the merchant is likely to know who that is.

/obj/item/weapon/gun/energy/laser/dogan/consume_next_projectile()
	projectile_type = pick(/obj/item/projectile/beam/midlaser, /obj/item/projectile/beam/lastertag/red, /obj/item/projectile/beam)
	return ..()

/obj/item/weapon/gun/projectile/automatic/machine_pistol/usi
	desc = "An uncommon machine pistol, sometimes refered to as an 'uzi' by the backwater spacers it is often associated with. This one looks especially run-down. Uses pistol rounds."
	jam_chance = 20