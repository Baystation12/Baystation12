/obj/machinery/missile/magazine
	name = "deck gun magazine"
	desc = "A magazine for a deck gun."
	var/obj/item/ammo_magazine/deck_gun/magazine
	spawn_type = null
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "magazine"
	width = 1
	spawn_type = /obj/item/ammo_magazine/deck_gun
	fire_missile()
		return "ERROR: The [src] cannot be fired!"

	New()
		..()
		magazine = new spawn_type(src)

/obj/item/ammo_magazine/deck_gun
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "357"
	icon = 'icons/obj/ammo.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10

	caliber = "60mm"
	max_ammo = 16

	var/burst = 8
	var/burst_delay = 10
	var/accuracy = -3

	ammo_type = /obj/item/ammo_casing/deck_gun


/obj/item/ammo_casing/deck_gun
	name = "large shell"
	desc = "A penetrative round used in ship combat"
	projectile_type = /obj/item/projectile/bullet/deck_gun
	caliber = "60mm"


/obj/item/projectile/bullet/deck_gun
	damage = 90 // I know, one shot from a 60mm should kill you...But that's no fun

	damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE, HALLOSS are the only things that should be in here
	check_armour = "bullet"
	penetrating = 2 //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()

	stun = 15
	weaken = 25
	paralyze = 10
	irradiate = 0
	stutter = 15
	eyeblur = 15
	drowsy = 15
	agony = 120 // This is going to freaking hurt.
	embed = 1

/obj/item/projectile/bullet/deck_gun/get_structure_damage()
	return round(damage / 3) // Its made to penetrate through walls, not destroy them.

/obj/item/ammo_casing/deck_gun
	name = "large shell"
	desc = "A penetrative round used in ship combat"
	projectile_type = /obj/item/projectile/bullet/deck_gun
	caliber = "60mm"

/obj/item/projectile/bullet/deck_gun/light
	damage = 30
	penetrating = 4

	stun = 15
	weaken = 5
	paralyze = 10
	agony = 60

/obj/item/ammo_magazine/deck_gun/light
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "357"
	icon = 'icons/obj/ammo.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10

	burst = 15
	burst_delay = 2
	accuracy = 1

	caliber = "60mm"
	max_ammo = 30

	ammo_type = /obj/item/ammo_casing/deck_gun/light

/obj/item/ammo_casing/deck_gun/light
	name = "large shell"
	desc = "A penetrative round used in ship combat"
	projectile_type = /obj/item/projectile/bullet/deck_gun/light
	caliber = "60mm"

/obj/machinery/missile/magazine/light
	name = "light deck gun magazine"
	desc = "A light magazine for a deck gun."
	spawn_type = /obj/item/ammo_magazine/deck_gun/light
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "magazine"
	width = 1
	req_grabs = 1

/obj/item/projectile/bullet/deck_gun/penetrative
	damage = 20
	penetrating = 10

	stun = 15
	weaken = 5
	paralyze = 10
	agony = 40
	sharp = 1

/obj/item/ammo_magazine/deck_gun/penetrative
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "357"
	icon = 'icons/obj/ammo.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10

	burst = 10
	burst_delay = 4
	accuracy = 0

	caliber = "60mm"
	max_ammo = 20

	ammo_type = /obj/item/ammo_casing/deck_gun/penetrative

/obj/item/ammo_casing/deck_gun/penetrative
	name = "large shell"
	desc = "A penetrative round used in ship combat"
	projectile_type = /obj/item/projectile/bullet/deck_gun/penetrative
	caliber = "60mm"

/obj/machinery/missile/magazine/penetrative
	name = "penetrative deck gun magazine"
	desc = "A penetrative magazine for a deck gun."
	spawn_type = /obj/item/ammo_magazine/deck_gun/penetrative
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "magazine"
	width = 1
	req_grabs = 1

/obj/item/projectile/bullet/deck_gun/heavy
	damage = 80
	penetrating = 6

	stun = 30
	weaken = 20
	paralyze = 25
	agony = 120
	sharp = 1

/obj/item/ammo_magazine/deck_gun/heavy
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "357"
	icon = 'icons/obj/ammo.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10

	burst = 1
	burst_delay = 10
	accuracy = 5

	caliber = "60mm"
	max_ammo = 3

	ammo_type = /obj/item/ammo_casing/deck_gun/heavy

/obj/item/ammo_casing/deck_gun/heavy
	name = "large shell"
	desc = "A penetrative round used in ship combat"
	projectile_type = /obj/item/projectile/bullet/deck_gun/heavy
	caliber = "60mm"

/obj/machinery/missile/magazine/heavy
	name = "heavy deck gun magazine"
	desc = "A heavy magazine for a deck gun."
	spawn_type = /obj/item/ammo_magazine/deck_gun/heavy
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "magazine"
	width = 1
	req_grabs = 1