
//M392 designated marksman rifle
/obj/item/weapon/gun/projectile/m392_dmr
	name = "M392 Designated Marksman Rifle"
	desc = "This rifle favors mid- to long-ranged combat, offering impressive stopping power over a long distance. Has an inbuilt underbarrel flashlight.  Takes 7.62mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M395-Loaded-Base"
	item_state = "m392"
	load_method = MAGAZINE
	caliber = "7.62mmdmr"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/m392/m120
	allowed_magazines = list(/obj/item/ammo_magazine/m392)
	fire_sound = 'code/modules/halo/sounds/DMR_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/DMR_Reload_New.wav'
	one_hand_penalty = -1
	w_class = ITEM_SIZE_LARGE
	dispersion = list(0)
	hud_bullet_row_num = 10
	accuracy = -1
	scoped_accuracy = 2
	var/on = 0
	var/activation_sound = 'code/modules/halo/sounds/Assault_Rifle_Flashlight.wav'

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)
	wielded_item_state = "m392-wielded"
	attachment_slots = list("barrel","sight")
	attachments_on_spawn = list(/obj/item/weapon_attachment/barrel/M395,/obj/item/weapon_attachment/sight/M395_scope)

/obj/item/weapon/gun/projectile/m392_dmr/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/m392_dmr/update_icon()
	if(ammo_magazine)
		icon_state = "M395-Loaded-Base"
	else
		icon_state = "M395_Unloaded-Base"
	. = ..()

//Basic Magazine

/obj/item/ammo_magazine/m392
	name = "M392 magazine"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M395mag"
	mag_type = MAGAZINE
	caliber = "7.62mmdmr"
	max_ammo = 20
	multiple_sprites = 1

//M118 Ammunition

/obj/item/ammo_magazine/m392/m120
	name = "M392 magazine (7.62mm) M120"
	desc = "7.62x51mm M120 Full Metal Jacket High Penetration (FMJ-HP) magazine for the M392 containing 20 shots."
	ammo_type = /obj/item/ammo_casing/m120

/obj/item/weapon/storage/box/m392_m120
	name = "box of M392 (7.62mm) M118 magazines"
	startswith = list(/obj/item/ammo_magazine/m392/m120 = 7)

//Innie gun variant

/obj/item/weapon/gun/projectile/m392_dmr/innie
	name = "Modified M392 DMR"
	desc = "A heavily modified M392 remade without a bullpup design and including a hardened barrel for a faster fire rate. Fires in bursts. Takes 7.62mm rounds."
	fire_sound = 'code/modules/halo/sounds/innieDMRfirfix.ogg'
	reload_sound = 'code/modules/halo/sounds/InnieDMRreload.ogg'
	fire_delay = 8
	burst_delay = 1.5
	dispersion = list(0.26)
	burst = 2
	accuracy = -2
	scoped_accuracy = 0
