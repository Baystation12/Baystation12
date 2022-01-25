/obj/item/gun/energy/taser
	name = "electrolaser"
	desc = "The NT Mk30 NL is a small, low capacity gun used for non-lethal takedowns. Produced by NT, it's actually a licensed version of a W-T design. It can switch between high and low intensity stun shots."
	icon = 'icons/obj/guns/taser.dmi'
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	max_shots = 5
	projectile_type = /obj/item/projectile/beam/stun
	combustion = 0

	init_firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock),
		)

/obj/item/gun/energy/taser/carbine
	name = "electrolaser carbine"
	desc = "The NT Mk44 NL is a high capacity gun used for non-lethal takedowns. It can switch between high and low intensity stun shots."
	icon = 'icons/obj/guns/taser_carbine.dmi'
	icon_state = "tasercarbine"
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BELT|SLOT_BACK
	one_hand_penalty = 3
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	force = 8
	max_shots = 12
	accuracy = 1
	projectile_type = /obj/item/projectile/beam/stun/heavy
	wielded_item_state = "tasercarbine-wielded"

	init_firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/heavy),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock/heavy),
		)

/obj/item/gun/energy/taser/mounted
	name = "mounted electrolaser"
	self_recharge = 1
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/taser/mounted/cyborg
	name = "electrolaser"
	max_shots = 6
	recharge_time = 10 //Time it takes for shots to recharge (in ticks)


/obj/item/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "An A&M X6 Zeus. Designed by al-Maliki & Mosley, but produced under the wing of the Free Trade Union. Industry spies have been trying to get a hold of the blueprints for half a decade."
	icon = 'icons/obj/guns/stunrevolver.dmi'
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	projectile_type = /obj/item/projectile/energy/electrode
	max_shots = 6
	combustion = 0

/obj/item/gun/energy/stunrevolver/rifle
	name = "stun rifle"
	desc = "An A&M X10 Thor. A vastly oversized variant of the A&M X6 Zeus. Fires overcharged electrodes to obliterate pain receptors without harming them too much."
	icon = 'icons/obj/guns/stunrifle.dmi'
	icon_state = "stunrifle"
	item_state = "stunrifle"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	one_hand_penalty = 6
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	force = 10
	max_shots = 10
	accuracy = 1
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	wielded_item_state = "stunrifle-wielded"

/obj/item/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon = 'icons/obj/guns/energy_crossbow.dmi'
	icon_state = "crossbow"
	w_class = ITEM_SIZE_NORMAL
	item_state = "crossbow"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2, TECH_ESOTERIC = 5)
	matter = list(MATERIAL_STEEL = 2000)
	slot_flags = SLOT_BELT
	silenced = TRUE
	fire_sound = 'sound/weapons/Genhit.ogg'
	projectile_type = /obj/item/projectile/energy/bolt
	max_shots = 8
	self_recharge = 1
	charge_meter = 0
	combustion = 0

/obj/item/gun/energy/crossbow/ninja
	name = "energy dart thrower"
	projectile_type = /obj/item/projectile/energy/dart
	max_shots = 5

/obj/item/gun/energy/crossbow/ninja/mounted
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = ITEM_SIZE_LARGE
	force = 10
	one_hand_penalty = 1
	matter = list(MATERIAL_STEEL = 200000)
	projectile_type = /obj/item/projectile/energy/bolt/large

/obj/item/gun/energy/plasmastun
	name = "plasma pulse projector"
	desc = "The Mars Military Industries MA21 Selkie is a weapon that uses a laser pulse to ionise the local atmosphere, creating a disorienting pulse of plasma and deafening shockwave as the wave expands."
	icon = 'icons/obj/guns/plasma_stun.dmi'
	icon_state = "plasma_stun"
	item_state = "plasma_stun"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_POWER = 3)
	fire_delay = 20
	max_shots = 4
	projectile_type = /obj/item/projectile/energy/plasmastun
	combustion = 0

/obj/item/gun/energy/confuseray
	name = "disorientator"
	desc = "The W-T Mk. 4 Disorientator is a small, low capacity, and short-ranged energy projector intended for personal defense with minimal risk of permanent damage or cross-fire."
	icon = 'icons/obj/guns/confuseray.dmi'
	icon_state = "confuseray"
	safety_icon = "safety"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_POWER = 2)
	w_class = ITEM_SIZE_SMALL
	max_shots = 4
	projectile_type = /obj/item/projectile/beam/confuseray
	combustion = 0
