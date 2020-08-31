
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