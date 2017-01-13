/obj/machinery/modular_computer/console/preset/
	// Can be changed to give devices specific hardware
	var/_has_id_slot = 0
	var/_has_printer = 0
	var/_has_battery = 0
	var/_has_aislot = 0

/obj/machinery/modular_computer/console/preset/New()
	. = ..()
	if(!cpu)
		return
	cpu.processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(cpu)
	if(_has_id_slot)
		cpu.card_slot = new/obj/item/weapon/computer_hardware/card_slot(cpu)
	if(_has_printer)
		cpu.nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(cpu)
	if(_has_battery)
		cpu.battery_module = new/obj/item/weapon/computer_hardware/battery_module/super(cpu)
	if(_has_aislot)
		cpu.ai_slot = new/obj/item/weapon/computer_hardware/ai_slot(cpu)
	install_programs()

/obj/machinery/modular_computer/console/preset/proc/install_programs()
	return

// ===== ENGINEERING CONSOLE =====
/obj/machinery/modular_computer/console/preset/engineering
	console_department = "Engineering"
	desc = "A stationary computer. This one comes preloaded with engineering programs."

/obj/machinery/modular_computer/console/preset/engineering/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/power_monitor())
	cpu.hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	cpu.hard_drive.store_file(new/datum/computer_file/program/atmos_control())
	cpu.hard_drive.store_file(new/datum/computer_file/program/rcon_console())
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor())


// ===== MEDICAL CONSOLE =====
/obj/machinery/modular_computer/console/preset/medical
	console_department = "Medical"
	desc = "A stationary computer. This one comes preloaded with medical programs."

/obj/machinery/modular_computer/console/preset/medical/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/suit_sensors())
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	cpu.hard_drive.store_file(new/datum/computer_file/data/autorun("sensormonitor"))

// ===== RESEARCH CONSOLE =====
/obj/machinery/modular_computer/console/preset/research
	console_department = "Research"
	desc = "A stationary computer. This one comes preloaded with research programs."
	_has_aislot = 1

/obj/machinery/modular_computer/console/preset/research/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/ntnetmonitor())
	cpu.hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	cpu.hard_drive.store_file(new/datum/computer_file/program/chatclient())
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	cpu.hard_drive.store_file(new/datum/computer_file/program/aidiag())


// ===== COMMAND CONSOLE =====
/obj/machinery/modular_computer/console/preset/command
	console_department = "Command"
	desc = "A stationary computer. This one comes preloaded with command programs."
	_has_id_slot = 1
	_has_printer = 1

/obj/machinery/modular_computer/console/preset/command/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/chatclient())
	cpu.hard_drive.store_file(new/datum/computer_file/program/card_mod())
	cpu.hard_drive.store_file(new/datum/computer_file/program/comm())
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor())

/obj/machinery/modular_computer/console/preset/command/main
	console_department = "Command"
	desc = "A stationary computer. This one comes preloaded with essential command programs."

// ===== SECURITY CONSOLE =====
/obj/machinery/modular_computer/console/preset/security
	console_department = "Security"
	desc = "A stationary computer. This one comes preloaded with security programs."

/obj/machinery/modular_computer/console/preset/security/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	cpu.hard_drive.store_file(new/datum/computer_file/data/autorun("cammon"))


// ===== CIVILIAN CONSOLE =====
/obj/machinery/modular_computer/console/preset/civilian
	console_department = "Civilian"
	desc = "A stationary computer. This one comes preloaded with generic programs."

/obj/machinery/modular_computer/console/preset/civilian/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/chatclient())
	cpu.hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	cpu.hard_drive.store_file(new/datum/computer_file/program/newsbrowser())
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor()) // Mainly for the entertainment channel, won't allow connection to other channels without access anyway

// ===== ERT CONSOLE =====
/obj/machinery/modular_computer/console/preset/ert
	console_department = "Crescent"
	desc = "A stationary computer. This one comes preloaded with various programs used by Nanotrasen response teams."
	_has_printer = 1
	_has_id_slot = 1
	_has_aislot = 1

/obj/machinery/modular_computer/console/preset/ert/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor/ert())
	cpu.hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	cpu.hard_drive.store_file(new/datum/computer_file/program/comm())
	cpu.hard_drive.store_file(new/datum/computer_file/program/aidiag())

// ===== MERCENARY CONSOLE =====
/obj/machinery/modular_computer/console/preset/mercenary
	console_department = "Unset"
	desc = "A stationary computer. This one comes preloaded with various programs used by shady organizations."
	_has_printer = 1
	_has_id_slot = 1
	_has_aislot = 1
	emagged = 1		// Allows download of other antag programs for free.

/obj/machinery/modular_computer/console/preset/mercenary/install_programs()
	cpu.hard_drive.store_file(new/datum/computer_file/program/camera_monitor/hacked())
	cpu.hard_drive.store_file(new/datum/computer_file/program/alarm_monitor())
	cpu.hard_drive.store_file(new/datum/computer_file/program/aidiag())
