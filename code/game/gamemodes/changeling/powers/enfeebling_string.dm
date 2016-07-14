/datum/power/changeling/enfeebling_string
	name = "Enfeebling String"
	desc = "We sting a biological with a potent toxin that will greatly weaken them for a short period of time."
	helptext = "Lowers the maximum health of the victim for a few minutes.  This sting will also warn them of this.  Has a \
	five minute coodown between uses."
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

		var/effect = 30 //percent
		if(src.mind.changeling.recursive_enhancement)
			effect = effect + 20
			src << "<span class='notice'>We make them extremely weak.</span>"
			src.mind.changeling.recursive_enhancement = 0
		var/health_to_take_away = H.maxHealth * (effect / 100)

		H.maxHealth -= health_to_take_away
		H << "<span class='danger'>You feel a small prick and you feel extremly weak!</span>"
		src.verbs -= /mob/proc/changeling_enfeebling_string
		spawn(5 MINUTES)
			src.verbs |= /mob/proc/changeling_enfeebling_string
			src << "<span class='notice'>Our enfeebling string is ready to be used once more.</span>"
			if(H) //Just incase we stop existing in five minutes for whatever reason.
				H.maxHealth += health_to_take_away
				if(!H.stat) //It'd be weird to no longer feel weak when you're dead.
					H << "<span class='notice'>You no longer feel extremly weak.</span>"
	feedback_add_details("changeling_powers","ES")
	return 1
