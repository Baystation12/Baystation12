
#define CLEAR_CASINGS 1
#define CASELESS 4

/obj/item/weapon/gun/projectile/m41
	name = "M41 SSR"
	desc = "Surface to surface rocket launcher for anti armor and anti infantry purposes. Takes SPNKr tubes."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M41closed"
	item_state = "m41"
	fire_sound = 'code/modules/halo/sounds/RocketLauncherShotSoundEffect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/spnkr
	fire_delay = 8
	one_hand_penalty = -1
	caliber = "spnkr"
	handle_casings = CASELESS
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	var/clamshell_open = 0
	slowdown_general = 1

/obj/item/weapon/gun/projectile/m41/special_check(mob/user)
	if(clamshell_open)
		to_chat(user, "<span class='warning'>[src]'s cover is open! Close it before firing!</span>")
		return 0
	return ..()

/obj/item/weapon/gun/projectile/m41/proc/toggle_clamshell(mob/user)
	clamshell_open = !clamshell_open
	to_chat(user, "<span class='notice'>You [clamshell_open ? "open" : "close"] [src]'s cover.</span>")
	update_icon()

/obj/item/weapon/gun/projectile/m41/attack_self(mob/user as mob)
	if(clamshell_open)
		toggle_clamshell(user)
	else
		return ..()

/obj/item/weapon/gun/projectile/m41/attack_hand(mob/user as mob)
	if(!clamshell_open && user.get_inactive_hand() == src)
		toggle_clamshell(user)
	else
		return ..()

/obj/item/weapon/gun/projectile/m41/update_icon()
	if(ammo_magazine)
		icon_state = "M41[clamshell_open ? "open" : "closed"]"
	else
		icon_state = "M41[clamshell_open ? "open" : "closed"]-empty"
	..()

/obj/item/weapon/gun/projectile/m41/load_ammo(var/obj/item/A, mob/user)
	if(!clamshell_open)
		to_chat(user, "<span class='warning'>You need to open the cover to load that into [src].</span>")
		return
	..()

/obj/item/weapon/gun/projectile/m41/unload_ammo(mob/user, var/allow_dump=1)
	if(!clamshell_open)
		to_chat(user, "<span class='warning'>You need to open the cover to unload [src].</span>")
		return
	..()

/obj/item/weapon/gun/launcher/rocket/rgl
	name = "RGL-Mk12"
	desc = "Rocket Grenade Launcher"
	icon = 'code/modules/halo/weapons/icons/URF gadgetry.dmi'
	icon_state = "1shot_launcher"
	item_state = "m41"
	fire_sound = 'code/modules/halo/sounds/RocketLauncherShotSoundEffect.ogg'
	//reload_sound = 'code/modules/halo/sounds/RocketLauncherReloadSoundEffect.ogg'
	one_hand_penalty = -1
	w_class = ITEM_SIZE_HUGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/ACL55
	name = "ACL-55"
	desc = "The Adaptiv Combat Launcher or ACL-55 is a new surface to surface rocket launcher model for anti armor and anti infantry purposes desgined by X-25. Takes M-20 series tubes."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "rawketlauncha"
	item_state = "w_rocketlauncher"
	fire_sound = 'code/modules/halo/sounds/RocketLauncherShotSoundEffect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m26
	fire_delay = 8
	one_hand_penalty = -1
	caliber = "m26"
	handle_casings = CASELESS
	w_class = ITEM_SIZE_HUGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
/obj/item/weapon/gun/projectile/ACL55/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "rawketlauncha"
	else
		icon_state = "rawketlauncha_unloaded"