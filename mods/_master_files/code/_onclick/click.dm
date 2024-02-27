/mob/living/carbon/human/AltClickOn(atom/A)
	if(get_dist(src, A) > 1)
		return ..()
	if(!stat && mind && ismob(A) && (A != src) && (src.species.name == SPECIES_ADHERENT))
		var/mob/living/carbon/human/adherent = src
		var/obj/item/organ/internal/cell/adherent/adherent_core = adherent.internal_organs_by_name[BP_CELL]
		if(adherent_core.ready_to_charge)
			var/mob/living/carbon/human/target_human = A
			var/mob/living/target = A
			var/obj/item/cell/target_cell
			var/obj/item/cell/adherent_cell
			var/obj/item/organ/internal/cell/acell = locate() in adherent.internal_organs
			if(acell && acell.cell)
				adherent_cell = acell.cell

			if(adherent_cell && adherent_cell.charge <= 2000)
				to_chat(src, SPAN_WARNING("Your cell charge is too low for this action."))
				return

			if(ishuman(target_human))
				var/obj/item/organ/internal/cell/cell = locate() in target_human.internal_organs
				if(cell && cell.cell)
					target_cell = cell.cell
			else if(isrobot(target))
				var/mob/living/silicon/robot/robot = target
				target_cell = robot.get_cell()

			target.visible_message(SPAN_WARNING("There is a loud crack and the smell of ozone as \the [adherent] touches \the [target]."))
			playsound(loc, 'sound/effects/snap.ogg', 50, 1)

			if(target_cell)
				if(target_cell.maxcharge > (target_cell.charge + 2000))
					target_cell.charge += 2000
				else
					target_cell.charge = target_cell.maxcharge
				to_chat(target, SPAN_NOTICE("<b>Your [target_cell] has been charged.</b>"))
			adherent_cell.charge -= 2000
			if(istype(target_human) && target_human.species.name == SPECIES_ADHERENT)
				next_click = world.time + 2 SECONDS
				return
			if(isrobot(target))
				target.apply_damage(100, DAMAGE_BURN, def_zone = src.zone_sel.selecting)
				visible_message(SPAN_DANGER("[adherent] touches [target] with bright electrical arc connecting them."))
				to_chat(target, SPAN_DANGER("<b>You detect damage to your components!</b>"))
			else if(ishuman(target))
				target.electrocute_act(100, src, def_zone = src.zone_sel.selecting)
				visible_message(SPAN_DANGER("With bright electrical flash [adherent] touches [target] using it's tentacles."))
			else
				target.apply_damage(100, DAMAGE_BURN, def_zone = src.zone_sel.selecting)
				visible_message(SPAN_DANGER("With bright electrical flash [adherent] touches [target] using it's tentacles."))
			admin_attack_log(src, target, "Has electrocuted", "Has been electrocuted", "electrocuted")
			target.throw_at(get_step(target,get_dir(src,target)), 5, 10)
			next_click = world.time + 2 SECONDS
			return
	return ..()
