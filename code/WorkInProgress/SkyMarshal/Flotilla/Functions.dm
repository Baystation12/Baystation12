//Some nice lists of discriptions, to be picked randomly.
var/list/solar_descriptions = ("A small orange-yellow star, cooler than Sol.  It looks... wrong.")
var/list/planetary_descriptions = ("A rocky body, totally uninteresting.")
var/list/gas_giant_descriptions = ("A ball of gas and beauty, it looks like a marble in the sky.")


#ifdef PHYSICS_DEBUG
  ///////////////////
 //Debugging tools//
///////////////////
mob/verb/GetPhysicsReference()
	set src = usr
	for(var/frame/frame in physics_sim.all_frames)
		world << "[frame.name] Velocity: [Dist(frame.delta_x,frame.delta_y)*1e6]km/s"

mob/verb/DebugVariablesReference()
	set src = usr
	var/tag = input("GIMME DAT TAG","View Variables","\ref[physics_sim]") as text
	var/datum/D = locate(tag)
	if(D)
		usr.client.debug_variables(D)

mob/verb/TickPhysics()
	set src = usr
	if(physics_sim)
		physics_sim.Tick()

mob/verb/HaltResumePhysics()
	set src = usr
	halt_physics = !halt_physics
#endif

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //Useful functions, one for getting floating point random numbers between two values (BYOND lacks this natively) and one for getting orbital vector for a two body system//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

proc/GetRand(LB=0,UB=0)
	if(UB > LB)
		return LB + (UB-LB)*rand()
	else if (LB > UB)
		return UB + (LB-UB)*rand()
	return LB //They are equal.

proc/GetVectorToOrbit(var/frame/orbited_mass, x, y, orbital_direction = CLOCKWISE, circular = FALSE)
	var/dx = orbited_mass.x - x
	var/dy = orbited_mass.y - y
	var/distance = Dist(dx, dy)
	var/attraction = OrbitalVelocity(orbited_mass.mass, distance) // * (1 + GetRand(-ORBITAL_VECTOR_DEVATION,ORBITAL_VECTOR_DEVATION))

	if(!circular)
		attraction *= (1 + GetRand(0, ORBITAL_VECTOR_DEVATION))

	if(orbital_direction == ANTICLOCKWISE)
		attraction *= -1

	var/list/vector = list()
	vector["y"] = (attraction/distance)*dx
	vector["x"] = -(attraction/distance)*dy

	return vector


proc/GenerateStarName()
	return "Idunnolol"

var/list/alphabet = list("A","B","C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")
proc/GeneratePlanetName(var/system_name, var/planet_number, var/moon_number)
	if(!system_name)
		return "DERP"
	if(moon_number)
		if(moon_number > 26)
			var/moon_primary = round(moon_number/26, 1)
			var/moon_secondary = (moon_number%26) + 1
			return "[system_name] [planet_number][alphabet[moon_primary]][alphabet[moon_secondary]]"
		else
			return "[system_name] [planet_number][alphabet[moon_number]]"
	return "[system_name] [planet_number]"