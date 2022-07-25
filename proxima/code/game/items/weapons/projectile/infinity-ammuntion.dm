// Ammo cassings

/obj/item/ammo_casing/corpo
	desc = "A high-powered bullet casing. Somwewhat between 5-6mm."
	caliber = CALIBER_PISTOL_FAST
	projectile_type = /obj/item/projectile/bullet/pistol/medium/fast

/obj/item/ammo_casing/amr
	name = "bullet casing"
	desc = "A high-powered bullet casing. Somewhat around 12mmR."
	projectile_type = /obj/item/projectile/bullet/rifle/amr
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = CALIBER_ANTIMATERIAL_SMALL
	matter = list(MATERIAL_STEEL = 500)

/obj/item/ammo_casing/pdw
	desc = "A bullet casing. Somewhat near 5,5mm"
	caliber = CALIBER_PISTOL_FAST
	projectile_type = /obj/item/projectile/bullet/pistol/medium/fast

// Magazines

/obj/item/ammo_magazine/corpo
	name = "corporate smg magazine"
	icon = 'proxima/icons/obj/guns/ammo.dmi'
	icon_state = "10mm"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/corpo
	matter = list(MATERIAL_STEEL = 1500)
	caliber = CALIBER_PISTOL_FAST
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/amr
	name = "corporate carbine magazine"
	icon = 'proxima/icons/obj/guns/ammo.dmi'
	icon_state = "assault_rifle"
	mag_type = MAGAZINE
	caliber = CALIBER_ANTIMATERIAL_SMALL
	matter = list(MATERIAL_STEEL = 2300)
	ammo_type = /obj/item/ammo_casing/amr
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/pdw
	name = "corporate pdw magazine"
	icon = 'proxima/icons/obj/guns/ammo.dmi'
	icon_state = "uzi9mm" //more states, lmao
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pdw
	matter = list(MATERIAL_STEEL = 1200)
	caliber = CALIBER_PISTOL_FAST
	max_ammo = 30

// Fabricator repices

/datum/fabricator_recipe/arms_ammo/magazine_nt41
	name = "ammunition (corporate smg magazine)"
	path = /obj/item/ammo_magazine/corpo
	hidden = 1
	category = "Arms and Ammunition"
