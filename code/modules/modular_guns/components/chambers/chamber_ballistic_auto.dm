/obj/item/gun_component/chamber/ballistic/auto
	icon_state="smg"
	name = "autoloader"
	automatic = 1
	weapon_type = GUN_SMG
	load_method = MAGAZINE
	max_shots = 22
	ammo_indicator_state = "ballistic_smg_loaded"
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, one_hand_penalty = 2, move_delay=5,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0))
		)
	recoil_mod = 1
	accuracy_mod = -2
	color = COLOR_GUNMETAL

/obj/item/gun_component/chamber/ballistic/auto/assault
	icon_state="assault"
	name = "autoloader"
	weapon_type = GUN_ASSAULT
	ammo_indicator_state = "ballistic_assault_loaded"
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	color = null

/obj/item/gun_component/chamber/ballistic/auto/cannon
	icon_state="cannon"
	weapon_type = GUN_CANNON
	ammo_indicator_state = "ballistic_cannon_loaded"
	color = null
