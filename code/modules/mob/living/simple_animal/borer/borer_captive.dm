/mob/living/captive_brain
	name = "host brain"
	real_name = "host brain"
	universal_understand = 1

/mob/living/captive_brain/process_resist()
	//Resisting control by an alien mind.
	if(istype(src.loc,/mob/living/simple_animal/borer))
		var/mob/living/simple_animal/borer/B = src.loc
		var/mob/living/captive_brain/H = src

		H << "<span class='danger'>You begin doggedly resisting the parasite's control (this will take approximately sixty seconds).</span>"
		B.host << "<span class='danger'>You feel the captive mind of [src] begin to resist your control.</span>"

		spawn(rand(200,250)+B.host.brainloss)
			if(!B || !B.controlling) return

			B.host.adjustBrainLoss(rand(0.1,0.5))
			H << "<span class='danger'>With an immense exertion of will, you regain control of your body!</span>"
			B.host << "<span class='danger'>You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you.</span>"
			B.detatch()
			verbs -= /mob/living/carbon/proc/release_control
			verbs -= /mob/living/carbon/proc/punish_host
			verbs -= /mob/living/carbon/proc/spawn_larvae

		return

	..()
