/obj/item/device/assembly_holder/grenade/flashbang
	name = "flashbang"
	desc = "A bang. That makes a flash. Or is it a flash that makes a bang.."
	icon_state = "flashbang"
	item_state = "flashbang"
	var/banglet = 0
	default_grenade = 0

/obj/item/device/assembly_holder/grenade/flashbang/New()
	trigger = new /obj/item/device/assembly/button (src)
	detonator = new /obj/item/device/assembly/timer (src)
	igniter = new /obj/item/device/assembly/igniter (src)
	explosive = new /obj/item/device/assembly/explosive/flash (src)
	..()

/obj/item/device/assembly_holder/grenade/flashbang/clusterbang//Created by Polymorph, fixed by Sieve, updated by Rose
	desc = "Use of this weapon may constiute a war crime in your area, consult your local captain."
	name = "clusterbang"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang"

	New()
		trigger = new /obj/item/device/assembly/button (src)
		detonator = new /obj/item/device/assembly/timer (src)
		igniter = new /obj/item/device/assembly/igniter (src)
		explosive = new /obj/item/device/assembly/explosive/flash/clusterbang (src)
		..()
