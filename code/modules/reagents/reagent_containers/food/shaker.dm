/obj/item/weapon/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A three piece Cobbler-style shaker. Used to mix, cool, and strain drinks."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;60" //Professional bartender should be able to transfer as much as needed
	volume = 120
	center_of_mass = "x=17;y=10"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT

/obj/item/weapon/reagent_containers/food/drinks/shaker/attack_self(mob/user as mob)
	if(user.skill_check(SKILL_COOKING, SKILL_PROF))
		user.visible_message("<span class='rose'>\The [user] shakes \the [src] briskly in one hand, with supreme confidence and competence.</span>", "<span class='rose'>You shake \the [src] briskly with one hand.</span>")
		mix()
		return
	if(user.skill_check(SKILL_COOKING, SKILL_ADEPT))
		user.visible_message(SPAN_NOTICE("\The [user] shakes \the [src] briskly, with some skill."), SPAN_NOTICE("You shake \the [src] briskly, with some skill."))
		mix()
		return
	else
		user.visible_message(SPAN_NOTICE("\The [user] shakes \the [src] gingerly."), SPAN_NOTICE("You shake \the [src] gingerly."))
		if(prob(15) && (reagents && reagents.total_volume))
			user.visible_message(SPAN_WARNING("\The [user] spills the contents of \the [src] over themselves!"), SPAN_WARNING("You spill the contents of \the [src] over yourself!"))
			reagents.splash(user, reagents.total_volume)
		else
			mix()

/obj/item/weapon/reagent_containers/food/drinks/shaker/proc/mix()
	if(reagents && reagents.total_volume)
		atom_flags &= ~ATOM_FLAG_NO_REACT
		HANDLE_REACTIONS(reagents)
		addtimer(CALLBACK(src, .proc/stop_react), SSchemistry.wait)

/obj/item/weapon/reagent_containers/food/drinks/shaker/proc/stop_react()
	atom_flags |= ATOM_FLAG_NO_REACT