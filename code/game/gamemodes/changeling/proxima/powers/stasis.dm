//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/mob/proc/changeling_fakedeath()
	set category = "Changeling"
	set name = "Regenerative Stasis (20)"

	var/datum/changeling/changeling = changeling_power(20,1,100,DEAD)
	if(!changeling)	return
	var/mob/living/carbon/C = src
	if(changeling.stasis_state)
		if(alert("Мы готовы к пробуждению.","Стазис","Проснуться","Ждать") == "Ждать")
			return
		if(MUTATION_HUSK in C.mutations)
			C.ghostize()
			return
		C.revive()
		// remove our fake death flag
		C.status_flags &= ~(FAKEDEATH)
		// let us move again
		C.UpdateLyingBuckledAndVerbStatus()
		// re-add out changeling powers
		C.make_changeling()
		// sending display messages
		to_chat(C, SPAN_LING("Мы восстановились."))
		changeling.chem_charges -= 20
		changeling.chem_storage -= 20
		changeling.stasis_state = 0
		return 1

	if(status_flags & FAKEDEATH)
		to_chat(src, SPAN_LING("Мы уже регенирируем."))
		return
	if(C.stat <= 1 && alert("Нам следует инсциировать собственную смерть? Мы потеряем 20 единиц от максимального количества химикатов, когда проснемся.","Стазис","Да","Нет") == "Нет")//Confirmation for living changelings if they want to fake their death
		return

	to_chat(C, SPAN_LING("Мы попытаемся восстановить нашу оболочку."))
	C.status_flags |= FAKEDEATH //play dead
	C.UpdateLyingBuckledAndVerbStatus()
	C.remove_changeling_powers()
	C.verbs += /mob/proc/changeling_fakedeath

	spawn(130 SECONDS)
		if(!(MUTATION_HUSK in C.mutations))
			// charge the changeling chemical cost for stasis
			changeling.stasis_state = 1
			to_chat(C, SPAN_LING(FONT_GIANT("Мы готовы восстать. Используйте кнопку <b>Regenerative Stasis (20)</b>, когда будет удобный момент.")))
//todo			src.ability_master.add_ling_verb(src, /mob/proc/changeling_revive, "Revive", "revive")
	return 1
/* unused
/mob/proc/changeling_revive()
	set category = "Changeling"
	set name = "Revive"

	var/mob/living/carbon/C = src
	// If we were devoured
	if(MUTATION_HUSK in C.mutations)
		C.verbs -= /mob/proc/changeling_revive
		C.ghostize()
		return
	// restore us to health
	C.revive()
	// remove our fake death flag
	C.status_flags &= ~(FAKEDEATH)
	// let us move again
	C.UpdateLyingBuckledAndVerbStatus()
	// re-add out changeling powers
	C.make_changeling()
	// sending display messages
	to_chat(C, SPAN_LING("Мы восстановились."))
	C.verbs -= /mob/proc/changeling_revive
*/
/datum/changeling/proc/regenerate()
	chem_charges = min(max(0, chem_charges+chem_recharge_rate), chem_storage)
	geneticdamage = max(0, geneticdamage-1)
