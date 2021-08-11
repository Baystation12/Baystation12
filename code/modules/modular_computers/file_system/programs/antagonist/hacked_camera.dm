/datum/computer_file/program/camera_monitor/hacked
	filename = "camcrypt"
	filedesc = "Camera Decryption Tool"
	nanomodule_path = /datum/nano_module/camera_monitor/hacked
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "zoomin"
	extended_desc = "This very advanced piece of software uses adaptive programming and large database of cipherkeys to bypass most encryptions used on camera networks. Be warned that system administrator may notice this."
	size = 73 // Very large, a price for bypassing ID checks completely.
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE

/datum/computer_file/program/camera_monitor/hacked/process_tick()
	..()
	if(program_state != PROGRAM_STATE_ACTIVE) // Background programs won't trigger alarms.
		return

	var/datum/nano_module/camera_monitor/hacked/HNM = NM

	// The program is active and connected to one of the station's networks. Has a very small chance to trigger IDS alarm every tick.
	if(HNM && HNM.current_network && (HNM.current_network in GLOB.using_map.station_networks) && prob((SKILL_MAX - operator_skill) * 0.05))
		ntnet_global.add_log_with_ids_check("Unauthorised access detected to camera network [HNM.current_network].", computer.get_component(PART_NETWORK))

/datum/computer_file/program/camera_monitor/hacked/ui_interact(mob/user)
	operator_skill = user.get_skill_value(SKILL_COMPUTER)
	. = ..() // Actual work done by nanomodule's parent.

/datum/nano_module/camera_monitor/hacked
	name = "Hacked Camera Monitoring Program"
	available_to_ai = FALSE

/datum/nano_module/camera_monitor/hacked/can_access_network(mob/user, network_access)
	return TRUE

// The hacked variant has access to all commonly used networks.
/datum/nano_module/camera_monitor/hacked/modify_networks_list(var/list/networks)
	networks.Add(list(list("tag" = NETWORK_MERCENARY, "has_access" = 1)))
	networks.Add(list(list("tag" = NETWORK_ERT, "has_access" = 1)))
	networks.Add(list(list("tag" = NETWORK_CRESCENT, "has_access" = 1)))
	return networks