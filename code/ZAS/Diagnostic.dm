client/proc/ZoneTick()
	set category = "Debug"
	set name = "Process Atmos"

	var/result = air_master.Tick()
	if(result)
		src << "Sucessfully Processed."

	else
		src << "Failed to process! ([air_master.tick_progress])"


client/proc/Zone_Info(turf/T as null|turf)
	set category = "Debug"
	if(T)
		if(istype(T,/turf/simulated) && T:zone)
			T:zone:dbg_data(src)
		else
			mob << "No zone here."
			var/datum/gas_mixture/mix = T.return_air()
			mob << "[mix.return_pressure()] kPa [mix.temperature]C"
			for(var/g in mix.gas)
				mob << "[g]: [mix.gas[g]]\n"
	else
		if(zone_debug_images)
			for(var/zone in  zone_debug_images)
				images -= zone_debug_images[zone]
			zone_debug_images = null

client/var/list/zone_debug_images

client/proc/Test_ZAS_Connection(var/turf/simulated/T as turf)
	set category = "Debug"
	if(!istype(T))
		return

	var/direction_list = list(\
	"North" = NORTH,\
	"South" = SOUTH,\
	"East" = EAST,\
	"West" = WEST,\
	"N/A" = null)
	var/direction = input("What direction do you wish to test?","Set direction") as null|anything in direction_list
	if(!direction)
		return

	if(direction == "N/A")
		if(!(T.c_airblock(T) & AIR_BLOCKED))
			mob << "The turf can pass air! :D"
		else
			mob << "No air passage :x"
		return

	var/turf/simulated/other_turf = get_step(T, direction_list[direction])
	if(!istype(other_turf))
		return

	var/t_block = T.c_airblock(other_turf)
	var/o_block = other_turf.c_airblock(T)

	if(o_block & AIR_BLOCKED)
		if(t_block & AIR_BLOCKED)
			mob << "Neither turf can connect. :("

		else
			mob << "The initial turf only can connect. :\\"
	else
		if(t_block & AIR_BLOCKED)
			mob << "The other turf can connect, but not the initial turf. :/"

		else
			mob << "Both turfs can connect! :)"

	mob << "Additionally, \..."

	if(o_block & ZONE_BLOCKED)
		if(t_block & ZONE_BLOCKED)
			mob << "neither turf can merge."
		else
			mob << "the other turf cannot merge."
	else
		if(t_block & ZONE_BLOCKED)
			mob << "the initial turf cannot merge."
		else
			mob << "both turfs can merge."

client/proc/ZASSettings()
	set category = "Debug"

	vsc.SetDefault(mob)
