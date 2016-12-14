/datum/technomancer/spell/mend_organs
	name = "Great Mend Wounds"
	desc = "Greatly heals the target's wounds, both external and internal.  Restores internal organs to functioning states, even if \
	robotic, reforms bones, patches internal bleeding, and restores missing blood."
	cost = 100
	obj_path = /obj/item/weapon/spell/insert/mend_organs
	ability_icon_state = "tech_mendwounds"
	category = SUPPORT_SPELLS

/obj/item/weapon/spell/insert/mend_organs
	name = "great mend wounds"
	desc = "A walking medbay is now you!"
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/weapon/inserted_spell/mend_organs

/obj/item/weapon/inserted_spell/mend_organs/on_insert()
	spawn(1)
		if(ishuman(host))
			var/mob/living/carbon/human/H = host
			var/heal_power = host == origin ? 2 : 5
			origin.adjust_instability(15)

			for(var/i = 0, i<5,i++)
				if(H)
					for(var/obj/item/organ/O in H.internal_organs)
						if(O.damage > 0) // Fix internal damage
							O.damage = max(O.damage - (heal_power / 5), 0)
						if(O.damage <= 5 && O.organ_tag == BP_EYES) // Fix eyes
							H.sdisabilities &= ~BLIND

					for(var/obj/item/organ/external/O in H.organs) // Fix limbs
						if(!O.robotic < ORGAN_ROBOT) // No robot parts for this.
							continue
						O.heal_damage(0, heal_power / 5, internal = 1, robo_repair = 0)

					for(var/obj/item/organ/E in H.bad_external_organs) // Fix bones
						var/obj/item/organ/external/affected = E
						if((affected.damage < affected.min_broken_damage * config.organ_health_multiplier) && (affected.status & ORGAN_BROKEN))
							affected.status &= ~ORGAN_BROKEN

						for(var/datum/wound/W in affected.wounds) // Fix IB
							if(istype(W, /datum/wound/internal_bleeding))
								affected.wounds -= W
								affected.update_damages()

					H.restore_blood() // Fix bloodloss

					sleep(1 SECOND)
		on_expire()