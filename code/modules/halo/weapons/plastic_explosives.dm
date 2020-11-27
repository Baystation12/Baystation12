/obj/item/weapon/plastique
	name = "C-12 Shaped Demolition Charge"
	desc = "C-12 Shaped-charges or C-12 SCs are used mainly for heavy demolitions and can also be used as weapons. This charge is small and used for pinpoint breaching."
	gender = PLURAL
	icon = 'code/modules/halo/weapons/icons/plastic_explosives.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags = NOBLUDGEON
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ILLEGAL = 2)
	var/datum/wires/explosive/c4/wires = null
	var/timer = 10
	var/atom/target = null
	var/open_panel = 0
	var/overlay_state = "plastic-explosive2"
	var/image_overlay = null

/obj/item/weapon/plastique/New()
	wires = new(src)
	image_overlay = image(icon,overlay_state)
	..()

/obj/item/weapon/plastique/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/item/weapon/plastique/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/screwdriver))
		open_panel = !open_panel
		to_chat(user, "<span class='notice'>You [open_panel ? "open" : "close"] the wire panel.</span>")
	else if(istype(I, /obj/item/weapon/wirecutters) || istype(I, /obj/item/device/multitool) || istype(I, /obj/item/device/assembly/signaler ))
		wires.Interact(user)
	else
		..()

/obj/item/weapon/plastique/attack_self(mob/user as mob)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if(user.get_active_hand() == src)
		newtime = Clamp(newtime, 10, 60000)
		timer = newtime
		to_chat(user, "Timer set for [timer] seconds.")

/obj/item/weapon/plastique/afterattack(atom/movable/target, mob/user, flag)
	if (!flag)
		return
	if (ismob(target) || istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/weapon/storage/) || istype(target, /obj/item/clothing/accessory/storage/) || istype(target, /obj/item/clothing/under))
		return
	to_chat(user, "Planting explosives...")
	user.do_attack_animation(target)

	if(do_after(user, 50, target) && in_range(user, target))
		user.drop_item()
		src.target = target
		dir = get_dir(user,target)
		forceMove(null)

		if (ismob(target))
			admin_attack_log(user, target, "Planted \a [src] with a [timer] second fuse.", "Had \a [src] with a [timer] second fuse planted on them.", "planted \a [src] with a [timer] second fuse on")
			user.visible_message("<span class='danger'>[user.name] finished planting an explosive charge on [target.name]!</span>")
			log_game("[key_name(user)] planted [src.name] on [key_name(target)] with [timer] second fuse")

		else
			log_and_message_admins("planted \a [src] with a [timer] second fuse on \the [target].")

		target.overlays += image_overlay
		to_chat(user, "Bomb has been planted. Timer counting down from [timer].")
		spawn(timer SECONDS)
			explode(get_turf(target))

/obj/item/weapon/plastique/proc/explode(var/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, -1, -1, 2, 3)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else if(istype(target, /mob/living))
			target.ex_act(2) // c4 can't gib mobs anymore.
		else
			target.ex_act(1)
	if(target)
		target.overlays -= image_overlay
	qdel(src)

/obj/item/weapon/plastique/attack(mob/M as mob, mob/user as mob, def_zone)
	return

/obj/item/weapon/plastique/breaching
	name = "Breaching Charge"
	desc = "A charge used to create a wide breach in a and project a deadly concussive and explosive effect directly behind it."

/obj/item/weapon/plastique/breaching/proc/do_explosion_effect(var/location)
	explosion(location,5,6,8,10,1,0,1,0,0,null,dir,-2,2)

/obj/item/weapon/plastique/breaching/explode(var/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	//This is purposefully inverted so the alternative effect happens first, then the explosion.
	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else if(istype(target, /mob/living))
			target.ex_act(2) // c4 can't gib mobs anymore.
		else
			target.ex_act(1)
	if(location)
		do_explosion_effect(location)

	if(target)
		target.overlays -= image_overlay
	qdel(src)

/obj/item/weapon/plastique/breaching/longrange
	name = "Breaching Charge, Piercing"
	desc = "A charge designed to pierce through a long line of walls and cause large damage to a specific point."

/obj/item/weapon/plastique/breaching/longrange/do_explosion_effect(var/location)
	explosion(location,7,10,12,12,1,0,1,0,0,null,dir,-4,6)