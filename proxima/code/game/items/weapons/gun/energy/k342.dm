/obj/item/projectile/plasma
	name = "plasma bolt"
	icon_state = "plasma_bolt"
	fire_sound='proxima/sound/weapons/guns/incinerate.ogg'
	armor_penetration = 25
	damage = 33
	damage_type = DAMAGE_BURN
	step_delay = 0.5

	muzzle_type = /obj/effect/projectile/plasma/muzzle
	impact_type = /obj/effect/projectile/plasma/impact

/obj/effect/projectile/plasma
	light_color = COLOR_BLUE
	color = COLOR_BLUE_LIGHT

/obj/effect/projectile/plasma/heavy
	light_color = COLOR_RED
	color = COLOR_RED

/obj/effect/projectile/plasma/stun
	light_color = COLOR_YELLOW
	color = COLOR_YELLOW

/obj/effect/projectile/plasma/net
	light_color = COLOR_GREEN
	color = COLOR_GREEN

/obj/effect/projectile/plasma/muzzle
	icon_state = "muzzle_plasma"

/obj/effect/projectile/plasma/impact
	icon_state = "impact_plasma"

/obj/effect/projectile/plasma/heavy/muzzle
	icon_state = "muzzle_plasma"

/obj/effect/projectile/plasma/heavy/impact
	icon_state = "impact_plasma"

/obj/effect/projectile/plasma/stun/muzzle
	icon_state = "muzzle_plasma"

/obj/effect/projectile/plasma/stun/impact
	icon_state = "impact_plasma"

/obj/effect/projectile/plasma/net/muzzle
	icon_state = "muzzle_plasma"

/obj/effect/projectile/plasma/net/impact
	icon_state = "impact_plasma"

/obj/item/projectile/plasma/sniper
	name = "sniper plasma bolt"
	fire_sound='proxima/sound/weapons/guns/vaporize.ogg'
	armor_penetration = 35
	damage = 45
	agony = 5
	step_delay = 0.4

/obj/item/projectile/plasma/heavy
	name = "heavy plasma bolt"
	fire_sound='proxima/sound/weapons/guns/vaporize.ogg'
	armor_penetration = 50
	damage = 60

	muzzle_type = /obj/effect/projectile/plasma/heavy/muzzle
	impact_type = /obj/effect/projectile/plasma/heavy/impact

/obj/item/projectile/plasma/heavy/sniper
	name = "heavy sniper plasma bolt"
	fire_sound='proxima/sound/weapons/guns/vaporize.ogg'
	armor_penetration = 75
	agony = 15
	damage = 90
	step_delay = 0.4

	muzzle_type = /obj/effect/projectile/plasma/heavy/muzzle
	impact_type = /obj/effect/projectile/plasma/heavy/impact

/obj/item/projectile/plasma/stun
	name = "stun plasma bolt"
	fire_sound='proxima/sound/weapons/guns/burn.ogg'
	damage = 2
	agony = 40
	eyeblur = 1
	muzzle_type = /obj/effect/projectile/plasma/stun/muzzle
	impact_type = /obj/effect/projectile/plasma/stun/impact

/obj/item/projectile/plasma/stun/sniper
	name = "sniper stun plasma bolt"
	damage = 2
	agony = 60
	step_delay = 0.4

/obj/item/projectile/plasma/stun/net
	name = "plasma net"
	agony = 20
	damage = 0
	damage_type = null
	muzzle_type = /obj/effect/projectile/plasma/net/muzzle
	impact_type = /obj/effect/projectile/plasma/net/impact

/obj/item/projectile/plasma/stun/net/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	var/obj/item/energy_net/net = new(loc)
	net.try_capture_mob(target)
	return TRUE

/obj/item/projectile/plasma/weak
	armor_penetration = 0
	damage = 25
	agony = 10
	color = COLOR_GREEN
	light_color = COLOR_GREEN

