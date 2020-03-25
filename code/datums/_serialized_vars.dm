/proc/initialize_saved_vars()
	. = list()

	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/computer_file/data
	//
	LAZYADD(.[/datum/computer_file/data], "stored_data")
	LAZYADD(.[/datum/computer_file/data], "size")
	LAZYADD(.[/datum/computer_file/data], "block_size")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/computer_file/program
	//
	LAZYADD(.[/datum/computer_file/program], "program_state")
	LAZYADD(.[/datum/computer_file/program], "computer")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/dna
	//
	LAZYADD(.[/datum/dna], "uni_identity")
	LAZYADD(.[/datum/dna], "struc_enzymes")
	LAZYADD(.[/datum/dna], "unique_enzymes")
	LAZYADD(.[/datum/dna], "UI")
	LAZYADD(.[/datum/dna], "SE")
	LAZYADD(.[/datum/dna], "b_type")
	LAZYADD(.[/datum/dna], "real_name")
	LAZYADD(.[/datum/dna], "species")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/extension/holster
	//
	LAZYADD(.[/datum/extension/holster], "holder")
	LAZYADD(.[/datum/extension/holster], "atom_holder")
	LAZYADD(.[/datum/extension/holster], "storage")
	LAZYADD(.[/datum/extension/holster], "can_holster")
	LAZYADD(.[/datum/extension/holster], "holstered")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/fluidtrack
	//
	LAZYADD(.[/datum/fluidtrack], "direction")
	LAZYADD(.[/datum/fluidtrack], "basecolor")
	LAZYADD(.[/datum/fluidtrack], "crusty")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/gas_mixture
	//
	LAZYADD(.[/datum/gas_mixture], "gas")
	LAZYADD(.[/datum/gas_mixture], "temperature")
	LAZYADD(.[/datum/gas_mixture], "total_moles")
	LAZYADD(.[/datum/gas_mixture], "volume")
	LAZYADD(.[/datum/gas_mixture], "group_multiplier")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/integrated_io
	//
	LAZYADD(.[/datum/integrated_io], "holder")
	LAZYADD(.[/datum/integrated_io], "linked")
	LAZYADD(.[/datum/integrated_io], "io_type")
	LAZYADD(.[/datum/integrated_io], "pin_type")
	LAZYADD(.[/datum/integrated_io], "ord")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/mind
	//
	LAZYADD(.[/datum/mind], "memory")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/money_account
	//
	LAZYADD(.[/datum/money_account], "owner_name")
	LAZYADD(.[/datum/money_account], "account_number")
	LAZYADD(.[/datum/money_account], "remote_access_pin")
	LAZYADD(.[/datum/money_account], "money")
	LAZYADD(.[/datum/money_account], "transaction_log")
	LAZYADD(.[/datum/money_account], "suspended")
	LAZYADD(.[/datum/money_account], "security_level")
	LAZYADD(.[/datum/money_account], "account_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/omni_port
	//
	LAZYADD(.[/datum/omni_port], "master")
	LAZYADD(.[/datum/omni_port], "dir")
	LAZYADD(.[/datum/omni_port], "mode")
	LAZYADD(.[/datum/omni_port], "concentration")
	LAZYADD(.[/datum/omni_port], "con_lock")
	LAZYADD(.[/datum/omni_port], "transfer_moles")
	LAZYADD(.[/datum/omni_port], "air")
	LAZYADD(.[/datum/omni_port], "node")
	LAZYADD(.[/datum/omni_port], "network")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/pipeline
	//
	LAZYADD(.[/datum/pipeline], "air")
	LAZYADD(.[/datum/pipeline], "edges")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/reagent
	//
	LAZYADD(.[/datum/reagent], "holder")
	LAZYADD(.[/datum/reagent], "data")
	LAZYADD(.[/datum/reagent], "volume")
	LAZYADD(.[/datum/reagent], "ingest_met")
	LAZYADD(.[/datum/reagent], "touch_met")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/reagents/metabolism
	//
	LAZYADD(.[/datum/reagents/metabolism], "metabolism_class")
	LAZYADD(.[/datum/reagents/metabolism], "parent")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/reagents
	//
	LAZYADD(.[/datum/reagents], "reagent_list")
	LAZYADD(.[/datum/reagents], "total_volume")
	LAZYADD(.[/datum/reagents], "maximum_volume")
	LAZYADD(.[/datum/reagents], "my_atom")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/robot_component/cell
	//
	LAZYADD(.[/datum/robot_component/cell], "stored_cell")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/seed
	//
	LAZYADD(.[/datum/seed], "name")
	LAZYADD(.[/datum/seed], "seed_name")
	LAZYADD(.[/datum/seed], "seed_noun")
	LAZYADD(.[/datum/seed], "display_name")
	LAZYADD(.[/datum/seed], "can_self_harvest")
	LAZYADD(.[/datum/seed], "growth_stages")
	LAZYADD(.[/datum/seed], "traits")
	LAZYADD(.[/datum/seed], "mutants")
	LAZYADD(.[/datum/seed], "chems")
	LAZYADD(.[/datum/seed], "consume_gasses")
	LAZYADD(.[/datum/seed], "exude_gasses")
	LAZYADD(.[/datum/seed], "kitchen_tag")
	LAZYADD(.[/datum/seed], "trash_type")
	LAZYADD(.[/datum/seed], "splat_type")
	LAZYADD(.[/datum/seed], "has_mob_product")
	LAZYADD(.[/datum/seed], "force_layer")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/shuttle
	//
	LAZYADD(.[/datum/shuttle], "name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/stored_items
	//
	LAZYADD(.[/datum/stored_items], "item_name")
	LAZYADD(.[/datum/stored_items], "item_path")
	LAZYADD(.[/datum/stored_items], "amount")
	LAZYADD(.[/datum/stored_items], "instances")
	LAZYADD(.[/datum/stored_items], "storing_object")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/materials
	//
	LAZYADD(.[/datum/tech/materials], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/transaction
	//
	LAZYADD(.[/datum/transaction], "purpose")
	LAZYADD(.[/datum/transaction], "amount")
	LAZYADD(.[/datum/transaction], "date")
	LAZYADD(.[/datum/transaction], "time")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/turbolift
	//
	LAZYADD(.[/datum/turbolift], "current_floor")
	LAZYADD(.[/datum/turbolift], "doors")
	LAZYADD(.[/datum/turbolift], "floors")
	LAZYADD(.[/datum/turbolift], "control_panel_interior")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/turbolift_floor
	//
	LAZYADD(.[/datum/turbolift_floor], "label")
	LAZYADD(.[/datum/turbolift_floor], "name")
	LAZYADD(.[/datum/turbolift_floor], "announce_str")
	LAZYADD(.[/datum/turbolift_floor], "arrival_sound")
	LAZYADD(.[/datum/turbolift_floor], "doors")
	LAZYADD(.[/datum/turbolift_floor], "ext_panel")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/wires
	//
	LAZYADD(.[/datum/wires], "wire_count")
	LAZYADD(.[/datum/wires], "wires_status")
	LAZYADD(.[/datum/wires], "wires")
	LAZYADD(.[/datum/wires], "signallers")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/wound
	//
	LAZYADD(.[/datum/wound], "current_stage")
	LAZYADD(.[/datum/wound], "damage")
	LAZYADD(.[/datum/wound], "bleed_timer")
	LAZYADD(.[/datum/wound], "bleed_threshold")
	LAZYADD(.[/datum/wound], "min_damage")
	LAZYADD(.[/datum/wound], "bandaged")
	LAZYADD(.[/datum/wound], "clamped")
	LAZYADD(.[/datum/wound], "salved")
	LAZYADD(.[/datum/wound], "disinfected")
	LAZYADD(.[/datum/wound], "created")
	LAZYADD(.[/datum/wound], "amount")
	LAZYADD(.[/datum/wound], "germ_level")
	LAZYADD(.[/datum/wound], "embedded_objects")
	LAZYADD(.[/datum/wound], "desc_list")
	LAZYADD(.[/datum/wound], "damage_list")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living
	//
	LAZYADD(.[/mob/living], "maxHealth")
	LAZYADD(.[/mob/living], "health")
	LAZYADD(.[/mob/living], "last_special")
	LAZYADD(.[/mob/living], "t_phoron")
	LAZYADD(.[/mob/living], "t_oxygen")
	LAZYADD(.[/mob/living], "t_sl_gas")
	LAZYADD(.[/mob/living], "t_n2")
	LAZYADD(.[/mob/living], "now_pushing")
	LAZYADD(.[/mob/living], "mob_bump_flag")
	LAZYADD(.[/mob/living], "mob_swap_flags")
	LAZYADD(.[/mob/living], "mob_push_flags")
	LAZYADD(.[/mob/living], "mob_always_swap")
	LAZYADD(.[/mob/living], "silent")
	LAZYADD(.[/mob/living], "update_slimes")
	LAZYADD(.[/mob/living], "on_fire")
	LAZYADD(.[/mob/living], "fire_stacks")
	LAZYADD(.[/mob/living], "failed_last_breath")
	LAZYADD(.[/mob/living], "possession_candidate")
	LAZYADD(.[/mob/living], "eye_blind")
	LAZYADD(.[/mob/living], "eye_blurry")
	LAZYADD(.[/mob/living], "ear_damage")
	LAZYADD(.[/mob/living], "stuttering")
	LAZYADD(.[/mob/living], "slurring")
	LAZYADD(.[/mob/living], "last_resist")
	LAZYADD(.[/mob/living], "auras")
	LAZYADD(.[/mob/living], "job")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/bot
	//
	LAZYADD(.[/mob/living/bot], "on")
	LAZYADD(.[/mob/living/bot], "open")
	LAZYADD(.[/mob/living/bot], "locked")
	LAZYADD(.[/mob/living/bot], "emagged")
	LAZYADD(.[/mob/living/bot], "light_strength")
	LAZYADD(.[/mob/living/bot], "busy")
	LAZYADD(.[/mob/living/bot], "target")
	LAZYADD(.[/mob/living/bot], "obstacle")
	LAZYADD(.[/mob/living/bot], "ignore_list")
	LAZYADD(.[/mob/living/bot], "patrol_path")
	LAZYADD(.[/mob/living/bot], "target_path")
	LAZYADD(.[/mob/living/bot], "wait_if_pulled")
	LAZYADD(.[/mob/living/bot], "will_patrol")
	LAZYADD(.[/mob/living/bot], "patrol_speed")
	LAZYADD(.[/mob/living/bot], "target_speed")
	LAZYADD(.[/mob/living/bot], "min_target_dist")
	LAZYADD(.[/mob/living/bot], "max_target_dist")
	LAZYADD(.[/mob/living/bot], "max_patrol_dist")
	LAZYADD(.[/mob/living/bot], "RequiresAccessToToggle")
	LAZYADD(.[/mob/living/bot], "target_patience")
	LAZYADD(.[/mob/living/bot], "frustration")
	LAZYADD(.[/mob/living/bot], "max_frustration")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/bot/secbot/ed209
	//
	LAZYADD(.[/mob/living/bot/secbot/ed209], "shot_delay")
	LAZYADD(.[/mob/living/bot/secbot/ed209], "last_shot")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/bot/cleanbot
	//
	LAZYADD(.[/mob/living/bot/cleanbot], "cleaning")
	LAZYADD(.[/mob/living/bot/cleanbot], "screwloose")
	LAZYADD(.[/mob/living/bot/cleanbot], "oddbutton")
	LAZYADD(.[/mob/living/bot/cleanbot], "blood")
	LAZYADD(.[/mob/living/bot/cleanbot], "target_types")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/bot/floorbot
	//
	LAZYADD(.[/mob/living/bot/floorbot], "amount")
	LAZYADD(.[/mob/living/bot/floorbot], "maxAmount")
	LAZYADD(.[/mob/living/bot/floorbot], "tilemake")
	LAZYADD(.[/mob/living/bot/floorbot], "improvefloors")
	LAZYADD(.[/mob/living/bot/floorbot], "eattiles")
	LAZYADD(.[/mob/living/bot/floorbot], "maketiles")
	LAZYADD(.[/mob/living/bot/floorbot], "boxtype")
	LAZYADD(.[/mob/living/bot/floorbot], "floor_build_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/bot/medbot
	//
	LAZYADD(.[/mob/living/bot/medbot], "skin")
	LAZYADD(.[/mob/living/bot/medbot], "last_newpatient_speak")
	LAZYADD(.[/mob/living/bot/medbot], "vocal")
	LAZYADD(.[/mob/living/bot/medbot], "reagent_glass")
	LAZYADD(.[/mob/living/bot/medbot], "injection_amount")
	LAZYADD(.[/mob/living/bot/medbot], "heal_threshold")
	LAZYADD(.[/mob/living/bot/medbot], "use_beaker")
	LAZYADD(.[/mob/living/bot/medbot], "declare_treatment")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/bot/mulebot
	//
	LAZYADD(.[/mob/living/bot/mulebot], "load")
	LAZYADD(.[/mob/living/bot/mulebot], "paused")
	LAZYADD(.[/mob/living/bot/mulebot], "crates_only")
	LAZYADD(.[/mob/living/bot/mulebot], "auto_return")
	LAZYADD(.[/mob/living/bot/mulebot], "safety")
	LAZYADD(.[/mob/living/bot/mulebot], "targetName")
	LAZYADD(.[/mob/living/bot/mulebot], "home")
	LAZYADD(.[/mob/living/bot/mulebot], "homeName")
	LAZYADD(.[/mob/living/bot/mulebot], "amount")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/bot/farmbot
	//
	LAZYADD(.[/mob/living/bot/farmbot], "action")
	LAZYADD(.[/mob/living/bot/farmbot], "waters_trays")
	LAZYADD(.[/mob/living/bot/farmbot], "refills_water")
	LAZYADD(.[/mob/living/bot/farmbot], "uproots_weeds")
	LAZYADD(.[/mob/living/bot/farmbot], "replaces_nutriment")
	LAZYADD(.[/mob/living/bot/farmbot], "collects_produce")
	LAZYADD(.[/mob/living/bot/farmbot], "removes_dead")
	LAZYADD(.[/mob/living/bot/farmbot], "tank")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/carbon
	//
	LAZYADD(.[/mob/living/carbon], "life_tick")
	LAZYADD(.[/mob/living/carbon], "handcuffed")
	LAZYADD(.[/mob/living/carbon], "surgeries_in_progress")
	LAZYADD(.[/mob/living/carbon], "pose")
	LAZYADD(.[/mob/living/carbon], "chem_effects")
	LAZYADD(.[/mob/living/carbon], "chem_doses")
	LAZYADD(.[/mob/living/carbon], "bloodstr")
	LAZYADD(.[/mob/living/carbon], "touching")
	LAZYADD(.[/mob/living/carbon], "losebreath")
	LAZYADD(.[/mob/living/carbon], "coughedtime")
	LAZYADD(.[/mob/living/carbon], "cpr_time")
	LAZYADD(.[/mob/living/carbon], "lastpuke")
	LAZYADD(.[/mob/living/carbon], "nutrition")
	LAZYADD(.[/mob/living/carbon], "hydration")
	LAZYADD(.[/mob/living/carbon], "internal")
	LAZYADD(.[/mob/living/carbon], "last_taste_time")
	LAZYADD(.[/mob/living/carbon], "last_taste_text")
	LAZYADD(.[/mob/living/carbon], "internal_organs")
	LAZYADD(.[/mob/living/carbon], "organs")
	LAZYADD(.[/mob/living/carbon], "organs_by_name")
	LAZYADD(.[/mob/living/carbon], "internal_organs_by_name")
	LAZYADD(.[/mob/living/carbon], "stasis_sources")
	LAZYADD(.[/mob/living/carbon], "stasis_value")
	LAZYADD(.[/mob/living/carbon], "player_triggered_sleeping")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/carbon/slime
	//
	LAZYADD(.[/mob/living/carbon/slime], "colour")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/silicon
	//
	LAZYADD(.[/mob/living/silicon], "syndicate")
	LAZYADD(.[/mob/living/silicon], "speech_synthesizer_langs")
	LAZYADD(.[/mob/living/silicon], "speak_statement")
	LAZYADD(.[/mob/living/silicon], "speak_exclamation")
	LAZYADD(.[/mob/living/silicon], "speak_query")
	LAZYADD(.[/mob/living/silicon], "pose")
	LAZYADD(.[/mob/living/silicon], "local_transmit")
	LAZYADD(.[/mob/living/silicon], "sensor_mode")
	LAZYADD(.[/mob/living/silicon], "next_alarm_notice")
	LAZYADD(.[/mob/living/silicon], "queued_alarms")
	LAZYADD(.[/mob/living/silicon], "access_rights")
	LAZYADD(.[/mob/living/silicon], "idcard")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/silicon/robot
	//
	LAZYADD(.[/mob/living/silicon/robot], "lights_on")
	LAZYADD(.[/mob/living/silicon/robot], "power_efficiency")
	LAZYADD(.[/mob/living/silicon/robot], "sight_mode")
	LAZYADD(.[/mob/living/silicon/robot], "custom_name")
	LAZYADD(.[/mob/living/silicon/robot], "custom_sprite")
	LAZYADD(.[/mob/living/silicon/robot], "crisis")
	LAZYADD(.[/mob/living/silicon/robot], "crisis_override")
	LAZYADD(.[/mob/living/silicon/robot], "module_category")
	LAZYADD(.[/mob/living/silicon/robot], "module")
	LAZYADD(.[/mob/living/silicon/robot], "module_active")
	LAZYADD(.[/mob/living/silicon/robot], "module_state_1")
	LAZYADD(.[/mob/living/silicon/robot], "module_state_2")
	LAZYADD(.[/mob/living/silicon/robot], "module_state_3")
	LAZYADD(.[/mob/living/silicon/robot], "cell")
	LAZYADD(.[/mob/living/silicon/robot], "components")
	LAZYADD(.[/mob/living/silicon/robot], "mmi")
	LAZYADD(.[/mob/living/silicon/robot], "storage")
	LAZYADD(.[/mob/living/silicon/robot], "opened")
	LAZYADD(.[/mob/living/silicon/robot], "emagged")
	LAZYADD(.[/mob/living/silicon/robot], "wiresexposed")
	LAZYADD(.[/mob/living/silicon/robot], "locked")
	LAZYADD(.[/mob/living/silicon/robot], "has_power")
	LAZYADD(.[/mob/living/silicon/robot], "spawn_module")
	LAZYADD(.[/mob/living/silicon/robot], "ident")
	LAZYADD(.[/mob/living/silicon/robot], "viewalerts")
	LAZYADD(.[/mob/living/silicon/robot], "modtype")
	LAZYADD(.[/mob/living/silicon/robot], "lower_mod")
	LAZYADD(.[/mob/living/silicon/robot], "jetpack")
	LAZYADD(.[/mob/living/silicon/robot], "jeton")
	LAZYADD(.[/mob/living/silicon/robot], "killswitch")
	LAZYADD(.[/mob/living/silicon/robot], "killswitch_time")
	LAZYADD(.[/mob/living/silicon/robot], "weapon_lock")
	LAZYADD(.[/mob/living/silicon/robot], "weaponlock_time")
	LAZYADD(.[/mob/living/silicon/robot], "lawupdate")
	LAZYADD(.[/mob/living/silicon/robot], "lockcharge")
	LAZYADD(.[/mob/living/silicon/robot], "speed")
	LAZYADD(.[/mob/living/silicon/robot], "scrambledcodes")
	LAZYADD(.[/mob/living/silicon/robot], "tracking_entities")
	LAZYADD(.[/mob/living/silicon/robot], "braintype")
	LAZYADD(.[/mob/living/silicon/robot], "intenselight")
	LAZYADD(.[/mob/living/silicon/robot], "vtec")
	LAZYADD(.[/mob/living/silicon/robot], "camera")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/silicon/robot/drone
	//
	LAZYADD(.[/mob/living/silicon/robot/drone], "mail_destination")
	LAZYADD(.[/mob/living/silicon/robot/drone], "hat")
	LAZYADD(.[/mob/living/silicon/robot/drone], "hat_x_offset")
	LAZYADD(.[/mob/living/silicon/robot/drone], "hat_y_offset")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/silicon/pai
	//
	LAZYADD(.[/mob/living/silicon/pai], "network")
	LAZYADD(.[/mob/living/silicon/pai], "camera")
	LAZYADD(.[/mob/living/silicon/pai], "ram")
	LAZYADD(.[/mob/living/silicon/pai], "software")
	LAZYADD(.[/mob/living/silicon/pai], "userDNA")
	LAZYADD(.[/mob/living/silicon/pai], "card")
	LAZYADD(.[/mob/living/silicon/pai], "chassis")
	LAZYADD(.[/mob/living/silicon/pai], "master")
	LAZYADD(.[/mob/living/silicon/pai], "master_dna")
	LAZYADD(.[/mob/living/silicon/pai], "pai_law0")
	LAZYADD(.[/mob/living/silicon/pai], "pai_laws")
	LAZYADD(.[/mob/living/silicon/pai], "silence_time")
	LAZYADD(.[/mob/living/silicon/pai], "screen")
	LAZYADD(.[/mob/living/silicon/pai], "subscreen")
	LAZYADD(.[/mob/living/silicon/pai], "secHUD")
	LAZYADD(.[/mob/living/silicon/pai], "medHUD")
	LAZYADD(.[/mob/living/silicon/pai], "medical_cannotfind")
	LAZYADD(.[/mob/living/silicon/pai], "medicalActive1")
	LAZYADD(.[/mob/living/silicon/pai], "medicalActive2")
	LAZYADD(.[/mob/living/silicon/pai], "security_cannotfind")
	LAZYADD(.[/mob/living/silicon/pai], "securityActive1")
	LAZYADD(.[/mob/living/silicon/pai], "securityActive2")
	LAZYADD(.[/mob/living/silicon/pai], "hackdoor")
	LAZYADD(.[/mob/living/silicon/pai], "hackprogress")
	LAZYADD(.[/mob/living/silicon/pai], "hack_aborted")
	LAZYADD(.[/mob/living/silicon/pai], "translator_on")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/simple_animal/cat
	//
	LAZYADD(.[/mob/living/simple_animal/cat], "name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/simple_animal/hostile
	//
	LAZYADD(.[/mob/living/simple_animal/hostile], "attack_same")
	LAZYADD(.[/mob/living/simple_animal/hostile], "desc")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/effect/floor_decal
	//
	LAZYADD(.[/obj/effect/floor_decal], "supplied_dir")
	LAZYADD(.[/obj/effect/floor_decal], "color")
	LAZYADD(.[/obj/effect/floor_decal], "plane")
	LAZYADD(.[/obj/effect/floor_decal], "layer")
	LAZYADD(.[/obj/effect/floor_decal], "appearance_flags")
	LAZYADD(.[/obj/effect/floor_decal], "alpha")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/ammo_casing
	//
	LAZYADD(.[/obj/item/ammo_casing], "BB")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/accessory/storage
	//
	LAZYADD(.[/obj/item/clothing/accessory/storage], "slots")
	LAZYADD(.[/obj/item/clothing/accessory/storage], "hold")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/accessory
	//
	LAZYADD(.[/obj/item/clothing/accessory], "has_suit")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/head/welding
	//
	LAZYADD(.[/obj/item/clothing/head/welding], "up")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/mask/smokable/cigarette
	//
	LAZYADD(.[/obj/item/clothing/mask/smokable/cigarette], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/ring/material
	//
	LAZYADD(.[/obj/item/clothing/ring/material], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/shoes/magboots
	//
	LAZYADD(.[/obj/item/clothing/shoes/magboots], "shoes")
	LAZYADD(.[/obj/item/clothing/shoes/magboots], "wearer")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/suit/space/void
	//
	LAZYADD(.[/obj/item/clothing/suit/space/void], "boots")
	LAZYADD(.[/obj/item/clothing/suit/space/void], "helmet")
	LAZYADD(.[/obj/item/clothing/suit/space/void], "tank")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/suit/storage
	//
	LAZYADD(.[/obj/item/clothing/suit/storage], "pockets")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing
	//
	LAZYADD(.[/obj/item/clothing], "species_restricted")
	LAZYADD(.[/obj/item/clothing], "accessories")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/assembly/infra
	//
	LAZYADD(.[/obj/item/device/assembly/infra], "on")
	LAZYADD(.[/obj/item/device/assembly/infra], "visible")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/assembly/mousetrap
	//
	LAZYADD(.[/obj/item/device/assembly/mousetrap], "armed")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/assembly/prox_sensor
	//
	LAZYADD(.[/obj/item/device/assembly/prox_sensor], "scanning")
	LAZYADD(.[/obj/item/device/assembly/prox_sensor], "timing")
	LAZYADD(.[/obj/item/device/assembly/prox_sensor], "time")
	LAZYADD(.[/obj/item/device/assembly/prox_sensor], "range")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/assembly/signaler
	//
	LAZYADD(.[/obj/item/device/assembly/signaler], "code")
	LAZYADD(.[/obj/item/device/assembly/signaler], "frequency")
	LAZYADD(.[/obj/item/device/assembly/signaler], "delay")
	LAZYADD(.[/obj/item/device/assembly/signaler], "airlock_wire")
	LAZYADD(.[/obj/item/device/assembly/signaler], "connected")
	LAZYADD(.[/obj/item/device/assembly/signaler], "deadman")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/assembly/timer
	//
	LAZYADD(.[/obj/item/device/assembly/timer], "timing")
	LAZYADD(.[/obj/item/device/assembly/timer], "time")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/assembly/voice
	//
	LAZYADD(.[/obj/item/device/assembly/voice], "listening")
	LAZYADD(.[/obj/item/device/assembly/voice], "recorded")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/assembly
	//
	LAZYADD(.[/obj/item/device/assembly], "secured")
	LAZYADD(.[/obj/item/device/assembly], "attached_overlays")
	LAZYADD(.[/obj/item/device/assembly], "holder")
	LAZYADD(.[/obj/item/device/assembly], "cooldown")
	LAZYADD(.[/obj/item/device/assembly], "wires")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/assembly_holder
	//
	LAZYADD(.[/obj/item/device/assembly_holder], "secured")
	LAZYADD(.[/obj/item/device/assembly_holder], "a_left")
	LAZYADD(.[/obj/item/device/assembly_holder], "a_right")
	LAZYADD(.[/obj/item/device/assembly_holder], "special_assembly")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/electronic_assembly
	//
	LAZYADD(.[/obj/item/device/electronic_assembly], "assembly_components")
	LAZYADD(.[/obj/item/device/electronic_assembly], "opened")
	LAZYADD(.[/obj/item/device/electronic_assembly], "battery")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/flashlight
	//
	LAZYADD(.[/obj/item/device/flashlight], "on")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/integrated_circuit_printer
	//
	LAZYADD(.[/obj/item/device/integrated_circuit_printer], "metal")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/lightreplacer
	//
	LAZYADD(.[/obj/item/device/lightreplacer], "uses")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/radio/headset
	//
	LAZYADD(.[/obj/item/device/radio/headset], "ks1type")
	LAZYADD(.[/obj/item/device/radio/headset], "ks2type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/radio
	//
	LAZYADD(.[/obj/item/device/radio], "frequency")
	LAZYADD(.[/obj/item/device/radio], "wires")
	LAZYADD(.[/obj/item/device/radio], "b_stat")
	LAZYADD(.[/obj/item/device/radio], "broadcasting")
	LAZYADD(.[/obj/item/device/radio], "listening")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/taperecorder
	//
	LAZYADD(.[/obj/item/device/taperecorder], "mytape")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/glass_jar
	//
	LAZYADD(.[/obj/item/glass_jar], "contains")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/integrated_circuit/filter/ref
	//
	LAZYADD(.[/obj/item/integrated_circuit/filter/ref], "filter_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/integrated_circuit/manipulation/grenade
	//
	LAZYADD(.[/obj/item/integrated_circuit/manipulation/grenade], "attached_grenade")
	LAZYADD(.[/obj/item/integrated_circuit/manipulation/grenade], "pre_attached_grenade_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/integrated_circuit/time/delay/custom
	//
	LAZYADD(.[/obj/item/integrated_circuit/time/delay/custom], "delay")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/integrated_circuit
	//
	LAZYADD(.[/obj/item/integrated_circuit], "inputs")
	LAZYADD(.[/obj/item/integrated_circuit], "outputs")
	LAZYADD(.[/obj/item/integrated_circuit], "activators")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/modular_computer
	//
	LAZYADD(.[/obj/item/modular_computer], "hardware_flag")
	LAZYADD(.[/obj/item/modular_computer], "computer_emagged")
	LAZYADD(.[/obj/item/modular_computer], "bsod")
	LAZYADD(.[/obj/item/modular_computer], "damage")
	LAZYADD(.[/obj/item/modular_computer], "processor_unit")
	LAZYADD(.[/obj/item/modular_computer], "network_card")
	LAZYADD(.[/obj/item/modular_computer], "hard_drive")
	LAZYADD(.[/obj/item/modular_computer], "battery_module")
	LAZYADD(.[/obj/item/modular_computer], "card_slot")
	LAZYADD(.[/obj/item/modular_computer], "nano_printer")
	LAZYADD(.[/obj/item/modular_computer], "portable_drive")
	LAZYADD(.[/obj/item/modular_computer], "ai_slot")
	LAZYADD(.[/obj/item/modular_computer], "tesla_link")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/organ/external
	//
	LAZYADD(.[/obj/item/organ/external], "pain")
	LAZYADD(.[/obj/item/organ/external], "model")
	LAZYADD(.[/obj/item/organ/external], "s_tone")
	LAZYADD(.[/obj/item/organ/external], "s_col")
	LAZYADD(.[/obj/item/organ/external], "s_col_blend")
	LAZYADD(.[/obj/item/organ/external], "wounds")
	LAZYADD(.[/obj/item/organ/external], "number_wounds")
	LAZYADD(.[/obj/item/organ/external], "parent")
	LAZYADD(.[/obj/item/organ/external], "children")
	LAZYADD(.[/obj/item/organ/external], "internal_organs")
	LAZYADD(.[/obj/item/organ/external], "implants")
	LAZYADD(.[/obj/item/organ/external], "genetic_degradation")
	LAZYADD(.[/obj/item/organ/external], "autopsy_data")
	LAZYADD(.[/obj/item/organ/external], "dislocated")
	LAZYADD(.[/obj/item/organ/external], "encased")
	LAZYADD(.[/obj/item/organ/external], "cavity")
	LAZYADD(.[/obj/item/organ/external], "stage")
	LAZYADD(.[/obj/item/organ/external], "applied_pressure")
	LAZYADD(.[/obj/item/organ/external], "splinted")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/organ
	//
	LAZYADD(.[/obj/item/organ], "status")
	LAZYADD(.[/obj/item/organ], "owner")
	LAZYADD(.[/obj/item/organ], "dna")
	LAZYADD(.[/obj/item/organ], "species")
	LAZYADD(.[/obj/item/organ], "damage")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/pipe
	//
	LAZYADD(.[/obj/item/pipe], "connect_types")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/rig_module
	//
	LAZYADD(.[/obj/item/rig_module], "holder")
	LAZYADD(.[/obj/item/rig_module], "charges")
	LAZYADD(.[/obj/item/rig_module], "active")
	LAZYADD(.[/obj/item/rig_module], "charge_selected")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/robot_parts/robot_suit
	//
	LAZYADD(.[/obj/item/robot_parts/robot_suit], "parts")
	LAZYADD(.[/obj/item/robot_parts/robot_suit], "created_name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/robot_parts
	//
	LAZYADD(.[/obj/item/robot_parts], "part")
	LAZYADD(.[/obj/item/robot_parts], "sabotaged")
	LAZYADD(.[/obj/item/robot_parts], "model_info")
	LAZYADD(.[/obj/item/robot_parts], "bp_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/seeds
	//
	LAZYADD(.[/obj/item/seeds], "seed")
	LAZYADD(.[/obj/item/seeds], "seed_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/stack/material/wood/mahogany
	//
	LAZYADD(.[/obj/item/stack/material/wood/mahogany], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/stack
	//
	LAZYADD(.[/obj/item/stack], "amount")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/underwear
	//
	LAZYADD(.[/obj/item/underwear], "gender")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/airlock_brace
	//
	LAZYADD(.[/obj/item/weapon/airlock_brace], "cur_health")
	LAZYADD(.[/obj/item/weapon/airlock_brace], "airlock")
	LAZYADD(.[/obj/item/weapon/airlock_brace], "electronics")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/airlock_electronics
	//
	LAZYADD(.[/obj/item/weapon/airlock_electronics], "conf_access")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/beartrap
	//
	LAZYADD(.[/obj/item/weapon/beartrap], "deployed")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/book
	//
	LAZYADD(.[/obj/item/weapon/book], "dat")
	LAZYADD(.[/obj/item/weapon/book], "author")
	LAZYADD(.[/obj/item/weapon/book], "unique")
	LAZYADD(.[/obj/item/weapon/book], "title")
	LAZYADD(.[/obj/item/weapon/book], "carved")
	LAZYADD(.[/obj/item/weapon/book], "store")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/card/id
	//
	LAZYADD(.[/obj/item/weapon/card/id], "age")
	LAZYADD(.[/obj/item/weapon/card/id], "access")
	LAZYADD(.[/obj/item/weapon/card/id], "registered_name")
	LAZYADD(.[/obj/item/weapon/card/id], "associated_account_number")
	LAZYADD(.[/obj/item/weapon/card/id], "blood_type")
	LAZYADD(.[/obj/item/weapon/card/id], "dna_hash")
	LAZYADD(.[/obj/item/weapon/card/id], "fingerprint_hash")
	LAZYADD(.[/obj/item/weapon/card/id], "sex")
	LAZYADD(.[/obj/item/weapon/card/id], "assignment")
	LAZYADD(.[/obj/item/weapon/card/id], "rank")
	LAZYADD(.[/obj/item/weapon/card/id], "job_access_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/cell
	//
	LAZYADD(.[/obj/item/weapon/cell], "charge")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/disk/botany
	//
	LAZYADD(.[/obj/item/weapon/disk/botany], "genes")
	LAZYADD(.[/obj/item/weapon/disk/botany], "genesource")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/flamethrower
	//
	LAZYADD(.[/obj/item/weapon/flamethrower], "weldtool")
	LAZYADD(.[/obj/item/weapon/flamethrower], "igniter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/grenade/chem_grenade
	//
	LAZYADD(.[/obj/item/weapon/grenade/chem_grenade], "stage")
	LAZYADD(.[/obj/item/weapon/grenade/chem_grenade], "path")
	LAZYADD(.[/obj/item/weapon/grenade/chem_grenade], "detonator")
	LAZYADD(.[/obj/item/weapon/grenade/chem_grenade], "beakers")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/grenade
	//
	LAZYADD(.[/obj/item/weapon/grenade], "det_time")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/energy
	//
	LAZYADD(.[/obj/item/weapon/gun/energy], "power_supply")
	LAZYADD(.[/obj/item/weapon/gun/energy], "cell_type")
	LAZYADD(.[/obj/item/weapon/gun/energy], "charge_meter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/launcher/pneumatic
	//
	LAZYADD(.[/obj/item/weapon/gun/launcher/pneumatic], "tank")
	LAZYADD(.[/obj/item/weapon/gun/launcher/pneumatic], "item_storage")
	LAZYADD(.[/obj/item/weapon/gun/launcher/pneumatic], "pressure_setting")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/magnetic
	//
	LAZYADD(.[/obj/item/weapon/gun/magnetic], "cell")
	LAZYADD(.[/obj/item/weapon/gun/magnetic], "capacitor")
	LAZYADD(.[/obj/item/weapon/gun/magnetic], "loaded")
	LAZYADD(.[/obj/item/weapon/gun/magnetic], "load_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/implant/freedom
	//
	LAZYADD(.[/obj/item/weapon/implant/freedom], "activation_emote")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/key
	//
	LAZYADD(.[/obj/item/weapon/key], "key_data")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/material/lock_construct
	//
	LAZYADD(.[/obj/item/weapon/material/lock_construct], "lock_data")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/material
	//
	LAZYADD(.[/obj/item/weapon/material], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/melee/baton
	//
	LAZYADD(.[/obj/item/weapon/melee/baton], "bcell")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/melee/energy/axe
	//
	LAZYADD(.[/obj/item/weapon/melee/energy/axe], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/ore
	//
	LAZYADD(.[/obj/item/weapon/ore], "geologic_data")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/paper
	//
	LAZYADD(.[/obj/item/weapon/paper], "info")
	LAZYADD(.[/obj/item/weapon/paper], "info_links")
	LAZYADD(.[/obj/item/weapon/paper], "stamps")
	LAZYADD(.[/obj/item/weapon/paper], "stamped")
	LAZYADD(.[/obj/item/weapon/paper], "ico")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/paper_bundle
	//
	LAZYADD(.[/obj/item/weapon/paper_bundle], "page")
	LAZYADD(.[/obj/item/weapon/paper_bundle], "pages")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/photo
	//
	LAZYADD(.[/obj/item/weapon/photo], "icon")
	LAZYADD(.[/obj/item/weapon/photo], "scribble")
	LAZYADD(.[/obj/item/weapon/photo], "tiny")
	LAZYADD(.[/obj/item/weapon/photo], "photo_size")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/rcd
	//
	LAZYADD(.[/obj/item/weapon/rcd], "stored_matter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/reagent_containers/food/snacks/grown
	//
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "plantname")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "name")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "seed")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "potency")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/rig
	//
	LAZYADD(.[/obj/item/weapon/rig], "hides_uniform")
	LAZYADD(.[/obj/item/weapon/rig], "wearer")
	LAZYADD(.[/obj/item/weapon/rig], "chest")
	LAZYADD(.[/obj/item/weapon/rig], "cell")
	LAZYADD(.[/obj/item/weapon/rig], "air_supply")
	LAZYADD(.[/obj/item/weapon/rig], "boots")
	LAZYADD(.[/obj/item/weapon/rig], "helmet")
	LAZYADD(.[/obj/item/weapon/rig], "gloves")
	LAZYADD(.[/obj/item/weapon/rig], "selected_module")
	LAZYADD(.[/obj/item/weapon/rig], "visor")
	LAZYADD(.[/obj/item/weapon/rig], "speech")
	LAZYADD(.[/obj/item/weapon/rig], "installed_modules")
	LAZYADD(.[/obj/item/weapon/rig], "open")
	LAZYADD(.[/obj/item/weapon/rig], "locked")
	LAZYADD(.[/obj/item/weapon/rig], "subverted")
	LAZYADD(.[/obj/item/weapon/rig], "interface_locked")
	LAZYADD(.[/obj/item/weapon/rig], "control_overridden")
	LAZYADD(.[/obj/item/weapon/rig], "ai_override_enabled")
	LAZYADD(.[/obj/item/weapon/rig], "security_check_enabled")
	LAZYADD(.[/obj/item/weapon/rig], "malfunctioning")
	LAZYADD(.[/obj/item/weapon/rig], "electrified")
	LAZYADD(.[/obj/item/weapon/rig], "locked_down")
	LAZYADD(.[/obj/item/weapon/rig], "offline")
	LAZYADD(.[/obj/item/weapon/rig], "airtight")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/spacecash
	//
	LAZYADD(.[/obj/item/weapon/spacecash], "access")
	LAZYADD(.[/obj/item/weapon/spacecash], "worth")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/capacitor/super
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/capacitor/super], "charge")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stool
	//
	LAZYADD(.[/obj/item/weapon/stool], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/storage/internal
	//
	LAZYADD(.[/obj/item/weapon/storage/internal], "master_item")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/storage/secure/safe
	//
	LAZYADD(.[/obj/item/weapon/storage/secure/safe], "l_code")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/storage/wallet/leather
	//
	LAZYADD(.[/obj/item/weapon/storage/wallet/leather], "front_id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/storage
	//
	LAZYADD(.[/obj/item/weapon/storage], "max_storage_space")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/tank
	//
	LAZYADD(.[/obj/item/weapon/tank], "air_contents")
	LAZYADD(.[/obj/item/weapon/tank], "distribute_pressure")
	LAZYADD(.[/obj/item/weapon/tank], "integrity")
	LAZYADD(.[/obj/item/weapon/tank], "valve_welded")
	LAZYADD(.[/obj/item/weapon/tank], "proxyassembly")
	LAZYADD(.[/obj/item/weapon/tank], "volume")
	LAZYADD(.[/obj/item/weapon/tank], "manipulated_by")
	LAZYADD(.[/obj/item/weapon/tank], "leaking")
	LAZYADD(.[/obj/item/weapon/tank], "wired")
	LAZYADD(.[/obj/item/weapon/tank], "starting_pressure")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/weldingtool
	//
	LAZYADD(.[/obj/item/weapon/weldingtool], "tank")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/weldpack
	//
	LAZYADD(.[/obj/item/weapon/weldpack], "welder")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/airlock_sensor
	//
	LAZYADD(.[/obj/machinery/airlock_sensor], "master_tag")
	LAZYADD(.[/obj/machinery/airlock_sensor], "frequency")
	LAZYADD(.[/obj/machinery/airlock_sensor], "command")
	LAZYADD(.[/obj/machinery/airlock_sensor], "on")
	LAZYADD(.[/obj/machinery/airlock_sensor], "alert")
	LAZYADD(.[/obj/machinery/airlock_sensor], "previousPressure")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/alarm
	//
	LAZYADD(.[/obj/machinery/alarm], "rcon_setting")
	LAZYADD(.[/obj/machinery/alarm], "locked")
	LAZYADD(.[/obj/machinery/alarm], "wiresexposed")
	LAZYADD(.[/obj/machinery/alarm], "aidisabled")
	LAZYADD(.[/obj/machinery/alarm], "mode")
	LAZYADD(.[/obj/machinery/alarm], "target_temperature")
	LAZYADD(.[/obj/machinery/alarm], "regulating_temperature")
	LAZYADD(.[/obj/machinery/alarm], "TLV")
	LAZYADD(.[/obj/machinery/alarm], "oxygen_dangerlevel")
	LAZYADD(.[/obj/machinery/alarm], "co2_dangerlevel")
	LAZYADD(.[/obj/machinery/alarm], "report_danger_level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/binary/passive_gate
	//
	LAZYADD(.[/obj/machinery/atmospherics/binary/passive_gate], "unlocked")
	LAZYADD(.[/obj/machinery/atmospherics/binary/passive_gate], "target_pressure")
	LAZYADD(.[/obj/machinery/atmospherics/binary/passive_gate], "regulate_mode")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/binary/pump
	//
	LAZYADD(.[/obj/machinery/atmospherics/binary/pump], "target_pressure")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/omni/filter
	//
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "filters")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "gas_filters")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "input")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "output")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "set_flow_rate")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "filtering_outputs")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "ports")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/omni
	//
	LAZYADD(.[/obj/machinery/atmospherics/omni], "overlays_on")
	LAZYADD(.[/obj/machinery/atmospherics/omni], "overlays_off")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/pipeturbine
	//
	LAZYADD(.[/obj/machinery/atmospherics/pipeturbine], "network1")
	LAZYADD(.[/obj/machinery/atmospherics/pipeturbine], "network2")
	LAZYADD(.[/obj/machinery/atmospherics/pipeturbine], "node2")
	LAZYADD(.[/obj/machinery/atmospherics/pipeturbine], "node1")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/portables_connector
	//
	LAZYADD(.[/obj/machinery/atmospherics/portables_connector], "connected_device")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/tvalve
	//
	LAZYADD(.[/obj/machinery/atmospherics/tvalve], "state")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/unary/freezer
	//
	LAZYADD(.[/obj/machinery/atmospherics/unary/freezer], "set_temperature")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/unary/outlet_injector
	//
	LAZYADD(.[/obj/machinery/atmospherics/unary/outlet_injector], "injecting")
	LAZYADD(.[/obj/machinery/atmospherics/unary/outlet_injector], "volume_rate")
	LAZYADD(.[/obj/machinery/atmospherics/unary/outlet_injector], "frequency")
	LAZYADD(.[/obj/machinery/atmospherics/unary/outlet_injector], "id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/unary/vent_pump
	//
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "pump_direction")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "external_pressure_bound")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "internal_pressure_bound")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "pressure_checks")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "welded")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/unary/vent_scrubber
	//
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_scrubber], "scrubbing")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_scrubber], "welded")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/valve
	//
	LAZYADD(.[/obj/machinery/atmospherics/valve], "open")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics
	//
	LAZYADD(.[/obj/machinery/atmospherics], "initialize_directions")
	LAZYADD(.[/obj/machinery/atmospherics], "pipe_color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/beehive
	//
	LAZYADD(.[/obj/machinery/beehive], "bee_count")
	LAZYADD(.[/obj/machinery/beehive], "frames")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/biogenerator
	//
	LAZYADD(.[/obj/machinery/biogenerator], "points")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/bodyscanner
	//
	LAZYADD(.[/obj/machinery/bodyscanner], "occupant")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/cell_charger
	//
	LAZYADD(.[/obj/machinery/cell_charger], "charging")
	LAZYADD(.[/obj/machinery/cell_charger], "chargelevel")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/chemical_dispenser
	//
	LAZYADD(.[/obj/machinery/chemical_dispenser], "cartridges")
	LAZYADD(.[/obj/machinery/chemical_dispenser], "container")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/computer/operating
	//
	LAZYADD(.[/obj/machinery/computer/operating], "table")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/computer/rdconsole/core
	//
	LAZYADD(.[/obj/machinery/computer/rdconsole/core], "files")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/computer/telecomms/monitor
	//
	LAZYADD(.[/obj/machinery/computer/telecomms/monitor], "network")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/computer/telecomms/server
	//
	LAZYADD(.[/obj/machinery/computer/telecomms/server], "network")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/conveyor
	//
	LAZYADD(.[/obj/machinery/conveyor], "forwards")
	LAZYADD(.[/obj/machinery/conveyor], "backwards")
	LAZYADD(.[/obj/machinery/conveyor], "id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/cryopod
	//
	LAZYADD(.[/obj/machinery/cryopod], "applies_stasis")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/deployable/barrier
	//
	LAZYADD(.[/obj/machinery/deployable/barrier], "locked")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/disposal
	//
	LAZYADD(.[/obj/machinery/disposal], "air_contents")
	LAZYADD(.[/obj/machinery/disposal], "mode")
	LAZYADD(.[/obj/machinery/disposal], "trunk")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/airlock/lift
	//
	LAZYADD(.[/obj/machinery/door/airlock/lift], "lift")
	LAZYADD(.[/obj/machinery/door/airlock/lift], "floor")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/airlock
	//
	LAZYADD(.[/obj/machinery/door/airlock], "welded")
	LAZYADD(.[/obj/machinery/door/airlock], "locked")
	LAZYADD(.[/obj/machinery/door/airlock], "lock_cut_state")
	LAZYADD(.[/obj/machinery/door/airlock], "closeOther")
	LAZYADD(.[/obj/machinery/door/airlock], "closeOtherId")
	LAZYADD(.[/obj/machinery/door/airlock], "safe")
	LAZYADD(.[/obj/machinery/door/airlock], "secured_wires")
	LAZYADD(.[/obj/machinery/door/airlock], "brace")
	LAZYADD(.[/obj/machinery/door/airlock], "airlock_type")
	LAZYADD(.[/obj/machinery/door/airlock], "door_color")
	LAZYADD(.[/obj/machinery/door/airlock], "stripe_color")
	LAZYADD(.[/obj/machinery/door/airlock], "symbol_color")
	LAZYADD(.[/obj/machinery/door/airlock], "frequency")
	LAZYADD(.[/obj/machinery/door/airlock], "shockedby")
	LAZYADD(.[/obj/machinery/door/airlock], "cur_command")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/firedoor
	//
	LAZYADD(.[/obj/machinery/door/firedoor], "areas_added")
	LAZYADD(.[/obj/machinery/door/firedoor], "net_id")
	LAZYADD(.[/obj/machinery/door/firedoor], "pdiff")
	LAZYADD(.[/obj/machinery/door/firedoor], "pdiff_alert")
	LAZYADD(.[/obj/machinery/door/firedoor], "blocked")
	LAZYADD(.[/obj/machinery/door/firedoor], "lockdown")
	LAZYADD(.[/obj/machinery/door/firedoor], "hatch_open")
	LAZYADD(.[/obj/machinery/door/firedoor], "nextstate")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/unpowered/simple
	//
	LAZYADD(.[/obj/machinery/door/unpowered/simple], "material")
	LAZYADD(.[/obj/machinery/door/unpowered/simple], "lock")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/unpowered
	//
	LAZYADD(.[/obj/machinery/door/unpowered], "locked")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/window
	//
	LAZYADD(.[/obj/machinery/door/window], "base_state")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door
	//
	LAZYADD(.[/obj/machinery/door], "layer")
	LAZYADD(.[/obj/machinery/door], "visible")
	LAZYADD(.[/obj/machinery/door], "p_open")
	LAZYADD(.[/obj/machinery/door], "autoclose")
	LAZYADD(.[/obj/machinery/door], "glass")
	LAZYADD(.[/obj/machinery/door], "normalspeed")
	LAZYADD(.[/obj/machinery/door], "health")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/embedded_controller
	//
	LAZYADD(.[/obj/machinery/embedded_controller], "on")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/embedded_controller/radio/simple_docking_controller
	//
	LAZYADD(.[/obj/machinery/embedded_controller/radio/simple_docking_controller], "tag_door")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/embedded_controller/radio/docking_port_multi
	//
	LAZYADD(.[/obj/machinery/embedded_controller/radio/docking_port_multi], "child_names")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/docking_port_multi], "child_names_txt")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/docking_port_multi], "child_tags_txt")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/embedded_controller/radio/airlock/docking_port
	//
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock/docking_port], "display_name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/embedded_controller/radio/airlock
	//
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_exterior_door")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_interior_door")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_airpump")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_chamber_sensor")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_exterior_sensor")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_interior_sensor")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_airlock_mech_sensor")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_shuttle_mech_sensor")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_secure")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "cycle_to_external_air")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/floorlayer
	//
	LAZYADD(.[/obj/machinery/floorlayer], "old_turf")
	LAZYADD(.[/obj/machinery/floorlayer], "on")
	LAZYADD(.[/obj/machinery/floorlayer], "T")
	LAZYADD(.[/obj/machinery/floorlayer], "mode")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/floor_light
	//
	LAZYADD(.[/obj/machinery/floor_light], "on")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/light
	//
	LAZYADD(.[/obj/machinery/light], "lightbulb")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/light_switch
	//
	LAZYADD(.[/obj/machinery/light_switch], "on")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/message_server
	//
	LAZYADD(.[/obj/machinery/message_server], "decryptkey")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/microwave
	//
	LAZYADD(.[/obj/machinery/microwave], "dirty")
	LAZYADD(.[/obj/machinery/microwave], "broken")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/mineral/processing_unit
	//
	LAZYADD(.[/obj/machinery/mineral/processing_unit], "ores_processing")
	LAZYADD(.[/obj/machinery/mineral/processing_unit], "ores_stored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/mineral
	//
	LAZYADD(.[/obj/machinery/mineral], "input_turf")
	LAZYADD(.[/obj/machinery/mineral], "output_turf")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/navbeacon
	//
	LAZYADD(.[/obj/machinery/navbeacon], "locked")
	LAZYADD(.[/obj/machinery/navbeacon], "location")
	LAZYADD(.[/obj/machinery/navbeacon], "codes")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/organ_printer
	//
	LAZYADD(.[/obj/machinery/organ_printer], "stored_matter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/papershredder
	//
	LAZYADD(.[/obj/machinery/papershredder], "paperamount")
	LAZYADD(.[/obj/machinery/papershredder], "shred_amounts")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/photocopier/faxmachine
	//
	LAZYADD(.[/obj/machinery/photocopier/faxmachine], "department")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/photocopier
	//
	LAZYADD(.[/obj/machinery/photocopier], "copyitem")
	LAZYADD(.[/obj/machinery/photocopier], "copies")
	LAZYADD(.[/obj/machinery/photocopier], "toner")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics/canister
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "health")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "valve_open")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "release_pressure")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "canister_color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics/hydroponics
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "base_name")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "dead")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "harvest")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "age")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "health")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "lastproduce")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "lastcycle")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "seed")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "toxic_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "nutrient_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "weedkiller_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "pestkiller_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "water_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "beneficial_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "mutagenic_reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics/powered/pump
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics/powered/pump], "cell")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics/powered/scrubber
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics/powered/scrubber], "cell")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics], "air_contents")
	LAZYADD(.[/obj/machinery/portable_atmospherics], "connected_port")
	LAZYADD(.[/obj/machinery/portable_atmospherics], "holding")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/porta_turret
	//
	LAZYADD(.[/obj/machinery/porta_turret], "health")
	LAZYADD(.[/obj/machinery/porta_turret], "locked")
	LAZYADD(.[/obj/machinery/porta_turret], "installation")
	LAZYADD(.[/obj/machinery/porta_turret], "check_access")
	LAZYADD(.[/obj/machinery/porta_turret], "enabled")
	LAZYADD(.[/obj/machinery/porta_turret], "lethal")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/apc
	//
	LAZYADD(.[/obj/machinery/power/apc], "area")
	LAZYADD(.[/obj/machinery/power/apc], "cell")
	LAZYADD(.[/obj/machinery/power/apc], "cell_type")
	LAZYADD(.[/obj/machinery/power/apc], "opened")
	LAZYADD(.[/obj/machinery/power/apc], "shorted")
	LAZYADD(.[/obj/machinery/power/apc], "lighting")
	LAZYADD(.[/obj/machinery/power/apc], "equipment")
	LAZYADD(.[/obj/machinery/power/apc], "environ")
	LAZYADD(.[/obj/machinery/power/apc], "operating")
	LAZYADD(.[/obj/machinery/power/apc], "chargemode")
	LAZYADD(.[/obj/machinery/power/apc], "locked")
	LAZYADD(.[/obj/machinery/power/apc], "coverlocked")
	LAZYADD(.[/obj/machinery/power/apc], "aidisabled")
	LAZYADD(.[/obj/machinery/power/apc], "lastused_light")
	LAZYADD(.[/obj/machinery/power/apc], "lastused_equip")
	LAZYADD(.[/obj/machinery/power/apc], "lastused_environ")
	LAZYADD(.[/obj/machinery/power/apc], "lastused_charging")
	LAZYADD(.[/obj/machinery/power/apc], "lastused_total")
	LAZYADD(.[/obj/machinery/power/apc], "main_status")
	LAZYADD(.[/obj/machinery/power/apc], "has_electronics")
	LAZYADD(.[/obj/machinery/power/apc], "beenhit")
	LAZYADD(.[/obj/machinery/power/apc], "is_critical")
	LAZYADD(.[/obj/machinery/power/apc], "autoflag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/emitter
	//
	LAZYADD(.[/obj/machinery/power/emitter], "active")
	LAZYADD(.[/obj/machinery/power/emitter], "locked")
	LAZYADD(.[/obj/machinery/power/emitter], "powered")
	LAZYADD(.[/obj/machinery/power/emitter], "burst_shots")
	LAZYADD(.[/obj/machinery/power/emitter], "fire_delay")
	LAZYADD(.[/obj/machinery/power/emitter], "last_shot")
	LAZYADD(.[/obj/machinery/power/emitter], "shot_number")
	LAZYADD(.[/obj/machinery/power/emitter], "efficiency")
	LAZYADD(.[/obj/machinery/power/emitter], "min_burst_delay")
	LAZYADD(.[/obj/machinery/power/emitter], "max_burst_delay")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/port_gen
	//
	LAZYADD(.[/obj/machinery/power/port_gen], "active")
	LAZYADD(.[/obj/machinery/power/port_gen], "open")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/sensor
	//
	LAZYADD(.[/obj/machinery/power/sensor], "name_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/shield_generator
	//
	LAZYADD(.[/obj/machinery/power/shield_generator], "shield_modes")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mitigation_em")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mitigation_physical")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mitigation_heat")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mitigation_max")
	LAZYADD(.[/obj/machinery/power/shield_generator], "max_energy")
	LAZYADD(.[/obj/machinery/power/shield_generator], "current_energy")
	LAZYADD(.[/obj/machinery/power/shield_generator], "field_radius")
	LAZYADD(.[/obj/machinery/power/shield_generator], "running")
	LAZYADD(.[/obj/machinery/power/shield_generator], "input_cap")
	LAZYADD(.[/obj/machinery/power/shield_generator], "upkeep_power_usage")
	LAZYADD(.[/obj/machinery/power/shield_generator], "upkeep_multiplier")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mode_changes_locked")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mode_list")
	LAZYADD(.[/obj/machinery/power/shield_generator], "field_segments")
	LAZYADD(.[/obj/machinery/power/shield_generator], "damaged_segments")
	LAZYADD(.[/obj/machinery/power/shield_generator], "target_radius")
	LAZYADD(.[/obj/machinery/power/shield_generator], "power_usage")
	LAZYADD(.[/obj/machinery/power/shield_generator], "overloaded")
	LAZYADD(.[/obj/machinery/power/shield_generator], "hacked")
	LAZYADD(.[/obj/machinery/power/shield_generator], "offline_for")
	LAZYADD(.[/obj/machinery/power/shield_generator], "input_cut")
	LAZYADD(.[/obj/machinery/power/shield_generator], "full_shield_strength")
	LAZYADD(.[/obj/machinery/power/shield_generator], "idle_multiplier")
	LAZYADD(.[/obj/machinery/power/shield_generator], "spinup_delay")
	LAZYADD(.[/obj/machinery/power/shield_generator], "spinup_counter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/smes/batteryrack
	//
	LAZYADD(.[/obj/machinery/power/smes/batteryrack], "max_transfer_rate")
	LAZYADD(.[/obj/machinery/power/smes/batteryrack], "mode")
	LAZYADD(.[/obj/machinery/power/smes/batteryrack], "internal_cells")
	LAZYADD(.[/obj/machinery/power/smes/batteryrack], "max_cells")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/smes
	//
	LAZYADD(.[/obj/machinery/power/smes], "capacity")
	LAZYADD(.[/obj/machinery/power/smes], "charge")
	LAZYADD(.[/obj/machinery/power/smes], "input_attempt")
	LAZYADD(.[/obj/machinery/power/smes], "input_level")
	LAZYADD(.[/obj/machinery/power/smes], "output_attempt")
	LAZYADD(.[/obj/machinery/power/smes], "output_level")
	LAZYADD(.[/obj/machinery/power/smes], "name_tag")
	LAZYADD(.[/obj/machinery/power/smes], "terminals")
	LAZYADD(.[/obj/machinery/power/smes], "should_be_mapped")
	LAZYADD(.[/obj/machinery/power/smes], "damage")
	LAZYADD(.[/obj/machinery/power/smes], "input_cut")
	LAZYADD(.[/obj/machinery/power/smes], "output_cut")
	LAZYADD(.[/obj/machinery/power/smes], "failure_timer")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/solar
	//
	LAZYADD(.[/obj/machinery/power/solar], "sunfrac")
	LAZYADD(.[/obj/machinery/power/solar], "control")
	LAZYADD(.[/obj/machinery/power/solar], "obscured")
	LAZYADD(.[/obj/machinery/power/solar], "adir")
	LAZYADD(.[/obj/machinery/power/solar], "ndir")
	LAZYADD(.[/obj/machinery/power/solar], "turn_angle")
	LAZYADD(.[/obj/machinery/power/solar], "health")
	LAZYADD(.[/obj/machinery/power/solar], "id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/terminal
	//
	LAZYADD(.[/obj/machinery/power/terminal], "master")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/tracker
	//
	LAZYADD(.[/obj/machinery/power/tracker], "control")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/reagentgrinder
	//
	LAZYADD(.[/obj/machinery/reagentgrinder], "beaker")
	LAZYADD(.[/obj/machinery/reagentgrinder], "contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/recharger
	//
	LAZYADD(.[/obj/machinery/recharger], "charging")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/sleeper
	//
	LAZYADD(.[/obj/machinery/sleeper], "occupant")
	LAZYADD(.[/obj/machinery/sleeper], "beaker")
	LAZYADD(.[/obj/machinery/sleeper], "filtering")
	LAZYADD(.[/obj/machinery/sleeper], "pump")
	LAZYADD(.[/obj/machinery/sleeper], "stasis")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/smartfridge
	//
	LAZYADD(.[/obj/machinery/smartfridge], "item_records")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/suit_cycler
	//
	LAZYADD(.[/obj/machinery/suit_cycler], "locked")
	LAZYADD(.[/obj/machinery/suit_cycler], "target_species")
	LAZYADD(.[/obj/machinery/suit_cycler], "suit")
	LAZYADD(.[/obj/machinery/suit_cycler], "helmet")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/receiver
	//
	LAZYADD(.[/obj/machinery/telecomms/receiver], "links")
	LAZYADD(.[/obj/machinery/telecomms/receiver], "listening_levels")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms
	//
	LAZYADD(.[/obj/machinery/telecomms], "on")
	LAZYADD(.[/obj/machinery/telecomms], "id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery
	//
	LAZYADD(.[/obj/machinery], "stat")
	LAZYADD(.[/obj/machinery], "emagged")
	LAZYADD(.[/obj/machinery], "malf_upgraded")
	LAZYADD(.[/obj/machinery], "use_power")
	LAZYADD(.[/obj/machinery], "component_parts")
	LAZYADD(.[/obj/machinery], "uid")
	LAZYADD(.[/obj/machinery], "panel_open")
	LAZYADD(.[/obj/machinery], "power_components")
	LAZYADD(.[/obj/machinery], "anchored")
	LAZYADD(.[/obj/machinery], "state")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/barricade
	//
	LAZYADD(.[/obj/structure/barricade], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/bed
	//
	LAZYADD(.[/obj/structure/bed], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/bigDelivery
	//
	LAZYADD(.[/obj/structure/bigDelivery], "wrapped")
	LAZYADD(.[/obj/structure/bigDelivery], "sortTag")
	LAZYADD(.[/obj/structure/bigDelivery], "examtext")
	LAZYADD(.[/obj/structure/bigDelivery], "nameset")
	LAZYADD(.[/obj/structure/bigDelivery], "label_y")
	LAZYADD(.[/obj/structure/bigDelivery], "label_x")
	LAZYADD(.[/obj/structure/bigDelivery], "tag_x")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/cable
	//
	LAZYADD(.[/obj/structure/cable], "d1")
	LAZYADD(.[/obj/structure/cable], "d2")
	LAZYADD(.[/obj/structure/cable], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/closet/secure_closet/personal
	//
	LAZYADD(.[/obj/structure/closet/secure_closet/personal], "registered_name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/closet
	//
	LAZYADD(.[/obj/structure/closet], "broken")
	LAZYADD(.[/obj/structure/closet], "opened")
	LAZYADD(.[/obj/structure/closet], "locked")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/c_tray
	//
	LAZYADD(.[/obj/structure/c_tray], "connected")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/dispenser
	//
	LAZYADD(.[/obj/structure/dispenser], "oxygentanks")
	LAZYADD(.[/obj/structure/dispenser], "phorontanks")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/disposalconstruct
	//
	LAZYADD(.[/obj/structure/disposalconstruct], "dpdir")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/disposalpipe
	//
	LAZYADD(.[/obj/structure/disposalpipe], "dpdir")
	LAZYADD(.[/obj/structure/disposalpipe], "health")
	LAZYADD(.[/obj/structure/disposalpipe], "base_icon_state")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/door_assembly
	//
	LAZYADD(.[/obj/structure/door_assembly], "panel_icon")
	LAZYADD(.[/obj/structure/door_assembly], "fill_icon")
	LAZYADD(.[/obj/structure/door_assembly], "glass_icon")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/girder
	//
	LAZYADD(.[/obj/structure/girder], "state")
	LAZYADD(.[/obj/structure/girder], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/janitorialcart
	//
	LAZYADD(.[/obj/structure/janitorialcart], "mybag")
	LAZYADD(.[/obj/structure/janitorialcart], "mymop")
	LAZYADD(.[/obj/structure/janitorialcart], "myspray")
	LAZYADD(.[/obj/structure/janitorialcart], "myreplacer")
	LAZYADD(.[/obj/structure/janitorialcart], "signs")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/lift/button
	//
	LAZYADD(.[/obj/structure/lift/button], "lift")
	LAZYADD(.[/obj/structure/lift/button], "floor")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/ore_box
	//
	LAZYADD(.[/obj/structure/ore_box], "stored_ore")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/sign/poster
	//
	LAZYADD(.[/obj/structure/sign/poster], "desc")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/table
	//
	LAZYADD(.[/obj/structure/table], "flipped")
	LAZYADD(.[/obj/structure/table], "material")
	LAZYADD(.[/obj/structure/table], "reinforced")
	LAZYADD(.[/obj/structure/table], "carpeted")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/wall_frame
	//
	LAZYADD(.[/obj/structure/wall_frame], "stripe_color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/window
	//
	LAZYADD(.[/obj/structure/window], "health")
	LAZYADD(.[/obj/structure/window], "polarized")
	LAZYADD(.[/obj/structure/window], "reinf_material")
	LAZYADD(.[/obj/structure/window], "init_material")
	LAZYADD(.[/obj/structure/window], "blend_objects")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure
	//
	LAZYADD(.[/obj/structure], "connections")
	LAZYADD(.[/obj/structure], "health")
	LAZYADD(.[/obj/structure], "other_connections")
	LAZYADD(.[/obj/structure], "waterproof")
	LAZYADD(.[/obj/structure], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/vehicle/train/cargo/engine
	//
	LAZYADD(.[/obj/vehicle/train/cargo/engine], "key")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/vehicle/train
	//
	LAZYADD(.[/obj/vehicle/train], "passenger_allowed")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/vehicle
	//
	LAZYADD(.[/obj/vehicle], "on")
	LAZYADD(.[/obj/vehicle], "health")
	LAZYADD(.[/obj/vehicle], "open")
	LAZYADD(.[/obj/vehicle], "locked")
	LAZYADD(.[/obj/vehicle], "stat")
	LAZYADD(.[/obj/vehicle], "cell")
	LAZYADD(.[/obj/vehicle], "load")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /turf/simulated/wall
	//
	LAZYADD(.[/turf/simulated/wall], "material")
	LAZYADD(.[/turf/simulated/wall], "state")
	LAZYADD(.[/turf/simulated/wall], "floor_type")
	LAZYADD(.[/turf/simulated/wall], "paint_color")
	LAZYADD(.[/turf/simulated/wall], "stripe_color")
	LAZYADD(.[/turf/simulated/wall], "damage")
	LAZYADD(.[/turf/simulated/wall], "opacity")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/implant/sic
	//
	LAZYADD(.[/obj/item/weapon/implant/sic], "unique_id")
	LAZYADD(.[/obj/item/weapon/implant/sic], "alias")
	LAZYADD(.[/obj/item/weapon/implant/sic], "ignored")
	LAZYADD(.[/obj/item/weapon/implant/sic], "max_bill")
	LAZYADD(.[/obj/item/weapon/implant/sic], "current_bill")
	LAZYADD(.[/obj/item/weapon/implant/sic], "free_messaging")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /turf
	//
	LAZYADD(.[/turf], "level")
	LAZYADD(.[/turf], "holy")
	LAZYADD(.[/turf], "blocks_air")
	LAZYADD(.[/turf], "blessed")
	LAZYADD(.[/turf], "fluid_can_pass")
	LAZYADD(.[/turf], "flooded")
	LAZYADD(.[/turf], "footstep_type")
	LAZYADD(.[/turf], "contents")
	LAZYADD(.[/turf], "density")
	LAZYADD(.[/turf], "icon_state")
	LAZYADD(.[/turf], "name")
	LAZYADD(.[/turf], "pixel_x")
	LAZYADD(.[/turf], "pixel_y")
	LAZYADD(.[/turf], "dir")
	LAZYADD(.[/turf], "decals")
	LAZYADD(.[/turf], "air")
	LAZYADD(.[/turf], "is_on_fire")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob
	//
	LAZYADD(.[/mob], "mob_flags")
	LAZYADD(.[/mob], "last_quick_move_time")
	LAZYADD(.[/mob], "mind")
	LAZYADD(.[/mob], "lastKnownIP")
	LAZYADD(.[/mob], "computer_id")
	LAZYADD(.[/mob], "last_ckey")
	LAZYADD(.[/mob], "contents")
	LAZYADD(.[/mob], "stat")
	LAZYADD(.[/mob], "damageoverlaytemp")
	LAZYADD(.[/mob], "machine")
	LAZYADD(.[/mob], "sdisabilities")
	LAZYADD(.[/mob], "disabilities")
	LAZYADD(.[/mob], "pulling")
	LAZYADD(.[/mob], "other_mobs")
	LAZYADD(.[/mob], "next_move")
	LAZYADD(.[/mob], "hand")
	LAZYADD(.[/mob], "real_name")
	LAZYADD(.[/mob], "bhunger")
	LAZYADD(.[/mob], "druggy")
	LAZYADD(.[/mob], "confused")
	LAZYADD(.[/mob], "sleeping")
	LAZYADD(.[/mob], "resting")
	LAZYADD(.[/mob], "lying")
	LAZYADD(.[/mob], "lying_prev")
	LAZYADD(.[/mob], "radio_interrupt_cooldown")
	LAZYADD(.[/mob], "unacidable")
	LAZYADD(.[/mob], "pinned")
	LAZYADD(.[/mob], "embedded")
	LAZYADD(.[/mob], "languages")
	LAZYADD(.[/mob], "species_language")
	LAZYADD(.[/mob], "only_species_language")
	LAZYADD(.[/mob], "speak_emote")
	LAZYADD(.[/mob], "emote_type")
	LAZYADD(.[/mob], "facing_dir")
	LAZYADD(.[/mob], "timeofdeath")
	LAZYADD(.[/mob], "bodytemperature")
	LAZYADD(.[/mob], "a_intent")
	LAZYADD(.[/mob], "move_intent")
	LAZYADD(.[/mob], "buckled")
	LAZYADD(.[/mob], "l_hand")
	LAZYADD(.[/mob], "r_hand")
	LAZYADD(.[/mob], "back")
	LAZYADD(.[/mob], "s_active")
	LAZYADD(.[/mob], "wear_mask")
	LAZYADD(.[/mob], "grabbed_by")
	LAZYADD(.[/mob], "in_throw_mode")
	LAZYADD(.[/mob], "inertia_dir")
	LAZYADD(.[/mob], "can_pull_size")
	LAZYADD(.[/mob], "can_pull_mobs")
	LAZYADD(.[/mob], "dna")
	LAZYADD(.[/mob], "active_genes")
	LAZYADD(.[/mob], "mutations")
	LAZYADD(.[/mob], "radiation")
	LAZYADD(.[/mob], "voice_name")
	LAZYADD(.[/mob], "faction")
	LAZYADD(.[/mob], "blinded")
	LAZYADD(.[/mob], "ear_deaf")
	LAZYADD(.[/mob], "LAssailant")
	LAZYADD(.[/mob], "status_flagS")
	LAZYADD(.[/mob], "lastarea")
	LAZYADD(.[/mob], "digitalcamo")
	LAZYADD(.[/mob], "control_object")
	LAZYADD(.[/mob], "universal_speak")
	LAZYADD(.[/mob], "universal_understand")
	LAZYADD(.[/mob], "shouldnt_see")
	LAZYADD(.[/mob], "mob_size")
	LAZYADD(.[/mob], "paralysis")
	LAZYADD(.[/mob], "stunned")
	LAZYADD(.[/mob], "weakness")
	LAZYADD(.[/mob], "drowsyness")
	LAZYADD(.[/mob], "flavor_text")
	LAZYADD(.[/mob], "skillset")
	LAZYADD(.[/mob], "additional_vision_handlers")
	LAZYADD(.[/mob], "feet_blood_color")
	LAZYADD(.[/mob], "gender")
	LAZYADD(.[/mob], "id_tag")
	LAZYADD(.[/mob], "saved_ckey")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /atom/movable
	//
	LAZYADD(.[/atom/movable], "level")
	LAZYADD(.[/atom/movable], "germ_level")
	LAZYADD(.[/atom/movable], "blood_DNA")
	LAZYADD(.[/atom/movable], "was_bloodied")
	LAZYADD(.[/atom/movable], "last_bumped")
	LAZYADD(.[/atom/movable], "climbers")
	LAZYADD(.[/atom/movable], "contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /atom
	//
	LAZYADD(.[/atom], "visibility")
	LAZYADD(.[/atom], "suit_fibers")
	LAZYADD(.[/atom], "fingerprints")
	LAZYADD(.[/atom], "gunshot_resique")
	LAZYADD(.[/atom], "contents")
	LAZYADD(.[/atom], "blend_mode")
	LAZYADD(.[/atom], "density")
	LAZYADD(.[/atom], "dir")
	LAZYADD(.[/atom], "icon_state")
	LAZYADD(.[/atom], "name")
	LAZYADD(.[/atom], "opacity")
	LAZYADD(.[/atom], "layer")
	LAZYADD(.[/atom], "pixel_x")
	LAZYADD(.[/atom], "pixel_y")
	LAZYADD(.[/atom], "loc")
	LAZYADD(.[/atom], "id_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj
	//
	LAZYADD(.[/obj], "visibility")
	LAZYADD(.[/obj], "suit_fibers")
	LAZYADD(.[/obj], "fingerprints")
	LAZYADD(.[/obj], "gunshot_resique")
	LAZYADD(.[/obj], "contents")
	LAZYADD(.[/obj], "density")
	LAZYADD(.[/obj], "dir")
	LAZYADD(.[/obj], "icon")
	LAZYADD(.[/obj], "icon_state")
	LAZYADD(.[/obj], "name")
	LAZYADD(.[/obj], "opacity")
	LAZYADD(.[/obj], "pixel_x")
	LAZYADD(.[/obj], "pixel_y")
	LAZYADD(.[/obj], "loc")
	LAZYADD(.[/obj], "id_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/robot_component
	//
	LAZYADD(.[/datum/robot_component], "name")
	LAZYADD(.[/datum/robot_component], "installed")
	LAZYADD(.[/datum/robot_component], "powered")
	LAZYADD(.[/datum/robot_component], "toggled")
	LAZYADD(.[/datum/robot_component], "brute_damage")
	LAZYADD(.[/datum/robot_component], "electronics_damage")
	LAZYADD(.[/datum/robot_component], "max_damage")
	LAZYADD(.[/datum/robot_component], "external_type")
	LAZYADD(.[/datum/robot_component], "wrapped")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/simple_animal/corgi/puppy
	//
	LAZYADD(.[/mob/living/simple_animal/corgi/puppy], "max_health")
	LAZYADD(.[/mob/living/simple_animal/corgi/puppy], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/shoes
	//
	LAZYADD(.[/obj/item/clothing/shoes], "overshoes")
	LAZYADD(.[/obj/item/clothing/shoes], "hidden_item")
	LAZYADD(.[/obj/item/clothing/shoes], "attached_cuffs")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/suit
	//
	LAZYADD(.[/obj/item/clothing/suit], "allowed")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/under/rank/psych/turtleneck/sweater
	//
	LAZYADD(.[/obj/item/clothing/under/rank/psych/turtleneck/sweater], "contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/under
	//
	LAZYADD(.[/obj/item/clothing/under], "sensor_mode")
	LAZYADD(.[/obj/item/clothing/under], "rolled_down")
	LAZYADD(.[/obj/item/clothing/under], "rolled_sleeves")
	LAZYADD(.[/obj/item/clothing/under], "worn_state")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/electronic_assembly/medium
	//
	LAZYADD(.[/obj/item/device/electronic_assembly/medium], "opened")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/flashlight/flare
	//
	LAZYADD(.[/obj/item/device/flashlight/flare], "fuel")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/tankassemblyproxy
	//
	LAZYADD(.[/obj/item/device/tankassemblyproxy], "tank")
	LAZYADD(.[/obj/item/device/tankassemblyproxy], "assembly")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/disposal_switch_construct
	//
	LAZYADD(.[/obj/item/disposal_switch_construct], "id_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/integrated_circuit/manipulation/ai
	//
	LAZYADD(.[/obj/item/integrated_circuit/manipulation/ai], "aicard")
	LAZYADD(.[/obj/item/integrated_circuit/manipulation/ai], "controlling")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/pizzabox
	//
	LAZYADD(.[/obj/item/pizzabox], "pizza")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/robot_parts/chest
	//
	LAZYADD(.[/obj/item/robot_parts/chest], "wires")
	LAZYADD(.[/obj/item/robot_parts/chest], "cell")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/robot_parts/head
	//
	LAZYADD(.[/obj/item/robot_parts/head], "flash1")
	LAZYADD(.[/obj/item/robot_parts/head], "flash2")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/stack/material/generic
	//
	LAZYADD(.[/obj/item/stack/material/generic], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/cell/apc
	//
	LAZYADD(.[/obj/item/weapon/cell/apc], "maxcharge")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/cell/device/variable
	//
	LAZYADD(.[/obj/item/weapon/cell/device/variable], "maxcharge")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts
	//
	LAZYADD(.[/obj/item/weapon/stock_parts], "rating")
	LAZYADD(.[/obj/item/weapon/stock_parts], "status")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/computer/ai_slot
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/computer/ai_slot], "stored_card")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/computer/battery_module
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/computer/battery_module], "battery")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/computer/hard_drive
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/computer/hard_drive], "stored_files")
	LAZYADD(.[/obj/item/weapon/stock_parts/computer/hard_drive], "used_capacity")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/computer/card_slot
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/computer/card_slot], "stored_card")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/computer/nano_printer
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/computer/nano_printer], "stored_paper")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/computer/
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/computer/], "damage")
	LAZYADD(.[/obj/item/weapon/stock_parts/computer/], "enabled")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/disk/tech_disk
	//
	LAZYADD(.[/obj/item/weapon/disk/tech_disk], "stored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/disk/tech_disk
	//
	LAZYADD(.[/obj/item/weapon/disk/tech_disk], "stored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/disk/tech_disk
	//
	LAZYADD(.[/obj/item/weapon/disk/tech_disk], "stored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/ducttape
	//
	LAZYADD(.[/obj/item/weapon/ducttape], "stuck")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/flamethrower/full
	//
	LAZYADD(.[/obj/item/weapon/flamethrower/full], "tank")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/projectile/pistol/sec/detective
	//
	LAZYADD(.[/obj/item/weapon/gun/projectile/pistol/sec/detective], "unique_name")
	LAZYADD(.[/obj/item/weapon/gun/projectile/pistol/sec/detective], "unique_reskin")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/material/
	//
	LAZYADD(.[/obj/item/weapon/material/], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/tank
	//
	LAZYADD(.[/obj/item/weapon/tank], "air_contents")
	LAZYADD(.[/obj/item/weapon/tank], "distribute_pressure")
	LAZYADD(.[/obj/item/weapon/tank], "valve_welded")
	LAZYADD(.[/obj/item/weapon/tank], "proxyassembly")
	LAZYADD(.[/obj/item/weapon/tank], "wired")
	LAZYADD(.[/obj/item/weapon/tank], "leaking")
	LAZYADD(.[/obj/item/weapon/tank], "starting_pressure")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/button
	//
	LAZYADD(.[/obj/machinery/button], "active")
	LAZYADD(.[/obj/machinery/button], "operating")
	LAZYADD(.[/obj/machinery/button], "in_use")
	LAZYADD(.[/obj/machinery/button], "public_variables")
	LAZYADD(.[/obj/machinery/button], "public_methods")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/access_button
	//
	LAZYADD(.[/obj/machinery/access_button], "master_tag")
	LAZYADD(.[/obj/machinery/access_button], "frequency")
	LAZYADD(.[/obj/machinery/access_button], "command")
	LAZYADD(.[/obj/machinery/access_button], "on")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/pipe
	//
	LAZYADD(.[/obj/machinery/atmospherics/pipe], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/fabricator
	//
	LAZYADD(.[/obj/machinery/fabricator], "stored_material")
	LAZYADD(.[/obj/machinery/fabricator], "contents")
	LAZYADD(.[/obj/machinery/fabricator], "has_recycler")
	LAZYADD(.[/obj/machinery/fabricator], "base_icon_state")
	LAZYADD(.[/obj/machinery/fabricator], "panel_image")
	LAZYADD(.[/obj/machinery/fabricator], "queued_orders")
	LAZYADD(.[/obj/machinery/fabricator], "currently_building")
	LAZYADD(.[/obj/machinery/fabricator], "storage_capacity")
	LAZYADD(.[/obj/machinery/fabricator], "show_category")
	LAZYADD(.[/obj/machinery/fabricator], "fab_status_flags")
	LAZYADD(.[/obj/machinery/fabricator], "mat_efficiency")
	LAZYADD(.[/obj/machinery/fabricator], "build_time_multiplier")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/conveyor_switch
	//
	LAZYADD(.[/obj/machinery/conveyor_switch], "id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/disposal_switch
	//
	LAZYADD(.[/obj/machinery/disposal_switch], "id_tag")
	LAZYADD(.[/obj/machinery/disposal_switch], "on")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/integrated_circuit_printer
	//
	LAZYADD(.[/obj/item/device/integrated_circuit_printer], "upgraded")
	LAZYADD(.[/obj/item/device/integrated_circuit_printer], "materials")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/iv_drip
	//
	LAZYADD(.[/obj/structure/iv_drip], "mode")
	LAZYADD(.[/obj/structure/iv_drip], "beaker")
	LAZYADD(.[/obj/structure/iv_drip], "attached")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics/canister/air
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister/air], "destroyed")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister/air], "health")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister/air], "valve_open")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister/air], "release_pressure")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister/air], "canister_color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/port_gen/pacman
	//
	LAZYADD(.[/obj/machinery/power/port_gen/pacman], "sheets")
	LAZYADD(.[/obj/machinery/power/port_gen/pacman], "sheets_left")
	LAZYADD(.[/obj/machinery/power/port_gen/pacman], "operating_temperature")
	LAZYADD(.[/obj/machinery/power/port_gen/pacman], "overheating")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/solar_control
	//
	LAZYADD(.[/obj/machinery/power/solar_control], "connected_tracker")
	LAZYADD(.[/obj/machinery/power/solar_control], "connected_panels")
	LAZYADD(.[/obj/machinery/power/solar_control], "trackrate")
	LAZYADD(.[/obj/machinery/power/solar_control], "targetdir")
	LAZYADD(.[/obj/machinery/power/solar_control], "track")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/bus
	//
	LAZYADD(.[/obj/machinery/telecomms/bus], "change_frequency")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/processor
	//
	LAZYADD(.[/obj/machinery/telecomms/processor], "process_mode")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/server
	//
	LAZYADD(.[/obj/machinery/telecomms/server], "log_entries")
	LAZYADD(.[/obj/machinery/telecomms/server], "stored_names")
	LAZYADD(.[/obj/machinery/telecomms/server], "TrafficActions")
	LAZYADD(.[/obj/machinery/telecomms/server], "logs")
	LAZYADD(.[/obj/machinery/telecomms/server], "memory")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/disposalpipe/diversion_junction
	//
	LAZYADD(.[/obj/structure/disposalpipe/diversion_junction], "active")
	LAZYADD(.[/obj/structure/disposalpipe/diversion_junction], "active_dir")
	LAZYADD(.[/obj/structure/disposalpipe/diversion_junction], "inactive_dir")
	LAZYADD(.[/obj/structure/disposalpipe/diversion_junction], "sortdir")
	LAZYADD(.[/obj/structure/disposalpipe/diversion_junction], "id_tag")
	LAZYADD(.[/obj/structure/disposalpipe/diversion_junction], "linked")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/disposalpipe/sortjunction
	//
	LAZYADD(.[/obj/structure/disposalpipe/sortjunction], "sortdir")
	LAZYADD(.[/obj/structure/disposalpipe/sortjunction], "posdir")
	LAZYADD(.[/obj/structure/disposalpipe/sortjunction], "negdir")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/disposalpipe/tagger
	//
	LAZYADD(.[/obj/structure/disposalpipe/tagger], "sorttag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/lift/panel
	//
	LAZYADD(.[/obj/structure/lift/panel], "lift")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /turf/simulated/mineral
	//
	LAZYADD(.[/turf/simulated/mineral], "resources")
	LAZYADD(.[/turf/simulated/mineral], "mineral")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /turf/simulated/floor
	//
	LAZYADD(.[/turf/simulated/floor], "burnt")
	LAZYADD(.[/turf/simulated/floor], "broken")
	LAZYADD(.[/turf/simulated/floor], "icon_state")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /image
	//
	LAZYADD(.[/image], "color")
	LAZYADD(.[/image], "transform")
	LAZYADD(.[/image], "icon")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/wrapper/area
	//
	LAZYADD(.[/datum/wrapper/area], "area_type")
	LAZYADD(.[/datum/wrapper/area], "name")
	LAZYADD(.[/datum/wrapper/area], "turfs")
	LAZYADD(.[/datum/wrapper/area], "has_gravity")
	LAZYADD(.[/datum/wrapper/area], "apc")
	LAZYADD(.[/datum/wrapper/area], "power_light")
	LAZYADD(.[/datum/wrapper/area], "power_equip")
	LAZYADD(.[/datum/wrapper/area], "power_environ")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/wrapper/multiz
	//
	LAZYADD(.[/datum/wrapper/multiz], "saved_z_levels")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/light
	//
	LAZYADD(.[/obj/machinery/light], "status")
	LAZYADD(.[/obj/machinery/light], "switchcount")
	LAZYADD(.[/obj/machinery/light], "rigged")
	LAZYADD(.[/obj/machinery/light], "broken_chance")
	LAZYADD(.[/obj/machinery/light], "b_colour")
	LAZYADD(.[/obj/machinery/light], "current_mode")
	LAZYADD(.[/obj/machinery/light], "icon_state")
	LAZYADD(.[/obj/machinery/light], "base_state")
	LAZYADD(.[/obj/machinery/light], "light_type")
	LAZYADD(.[/obj/machinery/light], "on")
	LAZYADD(.[/obj/machinery/light], "lightbulb")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/ladder
	//
	LAZYADD(.[/obj/structure/ladder], "allowed_directions")
	LAZYADD(.[/obj/structure/ladder], "target_up")
	LAZYADD(.[/obj/structure/ladder], "target_down")
	LAZYADD(.[/obj/structure/ladder], "climb_time")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/stairs
	//
	LAZYADD(.[/obj/structure/stairs], "layer")
	LAZYADD(.[/obj/structure/stairs], "bound_height")
	LAZYADD(.[/obj/structure/stairs], "dir")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/supermatter
	//
	LAZYADD(.[/obj/machinery/power/supermatter], "nitrogen_retardation_factor")
	LAZYADD(.[/obj/machinery/power/supermatter], "thermal_release_modifier")
	LAZYADD(.[/obj/machinery/power/supermatter], "phoron_release_modifier")
	LAZYADD(.[/obj/machinery/power/supermatter], "oxygen_release_modifier")
	LAZYADD(.[/obj/machinery/power/supermatter], "radiation_release_modifier")
	LAZYADD(.[/obj/machinery/power/supermatter], "reaction_power_modifier")
	LAZYADD(.[/obj/machinery/power/supermatter], "power_factor")
	LAZYADD(.[/obj/machinery/power/supermatter], "decay_factor")
	LAZYADD(.[/obj/machinery/power/supermatter], "critical_temperature")
	LAZYADD(.[/obj/machinery/power/supermatter], "charging_factor")
	LAZYADD(.[/obj/machinery/power/supermatter], "damage_rate_limit")
	LAZYADD(.[/obj/machinery/power/supermatter], "gasefficency")
	LAZYADD(.[/obj/machinery/power/supermatter], "damage")
	LAZYADD(.[/obj/machinery/power/supermatter], "light_color")
	LAZYADD(.[/obj/machinery/power/supermatter], "warning_color")
	LAZYADD(.[/obj/machinery/power/supermatter], "emergency_color")
	LAZYADD(.[/obj/machinery/power/supermatter], "grav_pulling")
	LAZYADD(.[/obj/machinery/power/supermatter], "pull_time")
	LAZYADD(.[/obj/machinery/power/supermatter], "explosion_power")
	LAZYADD(.[/obj/machinery/power/supermatter], "emergency_issued")
	LAZYADD(.[/obj/machinery/power/supermatter], "lastwarning")
	LAZYADD(.[/obj/machinery/power/supermatter], "exploded")
	LAZYADD(.[/obj/machinery/power/supermatter], "power")
	LAZYADD(.[/obj/machinery/power/supermatter], "oxygen")
	LAZYADD(.[/obj/machinery/power/supermatter], "config_bullet_energy")
	LAZYADD(.[/obj/machinery/power/supermatter], "config_hallucination_power")
	LAZYADD(.[/obj/machinery/power/supermatter], "aw_normal")
	LAZYADD(.[/obj/machinery/power/supermatter], "aw_notify")
	LAZYADD(.[/obj/machinery/power/supermatter], "aw_warning")
	LAZYADD(.[/obj/machinery/power/supermatter], "aw_danger")
	LAZYADD(.[/obj/machinery/power/supermatter], "aw_emerg")
	LAZYADD(.[/obj/machinery/power/supermatter], "aw_delam")
	LAZYADD(.[/obj/machinery/power/supermatter], "aw_EPR")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/kinetic_harvester
	//
	LAZYADD(.[/obj/machinery/kinetic_harvester], "stored")
	LAZYADD(.[/obj/machinery/kinetic_harvester], "harvesting")
	LAZYADD(.[/obj/machinery/kinetic_harvester], "harvest_from")
	LAZYADD(.[/obj/machinery/kinetic_harvester], "initial_id_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/fusion_core
	//
	LAZYADD(.[/obj/machinery/power/fusion_core], "owned_field")
	LAZYADD(.[/obj/machinery/power/fusion_core], "field_strength")
	LAZYADD(.[/obj/machinery/power/fusion_core], "initial_id_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/effect/fusion_em_field
	//
	LAZYADD(.[/obj/effect/fusion_em_field], "size")
	LAZYADD(.[/obj/effect/fusion_em_field], "energy")
	LAZYADD(.[/obj/effect/fusion_em_field], "plasma_temperature")
	LAZYADD(.[/obj/effect/fusion_em_field], "radiation")
	LAZYADD(.[/obj/effect/fusion_em_field], "field_strength")
	LAZYADD(.[/obj/effect/fusion_em_field], "tick_instability")
	LAZYADD(.[/obj/effect/fusion_em_field], "percent_unstable")
	LAZYADD(.[/obj/effect/fusion_em_field], "owned_core")
	LAZYADD(.[/obj/effect/fusion_em_field], "reactants")
	LAZYADD(.[/obj/effect/fusion_em_field], "particle_catchers")
	LAZYADD(.[/obj/effect/fusion_em_field], "light_min_range")
	LAZYADD(.[/obj/effect/fusion_em_field], "light_min_power")
	LAZYADD(.[/obj/effect/fusion_em_field], "light_max_range")
	LAZYADD(.[/obj/effect/fusion_em_field], "light_max_power")
	LAZYADD(.[/obj/effect/fusion_em_field], "last_range")
	LAZYADD(.[/obj/effect/fusion_em_field], "last_power")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/fuel_assembly
	//
	LAZYADD(.[/obj/item/weapon/fuel_assembly], "material_name")
	LAZYADD(.[/obj/item/weapon/fuel_assembly], "percent_depleted")
	LAZYADD(.[/obj/item/weapon/fuel_assembly], "rod_quantities")
	LAZYADD(.[/obj/item/weapon/fuel_assembly], "fuel_type")
	LAZYADD(.[/obj/item/weapon/fuel_assembly], "fuel_colour")
	LAZYADD(.[/obj/item/weapon/fuel_assembly], "radioactivity")
	LAZYADD(.[/obj/item/weapon/fuel_assembly], "initial_amount")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/fusion_fuel_injector
	//
	LAZYADD(.[/obj/machinery/fusion_fuel_injector], "fuel_usage")
	LAZYADD(.[/obj/machinery/fusion_fuel_injector], "initial_id_tag")
	LAZYADD(.[/obj/machinery/fusion_fuel_injector], "injecting")
	LAZYADD(.[/obj/machinery/fusion_fuel_injector], "cur_assembly")
	LAZYADD(.[/obj/machinery/fusion_fuel_injector], "injection_rate")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/computer/fusion
	//
	LAZYADD(.[/obj/machinery/computer/fusion], "ui_template")
	LAZYADD(.[/obj/machinery/computer/fusion], "initial_id_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/effect/fusion_particle_catcher
	//
	LAZYADD(.[/obj/effect/fusion_particle_catcher], "parent")
	LAZYADD(.[/obj/effect/fusion_particle_catcher], "mysize")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/compressor
	//
	LAZYADD(.[/obj/machinery/compressor], "turbine")
	LAZYADD(.[/obj/machinery/compressor], "gas_contained")
	LAZYADD(.[/obj/machinery/compressor], "inturf")
	LAZYADD(.[/obj/machinery/compressor], "starter")
	LAZYADD(.[/obj/machinery/compressor], "rpm")
	LAZYADD(.[/obj/machinery/compressor], "rpmtarget")
	LAZYADD(.[/obj/machinery/compressor], "capacity")
	LAZYADD(.[/obj/machinery/compressor], "comp_id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/turbine
	//
	LAZYADD(.[/obj/machinery/power/turbine], "compressor")
	LAZYADD(.[/obj/machinery/power/turbine], "outturf")
	LAZYADD(.[/obj/machinery/power/turbine], "lastgen")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/computer/turbine_computer
	//
	LAZYADD(.[/obj/machinery/computer/turbine_computer], "compressor")
	LAZYADD(.[/obj/machinery/computer/turbine_computer], "doors")
	LAZYADD(.[/obj/machinery/computer/turbine_computer], "door_status")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/radio/receiver
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/radio/receiver], "receive_and_write")
	LAZYADD(.[/obj/item/weapon/stock_parts/radio/receiver], "receive_and_call")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/radio/transmitter
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/radio/transmitter], "range")
	LAZYADD(.[/obj/item/weapon/stock_parts/radio/transmitter], "latency")
	LAZYADD(.[/obj/item/weapon/stock_parts/radio/transmitter], "buffer")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/radio
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/radio], "frequency")
	LAZYADD(.[/obj/item/weapon/stock_parts/radio], "id_tag")
	LAZYADD(.[/obj/item/weapon/stock_parts/radio], "filter")
	LAZYADD(.[/obj/item/weapon/stock_parts/radio], "encryption")
	LAZYADD(.[/obj/item/weapon/stock_parts/radio], "multitool_extension")
	LAZYADD(.[/obj/item/weapon/stock_parts/radio], "radio")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/power/terminal
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/power/terminal], "terminal_dir")
	LAZYADD(.[/obj/item/weapon/stock_parts/power/terminal], "terminal")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/stock_parts/power/terminal
	//
	LAZYADD(.[/obj/item/weapon/stock_parts/power/terminal], "priority")
	LAZYADD(.[/obj/item/weapon/stock_parts/power/terminal], "cached_channel")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/emitter/gyrotron
	//
	LAZYADD(.[/obj/machinery/power/emitter/gyrotron], "initial_id_tag")
	LAZYADD(.[/obj/machinery/power/emitter/gyrotron], "rate")
	LAZYADD(.[/obj/machinery/power/emitter/gyrotron], "mega_energy")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/ntnet_relay
	//
	LAZYADD(.[/obj/machinery/ntnet_relay], "enabled")
	LAZYADD(.[/obj/machinery/ntnet_relay], "dos_failure")
	LAZYADD(.[/obj/machinery/ntnet_relay], "dos_sources")
	LAZYADD(.[/obj/machinery/ntnet_relay], "dos_overload")
	LAZYADD(.[/obj/machinery/ntnet_relay], "dos_capacity")
	LAZYADD(.[/obj/machinery/ntnet_relay], "dos_dissipate")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/lift
	//
	LAZYADD(.[/obj/structure/lift], "lift")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/blast
	//
	LAZYADD(.[/obj/machinery/door/blast], "icon_state_open")
	LAZYADD(.[/obj/machinery/door/blast], "icon_state_opening")
	LAZYADD(.[/obj/machinery/door/blast], "icon_state_closed")
	LAZYADD(.[/obj/machinery/door/blast], "icon_state_closing")
	LAZYADD(.[/obj/machinery/door/blast], "icon_state_open_broken")
	LAZYADD(.[/obj/machinery/door/blast], "icon_state_closed_broken")
	LAZYADD(.[/obj/machinery/door/blast], "begins_closed")
	LAZYADD(.[/obj/machinery/door/blast], "implicit_material")
	LAZYADD(.[/obj/machinery/door/blast], "min_force")
	LAZYADD(.[/obj/machinery/door/blast], "maxhealth")
	LAZYADD(.[/obj/machinery/door/blast], "block_air_zones")
	LAZYADD(.[/obj/machinery/door/blast], "explosion_resistance")
	LAZYADD(.[/obj/machinery/door/blast], "pry_mod")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/fabricator_build_order
	//
	LAZYADD(.[/datum/fabricator_build_order], "target_recipe")
	LAZYADD(.[/datum/fabricator_build_order], "multiplier")
	LAZYADD(.[/datum/fabricator_build_order], "remaining_time")
	LAZYADD(.[/datum/fabricator_build_order], "earmarked_materials")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/fabricator_recipe
	//
	LAZYADD(.[/datum/fabricator_recipe], "name")
	LAZYADD(.[/datum/fabricator_recipe], "path")
	LAZYADD(.[/datum/fabricator_recipe], "hidden")
	LAZYADD(.[/datum/fabricator_recipe], "category")
	LAZYADD(.[/datum/fabricator_recipe], "resources")
	LAZYADD(.[/datum/fabricator_recipe], "build_time")
	LAZYADD(.[/datum/fabricator_recipe], "ignore_materials")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/razorweb
	//
	LAZYADD(.[/obj/item/razorweb], "web_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/effect/fluid
	//
	LAZYADD(.[/obj/effect/fluid], "fluid_amount")
	LAZYADD(.[/obj/effect/fluid], "start_loc")
	LAZYADD(.[/obj/effect/fluid], "equalizing_fluids")
	LAZYADD(.[/obj/effect/fluid], "equalize_avg_depth")
	LAZYADD(.[/obj/effect/fluid], "equalize_avg_temp")
	LAZYADD(.[/obj/effect/fluid], "flow_amount")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/effect/effect/smoke/chem
	//
	LAZYADD(.[/obj/effect/effect/smoke/chem], "splash_amount")
	LAZYADD(.[/obj/effect/effect/smoke/chem], "destination")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/skillset
	//
	LAZYADD(.[/datum/skillset], "skill_list")
	LAZYADD(.[/datum/skillset], "owner")
	LAZYADD(.[/datum/skillset], "skill_buffs")
	LAZYADD(.[/datum/skillset], "time_skills_set")
	LAZYADD(.[/datum/skillset], "points_remaining")


	for(var/type in .)
		for (var/subtype in subtypesof(type))
			for (var/v in .[type])
				LAZYDISTINCTADD(.[subtype], v)

