/obj/structure/diona_gestalt/attack_generic(mob/user, damage, attack_message)
	if(user.loc == src)
		return

	if(istype(user, /mob/living/carbon/alien/diona) && user.a_intent != I_HURT)
		can_roll_up_atom(user)
		return

	visible_message(SPAN_DANGER("\The [user] has [attack_message] \the [src]!"))
	shed_atom(forcefully = TRUE)


/obj/structure/diona_gestalt/post_use_item(obj/item/tool, mob/user, interaction_handled, use_call, click_params)
	..()
	if (interaction_handled && use_call == "weapon" && tool.force)
		shed_atom(forcefully = TRUE)


/obj/structure/diona_gestalt/hitby()
	. = ..()
	shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if (P && (P.damage_type == DAMAGE_BRUTE || P.damage_type == DAMAGE_BURN))
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/ex_act()
	var/shed_count = rand(1,3)
	while(shed_count && nymphs && length(nymphs))
		shed_count--
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/proc/handle_member_click(mob/living/carbon/alien/diona/clicker)
	return
