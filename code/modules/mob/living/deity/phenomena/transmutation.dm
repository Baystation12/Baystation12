/datum/phenomena/warp
	name = "Warp Body"
	cost = 25
	cooldown = 300
	flags = PHENOMENA_NEAR_STRUCTURE|PHENOMENA_MUNDANE|PHENOMENA_FOLLOWER|PHENOMENA_NONFOLLOWER
	expected_type = /mob/living

/datum/phenomena/warp/activate(var/mob/living/L)
	..()
	L.adjustCloneLoss(20)
	L.Weaken(2)
	to_chat(L, "<span class='danger'>You feel your body warp and change underneath you!</span>")

/datum/phenomena/rock_form
	name = "Rock Form"
	cost = 15
	flags = PHENOMENA_NEAR_STRUCTURE|PHENOMENA_FOLLOWER
	expected_type = /mob/living/carbon/human

/datum/phenomena/rock_form/activate(var/mob/living/carbon/human/H)
	..()
	to_chat(H, "<span class='danger'>You feel your body harden as it rapidly is transformed into living stone!</span>")
	H.set_species("Golem")
	H.Weaken(5)