/obj/item/gun/energy/k342
	name = "plasma rifle"
	desc = "K342 Barrakuda is the latest plasma weapon created by NanoTrasen. It can fire several types of charges: stunning, incendiary and lethal."
	icon = 'proxima/icons/obj/guns/k342.dmi'
	w_class = ITEM_SIZE_LARGE
	item_icons = list(
		slot_l_hand_str = 'proxima/icons/mob/onmob/items/lefthand-guns.dmi',
		slot_r_hand_str = 'proxima/icons/mob/onmob/items/righthand-guns.dmi',
		slot_back_str = 'proxima/icons/mob/onmob/items/back-guns.dmi'
		)
	slot_flags = SLOT_BACK|SLOT_BELT
	icon_state = "barrakuda_off"
	item_state = "barrakuda"
	origin_tech = list(TECH_COMBAT=4, TECH_MATERIAL=3, TECH_POWER=5)
	wielded_item_state = "barrakuda-wielded"
	battery_changable = TRUE
	req_access = list(list(access_brig, access_bridge))
	authorized_modes = list(ALWAYS_AUTHORIZED)
	screen_shake = 0
	battery_chamber_size = BATTERY_RIFLE
	battery_type = /obj/item/cell/guncell/medium
	recoil_buildup = 0
	init_firemodes = list(
		list(mode_name="stun charge", projectile_type=/obj/item/projectile/plasma/stun, charge_cost=20, fire_delay=4, projectile_color=COLOR_YELLOW),
		list(mode_name="plasma charge", projectile_type=/obj/item/projectile/plasma, charge_cost=20, fire_delay=4, projectile_color=COLOR_BLUE_LIGHT),
		list(mode_name="heavy plasma charge", projectile_type=/obj/item/projectile/plasma/heavy, charge_cost=50, fire_delay=8, projectile_color=COLOR_RED)
	)

/obj/item/gun/energy/k342/explo
	desc = "K342E Kasatka is the latest plasma weapon created by NanoTrasen. This modification has been designed for Sol Central Government Expeditionary Corps and can fire several types of charges: stunning, lethal and net-mode."
	icon_state = "kasatka_off"
	item_state = "kasatka"
	req_access = list(list("ACCESS_TORCH_EXPLORER"))
	wielded_item_state = "kasatka-wielded"
	authorized_modes = list(UNAUTHORIZED, UNAUTHORIZED, UNAUTHORIZED)
	init_firemodes = list(
		list(mode_name="stun charge", projectile_type=/obj/item/projectile/plasma/stun, charge_cost=20, fire_delay=4, projectile_color=COLOR_YELLOW),
		list(mode_name="plasma charge", projectile_type=/obj/item/projectile/plasma, charge_cost=20, fire_delay=4, projectile_color=COLOR_BLUE_LIGHT),
		list(mode_name="net charge", projectile_type=/obj/item/projectile/plasma/stun/net, charge_cost=150, fire_delay=20, projectile_color=COLOR_GREEN)
	)

/obj/item/gun/energy/k342/explo/free_fire()
	var/my_z = get_z(src)
	if(!list_find(GLOB.using_map.station_levels, my_z))
		return TRUE
	return ..()

/obj/item/gun/energy/k342/explo/prereg
	authorized_modes = list(AUTHORIZED, AUTHORIZED, ALWAYS_AUTHORIZED)

/obj/item/gun/energy/k342/prereg
	authorized_modes = list(ALWAYS_AUTHORIZED, AUTHORIZED, AUTHORIZED)

/obj/item/gun/energy/k342/on_update_icon()
	. = ..()
	if(power_supply)
		icon_state = "[initial(item_state)]_on"
		var/i = ""
		switch(power_supply.percent())
			if(70 to 100)
				i = "g_70+"
			if(35 to 69)
				i = "g_35+"
			if(0.05 to 34)
				i = "g_0+"
		if(i)
			overlays += image(icon, i)
			overlays += image(icon, splittext(init_firemodes[sel_mode]["mode_name"], " ")[1])
	else
		icon_state = "[initial(item_state)]_off"

/obj/item/gun/energy/k342/pistol
	name = "plasma pistol"
	desc = "K12 Koi is the latest plasma sidearm created by NanoTrasen. It can fire two types of charges: stunning and lethal."
	icon = 'proxima/icons/obj/guns/k12.dmi'
	w_class = ITEM_SIZE_NORMAL
	item_icons = list(
		slot_l_hand_str = 'proxima/icons/mob/onmob/items/lefthand-guns.dmi',
		slot_r_hand_str = 'proxima/icons/mob/onmob/items/righthand-guns.dmi',
		slot_back_str = null
		)
	slot_flags = SLOT_BACK|SLOT_BELT
	icon_state = "koi_off"
	item_state = "koi"
	origin_tech = list(TECH_COMBAT=3, TECH_MATERIAL=3, TECH_POWER=5)
	wielded_item_state = null
	battery_changable = TRUE
	req_access = list(list(access_brig, access_bridge))
	authorized_modes = list(ALWAYS_AUTHORIZED)
	screen_shake = 0
	battery_chamber_size = BATTERY_PISTOL
	battery_type = /obj/item/cell/guncell/pistol/small
	recoil_buildup = 0
	init_firemodes = list(
		list(mode_name="stun charge", projectile_type=/obj/item/projectile/plasma/stun, charge_cost=25, fire_delay=4, projectile_color=COLOR_BLUE_LIGHT),
		list(mode_name="plasma charge", projectile_type=/obj/item/projectile/plasma/weak, charge_cost=25, fire_delay=4, projectile_color=COLOR_GREEN),
	)

