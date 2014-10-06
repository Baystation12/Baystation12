/mob/living/silicon/robot/verb/light()
	set name = "Light On/Off"
	set desc = "Activate your inbuilt light. Toggled on or off."
	set category = "Robot Commands"

	if(luminosity)
		SetLuminosity(0)
		return
	SetLuminosity(integrated_light_power)