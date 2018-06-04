


//MA5B assault rifle

/obj/item/weapon/gun/projectile/ma5b_ar
	name = "\improper MA5B Assault Rifle"
	desc = "Standard-issue service rifle of the UNSC Marines. Has an inbuilt underbarrel flashlight. Takes 7.62mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "MA5B"
	item_state = "ma5b"
	caliber = "a762"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/Assault_Rifle_Short_Burst_Sound_Effect.ogg'
	//fire_sound_burst = 'code/modules/halo/sounds/Assault_Rifle_Short_Burst_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/AssaultRifle&BattleRifle_ReloadSound_Effect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA5B
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap/MA5B) //Disallows loading LMG boxmags into the MA5B
	burst = 3
	burst_delay = 2
	one_hand_penalty = -1
	dispersion = list(2)//This gun spawns with a stock that counteracts this issue.
	var/on = 0
	var/activation_sound = 'sound/effects/flashlight.ogg'
	w_class = ITEM_SIZE_LARGE
	ammo_icon_state = "ma5b_mag"

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

	firemodes = list(
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, fire_delay=null, move_delay=6,    burst_accuracy=list(-1,-1,-2,-2,-3), dispersion=list(0.6, 1.0, 1.5, 1.5, 1.9)),
		)

	attachment_slots = list("sight","stock","barrel")
	attachments_on_spawn = list(/obj/item/weapon_attachment/stock/ma5b)

/obj/item/weapon/gun/projectile/ma5b_ar/New()
	..()
	add_flashlight()

/obj/item/weapon/gun/projectile/ma5b_ar/proc/add_flashlight()
	verbs += /obj/item/weapon/gun/projectile/ma5b_ar/proc/toggle_light

/obj/item/weapon/gun/projectile/ma5b_ar/MA37/add_flashlight()
	return

/obj/item/weapon/gun/projectile/ma5b_ar/training
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA5B/TTR

/obj/item/weapon/gun/projectile/ma5b_ar/MA37
	name = "\improper MA37 ICWS"
	desc = "Also formally known as the MA5. Takes 7.62mm ammo."
	icon_state = "MA37"
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA37
	ammo_icon_state = null
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap/MA37)
	attachment_slots = null
	attachments_on_spawn = null

/obj/item/weapon/gun/projectile/ma5b_ar/MA37/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "MA37"
	else
		icon_state = "MA37_unloaded"

/obj/item/weapon/gun/projectile/ma5b_ar/proc/toggle_light()
	set category = "Weapon"
	set name = "Toggle Gun Light"
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
		set_light(4)
	else
		set_light(0)

/obj/item/weapon/gun/projectile/ma5b_ar/MA3
	name = "\improper MA3 Assault Rifle"
	desc = "An obsolete military assault rifle commonly available on the black market. Takes 7.62mm ammo."
	icon_state = "MA3"
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA3
	ammo_icon_state = null
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap/MA3)
	attachment_slots = null
	attachments_on_spawn = null
	burst_delay = 0.5
	fire_sound = 'code/modules/halo/sounds/MA3firefix.ogg'
	reload_sound = 'code/modules/halo/sounds/MA3reload.ogg'
	firemodes = list(
		list(mode_name="4-round bursts", burst=4, fire_delay=1, move_delay=6,    burst_accuracy=list(0,0,-1,-1),       dispersion=list(0.6, 1.2, 1.6, 1.9)),
		list(mode_name="short bursts", 	burst=6, fire_delay=1, move_delay=6,    burst_accuracy=list(0,0,-1,-1,-2,-2), dispersion=list(0.6, 1.0, 1.5, 1.5, 1.9, 1.9)),
		)

/obj/item/weapon/gun/projectile/ma5b_ar/MA3/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "MA3"
	else
		icon_state = "MA3_unloaded"


//BR85 battle

/obj/item/weapon/gun/projectile/br85
	name = "\improper BR85 Battle Rifle"
	desc = "When nothing else gets the job done, the BR85 Battle Rifle will do. Takes 9.5mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Br85"
	item_state = "br85"
	caliber = "9.5mm"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/BattleRifleShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/AssaultRifle&BattleRifle_ReloadSound_Effect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m95_sap
	one_hand_penalty = -1
	burst = 3
	burst_delay = 0.5
	fire_delay = 2
	accuracy = 1
	w_class = ITEM_SIZE_LARGE
	dispersion=list(0.0, 0.6, 0.6)
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/br85/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, 1.15)

/obj/item/weapon/gun/projectile/br85/update_icon()
	if(ammo_magazine)
		icon_state = "Br85"
	else
		icon_state = "Br85_unloaded"
	. = ..()
