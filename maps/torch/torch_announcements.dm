/datum/map/torch
	emergency_shuttle_docked_message = "Attention all hands: the escape pods are now unlocked. You have %ETD% to board the escape pods."
	emergency_shuttle_leaving_dock = "Attention all hands: the escape pods have been launched, arriving at rendezvous point in %ETA%."

	emergency_shuttle_called_message = "Attention all hands: emergency evacuation procedures are now in effect. Escape pods will unlock in %ETA%"
	emergency_shuttle_called_sound = 'sound/AI/torch/abandonship.ogg'

	emergency_shuttle_recall_message = "Attention all hands: emergency evacuation sequence aborted. Return to normal operating conditions."

	command_report_sound = 'sound/AI/torch/commandreport.ogg'

	grid_check_message = "Abnormal activity detected in the %STATION_NAME%'s power network. As a precaution, the %STATION_NAME%'s power must be shut down for an indefinite duration."
	grid_check_sound = 'sound/AI/torch/poweroff.ogg'

	grid_restored_message = "Ship power to the %STATION_NAME% will be restored at this time"
	grid_restored_sound = 'sound/AI/torch/poweron.ogg'

	meteor_detected_sound = 'sound/AI/torch/meteors.ogg'

	radiation_detected_message = "High levels of radiation detected in proximity of the %STATION_NAME%. Please report to the infirmary if symptoms occur."
	radiation_detected_sound = 'sound/AI/torch/radiation2.ogg'

	space_time_anomaly_sound = 'sound/AI/torch/spanomalies.ogg'

	unknown_biological_entities_message = "Unknown biological entities have been detected near the %STATION_NAME%, please stand-by."

	unidentified_lifesigns_message = "Unidentified lifesigns detected. Please lock down all exterior access points."
	unidentified_lifesigns_sound = 'sound/AI/torch/aliens.ogg'

	xenomorph_spawn_sound = 'sound/AI/torch/aliens.ogg'

/datum/map/torch/level_x_biohazard_sound(var/bio_level)
	switch(bio_level)
		if(7)
			return 'sound/AI/torch/outbreak7.ogg'
		else
			return 'sound/AI/torch/outbreak5.ogg'
