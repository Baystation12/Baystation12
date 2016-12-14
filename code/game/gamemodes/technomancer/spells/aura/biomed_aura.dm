/datum/technomancer/spell/biomed_aura
	name = "Restoration Aura"
	desc = "Heals you and your allies (or everyone, if you want) of trauma and burns slowly, as long as they remain within four meters."
	cost = 100
	obj_path = /obj/item/weapon/spell/aura/biomed
	ability_icon_state = "tech_biomedaura"
	category = SUPPORT_SPELLS

/obj/item/weapon/spell/aura/biomed
	name = "restoration aura"
	desc = "Allows everyone, or just your allies, to slowly regenerate."
	icon_state = "generic"
	cast_methods = null
	aspect = ASPECT_BIOMED
	glow_color = "#33CC33"
	var/regen_tick = 0
	var/heal_allies_only = 1

/obj/item/weapon/spell/aura/biomed/process()
	if(!pay_energy(75))
		qdel(src)
	regen_tick++
	if(regen_tick % 5 == 0)
		var/list/nearby_mobs = range(4,owner)
		var/list/mobs_to_heal = list()
		for(var/mob/living/L in nearby_mobs)
			if(heal_allies_only)
				if(is_ally(L))
					mobs_to_heal |= L
			else
				mobs_to_heal |= L // Heal everyone!
		for(var/mob/living/L in mobs_to_heal)
			L.adjustBruteLoss(-2)
			L.adjustFireLoss(-2)
		adjust_instability(2)

/obj/item/weapon/spell/aura/biomed/on_use_cast(mob/living/user)
	heal_allies_only = !heal_allies_only
	to_chat(user,"Your aura will now heal [heal_allies_only ? "your allies" : "everyone"] near you.")
