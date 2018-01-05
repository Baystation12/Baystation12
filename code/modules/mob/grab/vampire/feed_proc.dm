/mob/living/carbon/human/proc/suck(var/obj/item/grab/G)

	var/mob/living/carbon/human/affecting = G.affecting
	G.attacking = 1
	var/datum/vampire/vampire = vampire_power(0, 0)

	if (!vampire)
		return
	if (isSynthetic(affecting) || isDiona(affecting))
		//Added this to prevent vampires draining diona and IPCs
		//Diona have 'blood' but its really green sap and shouldn't help vampires
		//IPCs leak oil
		to_chat(src, "<span class='warning'>[affecting] is not a creature you can drain useful blood from.</span>")
		return

	if (vampire.status & VAMP_DRAINING)//Should be unnecessary.
		return

	var/datum/vampire/draining_vamp = null
	if (affecting.mind && affecting.mind.vampire)
		draining_vamp = affecting.mind.vampire

	var/blood = 0
	var/blood_total = 0
	var/blood_usable = 0

	vampire.status |= VAMP_DRAINING

	visible_message("<span class='danger'>[src.name] bites [affecting.name]'s neck!</span>", "<span class='danger'>You bite [affecting.name]'s neck and begin to drain their blood.</span>", "<span class='notice'>You hear a soft puncture and a wet sucking noise</span>")
	admin_attack_log(src, affecting, "drained blood from [key_name(affecting)]", "was drained blood from by [key_name(src)]", "is draining blood from")

	to_chat(affecting, "<span class='warning'>You are unable to resist or even move. Your mind blanks as you're being fed upon.</span>")

	affecting.Stun(10)

	while (do_mob(src, affecting, 50))
		if (!mind.vampire)
			to_chat(src, "<span class='danger'>Your fangs have disappeared!</span>")
			return

		blood_total = vampire.blood_total
		blood_usable = vampire.blood_usable

		if (!affecting.get_blood_volume())
			to_chat(src, "<span class='danger'>[affecting] has no more blood left to give.</span>")
			G.attacking = 0
			break

		if (!affecting.stunned)
			affecting.Stun(10)

		var/frenzy_lower_chance = 0

		// Alive and not of empty mind.
		if (affecting.stat < 2)// && affecting.client)
			blood = min(10, affecting.get_blood_volume())
			draw_usable_blood(blood)

			frenzy_lower_chance = 40

			if (draining_vamp)
				vampire.blood_vamp += blood
				// Each point of vampire blood will increase your chance to frenzy.
				vampire.frenzy += blood

				// And drain the vampire as well.
				draining_vamp.blood_usable -= min(blood, draining_vamp.blood_usable)
				vampire_check_frenzy()

				frenzy_lower_chance = 0
		// SSD/protohuman or dead.
		else //TODO: Make this transfer blood volumes, then calculate from how much of what you've drank was blood.
			blood = min(5, affecting.vessel.get_reagent_amount("blood"))
			vampire.blood_usable += blood

			frenzy_lower_chance = 40

		if (prob(frenzy_lower_chance) && vampire.frenzy > 0)
			vampire.frenzy--

		if (blood_total != vampire.blood_total)


			to_chat(src, update_msg)
		check_vampire_upgrade()
		affecting.vessel.remove_reagent("blood", 25)
		return 1


	vampire.status &= ~VAMP_DRAINING
	to_chat(vampire, "<span class='notice'>You extract your fangs from [affecting.name]'s neck and stop draining them of blood. affectinghey will remember nothing of this occurance. Provided they survived.</span>")

	if (affecting.stat != 2)
		to_chat(affecting, "<span class='warning'>You remember nothing about being fed upon. Instead, you simply remember having a pleasant encounter with [src.name].</span>")

