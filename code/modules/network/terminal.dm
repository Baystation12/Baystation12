/*
Terminals are stationary or mobile access points for the station network. They can run
programs or save data to/from disks, but any area with a functioning APC will offer wifi
connection to the station network, from which a user can log in and access account-specific
programs.

Terminals contain a disk drive. A disk rive contains a nested structure of 'directory'
datums which can contain data or directories.

All terminals have:
netstat    - List local connections and other connections on the network.
connect    - Connect to a specified network address.
disconnect - Disconnect from currently connected network.
login      - Change current access profile.
ls         - List files and directories.
cd         - Change into a directory.
rm         - Remove a file or directory.
mkdir      - Create a new directory.
write      - Create a new text file.
cat        - Read a text file.
run        - Attempt to execute a program.
*/


/obj/machinery/terminal
	name = "computer terminal"
	desc = "A state of the art network terminal."
	icon = 'icons/obj/computer.dmi'
	icon_state = "comm_monitor0"

	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300

	// Network helpers.
	var/domain = "TERMINAL1" //todo, proper networking
	var/datum/network_account/logged_in
	var/list/open_ports = list()

	// File system helpers.
	var/datum/computer_file/directory/auth_dir
	var/datum/computer_file/directory/current_dir
	var/datum/computer_file/directory/program_dir
	var/datum/computer_file/directory/root

	// Internal data helpers.
	var/list/buffer = list()
	var/list/executing_programs = list()
	var/system_state = 0 // 1 is on

	// Component helpers
	var/obj/item/weapon/stock_parts/hdd/hard_drive
	var/obj/item/weapon/stock_parts/cpu/processor
	var/obj/item/weapon/stock_parts/ram/memory
	var/obj/item/weapon/stock_parts/nic/network
	var/obj/item/weapon/stock_parts/mobo/motherboard


/obj/machinery/terminal/New()
	..()

	// Create components.
	component_parts += new /obj/item/weapon/stock_parts/hdd(src)
	component_parts += new /obj/item/weapon/stock_parts/cpu(src)
	component_parts += new /obj/item/weapon/stock_parts/ram(src)
	component_parts += new /obj/item/weapon/stock_parts/nic(src)
	component_parts += new /obj/item/weapon/stock_parts/mobo(src)

	// Temp for testing
	logged_in = new("guest","password")

	// Create the basic directory structure, start with root.
	root = new(src,"root")
	current_dir = root
	auth_dir = new(src,"auth",root)
	program_dir = new (src,"bin",root)
	root.add_file(auth_dir)
	root.add_file(program_dir)

	// Create default authentication scheme.
	var/datum/computer_file/permission_file = new(src,"permissions.conf",auth_dir)
	permission_file.file_contents = "This is where access levels will be defined when I work out how to handle it."
	auth_dir.add_file(permission_file)

	// Create basic programs.
	var/list/utilities = list(
		/datum/computer_file/program/clear,
		/datum/computer_file/program/netstat,
		/datum/computer_file/program/connect,
		/datum/computer_file/program/disconnect,
		/datum/computer_file/program/logout,
		/datum/computer_file/program/login,
		/datum/computer_file/program/ls,
		/datum/computer_file/program/cd,
		/datum/computer_file/program/rm,
		/datum/computer_file/program/mkdir,
		/datum/computer_file/program/write,
		/datum/computer_file/program/cat,
		/datum/computer_file/program/run,
		/datum/computer_file/program/cp,
		/datum/computer_file/program/shutdown,
		/datum/computer_file/program/procs,
		/datum/computer_file/program/kill
		)

	for(var/path in utilities)
		var/datum/computer_file/program/new_command = new path(src,null,program_dir)
		program_dir.add_file(new_command)

/obj/machinery/terminal/RefreshParts()
	hard_drive = locate() in contents
	processor = locate() in contents
	memory = locate() in contents
	network = locate() in contents
	motherboard = locate() in contents
	..()

/obj/machinery/terminal/dismantle()
	terminal_shutdown()
	..()