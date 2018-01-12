/obj/item/weapon/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon_state = "pulse"
	item_state = "pulse"
	slot_flags = SLOT_BACK
	force = 12
	projectile_type = /obj/item/projectile/energy/pulse
	max_shots = 108
	w_class = ITEM_SIZE_HUGE
	one_hand_penalty=8
	multi_aim = 1
	burst_delay = 1
	burst = 6
	move_delay = 4
	wielded_item_state = "gun_wielded"
	accuracy = -4


/obj/item/weapon/gun/energy/pulse_rifle/carbine
	name = "pulse carbine"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Less bulky than the full-sized rifle."
	icon_state = "pulse_carbine"
	slot_flags = SLOT_BACK|SLOT_BELT
	force = 8
	max_shots = 72
	w_class = ITEM_SIZE_LARGE
	one_hand_penalty=3
	move_delay = 2
	accuracy = -2

/obj/item/weapon/gun/energy/pulse_rifle/pistol
	name = "pulse pistol"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Even smaller than the carbine."
	icon_state = "pulse_pistol"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	force = 6
	max_shots = 21
	w_class = ITEM_SIZE_NORMAL
	one_hand_penalty=1 //a bit heavy
	move_delay = 1
	wielded_item_state = null
	accuracy = -1


/obj/item/weapon/gun/energy/pulse_rifle/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/pulse_rifle/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, it is rarely seen in use except by specialists."
	cell_type = /obj/item/weapon/cell/super
	fire_delay = 25
	projectile_type=/obj/item/projectile/energy/pulse/destroy
	charge_cost= 40

/obj/item/weapon/gun/energy/pulse_rifle/destroyer/attack_self(mob/living/user as mob)
	to_chat(user, "<span class='warning'>[src.name] has three settings, and they are all DESTROY.</span>")

/obj/item/weapon/gun/energy/pulse_rifle/bogani
	name = "pulsar cannon"
	desc = "An alien weapon never before seen by the likes of your species."
	icon_state = "bog_rifle"
	item_state = "bog_rifle"
	wielded_item_state = "bog_rifle-wielded"
	burst = 3
	projectile_type = /obj/item/projectile/beam/bogani
	max_shots = 100 //Don't want it to run out
	icon_rounder = 20
