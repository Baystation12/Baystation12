/datum/technomancer/spell/asphyxiation
	name = "Asphyxiation"
	desc = "Launches a projectile at a target.  If the projectile hits, a short-lived toxin is created inside what the projectile \
	hits, which inhibits the delivery of oxygen.  The effectiveness of the toxin is heavily dependant on how healthy the target is, \
	with the target taking more damage the more wounded they are.  The effect lasts for twelve seconds."
	cost = 140
	obj_path = /obj/item/weapon/spell/insert/asphyxiation

/obj/item/weapon/spell/insert/asphyxiation
	name = "asphyxiation"
	desc = "Now you can cause suffication from afar!"
	icon_state = "generic"
	cast_methods = CAST_RANGED
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"
	inserting = /obj/item/weapon/inserted_spell/asphyxiation

// maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

/obj/item/weapon/inserted_spell/asphyxiation/on_insert()
	spawn(1)
		if(ishuman(host))
			var/mob/living/carbon/human/H = host
			if(H.isSynthetic() || H.should_have_organ(BP_LUNGS)) // It's hard to choke a robot or something that doesn't breathe.
				on_expire()
				return
			to_chat(H,"<span class='warning'>You are having difficulty breathing!</span>")
			var/pulses = 3
			var/warned_victim = 0
			while(pulses)
				if(!warned_victim)
					warned_victim = predict_crit(pulses, H, 0)
				sleep(4 SECONDS)
				H.adjustOxyLoss(5)
				var/health_lost = H.maxHealth - H.getOxyLoss() + H.getToxLoss() + H.getFireLoss() + H.getBruteLoss() + H.getCloneLoss()
				H.adjustOxyLoss(round(abs(health_lost * 0.25)))
				pulses--
			if(src) //We might've been dispelled at this point and deleted, better safe than sorry.
				on_expire()

/obj/item/weapon/inserted_spell/asphyxiation/on_expire()
	..()

// if((getOxyLoss() > (species.total_health/2)) || (health <= config.health_threshold_crit))

/obj/item/weapon/inserted_spell/asphyxiation/proc/predict_crit(var/pulses_remaining, var/mob/living/carbon/human/victim, var/previous_damage = 0)
	if(pulses_remaining <= 0) // Infinite loop protection
		return 0
	var/health_lost
	var/predicted_damage
	// First, we sum up all the damage we have.
	health_lost = victim.getOxyLoss() + victim.getToxLoss() + victim.getFireLoss() + victim.getBruteLoss() + victim.getCloneLoss()
	// Then add the damage we had done in the last check, if such a number exists, as this is a recursive proc.
	health_lost += previous_damage
	// We inflict 25% of the total health loss as oxy damage.
	predicted_damage = round(abs(health_lost * 0.25))
	// Add our prediction to previous_damage, so we will remember it for the next iteration.
	previous_damage = previous_damage + predicted_damage
	// Now do this again a few more times.
	if(pulses_remaining)
		pulses_remaining--
		return .(pulses_remaining, victim, previous_damage)
	// Now check if our damage predictions are going to cause the victim to go into crit if no healing occurs.
	if(previous_damage + health_lost >= victim.maxHealth) // We're probably going to hardcrit
		to_chat(victim,"<span class='danger'><font size='3'>A feeling of immense dread starts to overcome you as everything starts \
		to fade to black...</font></span>")
		return 1
	else if(predicted_damage >= victim.species.total_health / 2) // Or perhaps we're gonna go into 'oxy crit'.
		to_chat(victim,"<span class='danger'>You feel really light-headed, and everything seems to be fading...</span>")
		return 1
	//If we're at this point, the spell is not going to result in critting.
	return 0