/obj/item/gun/energy/k342/pistol/expo
	icon_state = "koi_e_off"
	item_state = "koi_e"

/obj/item/gun/energy/k342/pistol/explo/free_fire()
	var/my_z = get_z(src)
	if(!list_find(GLOB.using_map.station_levels, my_z))
		return TRUE
	return ..()

/obj/item/gun/energy/k342/sniper
	name = "plasma sniper rifle"
	desc = "K480 Skat is the latest heavy plasma weapon created by NanoTrasen for SolGov snipers, capable to fire several types of charges: stunning, incendiary, and lethal bolts. Advanced magnetic constriction technology improves accuracy and firepower."
	icon = 'proxima/icons/obj/guns/k480.dmi'
	icon_state = "mantis_off"
	item_state = "mantis"
	origin_tech = list(TECH_COMBAT=6, TECH_MATERIAL=3, TECH_POWER=7)
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK
	scoped_accuracy = 6
	scope_zoom = 1.5
	init_firemodes = list(
		list(mode_name="stun charge", projectile_type=/obj/item/projectile/plasma/stun/sniper, charge_cost=60, fire_delay=6, projectile_color=COLOR_YELLOW),
		list(mode_name="plasma charge", projectile_type=/obj/item/projectile/plasma/sniper, charge_cost=60, fire_delay=6, projectile_color=COLOR_BLUE_LIGHT),
		list(mode_name="heavy plasma charge", projectile_type=/obj/item/projectile/plasma/heavy/sniper, charge_cost=120, fire_delay=10, projectile_color=COLOR_RED)
	)

/datum/design/item/weapon/k342
	id = "k342"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 5)
	materials = list(MATERIAL_SILVER = 7000, MATERIAL_GLASS = 2000, MATERIAL_STEEL = 10000, MATERIAL_URANIUM = 2000)
	build_path = /obj/item/gun/energy/k342
	sort_string = "TAEAA"

/datum/design/item/weapon/k342/pistol
	id = "k342_pistol"
	build_path = /obj/item/gun/energy/k342/pistol
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 5)
	materials = list(MATERIAL_SILVER = 2000, MATERIAL_PLASTIC = 6000, MATERIAL_GLASS = 1000, MATERIAL_STEEL = 2000, MATERIAL_URANIUM = 1000)
	sort_string = "TAEAB"

/datum/design/item/weapon/k342/sniper
	id = "k342_sniper"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3, TECH_POWER = 7)
	materials = list(MATERIAL_SILVER = 7000, MATERIAL_GLASS = 4000, MATERIAL_STEEL = 20000, MATERIAL_URANIUM = 4000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/gun/energy/k342/sniper
	sort_string = "TAEAC"

/datum/design/item/weapon/ammunition/smallgunbattery
	id = "smallgun_battery"
	desc = "A small battery for energy guns. Rated for 200Wh"
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 1500)
	req_tech = list(TECH_POWER = 2, TECH_MATERIAL = 2, TECH_COMBAT = 1)
	build_path = /obj/item/cell/guncell/small

/datum/design/item/weapon/ammunition/smallgunbattery/hypercharged
	id = "smallgun_battery_hypercharged"
	req_tech = list(TECH_POWER = 2, TECH_MATERIAL = 2, TECH_COMBAT = 7)
	build_path = /obj/item/cell/guncell/overcharged/small

/datum/design/item/weapon/ammunition/smallgunbattery/pistol
	id = "smallgun_battery_pistol"
	build_path = /obj/item/cell/guncell/pistol/small

/datum/design/item/weapon/ammunition/smallgunbattery/pistol/hypercharged
	id = "smallgun_battery_pistol_hypercharged"
	build_path = /obj/item/cell/guncell/pistol/overcharged/small
	req_tech = list(TECH_POWER = 2, TECH_MATERIAL = 2, TECH_COMBAT = 7)

/datum/design/item/weapon/ammunition/mediumgunbattery
	id = "mediumgun_battery"
	desc = "A medium battery for energy guns. Rated for 300Wh"
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GLASS = 2500)
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2, TECH_COMBAT = 2)
	build_path = /obj/item/cell/guncell/medium

