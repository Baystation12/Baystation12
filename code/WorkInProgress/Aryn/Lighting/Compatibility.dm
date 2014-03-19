area/var/lighting_use_dynamic

turf/space/is_outside = 1
turf/simulated/shuttle/is_outside = 1

/datum/controller/lighting/var/processing = 1
/datum/controller/lighting/var/iteration = 0

//Because so many objects jump the gun.
proc/lighting_ready()
	return lighting_controller && lighting_controller.started

turf_light_data
	var/light_overlay
	var/lightNW
	var/lightSW
	var/lightNE
	var/lightSE
	var/lit_by

turf_light_data/proc/copy_from(turf/T)
	light_overlay = T.light_overlay
	lightNW = T.lightNW
	lightSW = T.lightSW
	lightNE = T.lightNE
	lightSE = T.lightSE
	lit_by = T.lit_by

turf_light_data/proc/copy_to(turf/T)
	T.light_overlay = light_overlay
	T.lightNW = lightNW
	T.lightSW = lightSW
	T.lightNE = lightNE
	T.lightSE = lightSE
	T.lit_by = lit_by
	//T.ResetValue()

atom/proc/SetLuminosity(n)
	ASSERT(n >= 0)

	n = min(n,10) //Caelcode.
	if(n > 0)
		//world << "[name].SetLuminosity([n]) \[[max(1,n>>1)],[n]\]"
		SetLight(max(1,n>>1),n)
	else
		//world << "[name].SetLuminosity(0)"
		SetLight(0,0)
	luminosity = n
	//else lighting_controller.initial_lights.Add(src)