/obj/item/weapon/tank/phoron/innie
	name = "Freedom flamethrower tank"
	icon = 'code/modules/halo/factions/npc_factions/gear/flp.dmi'
	icon_state = "flt_tank"

/obj/item/weapon/flamethrower/innie
	name = "Freedom flamethrower"
	icon = 'code/modules/halo/factions/npc_factions/gear/flp.dmi'
	icon_state = "flt_flammer_off"

/obj/item/weapon/flamethrower/innie/New()
	. = ..()
	weldtool = new /obj/item/weapon/weldingtool(src)
	weldtool.status = 0
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = 0
	status = 1
	ptank = new /obj/item/weapon/tank/phoron/innie(src)
	update_icon()

/obj/item/weapon/flamethrower/innie/attackby(obj/item/W as obj, mob/user as mob)
	if(istool(W))
		to_chat(user, "<span class='notice'>[src] cannot be modified!</span>")
	else
		if(istype(W,/obj/item/weapon/tank/phoron/innie))
			if(ptank)
				to_chat(user, "<span class='notice'>There appears to already be a [ptank] loaded in [src]!</span>")
				return
			user.drop_item()
			ptank = W
			W.loc = src
			update_icon()
			return

		if(istype(W, /obj/item/device/analyzer))
			var/obj/item/device/analyzer/A = W
			A.analyze_gases(src, user)
			return

/obj/item/weapon/flamethrower/innie/update_icon()
	if(!ptank)
		icon_state = "flt_flammer_unloaded"
	else if(lit)
		icon_state = "flt_flamme_on"
	else
		icon_state = "flt_flammer_off"
	return
