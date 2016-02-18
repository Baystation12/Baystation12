/obj/item/device/assembly_holder/grenade/anti_photon
	name = "photon distruption grenade"
	desc = "An experimental device for temporarily removing light in a limited area."
	icon_state = "emp"
	item_state = "empgrenade"
	origin_tech = "materials=2;magnets=3"
	default_grenade = 0
	max_connections = 3
	var/obj/item/device/assembly/power_bank/power

/obj/item/device/assembly_holder/grenade/anti_photon/New()
	igniter = null // Activated electronically
	trigger = new /obj/item/device/assembly/button (src)
	explosive = new /obj/item/device/assembly/explosive/anti_photon (src)
	detonator = new /obj/item/device/assembly/timer(src)
	power = new (src)
	attach_device(power)
	..()
	if(connected_devices[3] == explosive)
		power.connects_to += "3"

/obj/item/device/assembly_holder/grenade/anti_photon/attack_self(var/mob/user)
	if(detonator && trigger)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()
	..()