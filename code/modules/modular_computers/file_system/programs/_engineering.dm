// These programs are associated with engineering.

/datum/computer_file/program/power_monitor
	filename = "powermonitor"
	filedesc = "Power Monitoring"
	nanomodule_path = /datum/nano_module/power_monitor/
	program_icon_state = "power_monitor"
	extended_desc = "This program connects to sensors around the station to provide information about electrical systems"
	required_access = access_engine
	requires_ntnet = 1
	network_destination = "power monitoring system"
	size = 9

/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitor"
	filedesc = "Alarm Monitoring"
	nanomodule_path = /datum/nano_module/alarm_monitor/engineering
	program_icon_state = "alarm_monitor"
	extended_desc = "This program provides visual interface for station's alarm system."
	requires_ntnet = 1
	network_destination = "alarm monitoring network"
	size = 5

/datum/computer_file/program/atmos_control
	filename = "atmoscontrol"
	filedesc = "Atmosphere Control"
	nanomodule_path = /datum/nano_module/atmos_control
	program_icon_state = "atmos_control"
	extended_desc = "This program allows remote control of air alarms around the station"
	required_access = access_atmospherics
	requires_ntnet = 1
	network_destination = "atmospheric control system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_LAPTOP | PROGRAM_CONSOLE
	size = 17

/datum/computer_file/program/rcon_console
	filename = "rconconsole"
	filedesc = "RCON Remote Control"
	nanomodule_path = /datum/nano_module/rcon
	program_icon_state = "generic"
	extended_desc = "This program allows remote control of power distribution systems around the station."
	required_access = access_engine
	requires_ntnet = 1
	network_destination = "RCON remote control system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_LAPTOP | PROGRAM_CONSOLE
	size = 19