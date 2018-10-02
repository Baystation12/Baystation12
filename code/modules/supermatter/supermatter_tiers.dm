/*
	Critical failure:

*/

GLOBAL_LIST_INIT(supermatter_tiers, list(
	new /datum/sm_control/level_1,
	new /datum/sm_control/level_2,
	new /datum/sm_control/level_3,
	new /datum/sm_control/level_4,
	new /datum/sm_control/level_5,
	new /datum/sm_control/level_6,
	new /datum/sm_control/level_7))

/datum/sm_control
	var/nitrogen_retardation_factor = 0		//Higher == N2 slows reaction more
	var/thermal_release_modifier = 0		//Higher == more heat released during reaction
	var/phoron_release_modifier = 0			//Higher == less phoron released by reaction
	var/oxygen_release_modifier = 0			//Higher == less oxygen released at high temperature/power
	var/radiation_release_modifier = 0    	//Higher == more radiation released with more power.
	var/reaction_power_modifier =  0		//Higher == more overall power

	var/power_factor = 1.0					//Controls how much power is produced by each collector in range - this is the main parameter for tweaking SM balance, as it basically controls how the power variable relates to the rest of the game.
	var/decay_factor = 700					//Affects how fast the supermatter power decays
	var/critical_temperature = 5000			//K
	var/charging_factor = 0.05

	var/explosion_power = 9					//The size of the explosion
	var/delamination_size = 9 				//The size of the vorbis wave burst

	var/vacuum_damage = 0 					//The amount of damage done when the SM is sitting in a vacuum
	var/consumption_rate = 10 				//The amount of gas taken from the environment per tick

	var/psionic_power = 10 					//The amount of hallucination that will be added if someone looks at it

	var/pull_time = 300 					//the amount of time in seconds that the supermatter will pull in before exploding
	var/pull_range = 15 					//The distance that objects will be pulled from

	var/color = COLOR_SM_DEFAULT			//The color of the supermatter

/datum/sm_control/level_1
	reaction_power_modifier = 1.0
	radiation_release_modifier = 1.5

	oxygen_release_modifier = 15000
	nitrogen_retardation_factor = 0.15
	phoron_release_modifier = 1500
	thermal_release_modifier = 10000

/datum/sm_control/level_2
	reaction_power_modifier = 1.6
	radiation_release_modifier = 1.8
	decay_factor = 770
	charging_factor = 0.1

	oxygen_release_modifier = 16000
	nitrogen_retardation_factor = 0.15
	phoron_release_modifier = 1600
	thermal_release_modifier = 15000

	delamination_size = 14
	psionic_power = 15

	critical_temperature = 5150

	pull_time = 300
	pull_range = 18

	color = COLOR_SM_TWO

/datum/sm_control/level_3
	reaction_power_modifier = 2.8
	radiation_release_modifier = 2.8
	decay_factor = 1125
	charging_factor = 0.15

	oxygen_release_modifier = 17000
	nitrogen_retardation_factor = 0.12
	phoron_release_modifier = 1600
	thermal_release_modifier = 20000

	delamination_size = 19
	psionic_power = 20

	critical_temperature = 5100

	pull_time = 325
	pull_range = 21

	color = COLOR_SM_THREE

/datum/sm_control/level_4
	reaction_power_modifier = 4.4
	radiation_release_modifier = 5
	decay_factor = 1540
	charging_factor = 0.2

	oxygen_release_modifier = 18000
	nitrogen_retardation_factor = 0.12
	phoron_release_modifier = 1800
	thermal_release_modifier = 25000

	delamination_size = 24
	psionic_power = 25

	critical_temperature = 5200

	pull_time = 350
	pull_range = 22

	color = COLOR_SM_FOUR

/datum/sm_control/level_5
	reaction_power_modifier = 6.2
	radiation_release_modifier = 8.1
	decay_factor = 1890
	charging_factor = 0.25

	oxygen_release_modifier = 19000
	nitrogen_retardation_factor = 0.10
	phoron_release_modifier = 1900
	thermal_release_modifier = 30000

	explosion_power = 16
	delamination_size = 29
	psionic_power = 30

	critical_temperature = 5550

	pull_time = 375
	pull_range = 25

	color = COLOR_SM_FIVE

/datum/sm_control/level_6
	reaction_power_modifier = 8.0
	radiation_release_modifier = 9.0
	decay_factor = 2520
	charging_factor = 0.3

	oxygen_release_modifier = 20000
	nitrogen_retardation_factor = 0.8
	phoron_release_modifier = 2300
	thermal_release_modifier = 40000

	explosion_power = 32
	delamination_size = 55
	psionic_power = 40

	critical_temperature = 6275

	pull_time = 400
	pull_range = 35

	color = COLOR_SM_SIX

/datum/sm_control/level_7
	reaction_power_modifier = 10.0
	radiation_release_modifier = 10.0
	decay_factor = 4000
	charging_factor = 0.5

	oxygen_release_modifier = 30000
	nitrogen_retardation_factor = 0.05
	phoron_release_modifier = 2500
	thermal_release_modifier = 55000

	explosion_power = 60
	delamination_size = 85
	psionic_power = 55

	critical_temperature = 7300

	pull_time = 450
	pull_range = 66

	color = COLOR_SM_SEVEN