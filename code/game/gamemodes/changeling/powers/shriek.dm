/datum/power/changeling/resonant_shriek
	name = "Resonant Shriek"
	desc = "Our lungs and vocal chords shift, allowing us to briefly emit a noise that deafens and confuses the weak-minded biologicals and synthetics."
	genomecost = 2
	verbpath = /mob/proc/changeling_resonant_shriek

/datum/power/changeling/dissonant_shriek
	name = "Dissonant Shriek"
	desc = "We shift our vocal cords to release a high-frequency sound that overloads nearby electronics."
	genomecost = 2
	verbpath = /mob/proc/changeling_dissonant_shriek

//A flashy ability, good for crowd control and sewing chaos.
/mob/proc/changeling_resonant_shriek()
	set category = "Changeling"
	set name = "Resonant Shriek (20)"
	set desc = "Emits a high-frequency sound that confuses and deafens humans, blows out nearby lights and overloads cyborg sensors."

	var/datum/changeling/changeling = changeling_power(20,0,100,CONSCIOUS)
	if(!changeling)	return 0
	changeling.chem_charges -= 20

	for(var/mob/living/M in range(4, src))
		if(iscarbon(M))
			if(!M.mind || !M.mind.changeling)
				M.adjustEarDamage(0,30)
				M.confused += 20
			else
				M << sound('sound/effects/screech.ogg')

		if(issilicon(M))
			M << sound('sound/weapons/flash.ogg')
			M.Weaken(rand(5,10))

	for(var/obj/machinery/light/L in range(4, src))
		L.on = 1
		L.broken()

	feedback_add_details("changeling_powers","RS")
	return 1

//EMP version
/mob/proc/changeling_dissonant_shriek()
	set category = "Changeling"
	set name = "Dissonant Shriek (20)"
	set desc = "We shift our vocal cords to release a high-frequency sound that overloads nearby electronics."

	var/datum/changeling/changeling = changeling_power(20,0,100,CONSCIOUS)
	if(!changeling)	return 0
	changeling.chem_charges -= 20

	for(var/obj/machinery/light/L in range(5, src))
		L.on = 1
		L.broken()
	empulse(get_turf(src), 2, 5, 1)
	return 1