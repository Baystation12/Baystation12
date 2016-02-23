/obj/item/device/assembly_holder/grenade/empgrenade
	name = "classic emp grenade"
	desc = "A strange device glowing slightly blue. Hmm."
	icon_state = "emp"
	item_state = "empgrenade"
	origin_tech = "materials=2;magnets=3"
	default_grenade = 0
	max_connections = 4
	var/obj/item/device/assembly/power_bank/power

/obj/item/device/assembly_holder/grenade/empgrenade/New()
	igniter = null // Activated electronically
	trigger = new /obj/item/device/assembly/button (src)
	explosive = new /obj/item/device/assembly/explosive/emexplosive (src)
	detonator = new /obj/item/device/assembly/timer (src)
	power = new /obj/item/device/assembly/power_bank (src)
	attach_device(src, power)
	..()
	power.connects_to += "4"

/obj/item/device/assembly_holder/grenade/empgrenade/attack_self(var/mob/user)
	if(detonator && trigger)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()
	..()