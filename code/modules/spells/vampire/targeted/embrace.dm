// Convert a human into a vampire.
/spell/targeted/vampire/embrace
	name = "The Embrace"
	desc = "Spread your corruption to an innocent soul, turning them into a spawn of the Veil, much akin to yourself."
	blood_cost = 0 //Used only by fullpower vampires. This is the final spell. No cooldown... But requires a bit of setup.


/spell/targeted/vampire/embrace/cast()
	var/datum/vampire/vampire = vampire_power(0, 0)
	if (!vampire)
		return
e
	// Re-using blood drain code.
	var/obj/item/grab/G = get_active_hand()
	if (!istype(G))
		to_chat(src, "<span class='warning'>You must be grabbing a victim in your active hand to drain their blood.</span>")
		return
/*
	if (G.can_enthrall())
		to_chat(src, "<span class='warning'>You must have the victim pinned to the ground to drain their blood.</span>")
		return
*/
	var/mob/living/carbon/human/T = G.affecting
	if (!vampire_can_affect_target(T))
		return

	if (!T.client)
		to_chat(src, "<span class='warning'>[T] is a mindless husk. The Veil has no purpose for them.</span>")
		return

	if (T.stat == 2)
		to_chat(src, "<span class='warning'>[T]'s body is broken and damaged beyond salvation. You have no use for them.</span>")
		return

	if (vampire.status & VAMP_DRAINING)
		to_chat(src, "<span class='warning'>Your fangs are already sunk into a victim's neck!</span>")
		return

	if (T.mind.vampire)
		var/datum/vampire/draining_vamp = T.mind.vampire

		if (draining_vamp.status & VAMP_ISTHRALL)
			var/choice_text = ""
			var/denial_response = ""
			if (draining_vamp.master == src)
				choice_text = "[T] is your thrall. Do you wish to release them from the blood bond and give them the chance to become your equal?"
				denial_response = "You opt against giving [T] a chance to ascend, and choose to keep them as a servant."
			else
				choice_text = "You can feel the taint of another master running in the veins of [T]. Do you wish to release them of their blood bond, and convert them into a vampire, in spite of their master?"
				denial_response = "You choose not to continue with the Embrace, and permit [T] to keep serving their master."

			if (alert(src, choice_text, "Choices", "Yes", "No") == "No")
				to_chat(src, "<span class='notice'>[denial_response]</span>")
				return

			vampire_thrall.remove_antagonist(T.mind, 0, 0)
//			qdel(draining_vamp)
			draining_vamp = null
		else
			to_chat(src, "<span class='warning'>You feel corruption running in [T]'s blood. Much like yourself, \he[T] is already a spawn of the Veil, and cannot be Embraced.</span>")
			return

	vampire.status |= VAMP_DRAINING

	visible_message("<span class='danger'>[src] bites [T]'s neck!</span>", "<span class='danger'>You bite [T]'s neck and begin to drain their blood, as the first step of introducing the corruption of the Veil to them.</span>", "<span class='notice'>You hear a soft puncture and a wet sucking noise.</span>")

	to_chat(T, "<span class='notice'><br>You are currently being turned into a vampire. You will die in the course of this, but you will be revived by the end. Please do not ghost out of your body until the process is complete.</span>")

	while (do_mob(src, T, 50))
		if (!mind.vampire)
			to_chat(src, "<span class='alert'>Your fangs have disappeared!</span>")
			return

		if (!T.vessel.get_reagent_amount("blood"))
			to_chat(src, "<span class='alert'>[T] is now drained of blood. You begin forcing your own blood into their body, spreading the corruption of the Veil to their body.</span>")
			break

		T.vessel.remove_reagent("blood", 50)

	T.revive()

	// You ain't goin' anywhere, bud.
	if (!T.client && T.mind)
		for (var/mob/observer/ghost/spook in GLOB.player_list)
			if (spook.mind == T.mind)
				spook.can_reenter_corpse = 1
				spook.reenter_corpse()

				to_chat(T, "<span class='danger'>A dark force pushes you back into your body. You find yourself somehow still clinging to life.</span>")

	T.Weaken(15)
	vamp.add_antagonist(T.mind, 1, 1, 0, 0, 1)

	admin_attack_log(src, T, "successfully embraced [key_name(T)]", "was successfully embraced by [key_name(src)]", "successfully embraced and turned into a vampire")

	to_chat(T, "<span class='danger'>You awaken. Moments ago, you were dead, your conciousness still forced stuck inside your body. Now you live. You feel different, a strange, dark force now present within you. You have an insatiable desire to drain the blood of mortals, and to grow in power.</span>")
	to_chat(src, "<span class='warning'>You have corrupted another mortal with the taint of the Veil. Beware: they will awaken hungry and maddened; not bound to any master.</span>")

	T.mind.vampire.blood_usable = 0
	T.mind.vampire.frenzy = 250
	T.vampire_check_frenzy()

	vampire.status &= ~VAMP_DRAINING

