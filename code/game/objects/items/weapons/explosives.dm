/obj/item/weapon/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags = NOBLUDGEON
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ILLEGAL = 2)
	var/datum/wires/explosive/c4/wires = null
	var/timer = 10
	var/atom/target = null
	var/open_panel = 0
	var/image_overlay = null

/obj/item/weapon/plastique/New()
	wires = new(src)
	image_overlay = image('icons/obj/assemblies.dmi', "plastic-explosive2")
	..()

/obj/item/weapon/plastique/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/item/weapon/plastique/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/screwdriver))
		open_panel = !open_panel
		to_chat(user, "<span class='notice'>You [open_panel ? "open" : "close"] the wire panel.</span>")
	else if(iswirecutter(I) || istype(I, /obj/item/device/multitool) || istype(I, /obj/item/device/assembly/signaler ))
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
		forceMove(null)

		if (ismob(target))
			admin_attack_log(user, target, "Planted \a [src] with a [timer] second fuse.", "Had \a [src] with a [timer] second fuse planted on them.", "planted \a [src] with a [timer] second fuse on")
			user.visible_message("<span class='danger'>[user.name] finished planting an explosive on [target.name]!</span>")
			log_game("[key_name(user)] planted [src.name] on [key_name(target)] with [timer] second fuse")

		else
			log_and_message_admins("planted \a [src] with a [timer] second fuse on \the [target].")

		target.overlays += image_overlay
		to_chat(user, "Bomb has been planted. Timer counting down from [timer].")
		spawn(timer*10)
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
