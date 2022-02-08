/obj/structure/deity/altar/tower
	icon_state = "tomealtar"

/obj/structure/deity/wizard_recharger
	name = "fountain of power"
	desc = "Refreshing, cool water surrounded by archaic carvings."
	icon_state = "fountain"
	power_adjustment = 2
	build_cost = 700
	health_max = 75

/obj/structure/deity/wizard_recharger/attack_hand(var/mob/living/hitter)
	if(!hitter.mind || !hitter.mind.learned_spells || !hitter.mind.learned_spells.len)
		to_chat(hitter, SPAN_WARNING("You don't feel as if this will do anything for you."))
		return

	hitter.visible_message(SPAN_NOTICE("\The [hitter] dips their hands into \the [src], a soft glow emanating from them."))
	if(do_after(hitter, 300, src, DO_DEFAULT | DO_TARGET_UNIQUE_ACT))
		for(var/s in hitter.mind.learned_spells)
			var/spell/spell = s
			spell.charge_counter = spell.charge_max
		to_chat(hitter, SPAN_NOTICE("You feel refreshed!"))
		return
	to_chat(hitter,SPAN_WARNING("You need to keep in contact with \the [src]!"))
