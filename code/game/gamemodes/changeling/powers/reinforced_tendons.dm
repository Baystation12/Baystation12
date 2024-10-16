/datum/power/changeling/reinforced_tendons
	name = "Reinforced Tendons"
	desc = "We reinforce our tendons to lunch"
	helptext = "We will be also be able to fall great distances without damage. If we leap at a target with both arms shaped into weapons, we will perform a special pounce attack."
	genomecost = 2
	isVerb = 0
	verbpath = /mob/proc/reinforced_tendons
/mob/proc/reinforced_tendons()

	var/mob/living/carbon/human/C = src
	//C.available_maneuvers.Remove(/singleton/maneuver/leap)
	C.available_maneuvers.Add(/singleton/maneuver/leap/changeling)
	src.mind.changeling.tendons_reinforced = TRUE
	C.buff_skill(list(SKILL_HAULING = 1), 0, buff_type = /datum/skill_buff)
	//C.prepared_maneuver = /singleton/maneuver/leap/grab

	playsound(src, 'sound/effects/corpsecube.ogg',35,1)
	to_chat(src, SPAN_NOTICE("Our leg muscles twist and reknit themselves, forming stronger muscles that can both leap further and fall from great heights!"))
