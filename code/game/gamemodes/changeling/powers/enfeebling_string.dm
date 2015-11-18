/datum/power/changeling/enfeebling_string
	name = "Enfeebling String"
	desc = "We sting a biological with a potent toxin that will greatly weaken them for a short period of time."
	helptext = "Lowers the maximum health of the victim for a few minutes.  This sting will also warn them of this."
	enhancedtext = "Maximum health is lowered further."
	genomecost = 1
	verbpath = /mob/proc/changeling_enfeebling_string

/mob/proc/changeling_enfeebling_string()
	set category = "Changeling"
	set name = "Enfeebling Sting (30)"
	set desc = "Reduces the maximum health of a victim for a few minutes.."

	var/mob/living/carbon/T = changeling_sting(30,/mob/proc/changeling_enfeebling_string)
	if(!T)
		return 0
	if(ishuman(T))
		var/mob/living/carbon/human/H = T

		var/effect = 30
		if(src.mind.changeling.recursive_enhancement)
			effect = effect + 20
			src << "<span class='notice'>We make them extremely weak.</span>"
			src.mind.changeling.recursive_enhancement = 0

		H.maxHealth -= effect
		H << "<span class='danger'>You feel a small prick and you feel weak.</span>"
		spawn(300) //Five minutes
			if(H) //Just incase we stop existing in five minutes for whatever reason.
				H.maxHealth += 30
				if(!H.stat) //It'd be weird to no longer feel weak when you're dead.
					H << "<span class='notice'>You no longer feel extremly weak.</span>"
	feedback_add_details("changeling_powers","ES")
	return 1