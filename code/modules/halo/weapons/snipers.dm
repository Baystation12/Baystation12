


//SRS99 sniper rifle
//basically just a resprite
/obj/item/weapon/gun/projectile/srs99_sniper
	name = "SRS99 sniper rifle"
	desc = "Special Applications Rifle, system 99 Anti-Matériel. Deadly at extreme range.  Takes 14.5mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SRS99"
	item_state = "SRS99"
	load_method = MAGAZINE
	caliber = "14.5mm"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/m145_ap
	fire_sound = 'code/modules/halo/sounds/Sniper_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/Sniper_Reload_New.wav'
	one_hand_penalty = -1
	scoped_accuracy = 7
	accuracy = -5
	screen_shake = 0
	dispersion = list(0.1)
	fire_delay = 12
	burst = 1
	wielded_item_state = "SRS99-wielded"
	w_class = ITEM_SIZE_HUGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)

/obj/item/weapon/gun/projectile/srs99_sniper/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/srs99_sniper/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, 1.75)

/obj/item/weapon/gun/projectile/srs99_sniper/update_icon()
	if(ammo_magazine)
		icon_state = "SRS99"
	else
		icon_state = "SRS99_unloaded"
	. = ..()

//M392 designated marksman rifle
//todo: should this be a sniper?
/obj/item/weapon/gun/projectile/m392_dmr
	name = "M392 Designated Marksman Rifle"
	desc = "This rifle favors mid- to long-ranged combat, offering impressive stopping power over a long distance. Has an inbuilt underbarrel flashlight.  Takes 7.62mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M395-Loaded-Base"
	item_state = "m392"
	load_method = MAGAZINE
	caliber = "a762dmr"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/m762_ap/M392
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap/M392) //Disallows loading LMG boxmags into the DMR.
	fire_sound = 'code/modules/halo/sounds/DMR_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/DMR_Reload_New.wav'
	one_hand_penalty = -1
	w_class = ITEM_SIZE_LARGE
	dispersion = list(0.26)
	accuracy = 2
	scoped_accuracy = 1
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

/obj/item/weapon/gun/projectile/m392_dmr/innie
	name = "Modified M392 DMR"
	desc = "A heavily modified M392 remade without a bullpup design and including a hardened barrel for a faster fire rate. Has both semi and burst functionality. Takes 7.62mm rounds."
	fire_sound = 'code/modules/halo/sounds/innieDMRfirfix.ogg'
	reload_sound = 'code/modules/halo/sounds/InnieDMRreload.ogg'
	fire_delay = 7
	burst_delay = 1
	burst = 2
	magazine_type = /obj/item/ammo_magazine/m762_ap/M392/innie
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap/M392)
	accuracy = -1
	scoped_accuracy = 1

/obj/item/weapon/gun/energy/SDSR_10
	name = "SDSR-10"
	desc = "The Sonic Dispersion Sniper Rifle is a supposed prototype of an ONI Hard Sound Rifle. This prototype has a greatly decreased effectiveness compared to the final product. Construction blueprints were recovered from an ONI prowler. 10 seconds recharge time."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SoundRifle-full"
	item_state = "w_stungun"
	fire_sound = 'code/modules/halo/sounds/sound_rifle_firesound.ogg'
	charge_meter = 0
	self_recharge = 1
	recharge_time = 10 //10 seconds recharge time.
	max_shots = 1
	dispersion = list(0.26)
	one_hand_penalty = -1
	scoped_accuracy = 1
	accuracy = 0
	screen_shake = 0
	projectile_type = /obj/item/projectile/SDSS_proj
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/energy/SDSR_10/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, 1.4)