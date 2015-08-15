/datum/power/changeling/fakedeath
	name = "Regenerative Stasis"
	desc = "We become weakened to a death-like state, where we will rise again from death."
	helptext = "Can be used before or after death. Duration varies greatly."
	genomecost = 0
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_fakedeath

//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/mob/proc/changeling_fakedeath()
	set category = "Changeling"
	set name = "Regenerative Stasis (20)"

	var/datum/changeling/changeling = changeling_power(20,1,100,DEAD)
	if(!changeling)
		return

	var/mob/living/carbon/C = src
	if(!C.stat && alert("Are we sure we wish to fake our death?",,"Yes","No") == "No")//Confirmation for living changelings if they want to fake their death
		return
	C << "<span class='notice'>We will attempt to regenerate our form.</span>"

	C.status_flags |= FAKEDEATH		//play dead
	C.update_canmove()
	C.remove_changeling_powers()

	if(C.stat != DEAD)
		C.emote("deathgasp")
		C.tod = worldtime2text()

	spawn(rand(800,2000))
		//The ling will now be able to choose when to revive
		src.verbs += /mob/proc/changeling_revive
		src << "<span class='notice'>We are ready to rise.  Use the Revive verb when you are ready.</span>"
		/*
		// charge the changeling chemical cost for stasis
		changeling.chem_charges -= 20

		// restore us to health
		C.revive()

		// remove our fake death flag
		C.status_flags &= ~(FAKEDEATH)

		// let us move again
		C.update_canmove()

		// re-add out changeling powers
		C.make_changeling()

		// sending display messages
		C << "<span class='notice'>We have regenerated.</span>"
		*/

	feedback_add_details("changeling_powers","FD")
	return 1