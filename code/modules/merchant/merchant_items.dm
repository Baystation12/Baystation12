/**********************/
//    SHITTY WEAPONS  //
/**********************/
/*

Shitty weapons. They are powerful, but also not.

*/

/obj/item/weapon/gun/projectile/automatic/mini_uzi/usi
	name = "mini usi"
	jam_chance = 45
	item_worth = 1500

/obj/item/weapon/gun/projectile/heavysniper/ant
	name = "ant-material rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells. The ant-material gun however fires 9mm rounds."
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	item_worth = 1700

/obj/item/weapon/gun/projectile/sec/Mc
	desc = "The NT Mc58 is a shitty knockoff of the NT Mk58 made by back-water factories. Jams like a mother."
	jam_chance = 45
	item_worth = 1250

/obj/item/weapon/gun/projectile/silenced/cheap
	desc = "A (hopefully) small, quiet,  easily concealable gun. Uses .45 rounds."
	jam_chance = 15
	item_worth = 1500

/obj/item/weapon/gun/projectile/silenced/cheap/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	silenced = prob(50)
	return ..()

