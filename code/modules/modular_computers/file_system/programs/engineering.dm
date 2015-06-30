/datum/computer_file/program/power_monitor
	filename = "powermonitor"
	filedesc = "Power Monitoring"
	nanomodule_path = /datum/nano_module/power_monitor/
	laptop_icon_state = "power_monitor"
	requires_ntnet = 1

/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitor"
	filedesc = "Alarm Monitoring"
	nanomodule_path = /datum/nano_module/alarm_monitor/engineering
	laptop_icon_state = "alarm_monitor"
	requires_ntnet = 1

/datum/computer_file/program/atmos_control
	filename = "atmoscontrol"
	filedesc = "Atmosphere Control"
	nanomodule_path = /datum/nano_module/atmos_control
	laptop_icon_state = "atmos_control"
	required_access = access_atmospherics
	requires_ntnet = 1
	requires_ntnet_feature = NTNET_SYSTEMCONTROL

/datum/computer_file/program/rcon_console
	filename = "rconconsole"
	filedesc = "RCON Remote Control"
	nanomodule_path = /datum/nano_module/rcon
	laptop_icon_state = "rcon_console"
	required_access = access_engine
	requires_ntnet = 1
	requires_ntnet_feature = NTNET_SYSTEMCONTROL

/datum/computer_file/program/suit_sensors
	filename = "sensormonitor"
	filedesc = "Suit Sensors Monitoring"
	nanomodule_path = /datum/nano_module/crew_monitor
	laptop_icon_state = "suit_sensors"
	requires_ntnet = 1