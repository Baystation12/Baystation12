/*

Overview:
	This object functions similarly to /tg/'s /light. It is responsible for calculating what turfs are lit by it.

Class Vars:
	radius - Set by atom/SetLight(). This stores how far out turfs will be lit up.
	intensity - Set by atom/SetLight(). Stores the amount of light generated at the center.
	lit_turfs - A list of turfs being lit by this light.
	atom - The atom this light is attached to.

Class Procs:
	Reset()
		This is called whenever the light changes, or the underlying atom changes position.

	Off()
		A quick way to turn off a light. Removes the light from all turfs in lit_turfs.

	CalculateBrightness(turf/T)
		Returns the brightness that should be displayed by this light on a specific turf.

*/


light/var/radius = 0
light/var/intensity = 0
light/var/list/lit_turfs
light/var/atom/atom

light/New(atom/atom)
	src.atom = atom

light/proc/Reset()
	//if(atom.lights_verbose) world << "light.Reset()"
	Off()
	if(intensity > 0)
		//if(atom.lights_verbose) world << "Restoring light."
		for(var/turf/T in view(get_turf(atom),radius+1))
			if(!T.is_outside)
				T.AddLight(src)
				lit_turfs.Add(T)
		//if(atom.lights_verbose) world << "[lit_turfs.len] turfs added."

light/proc/Off()
	//if(atom.lights_verbose) world << "light.Off()"
	for(var/turf/T in lit_turfs)
		T.RemoveLight(src)
	lit_turfs = list()

light/proc/CalculateBrightness(turf/T)
	var/square = get_square_dist(atom.x,atom.y,atom.z,T.x,T.y,T.z)
	if(square > (radius+2)*(radius+2)) return 0
		//+2 offset gives an ambient light effect.

	var/value = ((radius)/(2*fsqrt(square) + 1)) * intensity - 0.48
		/*
			  lightRadius
			---------------- * lightValue - 0.48
			2 * distance + 1

			The light decreases by twice the distance, starting from the radius.
			The + 1 causes the graph to shift to the left one unit so that division by zero is prevented on the source tile.

			This is then multiplied by the light value to give the final result.
			The -0.48 offset causes the value to be near zero at the radius.

			This gives a result which is likely close to the inverse-square law in two dimensions instead of three.
		*/


	return max(min( value , intensity), 0) //Ensure the value never goes above the maximum light value or below zero.

		//return cos(90 * sqrt(square) / max(1,lightRadius)) * lightValue