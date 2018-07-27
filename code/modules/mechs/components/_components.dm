/obj/item/mech_component
	icon = 'icons/mecha/mech_parts.dmi'
	w_class = 5
	pixel_x = -8
	gender = PLURAL

	var/total_damage = 0
	var/brute_damage = 0
	var/burn_damage = 0
	var/max_damage = 60
	var/damage_state = 1
	var/list/has_hardpoints = list()

	matter = list(MATERIAL_STEEL = 15000, MATERIAL_PLASTIC = 1000, MATERIAL_OSMIUM = 500)

/obj/item/mech_component/emp_act(var/severity)
	take_burn_damage(rand((10 - (severity*3)),15-(severity*4)))
	for(var/obj/item/thing in contents)
		thing.emp_act(severity)

/obj/item/mech_component/New()
	..()
	set_dir(SOUTH)

/obj/item/mech_component/examine()
	. = ..()
	if(.)
		if(ready_to_install())
			to_chat(usr, "<span class='notice'>It is ready for installation.</span>")
		else
			show_missing_parts(usr)

/obj/item/mech_component/set_dir()
	..(SOUTH)

/obj/item/mech_component/proc/show_missing_parts(var/mob/user)
	return

/obj/item/mech_component/proc/prebuild()
	return

/obj/item/mech_component/proc/install_component(var/obj/item/thing, var/mob/user)
	user.drop_from_inventory(thing)
	thing.forceMove(src)
	user.visible_message("<span class='notice'>\The [user] installs \the [thing] in \the [src].</span>")
	return 1

/obj/item/mech_component/proc/update_health()
	total_damage = brute_damage + burn_damage
	if(total_damage > max_damage) total_damage = max_damage
	damage_state = min(max(round((total_damage/max_damage)*4),1),4)

/obj/item/mech_component/proc/ready_to_install()
	return 1

/obj/item/mech_component/proc/take_brute_damage(var/amt)
	brute_damage += amt
	update_health()
	if(total_damage > max_damage)
		take_component_damage(total_damage-max_damage,0)
		total_damage = max_damage

/obj/item/mech_component/proc/take_burn_damage(var/amt)
	burn_damage += amt
	update_health()
	if(total_damage > max_damage)
		take_component_damage(0,total_damage-max_damage)
		total_damage = max_damage

/obj/item/mech_component/proc/take_component_damage(var/brute, var/burn)
	var/list/damageable_components = list()
	for(var/obj/item/robot_parts/robot_component/RC in contents)
		damageable_components += RC
	if(!damageable_components.len) return
	var/obj/item/robot_parts/robot_component/RC = pick(damageable_components)
	if(RC.take_damage(brute, burn))
		qdel(RC)

/obj/item/mech_component/attackby(var/obj/item/thing, var/mob/user)
	if(isScrewdriver(thing))
		if(contents.len)
			var/obj/item/removed = pick(contents)
			user.visible_message("<span class='notice'>\The [user] removes \the [removed] from \the [src].</span>")
			user.put_in_hands(removed)
			playsound(user.loc, 'sound/effects/pop.ogg', 50, 0)
			update_components()
		else
			to_chat(user, "<span class='warning'>There is nothing to remove.</span>")
		return
	return ..()

/obj/item/mech_component/proc/update_components()
	return