/datum/design/item/weapon/ammunition/mediumgunbattery/pistol
	id = "mediumgun_battery_pistol"
	build_path = /obj/item/cell/guncell/pistol/medium

/datum/design/item/weapon/ammunition/mediumgunbattery/pistol/hypercharged
	id = "mediumgun_battery_pistol_hypercharged"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2, TECH_COMBAT = 7)
	build_path = /obj/item/cell/guncell/pistol/overcharged/medium

/datum/design/item/weapon/ammunition/mediumgunbattery/hypercharged
	id = "mediumgun_battery_hypercharged"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2, TECH_COMBAT = 7)
	build_path = /obj/item/cell/guncell/overcharged/medium

/datum/design/item/weapon/ammunition/largegunbattery
	id = "largegun_battery"
	desc = "A large battery for energy guns. Rated for 400Wh"
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 4000, MATERIAL_SILVER = 1500)
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4, TECH_COMBAT = 3)
	build_path = /obj/item/cell/guncell/large

/datum/design/item/weapon/ammunition/largegunbattery/pistol
	id = "largegun_battery_pistol"
	build_path = /obj/item/cell/guncell/pistol/large

/datum/design/item/weapon/ammunition/largegunbattery/pistol/hypercharged
	id = "largegun_battery_pistol_hypercharged"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4, TECH_COMBAT = 7)
	build_path = /obj/item/cell/guncell/pistol/overcharged/large

/datum/design/item/weapon/ammunition/largegunbattery/hypercharged
	id = "largegun_battery_hypercharged"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4, TECH_COMBAT = 7)
	build_path = /obj/item/cell/guncell/overcharged/large

/datum/design/item/weapon/ammunition/megalargegunbattery
	id = "megalarge_battery"
	desc = "A very large battery for energy guns. Rated for 500Wh"
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 5000, MATERIAL_SILVER = 2500 , MATERIAL_URANIUM = 1500)
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 5, TECH_COMBAT = 4)
	build_path = /obj/item/cell/guncell/megalarge

/datum/design/item/weapon/ammunition/megalargegunbattery/pistol
	id = "megalarge_battery_pistol"
	build_path = /obj/item/cell/guncell/pistol/megalarge

/datum/design/item/weapon/ammunition/megalargegunbattery/pistol/hypercharged
	id = "megalarge_battery_pistol_hypercharged"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 5, TECH_COMBAT = 7)
	build_path = /obj/item/cell/guncell/pistol/overcharged/megalarge

/datum/design/item/weapon/ammunition/megalargegunbattery/hypercharged
	id = "megalarge_battery_hypercharged"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 5, TECH_COMBAT = 7)
	build_path = /obj/item/cell/guncell/overcharged/megalarge

/datum/design/item/weapon/ammunition/hugebattery
	id = "huge_battery"
	desc = "A huge battery for energy guns. Rated for 600Wh"
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 15000, MATERIAL_SILVER = 3000 , MATERIAL_URANIUM = 2500, MATERIAL_GOLD = 2500)
	req_tech = list(TECH_POWER = 6, TECH_MATERIAL = 6, TECH_COMBAT = 5)
	build_path = /obj/item/cell/guncell/huge

/datum/design/item/weapon/ammunition/hugebattery/pistol
	id = "huge_battery_pistol"
	build_path = /obj/item/cell/guncell/pistol/huge

/datum/design/item/weapon/ammunition/hugebattery/pistol/hypercharged
	id = "huge_battery_pistol_hypercharged"
	req_tech = list(TECH_POWER = 6, TECH_MATERIAL = 6, TECH_COMBAT = 7)
	build_path = /obj/item/cell/guncell/pistol/overcharged/huge

/datum/design/item/weapon/ammunition/hugebattery/hypercharged
	id = "huge_battery_hypercharged"
	req_tech = list(TECH_POWER = 6, TECH_MATERIAL = 6, TECH_COMBAT = 7)
	build_path = /obj/item/cell/guncell/overcharged/huge

/datum/design/item/weapon/ammunition/powercore
	id = "battery_powercore"
	desc = "universal battery for energy guns with self recharge function."
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 15000, MATERIAL_SILVER = 3000 , MATERIAL_URANIUM = 4000, MATERIAL_GOLD = 2000, MATERIAL_DIAMOND = 500)
	req_tech = list(TECH_POWER = 7, TECH_MATERIAL = 6, TECH_COMBAT = 5)
	build_path = /obj/item/cell/guncell/powercore
