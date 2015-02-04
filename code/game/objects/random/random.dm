/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything


// creates a new object and deletes itself
/obj/random/New()
	..()
	if (!prob(spawn_nothing_percentage))
		spawn_item()
	del src


// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0


// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()
	return (new build_path(src.loc))


/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start"
	icon_state = "x3"
	var/spawn_object = null
	item_to_spawn()
		return ispath(spawn_object) ? spawn_object : text2path(spawn_object)


/obj/random/tool
	name = "random tool"
	desc = "This is a random tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	item_to_spawn()
		return pick(/obj/item/weapon/screwdriver,\
					/obj/item/weapon/wirecutters,\
					/obj/item/weapon/weldingtool,\
					/obj/item/weapon/crowbar,\
					/obj/item/weapon/wrench,\
					/obj/item/device/flashlight)


/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"
	item_to_spawn()
		return pick(prob(5);/obj/item/device/t_scanner,\
					prob(2);/obj/item/device/radio,\
					prob(5);/obj/item/device/analyzer)


/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_to_spawn()
		return pick(prob(10);/obj/item/weapon/cell/crap,\
					prob(40);/obj/item/weapon/cell,\
					prob(40);/obj/item/weapon/cell/high,\
					prob(9);/obj/item/weapon/cell/super,\
					prob(1);/obj/item/weapon/cell/hyper)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"
	item_to_spawn()
		return pick(/obj/item/device/assembly/igniter,\
					/obj/item/device/assembly/prox_sensor,\
					/obj/item/device/assembly/signaler,\
					/obj/item/device/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/storage/toolbox/mechanical,\
					prob(2);/obj/item/weapon/storage/toolbox/electrical,\
					prob(1);/obj/item/weapon/storage/toolbox/emergency)


/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/obj/random/powercell,\
					prob(2);/obj/random/technology_scanner,\
					prob(1);/obj/item/weapon/packageWrap,\
					prob(2);/obj/random/bomb_supply,\
					prob(1);/obj/item/weapon/extinguisher,\
					prob(1);/obj/item/clothing/gloves/fyellow,\
					prob(3);/obj/item/stack/cable_coil,\
					prob(2);/obj/random/toolbox,\
					prob(2);/obj/item/weapon/storage/belt/utility,\
					prob(5);/obj/random/tool,\
					prob(2);/obj/item/weapon/tape_roll)
