/obj/structure/deity/altar/tower
	icon_state = "tomealtar"

/obj/structure/deity/wizard_recharger
	name = "fountain of power"
	desc = "Refreshing, cool water surrounded by archaic carvings."
	icon_state = "fountain"
	power_adjustment = 2
	build_cost = 700

/obj/structure/deity/wizard_recharger/attack_hand(var/mob/living/hitter)
	if(!hitter.mind || !hitter.mind.learned_spells || !hitter.mind.learned_spells.len)
		to_chat(hitter, "<span class='warning'>You don't feel as if this will do anything for you.</span>")
		return

	hitter.visible_message("<span class='notice'>\The [hitter] dips their hands into \the [src], a soft glow emanating from them.</span>")
	if(do_after(hitter,300,src,needhand=0))
		for(var/s in hitter.mind.learned_spells)
			var/spell/spell = s
			spell.charge_counter = spell.charge_max
		to_chat(hitter, "<span class='notice'>You feel refreshed!</span>")
		return
	to_chat(hitter,"<span class='warning'>You need to keep in contact with \the [src]!</span>")
