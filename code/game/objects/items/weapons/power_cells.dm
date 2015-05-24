/obj/item/weapon/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	origin_tech = "powerstorage=1"
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = 3.0
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	var/construction_cost = list(DEFAULT_WALL_MATERIAL=750,"glass"=75)
	var/construction_time=100
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 50)

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is licking the electrodes of the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (FIRELOSS)

//currently only used by energy-type guns, that may change in the future.
/obj/item/weapon/cell/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "cell" //placeholder
	w_class = 2
	force = 0
	throw_speed = 5
	throw_range = 7
	maxcharge = 1000
	matter = list("metal" = 350, "glass" = 50)

/obj/item/weapon/cell/device/variable/New(newloc, charge_amount)
	..(newloc)
	maxcharge = charge_amount
	charge = maxcharge

/obj/item/weapon/cell/crap
	name = "\improper Nanotrasen brand rechargable AA battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = "powerstorage=0"
	maxcharge = 500
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 40)

/obj/item/weapon/cell/crap/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/secborg
	name = "security borg rechargable D battery"
	origin_tech = "powerstorage=0"
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 40)

/obj/item/weapon/cell/secborg/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/apc
	name = "heavy-duty power cell"
	origin_tech = "powerstorage=1"
	maxcharge = 5000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 50)

/obj/item/weapon/cell/high
	name = "high-capacity power cell"
	origin_tech = "powerstorage=2"
	icon_state = "hcell"
	maxcharge = 10000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 60)

/obj/item/weapon/cell/high/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/super
	name = "super-capacity power cell"
	origin_tech = "powerstorage=5"
	icon_state = "scell"
	maxcharge = 20000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 70)
	construction_cost = list(DEFAULT_WALL_MATERIAL=750,"glass"=100)

/obj/item/weapon/cell/super/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = "powerstorage=6"
	icon_state = "hpcell"
	maxcharge = 30000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 80)
	construction_cost = list(DEFAULT_WALL_MATERIAL=500,"glass"=150,"gold"=200,"silver"=200)

/obj/item/weapon/cell/hyper/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	origin_tech =  null
	maxcharge = 30000 //determines how badly mobs get shocked
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 80)
	
	check_charge()
		return 1
	use()
		return 1

/obj/item/weapon/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = "powerstorage=1"
	icon = 'icons/obj/power.dmi' //'icons/obj/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	charge = 100
	maxcharge = 300
	minor_fault = 1


/obj/item/weapon/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with phoron, it crackles with power."
	origin_tech = "powerstorage=2;biotech=4"
	icon = 'icons/mob/slimes.dmi' //'icons/obj/harvest.dmi'
	icon_state = "yellow slime extract" //"potato_battery"
	maxcharge = 10000
	matter = null
