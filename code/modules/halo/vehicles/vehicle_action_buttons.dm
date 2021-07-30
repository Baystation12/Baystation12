
#define ACTION_USE_BRAKE "Toggle Brake"
#define ACTION_USE_LANDTAKEOFF "Land/Takeoff"
#define ACTION_FLY_WAYPOINT "Fly To Waypoint"
#define ACTION_DETACH_VEHICLE "Detach Vehicle"
#define ACTION_USE_SMOKE "Activate Smoke Countermeasures"

/datum/action/vehicle_action
	action_type = AB_GENERIC
	check_flags = AB_CHECK_ALIVE
	button_icon = 'code/modules/halo/vehicles/vehicleactionicons.dmi'

/datum/action/vehicle_action/CheckRemoval(mob/living/user)
	return !(user in target)

/datum/action/vehicle_action/vehicle_brake
	name = ACTION_USE_BRAKE
	procname = "toggle_brakes"
	button_icon_state = "brake"

/datum/action/vehicle_action/vehicle_land_takeoff
	name = ACTION_USE_LANDTAKEOFF
	procname = "takeoff_land"
	button_icon_state = "takeoff_land"

/datum/action/vehicle_action/vehicle_fly_waypoint
	name = ACTION_FLY_WAYPOINT
	procname = "fly_to_waypoint"
	button_icon_state = "flytowaypoint"

/datum/action/vehicle_action/vehicle_detach_carried
	name = ACTION_DETACH_VEHICLE
	procname = "detach_vehicle"
	button_icon_state = "detachvehicle"

/datum/action/vehicle_action/vehicle_smoke_deploy
	name = ACTION_USE_SMOKE
	procname = "deploy_smoke"
	button_icon_state = "deploysmoke"

/obj/vehicles/proc/init_vehicle_actions()
	driver_actions = list(new /datum/action/vehicle_action/vehicle_brake(src))
	if(vehicle_carry_size > 0)
		driver_actions += new /datum/action/vehicle_action/vehicle_detach_carried (src)
	if(can_smoke)
		driver_actions += new /datum/action/vehicle_action/vehicle_smoke_deploy (src)

/obj/vehicles/air/init_vehicle_actions()
	. = ..()
	driver_actions += new /datum/action/vehicle_action/vehicle_land_takeoff (src)
	driver_actions += new /datum/action/vehicle_action/vehicle_fly_waypoint (src)

/obj/vehicles/proc/add_remove_vehicle_actions(var/mob/m,var/remove = 0)
	for(var/datum/action/a in driver_actions)
		if(remove)
			a.Remove(m)
		else
			a.Grant(m)

#undef ACTION_USE_BRAKE
#undef ACTION_USE_LANDTAKEOFF
#undef ACTION_FLY_WAYPOINT
#undef ACTION_DETACH_VEHICLE
#undef ACTION_USE_SMOKE
