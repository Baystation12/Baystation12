/obj/item/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon = 'icons/obj/guns/pulse_rifle.dmi'
	icon_state = "pulse"
	item_state = "pulse"
	slot_flags = SLOT_BACK
	force = 12
	projectile_type = /obj/item/projectile/beam/pulse/heavy
	max_shots = 36
	w_class = ITEM_SIZE_HUGE
	one_hand_penalty= 6
	multi_aim = 1
	burst_delay = 3
	burst = 3
	move_delay = 4
	accuracy = 1
	wielded_item_state = "gun_wielded"
	bulk = GUN_BULK_RIFLE

/obj/item/gun/energy/pulse_rifle/carbine
	name = "pulse carbine"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Less bulky than the full-sized rifle."
	icon = 'icons/obj/guns/pulse_carbine.dmi'
	icon_state = "pulse_carbine"
	slot_flags = SLOT_BACK|SLOT_BELT
	force = 8
	projectile_type = /obj/item/projectile/beam/pulse/mid
	max_shots = 24
	w_class = ITEM_SIZE_LARGE
	one_hand_penalty= 3
	burst_delay = 2
	move_delay = 2
	bulk = GUN_BULK_RIFLE - 3
	accuracy = 0

/obj/item/gun/energy/pulse_rifle/pistol
	name = "heavy blaster pistol"
	desc = "The DL-44 heavy blaster pistol. Often seen in special use by high ranking Republic officers. Not often seen in use by those of the Psidi Order - but in desperate times.."
	icon = 'icons/obj/guns/pulse_pistol.dmi'
	icon_state = "pulse_pistol"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	force = 6
	projectile_type = /obj/item/projectile/beam/pulse
	max_shots = 21
	w_class = ITEM_SIZE_NORMAL
	one_hand_penalty=1 //a bit heavy
	burst_delay = 1
	move_delay = 1
	wielded_item_state = null
	bulk = 0
	accuracy = 0

/obj/item/gun/energy/pulse_rifle/mounted
	self_recharge = 1
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/pulse_rifle/destroyer
	name = "heavy blaster carbine"
	desc = "An uncommon DLT-19 heavy blaster rifle, often seen in use by Clone Commanders. A rather recent addition to the arsenal."
	cell_type = /obj/item/cell/super
	fire_delay = 25
	projectile_type=/obj/item/projectile/beam/pulse/destroy
	charge_cost= 40

/obj/item/gun/energy/pulse_rifle/destroyer/attack_self(mob/living/user as mob)
	to_chat(user, SPAN_WARNING("[src.name] has three settings, and they are all DESTROY."))

/obj/item/gun/energy/pulse_rifle/skrell
	name = "blaster carbine"
	icon = 'icons/obj/guns/freezegun.dmi'
	icon_state = "freezegun"
	item_state = "freezegun"
	slot_flags = SLOT_BACK|SLOT_BELT
	desc = "A DC-15A blaster carbine, in regular use by Republic Clone Troopers."
	cell_type = /obj/item/cell/high
	self_recharge = 1
	move_delay = 2
	projectile_type=/obj/item/projectile/beam/pulse/skrell/single
	charge_cost=120
	one_hand_penalty = 3
	burst=1
	burst_delay=null
	wielded_item_state = "freezegun-wielded"
	accuracy = 1

	firemodes = list(
		list(mode_name="single", projectile_type=/obj/item/projectile/beam/pulse/skrell/single, charge_cost=120, burst=1, burst_delay=null),
		list(mode_name="heavy", projectile_type=/obj/item/projectile/beam/pulse/skrell/heavy, charge_cost=55, burst=2, burst_delay=3),
		list(mode_name="light", projectile_type=/obj/item/projectile/beam/pulse/skrell, charge_cost=40, burst=3, burst_delay=2)
		)
