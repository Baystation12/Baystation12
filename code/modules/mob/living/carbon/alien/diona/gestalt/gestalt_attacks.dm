/obj/structure/diona_gestalt/attack_generic(var/mob/user, var/damage, var/attack_message)
	if(user.loc == src)
		return

	if(istype(user, /mob/living/carbon/alien/diona) && user.a_intent != I_HURT)
		can_roll_up_atom(user)
		return

	visible_message("<span class='danger'>\The [user] has [attack_message] \the [src]!</span>")
	shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/attackby(var/obj/item/thing, var/mob/user)
	. = ..()
	if(thing.force) shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/hitby()
	. = ..()
	shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/bullet_act(var/obj/item/projectile/P, var/def_zone)
	. = ..()
	if(P && (P.damage_type == BRUTE || P.damage_type == BURN))
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/ex_act()
	var/shed_count = rand(1,3)
	while(shed_count && nymphs && nymphs.len)
		shed_count--
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/proc/handle_member_click(var/mob/living/carbon/alien/diona/clicker)
	return
