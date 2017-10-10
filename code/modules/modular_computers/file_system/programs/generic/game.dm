// This file is used as a reference for Modular Computers Development guide on the wiki. It contains a lot of excess comments, as it is intended as explanation
// for someone who may not be as experienced in coding. When making changes, please try to keep it this way.

// An actual program definition.
/datum/computer_file/program/game
	filename = "arcadec"					// File name, as shown in the file browser program.
	filedesc = "Unknown Game"				// User-Friendly name. In this case, we will generate a random name in constructor.
	program_icon_state = "game"				// Icon state of this program's screen.
	program_menu_icon = "script"
	extended_desc = "Fun for the whole family! Probably not an AAA title, but at least you can download it on the corporate network.."		// A nice description.
	size = 5								// Size in GQ. Integers only. Smaller sizes should be used for utility/low use programs (like this one), while large sizes are for important programs.
	requires_ntnet = 0						// This particular program does not require NTNet network conectivity...
	available_on_ntnet = 1					// ... but we want it to be available for download.
	nanomodule_path = /datum/nano_module/arcade_classic/	// Path of relevant nano module. The nano module is defined further in the file.
	var/picked_enemy_name

// Blatantly stolen and shortened version from arcade machines. Generates a random enemy name
/datum/computer_file/program/game/proc/random_enemy_name()
	var/name_part1 = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Cuban ", "the Evil ", "the Dread King ", "the Space ", "Lord ", "the Great ", "Duke ", "General ")
	var/name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Uhangoid", "Vhakoid", "Peteoid", "Slime", "Lizard Man", "Unicorn")
	return "[name_part1] [name_part2]"

// When the program is first created, we generate a new enemy name and name ourselves accordingly.
/datum/computer_file/program/game/New()
	..()
	picked_enemy_name = random_enemy_name()
	filedesc = "Defeat [picked_enemy_name]"

// Important in order to ensure that copied versions will have the same enemy name.
/datum/computer_file/program/game/clone()
	var/datum/computer_file/program/game/G = ..()
	G.picked_enemy_name = picked_enemy_name
	return G

// When running the program, we also want to pass our enemy name to the nano module.
/datum/computer_file/program/game/run_program()
	. = ..()
	if(. && NM)
		var/datum/nano_module/arcade_classic/NMC = NM
		NMC.enemy_name = picked_enemy_name


// Nano module the program uses.
// This can be either /datum/nano_module/ or /datum/nano_module/program. The latter is intended for nano modules that are suposed to be exclusively used with modular computers,
// and should generally not be used, as such nano modules are hard to use on other places.
/datum/nano_module/arcade_classic/
	name = "Classic Arcade"
	var/player_mana			// Various variables specific to the nano module. In this case, the nano module is a simple arcade game, so the variables store health and other stats.
	var/player_health
	var/enemy_mana
	var/enemy_health
	var/enemy_name = "Greytide Horde"
	var/gameover
	var/information

/datum/nano_module/arcade_classic/New()
	..()
	new_game()

// ui_interact handles transfer of data to NanoUI. Keep in mind that data you pass from here is actually sent to the client. In other words, don't send anything you don't want a client
// to see, and don't send unnecessarily large amounts of data (due to laginess).
/datum/nano_module/arcade_classic/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data["player_health"] = player_health
	data["player_mana"] = player_mana
	data["enemy_health"] = enemy_health
	data["enemy_mana"] = enemy_mana
	data["enemy_name"] = enemy_name
	data["gameover"] = gameover
	data["information"] = information

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "arcade_classic.tmpl", "Defeat [enemy_name]", 500, 350, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

// Three helper procs i've created. These are unique to this particular nano module. If you are creating your own nano module, you'll most likely create similar procs too.
/datum/nano_module/arcade_classic/proc/enemy_play()
	if((enemy_mana < 5) && prob(60))
		var/steal = rand(2, 3)
		player_mana -= steal
		enemy_mana += steal
		information += "[enemy_name] steals [steal] of your power!"
	else if((enemy_health < 15) && (enemy_mana > 3) && prob(80))
		var/healamt = min(rand(3, 5), enemy_mana)
		enemy_mana -= healamt
		enemy_health += healamt
		information += "[enemy_name] heals for [healamt] health!"
	else
		var/dam = rand(3,6)
		player_health -= dam
		information += "[enemy_name] attacks for [dam] damage!"

/datum/nano_module/arcade_classic/proc/check_gameover()
	if((player_health <= 0) || player_mana <= 0)
		if(enemy_health <= 0)
			information += "You have defeated [enemy_name], but you have died in the fight!"
		else
			information += "You have been defeated by [enemy_name]!"
		gameover = 1
		return TRUE
	else if(enemy_health <= 0)
		gameover = 1
		information += "Congratulations! You have defeated [enemy_name]!"
		return TRUE
	return FALSE

/datum/nano_module/arcade_classic/proc/new_game()
	player_mana = 10
	player_health = 30
	enemy_mana = 20
	enemy_health = 45
	gameover = FALSE
	information = "A new game has started!"



/datum/nano_module/arcade_classic/Topic(href, href_list)
	if(..())		// Always begin your Topic() calls with a parent call!
		return 1
	if(href_list["new_game"])
		new_game()
		return 1	// Returning 1 (TRUE) in Topic automatically handles UI updates.
	if(gameover)	// If the game has already ended, we don't want the following three topic calls to be processed at all.
		return 1	// Instead of adding checks into each of those three, we can easily add this one check here to reduce on code copy-paste.
	if(href_list["attack"])
		var/damage = rand(2, 6)
		information = "You attack for [damage] damage."
		enemy_health -= damage
		enemy_play()
		check_gameover()
		return 1
	if(href_list["heal"])
		var/healfor = rand(6, 8)
		var/cost = rand(1, 3)
		information = "You heal yourself for [healfor] damage, using [cost] energy in the process."
		player_health += healfor
		player_mana -= cost
		enemy_play()
		check_gameover()
		return 1
	if(href_list["regain_mana"])
		var/regen = rand(4, 7)
		information = "You rest of a while, regaining [regen] energy."
		player_mana += regen
		enemy_play()
		check_gameover()
		return 1