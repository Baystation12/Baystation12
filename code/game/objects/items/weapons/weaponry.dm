/obj/item/weapon/banhammer
	desc = "banhammer"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 2.0
	throw_speed = 7
	throw_range = 15
	attack_verb = list("banned")

	suicide_act(mob/user)
		viewers(user) << "<span class='danger'>[user] is hitting \himself with the [src.name]! It looks like \he's trying to ban \himself from life.</span>"
		return (BRUTELOSS|FIRELOSS|TOXLOSS|OXYLOSS)

/obj/item/weapon/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 15
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = 2

	suicide_act(mob/user)
		viewers(user) << "<span class='danger'>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>"
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/nullrod/attack(mob/M as mob, mob/living/user as mob) //Paste from old-code to decult with a null rod.

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")

	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		user << "<span class='danger'>You don't have the dexterity to do this!</span>"
		return

	if ((CLUMSY in user.mutations) && prob(50))
		user << "<span class='danger'>The rod slips out of your hand and hits your head.</span>"
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if (M.stat !=2)
		if(cult && (M.mind in cult.current_antagonists) && prob(33))
			M << "<span class='danger'>The power of [src] clears your mind of the cult's influence!</span>"
			user << "<span class='danger'>You wave [src] over [M]'s head and see their eyes become clear, their mind returning to normal.</span>"
			cult.remove_antagonist(M.mind)
			M.visible_message("<span class='danger'>\The [user] waves \the [src] over \the [M]'s head.</span>")
		else if(prob(10))
			user << "<span class='danger'>The rod slips in your hand.</span>"
			..()
		else
			user << "<span class='danger'>The rod appears to do nothing.</span>"
			M.visible_message("<span class='danger'>\The [user] waves \the [src] over \the [M]'s head.</span>")
			return

/obj/item/weapon/nullrod/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if (istype(A, /turf/simulated/floor))
		user << "<span class='notice'>You hit the floor with the [src].</span>"
		call(/obj/effect/rune/proc/revealrunes)(src)

/obj/item/weapon/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	slot_flags = SLOT_BELT
	force = 2
	throwforce = 1
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << "<span class='danger'>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>"
		return(BRUTELOSS)

/obj/item/weapon/sord/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throwforce = 0
	force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/weapon/energy_net/dropped()
	spawn(10)
		if(src) qdel(src)

/obj/item/weapon/energy_net/throw_impact(atom/hit_atom)
	..()

	var/mob/living/M = hit_atom

	if(!istype(M) || locate(/obj/effect/energy_net) in M.loc)
		qdel(src)
		return 0

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/net = new net_type(T)
		net.layer = M.layer+1
		M.captured = 1
		net.affecting = M
		T.visible_message("[M] was caught in an energy net!")
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = 1
	opacity = 0
	mouse_opacity = 1
	anchored = 1

	var/health = 25
	var/mob/living/affecting = null //Who it is currently affecting, if anyone.
	var/mob/living/master = null    //Who shot web. Will let this person know if the net was successful.
	var/countdown = -1

/obj/effect/energy_net/teleport
	countdown = 60

/obj/effect/energy_net/New()
	..()
	processing_objects |= src

/obj/effect/energy_net/Destroy()

	if(affecting)
		var/mob/living/carbon/M = affecting
		M.anchored = initial(affecting.anchored)
		M.captured = 0
		M << "You are free of the net!"

	processing_objects -= src
	..()

/obj/effect/energy_net/proc/healthcheck()

	if(health <=0)
		density = 0
		src.visible_message("The energy net is torn apart!")
		qdel(src)
	return

/obj/effect/energy_net/process()

	if(isnull(affecting) || affecting.loc != loc)
		qdel(src)
		return

	// Countdown begin set to -1 will stop the teleporter from firing.
	// Clientless mobs can be netted but they will not teleport or decrement the timer.
	var/mob/living/M = affecting
	if(countdown == -1 || (istype(M) && !M.client))
		return

	if(countdown > 0)
		countdown--
		return

	// TODO: consider removing or altering this; energy nets are useful on their own
	// merits and the teleportation was never properly implemented; it's halfassed.
	density = 0
	invisibility = 101 //Make the net invisible so all the animations can play out.
	health = INFINITY  //Make the net invincible so that an explosion/something else won't kill it during anims.

	playsound(affecting.loc, 'sound/effects/sparks4.ogg', 50, 1)
	anim(affecting.loc,affecting,'icons/mob/mob.dmi',,"phaseout",,affecting.dir)

	affecting.visible_message("[affecting] vanishes in a flare of light!")

	if(holdingfacility.len)
		affecting.loc = pick(holdingfacility)

	affecting << "You appear in a strange place!"

	playsound(affecting.loc, 'sound/effects/phasein.ogg', 25, 1)
	playsound(affecting.loc, 'sound/effects/sparks2.ogg', 50, 1)
	anim(affecting.loc,affecting,'icons/mob/mob.dmi',,"phasein",,affecting.dir)

	qdel(src)

/obj/effect/energy_net/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	healthcheck()
	return 0

/obj/effect/energy_net/ex_act()
	health = 0
	healthcheck()

/obj/effect/energy_net/attack_hand(var/mob/user)

	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H.species.can_shred(H))
			playsound(src.loc, 'sound/weapons/slash.ogg', 80, 1)
			health -= rand(10, 20)
		else
			health -= rand(1,3)

	else if (HULK in user.mutations)
		health = 0
	else
		health -= rand(5,8)

	H << "<span class='danger'>You claw at the energy net.</span>"

	healthcheck()
	return

/obj/effect/energy_net/attackby(obj/item/weapon/W as obj, mob/user as mob)
	health -= W.force
	healthcheck()
	..()
