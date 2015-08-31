/obj/item/device/soulstone/cultify()
	return

/obj/item/device/soulstone
	name = "soul stone shard"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	desc = "A fragment of the legendary treasure known simply as the 'Soul Stone'. The shard still flickers with a fraction of the full artefacts power."
	w_class = 2
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)

	var/full = 0
	var/is_evil = 1
	var/mob/living/simple_animal/shade = null

/obj/item/device/soulstone/full
	full = 1

/obj/item/device/soulstone/Destroy()
	if(shade)
		qdel(shade)
		shade = null
	..()

/obj/item/device/soulstone/attackby(var/obj/item/I, var/mob/user)
	..()
	if(is_evil && istype(I, /obj/item/weapon/nullrod))
		user << "<span class='notice'>You cleanse \the [src] of the taint.</span>"
		is_evil = 0
		return

/obj/item/device/soulstone/attack(var/mob/living/simple_animal/shade/S, var/mob/user)
	if(S == shade)
		user << "<span class='notice'>You recapture \the [S].</span>"
		S.forceMove(src)
		return

/obj/item/device/soulstone/attack_self(var/mob/user)
	if(!full)
		user << "<span class='notice'>This [src] has no life essence.</span>"
		return
	if(!shade)
		user << "<span class='notice'>You cut your finger and let the blood drip on \the [src].</span>"
		user.pay_for_rune(1)
		var/datum/ghosttrap/cult/shade/S = get_ghost_trap("soul stone")
		S.request_player(src, "The soul stone shade summon ritual has been performed. ")
	else if(shade.loc == src)
		shade.forceMove(get_turf(src))
		user << "<span class='notice'>You summon \the [shade].</span>"
		return

/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."

/obj/structure/constructshell/cultify()
	return

/obj/structure/constructshell/cult
	icon_state = "construct-cult"
	desc = "This eerie contraption looks like it would come alive if supplied with a missing ingredient."

/obj/structure/constructshell/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/S = I
		if(!S.shade || S.shade.loc != S)
			return
		var/construct = alert(user, "Please choose which type of construct you wish to create.",,"Artificer", "Wraith", "Juggernaut")
		var/ctype
		switch(construct)
			if("Artificer")
				ctype = /mob/living/simple_animal/construct/builder
			if("Wraith")
				ctype = /mob/living/simple_animal/construct/wraith
			if("Juggernaut")
				ctype = /mob/living/simple_animal/construct/armoured
		var/mob/living/simple_animal/construct/C = new ctype(get_turf(src))
		C.key = S.shade.key
		//C.cancel_camera()
		if(S.is_evil)
			cult.add_antagonist(C.mind)
		qdel(S)
		qdel(src)

/*
							var/mob/living/simple_animal/shade/S = new /mob/living/simple_animal/shade( T.loc )
							S.loc = C //put shade in stone
							S.status_flags |= GODMODE //So they won't die inside the stone somehow
							S.canmove = 0//Can't move out of the soul stone
							S.name = "Shade of [T.real_name]"
							S.real_name = "Shade of [T.real_name]"
							S.icon = T.icon
							S.icon_state = T.icon_state
							S.overlays = T.overlays
							S.color = rgb(254,0,0)
							S.alpha = 127
							if (T.client)
								T.client.mob = S
							S.cancel_camera()
							C.icon_state = "soulstone2"
							C.name = "Soul Stone: [S.real_name]"
							S << "Your soul has been captured! You are now bound to [U.name]'s will, help them suceed in their goals at all costs."
							U << "\blue <b>Capture successful!</b>: \black [T.real_name]'s soul has been ripped from their body and stored within the soul stone."
							U << "The soulstone has been imprinted with [S.real_name]'s mind, it will no longer react to other souls."
							C.imprinted = "[S.name]"
							qdel(T)


						Z << "<B>You are playing a Juggernaut. Though slow, you can withstand extreme punishment, and rip apart enemies and walls alike.</B>"

						Z << "<B>You are playing a Wraith. Though relatively fragile, you are fast, deadly, and even able to phase through walls.</B>"

						Z << "<B>You are playing an Artificer. You are incredibly weak and fragile, but you are able to construct fortifications, repair allied constructs (by clicking on them), and even create new constructs</B>"
						
						Z << "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>"
							*/
