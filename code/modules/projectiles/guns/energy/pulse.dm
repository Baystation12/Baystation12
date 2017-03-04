/obj/item/weapon/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon_state = "pulse"
	item_state = "pulse_back"
	slot_flags = SLOT_BELT|SLOT_BACK
	force = 10
	projectile_type = /obj/item/projectile/beam
	sel_mode = 2
	max_shots = 30
	w_class = ITEM_SIZE_HUGE

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_delay=null, charge_cost=null),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_delay=null, charge_cost=null),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_delay=25, charge_cost=400),
		)

/obj/item/weapon/gun/energy/pulse_rifle/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/pulse_rifle/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, it is rarely seen in use except by specialists."
	cell_type = /obj/item/weapon/cell/super
	fire_delay = 25
	projectile_type=/obj/item/projectile/beam/pulse
	charge_cost=40

/obj/item/weapon/gun/energy/pulse_rifle/destroyer/attack_self(mob/living/user as mob)
	to_chat(user, "<span class='warning'>[src.name] has three settings, and they are all DESTROY.</span>")

//WHY?
/obj/item/weapon/gun/energy/pulse_rifle/M1911
	name = "\improper M1911-P"
	desc = "It's not the size of the gun, it's the size of the hole it puts through people."
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon_state = "m1911-p"
	item_state = "pulse"
	max_shots = 8
	w_class = ITEM_SIZE_NORMAL
