/datum/power/changeling/fleshmend
	name = "Fleshmend"
	desc = "Begins a slow regeneration of our form.  Does not effect stuns or chemicals."
	helptext = "Can be used while unconscious."
	enhancedtext = "Healing is twice as effective."
	ability_icon_state = "ling_fleshmend"
	genomecost = 1
	verbpath = /mob/proc/changeling_fleshmend
/mob/proc/end_fleshmend()
	to_chat(src, "<span class='notice'>Our regeneration has slowed to normal levels.</span>")
	src.verbs += /mob/proc/changeling_fleshmend
	var/datum/changeling/changeling = src.mind.changeling
	changeling.already_regenerating = FALSE
//Starts healing you every second for 50 seconds. Can be used whilst unconscious.
/mob/proc/changeling_fleshmend()
	set category = "Changeling"
	set name = "Fleshmend (10)"
	set desc = "Begins a slow rengeration of our form.  Does not effect stuns or chemicals."
	set waitfor = FALSE
	var/datum/changeling/changeling = changeling_power(10,0,100,UNCONSCIOUS)
	if(!changeling)
		return
	var/mob/living/carbon/human/C = src
	if(C.on_fire)
		to_chat(src,SPAN_DANGER("We cannot regenerate while engulfed in flames!"))
		return
	if(changeling.already_regenerating)
		to_chat(src,SPAN_DANGER("We are already regenerating our flesh."))
		return
	src.mind.changeling.chem_charges -= 10
	var/heal_amount = 2
	if(src.mind.changeling.recursive_enhancement)
		src.mind.changeling.recursive_enhancement = FALSE
		heal_amount = heal_amount * 2
		to_chat(src, "<span class='notice'>We will heal much faster.</span>")

	to_chat(src, "<span class='notice'>We begin to heal ourselves.</span>")
	changeling.already_regenerating = TRUE
	for(var/i = 0, i<50,i++)
		if(C && !C.on_fire)
			C.adjustBruteLoss(-heal_amount)
			C.adjustOxyLoss(-heal_amount)
			C.adjustFireLoss(-heal_amount)
			C.regenerate_icons()
			sleep(1 SECOND)

	src.verbs -= /mob/proc/changeling_fleshmend
	addtimer(new Callback(src,/mob/.proc/end_fleshmend), 50 SECONDS)
