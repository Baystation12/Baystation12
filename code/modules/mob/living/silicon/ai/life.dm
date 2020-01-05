/mob/living/silicon/ai/Life()
	if (src.stat == DEAD)
		return

	if (src.stat!=CONSCIOUS)
		src.cameraFollow = null
		src.reset_view(null)

	src.updatehealth()

	handle_stunned()	// Handle EMP-stun
	lying = 0			// Handle lying down

	update_sight()

	process_queued_alarms()
	handle_regular_hud_updates()
	switch(src.sensor_mode)
		if (SEC_HUD)
			process_sec_hud(src,0,src.eyeobj)
		if (MED_HUD)
			process_med_hud(src,0,src.eyeobj)
	if(stunned == 0)
		spend_cpu(-1)
	for(var/i in active_cyberwarfare_effects)
		var/datum/cyberwarfare_command/c = i
		c.command_process()

/mob/living/silicon/ai/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
		setOxyLoss(0)
	else
		health = 100 - getFireLoss() - getBruteLoss() // Oxyloss is not part of health as it represents AIs backup power. AI is immune against ToxLoss as it is machine.

/mob/living/silicon/ai/rejuvenate()
	..()
	add_ai_verbs(src)
