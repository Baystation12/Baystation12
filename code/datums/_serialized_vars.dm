/proc/initialize_saved_vars()
	. = list()

	//////////////////////////////////////////////////////////////////////////////
	//
	// /atom/movable
	//
	LAZYADD(.[/atom/movable], "fingerprints")
	LAZYADD(.[/atom/movable], "fingerprintslast")
	LAZYADD(.[/atom/movable], "fingerprintshidden")
	LAZYADD(.[/atom/movable], "suit_fibers")
	LAZYADD(.[/atom/movable], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/computer_file/data/email_account
	//
	LAZYADD(.[/datum/computer_file/data/email_account], "login")
	LAZYADD(.[/datum/computer_file/data/email_account], "password")
	LAZYADD(.[/datum/computer_file/data/email_account], "inbox")
	LAZYADD(.[/datum/computer_file/data/email_account], "spam")
	LAZYADD(.[/datum/computer_file/data/email_account], "deleted")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/computer_file/data/email_message
	//
	LAZYADD(.[/datum/computer_file/data/email_message], "title")
	LAZYADD(.[/datum/computer_file/data/email_message], "stored_datd")
	LAZYADD(.[/datum/computer_file/data/email_message], "spam")
	LAZYADD(.[/datum/computer_file/data/email_message], "attachment")
	LAZYADD(.[/datum/computer_file/data/email_message], "timestamp")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/computer_file/data
	//
	LAZYADD(.[/datum/computer_file/data], "filetype")
	LAZYADD(.[/datum/computer_file/data], "filename")
	LAZYADD(.[/datum/computer_file/data], "size")
	LAZYADD(.[/datum/computer_file/data], "holder")
	LAZYADD(.[/datum/computer_file/data], "stored_datd")
	LAZYADD(.[/datum/computer_file/data], "block_size")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/computer_file/program
	//
	LAZYADD(.[/datum/computer_file/program], "program_state")
	LAZYADD(.[/datum/computer_file/program], "computer")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/computer_file/report/crew_record
	//
	LAZYADD(.[/datum/computer_file/report/crew_record], "ckey")
	LAZYADD(.[/datum/computer_file/report/crew_record], "network_level")
	LAZYADD(.[/datum/computer_file/report/crew_record], "citizenship")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/dna
	//
	LAZYADD(.[/datum/dna], "b_type")
	LAZYADD(.[/datum/dna], "unique_enzymes")
	LAZYADD(.[/datum/dna], "struc_enzymes")
	LAZYADD(.[/datum/dna], "species")
	LAZYADD(.[/datum/dna], "SE")
	LAZYADD(.[/datum/dna], "UI")
	LAZYADD(.[/datum/dna], "real_name")
	LAZYADD(.[/datum/dna], "uni_identity")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/extension/holster
	//
	LAZYADD(.[/datum/extension/holster], "holstered")
	LAZYADD(.[/datum/extension/holster], "holder")
	LAZYADD(.[/datum/extension/holster], "storage")
	LAZYADD(.[/datum/extension/holster], "atom_holder")
	LAZYADD(.[/datum/extension/holster], "can_holster")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/fluidtrack
	//
	LAZYADD(.[/datum/fluidtrack], "basecolor")
	LAZYADD(.[/datum/fluidtrack], "crusty")
	LAZYADD(.[/datum/fluidtrack], "direction")


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
	// /datum/integrated_io/activate
	//
	LAZYADD(.[/datum/integrated_io/activate], "holder")
	LAZYADD(.[/datum/integrated_io/activate], "linked")
	LAZYADD(.[/datum/integrated_io/activate], "io_type")
	LAZYADD(.[/datum/integrated_io/activate], "name")
	LAZYADD(.[/datum/integrated_io/activate], "data")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/integrated_io
	//
	LAZYADD(.[/datum/integrated_io], "pin_type")
	LAZYADD(.[/datum/integrated_io], "ord")
	LAZYADD(.[/datum/integrated_io], "linked")
	LAZYADD(.[/datum/integrated_io], "io_type")
	LAZYADD(.[/datum/integrated_io], "holder")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/mind
	//
	LAZYADD(.[/datum/mind], "memory")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/money_account
	//
	LAZYADD(.[/datum/money_account], "transaction_log")
	LAZYADD(.[/datum/money_account], "account_number")
	LAZYADD(.[/datum/money_account], "money")
	LAZYADD(.[/datum/money_account], "owner_name")
	LAZYADD(.[/datum/money_account], "remote_access_pin")
	LAZYADD(.[/datum/money_account], "suspended")
	LAZYADD(.[/datum/money_account], "security_level")
	LAZYADD(.[/datum/money_account], "account_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/ntnet
	//
	LAZYADD(.[/datum/ntnet], "name")
	LAZYADD(.[/datum/ntnet], "net_uid")
	LAZYADD(.[/datum/ntnet], "invisible")
	LAZYADD(.[/datum/ntnet], "secured")
	LAZYADD(.[/datum/ntnet], "password")
	LAZYADD(.[/datum/ntnet], "holder")
	LAZYADD(.[/datum/ntnet], "chat_channels")
	LAZYADD(.[/datum/ntnet], "email_accounts")
	LAZYADD(.[/datum/ntnet], "banned_nids")
	LAZYADD(.[/datum/ntnet], "setting_maxlogcount")
	LAZYADD(.[/datum/ntnet], "setting_softwaredownload")
	LAZYADD(.[/datum/ntnet], "setting_peertopeer")
	LAZYADD(.[/datum/ntnet], "setting_communication")


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
	LAZYADD(.[/datum/reagent], "datd")
	LAZYADD(.[/datum/reagent], "volume")
	LAZYADD(.[/datum/reagent], "ingest_met")
	LAZYADD(.[/datum/reagent], "touch_met")
	LAZYADD(.[/datum/reagent], "holder")


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
	LAZYADD(.[/datum/reagents], "my_atom")
	LAZYADD(.[/datum/reagents], "reagent_list")
	LAZYADD(.[/datum/reagents], "total_volume")
	LAZYADD(.[/datum/reagents], "maximum_volume")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/research
	//
	LAZYADD(.[/datum/research], "known_designs")
	LAZYADD(.[/datum/research], "known_tech")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/robot_component/cell
	//
	LAZYADD(.[/datum/robot_component/cell], "stored_cell")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/robot_component
	//
	LAZYADD(.[/datum/robot_component], "owner")
	LAZYADD(.[/datum/robot_component], "installed")
	LAZYADD(.[/datum/robot_component], "powered")
	LAZYADD(.[/datum/robot_component], "toggled")
	LAZYADD(.[/datum/robot_component], "brute_damage")
	LAZYADD(.[/datum/robot_component], "electronics_damage")
	LAZYADD(.[/datum/robot_component], "wrapped")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/seed
	//
	LAZYADD(.[/datum/seed], "name")
	LAZYADD(.[/datum/seed], "seed_name")
	LAZYADD(.[/datum/seed], "display_name")
	LAZYADD(.[/datum/seed], "seed_noun")
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
	LAZYADD(.[/datum/shuttle], "bridge")
	LAZYADD(.[/datum/shuttle], "owner")
	LAZYADD(.[/datum/shuttle], "ownertype")
	LAZYADD(.[/datum/shuttle], "size")
	LAZYADD(.[/datum/shuttle], "finalized")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/stored_items
	//
	LAZYADD(.[/datum/stored_items], "storing_object")
	LAZYADD(.[/datum/stored_items], "item_path")
	LAZYADD(.[/datum/stored_items], "item_name")
	LAZYADD(.[/datum/stored_items], "amount")
	LAZYADD(.[/datum/stored_items], "instances")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/biotech
	//
	LAZYADD(.[/datum/tech/biotech], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/bluespace
	//
	LAZYADD(.[/datum/tech/bluespace], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/combat
	//
	LAZYADD(.[/datum/tech/combat], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/engineering
	//
	LAZYADD(.[/datum/tech/engineering], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/magnets
	//
	LAZYADD(.[/datum/tech/magnets], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/materials
	//
	LAZYADD(.[/datum/tech/materials], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/phorontech
	//
	LAZYADD(.[/datum/tech/phorontech], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/powerstorage
	//
	LAZYADD(.[/datum/tech/powerstorage], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/tech/programming
	//
	LAZYADD(.[/datum/tech/programming], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/transaction
	//
	LAZYADD(.[/datum/transaction], "date")
	LAZYADD(.[/datum/transaction], "amount")
	LAZYADD(.[/datum/transaction], "target_name")
	LAZYADD(.[/datum/transaction], "tag")
	LAZYADD(.[/datum/transaction], "time")
	LAZYADD(.[/datum/transaction], "purpose")
	LAZYADD(.[/datum/transaction], "source_terminal")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/turbolift
	//
	LAZYADD(.[/datum/turbolift], "control_panel_interior")
	LAZYADD(.[/datum/turbolift], "current_floor")
	LAZYADD(.[/datum/turbolift], "current_floor")
	LAZYADD(.[/datum/turbolift], "doors")
	LAZYADD(.[/datum/turbolift], "floors")
	LAZYADD(.[/datum/turbolift], "doors")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/turbolift_floor
	//
	LAZYADD(.[/datum/turbolift_floor], "doors")
	LAZYADD(.[/datum/turbolift_floor], "ext_panel")
	LAZYADD(.[/datum/turbolift_floor], "label")
	LAZYADD(.[/datum/turbolift_floor], "name")
	LAZYADD(.[/datum/turbolift_floor], "announce_str")
	LAZYADD(.[/datum/turbolift_floor], "arrival_sound")
	LAZYADD(.[/datum/turbolift_floor], "area_contents")
	LAZYADD(.[/datum/turbolift_floor], "extra_turfs")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /datum/wires/airlock
	//
	LAZYADD(.[/datum/wires/airlock], "holder")


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
	// /image
	//
	LAZYADD(.[/image], "color")
	LAZYADD(.[/image], "transform")
	LAZYADD(.[/image], "icon")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/bot
	//
	LAZYADD(.[/mob/living/bot], "faction")
	LAZYADD(.[/mob/living/bot], "req_access_faction")
	LAZYADD(.[/mob/living/bot], "on")
	LAZYADD(.[/mob/living/bot], "will_patrol")
	LAZYADD(.[/mob/living/bot], "open")
	LAZYADD(.[/mob/living/bot], "name")
	LAZYADD(.[/mob/living/bot], "locked")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/carbon/human
	//
	LAZYADD(.[/mob/living/carbon/human], "wear_suit")
	LAZYADD(.[/mob/living/carbon/human], "w_uniform")
	LAZYADD(.[/mob/living/carbon/human], "shoes")
	LAZYADD(.[/mob/living/carbon/human], "belt")
	LAZYADD(.[/mob/living/carbon/human], "gloves")
	LAZYADD(.[/mob/living/carbon/human], "glasses")
	LAZYADD(.[/mob/living/carbon/human], "head")
	LAZYADD(.[/mob/living/carbon/human], "l_ear")
	LAZYADD(.[/mob/living/carbon/human], "r_ear")
	LAZYADD(.[/mob/living/carbon/human], "wear_id")
	LAZYADD(.[/mob/living/carbon/human], "r_store")
	LAZYADD(.[/mob/living/carbon/human], "l_store")
	LAZYADD(.[/mob/living/carbon/human], "s_store")
	LAZYADD(.[/mob/living/carbon/human], "skills")
	LAZYADD(.[/mob/living/carbon/human], "r_skin")
	LAZYADD(.[/mob/living/carbon/human], "g_skin")
	LAZYADD(.[/mob/living/carbon/human], "b_skin")
	LAZYADD(.[/mob/living/carbon/human], "s_tone")
	LAZYADD(.[/mob/living/carbon/human], "s_tone")
	LAZYADD(.[/mob/living/carbon/human], "r_eyes")
	LAZYADD(.[/mob/living/carbon/human], "r_eyes")
	LAZYADD(.[/mob/living/carbon/human], "g_eyes")
	LAZYADD(.[/mob/living/carbon/human], "g_eyes")
	LAZYADD(.[/mob/living/carbon/human], "g_eyes")
	LAZYADD(.[/mob/living/carbon/human], "b_eyes")
	LAZYADD(.[/mob/living/carbon/human], "b_eyes")
	LAZYADD(.[/mob/living/carbon/human], "b_type")
	LAZYADD(.[/mob/living/carbon/human], "home_system")
	LAZYADD(.[/mob/living/carbon/human], "citizenship")
	LAZYADD(.[/mob/living/carbon/human], "personal_faction")
	LAZYADD(.[/mob/living/carbon/human], "r_facial")
	LAZYADD(.[/mob/living/carbon/human], "g_facial")
	LAZYADD(.[/mob/living/carbon/human], "b_facial")
	LAZYADD(.[/mob/living/carbon/human], "f_style")
	LAZYADD(.[/mob/living/carbon/human], "h_style")
	LAZYADD(.[/mob/living/carbon/human], "r_hair")
	LAZYADD(.[/mob/living/carbon/human], "g_hair")
	LAZYADD(.[/mob/living/carbon/human], "b_hair")
	LAZYADD(.[/mob/living/carbon/human], "internal_organs")
	LAZYADD(.[/mob/living/carbon/human], "internal_organs_by_name")
	LAZYADD(.[/mob/living/carbon/human], "organs")
	LAZYADD(.[/mob/living/carbon/human], "organs_by_name")
	LAZYADD(.[/mob/living/carbon/human], "species")
	LAZYADD(.[/mob/living/carbon/human], "worn_underwear")
	LAZYADD(.[/mob/living/carbon/human], "r_hand")
	LAZYADD(.[/mob/living/carbon/human], "l_hand")
	LAZYADD(.[/mob/living/carbon/human], "handcuffed")
	LAZYADD(.[/mob/living/carbon/human], "back")
	LAZYADD(.[/mob/living/carbon/human], "wearing_rig")
	LAZYADD(.[/mob/living/carbon/human], "languages")
	LAZYADD(.[/mob/living/carbon/human], "languages")
	LAZYADD(.[/mob/living/carbon/human], "wear_mask")
	LAZYADD(.[/mob/living/carbon/human], "flavor_text")
	LAZYADD(.[/mob/living/carbon/human], "flavor_texts")
	LAZYADD(.[/mob/living/carbon/human], "virus2")
	LAZYADD(.[/mob/living/carbon/human], "chem_doses")
	LAZYADD(.[/mob/living/carbon/human], "chem_effects")
	LAZYADD(.[/mob/living/carbon/human], "bhunger")
	LAZYADD(.[/mob/living/carbon/human], "bad_external_organs")
	LAZYADD(.[/mob/living/carbon/human], "phoronation")
	LAZYADD(.[/mob/living/carbon/human], "phoron_alert")
	LAZYADD(.[/mob/living/carbon/human], "stuttering")
	LAZYADD(.[/mob/living/carbon/human], "age")
	LAZYADD(.[/mob/living/carbon/human], "spawn_personal")
	LAZYADD(.[/mob/living/carbon/human], "spawn_p_z")
	LAZYADD(.[/mob/living/carbon/human], "spawn_p_x")
	LAZYADD(.[/mob/living/carbon/human], "spawn_p_y")
	LAZYADD(.[/mob/living/carbon/human], "auras")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/carbon/slime
	//
	LAZYADD(.[/mob/living/carbon/slime], "colour")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/carbon
	//
	LAZYADD(.[/mob/living/carbon], "bloodstr")
	LAZYADD(.[/mob/living/carbon], "ingested")
	LAZYADD(.[/mob/living/carbon], "reagents")
	LAZYADD(.[/mob/living/carbon], "touching")
	LAZYADD(.[/mob/living/carbon], "nutrition")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/silicon/robot
	//
	LAZYADD(.[/mob/living/silicon/robot], "lmi")
	LAZYADD(.[/mob/living/silicon/robot], "mmi")
	LAZYADD(.[/mob/living/silicon/robot], "components")
	LAZYADD(.[/mob/living/silicon/robot], "cell")
	LAZYADD(.[/mob/living/silicon/robot], "name")
	LAZYADD(.[/mob/living/silicon/robot], "module")
	LAZYADD(.[/mob/living/silicon/robot], "installed_module")
	LAZYADD(.[/mob/living/silicon/robot], "chassis_mod")
	LAZYADD(.[/mob/living/silicon/robot], "chassis_mod_toggled")
	LAZYADD(.[/mob/living/silicon/robot], "stat")
	LAZYADD(.[/mob/living/silicon/robot], "silicon_radio")
	LAZYADD(.[/mob/living/silicon/robot], "module_state_1")
	LAZYADD(.[/mob/living/silicon/robot], "module_state_2")
	LAZYADD(.[/mob/living/silicon/robot], "module_state_3")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/simple_animal/cat
	//
	LAZYADD(.[/mob/living/simple_animal/cat], "desc")
	LAZYADD(.[/mob/living/simple_animal/cat], "name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/simple_animal/corgi/puppy
	//
	LAZYADD(.[/mob/living/simple_animal/corgi/puppy], "maxHealth")
	LAZYADD(.[/mob/living/simple_animal/corgi/puppy], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/simple_animal/corgi
	//
	LAZYADD(.[/mob/living/simple_animal/corgi], "real_name")
	LAZYADD(.[/mob/living/simple_animal/corgi], "desc")
	LAZYADD(.[/mob/living/simple_animal/corgi], "name")
	LAZYADD(.[/mob/living/simple_animal/corgi], "speak_emote")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/simple_animal/hostile/giant_spider/hunter
	//
	LAZYADD(.[/mob/living/simple_animal/hostile/giant_spider/hunter], "name")
	LAZYADD(.[/mob/living/simple_animal/hostile/giant_spider/hunter], "melee_damage_upper")
	LAZYADD(.[/mob/living/simple_animal/hostile/giant_spider/hunter], "melee_damage_lower")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/simple_animal/hostile
	//
	LAZYADD(.[/mob/living/simple_animal/hostile], "attack_same")
	LAZYADD(.[/mob/living/simple_animal/hostile], "desc")
	LAZYADD(.[/mob/living/simple_animal/hostile], "faction")
	LAZYADD(.[/mob/living/simple_animal/hostile], "name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living/simple_animal/lizard
	//
	LAZYADD(.[/mob/living/simple_animal/lizard], "name")
	LAZYADD(.[/mob/living/simple_animal/lizard], "desc")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob/living
	//
	LAZYADD(.[/mob/living], "health")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /mob
	//
	LAZYADD(.[/mob], "real_name")
	LAZYADD(.[/mob], "mind")
	LAZYADD(.[/mob], "contents")
	LAZYADD(.[/mob], "dnd")
	LAZYADD(.[/mob], "feet_blood_color")
	LAZYADD(.[/mob], "gender")
	LAZYADD(.[/mob], "spawn_type")
	LAZYADD(.[/mob], "spawn_loc")
	LAZYADD(.[/mob], "spawn_loc_2")
	LAZYADD(.[/mob], "stat")
	LAZYADD(.[/mob], "languages")
	LAZYADD(.[/mob], "save_slot")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/effect/decal/cleanable/blood/tracks/footprints
	//
	LAZYADD(.[/obj/effect/decal/cleanable/blood/tracks/footprints], "stack")
	LAZYADD(.[/obj/effect/decal/cleanable/blood/tracks/footprints], "setdirs")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/effect/floor_decal
	//
	LAZYADD(.[/obj/effect/floor_decal], "supplied_dir")
	LAZYADD(.[/obj/effect/floor_decal], "plane")
	LAZYADD(.[/obj/effect/floor_decal], "layer")
	LAZYADD(.[/obj/effect/floor_decal], "appearance_flags")
	LAZYADD(.[/obj/effect/floor_decal], "color")
	LAZYADD(.[/obj/effect/floor_decal], "alpha")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/ammo_casing
	//
	LAZYADD(.[/obj/item/ammo_casing], "BB")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/ammo_magazine
	//
	LAZYADD(.[/obj/item/ammo_magazine], "ammo_states")
	LAZYADD(.[/obj/item/ammo_magazine], "ammo_type")
	LAZYADD(.[/obj/item/ammo_magazine], "stored_ammo")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/accessory/medal/iron
	//
	LAZYADD(.[/obj/item/clothing/accessory/medal/iron], "name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/accessory/storage/holster
	//
	LAZYADD(.[/obj/item/clothing/accessory/storage/holster], "extensions")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/accessory/storage
	//
	LAZYADD(.[/obj/item/clothing/accessory/storage], "hold")
	LAZYADD(.[/obj/item/clothing/accessory/storage], "slots")
	LAZYADD(.[/obj/item/clothing/accessory/storage], "slot_flags")
	LAZYADD(.[/obj/item/clothing/accessory/storage], "extensions")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/accessory/toggleable/hawaii/random
	//
	LAZYADD(.[/obj/item/clothing/accessory/toggleable/hawaii/random], "icon_closed")
	LAZYADD(.[/obj/item/clothing/accessory/toggleable/hawaii/random], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/accessory/wcoat
	//
	LAZYADD(.[/obj/item/clothing/accessory/wcoat], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/accessory
	//
	LAZYADD(.[/obj/item/clothing/accessory], "has_suit")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/gloves/color/evening
	//
	LAZYADD(.[/obj/item/clothing/gloves/color/evening], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/gloves/insulated
	//
	LAZYADD(.[/obj/item/clothing/gloves/insulated], "species_restricted")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/gloves/rig
	//
	LAZYADD(.[/obj/item/clothing/gloves/rig], "max_heat_protection_temperature")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/gloves
	//
	LAZYADD(.[/obj/item/clothing/gloves], "ring")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/head/helmet/space/void/excavation
	//
	LAZYADD(.[/obj/item/clothing/head/helmet/space/void/excavation], "species_restricted")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/head/helmet/space/void/security/alt
	//
	LAZYADD(.[/obj/item/clothing/head/helmet/space/void/security/alt], "item_state")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/head/welding
	//
	LAZYADD(.[/obj/item/clothing/head/welding], "up")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/head/wizard/fake
	//
	LAZYADD(.[/obj/item/clothing/head/wizard/fake], "color")


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
	LAZYADD(.[/obj/item/clothing/ring/material], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/shoes/magboots
	//
	LAZYADD(.[/obj/item/clothing/shoes/magboots], "shoes")
	LAZYADD(.[/obj/item/clothing/shoes/magboots], "wearer")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/shoes
	//
	LAZYADD(.[/obj/item/clothing/shoes], "overshoes")
	LAZYADD(.[/obj/item/clothing/shoes], "holding")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/suit/armor/pcarrier/medium
	//
	LAZYADD(.[/obj/item/clothing/suit/armor/pcarrier/medium], "item_icons")
	LAZYADD(.[/obj/item/clothing/suit/armor/pcarrier/medium], "icon_state")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/suit/space/void
	//
	LAZYADD(.[/obj/item/clothing/suit/space/void], "helmet")
	LAZYADD(.[/obj/item/clothing/suit/space/void], "boots")
	LAZYADD(.[/obj/item/clothing/suit/space/void], "tank")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/suit/storage/toggle/hoodie
	//
	LAZYADD(.[/obj/item/clothing/suit/storage/toggle/hoodie], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/suit/storage
	//
	LAZYADD(.[/obj/item/clothing/suit/storage], "pockets")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/suit
	//
	LAZYADD(.[/obj/item/clothing/suit], "allowed")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/under/caretaker
	//
	LAZYADD(.[/obj/item/clothing/under/caretaker], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/under/rank/psych/turtleneck/sweater
	//
	LAZYADD(.[/obj/item/clothing/under/rank/psych/turtleneck/sweater], "contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/under/skirt_c/dress/long/gown
	//
	LAZYADD(.[/obj/item/clothing/under/skirt_c/dress/long/gown], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/under/skirt_c/dress/long
	//
	LAZYADD(.[/obj/item/clothing/under/skirt_c/dress/long], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/under/suit_jacket/charcoal
	//
	LAZYADD(.[/obj/item/clothing/under/suit_jacket/charcoal], "contents")
	LAZYADD(.[/obj/item/clothing/under/suit_jacket/charcoal], "accessories")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing/under
	//
	LAZYADD(.[/obj/item/clothing/under], "sensor_mode")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/clothing
	//
	LAZYADD(.[/obj/item/clothing], "accessories")
	LAZYADD(.[/obj/item/clothing], "gunshot_residue")
	LAZYADD(.[/obj/item/clothing], "species_restricted")


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
	LAZYADD(.[/obj/item/device/assembly/prox_sensor], "time")
	LAZYADD(.[/obj/item/device/assembly/prox_sensor], "timing")
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
	LAZYADD(.[/obj/item/device/assembly/signaler], "radio_connection")
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
	LAZYADD(.[/obj/item/device/assembly], "holder")
	LAZYADD(.[/obj/item/device/assembly], "cooldown")
	LAZYADD(.[/obj/item/device/assembly], "wires")
	LAZYADD(.[/obj/item/device/assembly], "attached_overlays")


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
	// /obj/item/device/camera
	//
	LAZYADD(.[/obj/item/device/camera], "icon")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/electronic_assembly/medium
	//
	LAZYADD(.[/obj/item/device/electronic_assembly/medium], "opened")
	LAZYADD(.[/obj/item/device/electronic_assembly/medium], "applied_shell")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/electronic_assembly
	//
	LAZYADD(.[/obj/item/device/electronic_assembly], "opened")
	LAZYADD(.[/obj/item/device/electronic_assembly], "battery")
	LAZYADD(.[/obj/item/device/electronic_assembly], "assembly_components")


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
	// /obj/item/device/radio/borg
	//
	LAZYADD(.[/obj/item/device/radio/borg], "myborg")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/radio/headset
	//
	LAZYADD(.[/obj/item/device/radio/headset], "ks1type")
	LAZYADD(.[/obj/item/device/radio/headset], "ks2type")
	LAZYADD(.[/obj/item/device/radio/headset], "keyslot2")
	LAZYADD(.[/obj/item/device/radio/headset], "channels")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/radio
	//
	LAZYADD(.[/obj/item/device/radio], "frequency")
	LAZYADD(.[/obj/item/device/radio], "faction_uid")
	LAZYADD(.[/obj/item/device/radio], "wires")
	LAZYADD(.[/obj/item/device/radio], "b_stat")
	LAZYADD(.[/obj/item/device/radio], "broadcasting")
	LAZYADD(.[/obj/item/device/radio], "listening")
	LAZYADD(.[/obj/item/device/radio], "public_mode")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/tankassemblyproxy
	//
	LAZYADD(.[/obj/item/device/tankassemblyproxy], "tank")
	LAZYADD(.[/obj/item/device/tankassemblyproxy], "assembly")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/device/taperecorder
	//
	LAZYADD(.[/obj/item/device/taperecorder], "mytape")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/disposal_switch_construct
	//
	LAZYADD(.[/obj/item/disposal_switch_construct], "id_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/glass_jar
	//
	LAZYADD(.[/obj/item/glass_jar], "contains")
	LAZYADD(.[/obj/item/glass_jar], "contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/integrated_circuit/filter/ref
	//
	LAZYADD(.[/obj/item/integrated_circuit/filter/ref], "filter_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/integrated_circuit/manipulation/ai
	//
	LAZYADD(.[/obj/item/integrated_circuit/manipulation/ai], "aicard")
	LAZYADD(.[/obj/item/integrated_circuit/manipulation/ai], "controlling")


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
	LAZYADD(.[/obj/item/integrated_circuit], "reagents")


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
	LAZYADD(.[/obj/item/modular_computer], "dna_scanner")
	LAZYADD(.[/obj/item/modular_computer], "logistic_processor")
	LAZYADD(.[/obj/item/modular_computer], "health")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/organ/external/head
	//
	LAZYADD(.[/obj/item/organ/external/head], "h_col")
	LAZYADD(.[/obj/item/organ/external/head], "eye_icon")
	LAZYADD(.[/obj/item/organ/external/head], "eye_icon_location")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/organ/external
	//
	LAZYADD(.[/obj/item/organ/external], "pain")
	LAZYADD(.[/obj/item/organ/external], "number_wounds")
	LAZYADD(.[/obj/item/organ/external], "parent")
	LAZYADD(.[/obj/item/organ/external], "children")
	LAZYADD(.[/obj/item/organ/external], "internal_organs")
	LAZYADD(.[/obj/item/organ/external], "sabotaged")
	LAZYADD(.[/obj/item/organ/external], "implants")
	LAZYADD(.[/obj/item/organ/external], "genetic_degradation")
	LAZYADD(.[/obj/item/organ/external], "autopsy_datd")
	LAZYADD(.[/obj/item/organ/external], "can_grasp")
	LAZYADD(.[/obj/item/organ/external], "can_stand")
	LAZYADD(.[/obj/item/organ/external], "disfigured")
	LAZYADD(.[/obj/item/organ/external], "dislocated")
	LAZYADD(.[/obj/item/organ/external], "encased")
	LAZYADD(.[/obj/item/organ/external], "stage")
	LAZYADD(.[/obj/item/organ/external], "cavity")
	LAZYADD(.[/obj/item/organ/external], "wounds")
	LAZYADD(.[/obj/item/organ/external], "splinted")
	LAZYADD(.[/obj/item/organ/external], "applied_pressure")
	LAZYADD(.[/obj/item/organ/external], "s_col")
	LAZYADD(.[/obj/item/organ/external], "s_tone")
	LAZYADD(.[/obj/item/organ/external], "s_col_blend")
	LAZYADD(.[/obj/item/organ/external], "was_bloodied")
	LAZYADD(.[/obj/item/organ/external], "model")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/organ/internal/eyes
	//
	LAZYADD(.[/obj/item/organ/internal/eyes], "eye_colour")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/organ
	//
	LAZYADD(.[/obj/item/organ], "status")
	LAZYADD(.[/obj/item/organ], "robotic")
	LAZYADD(.[/obj/item/organ], "owner")
	LAZYADD(.[/obj/item/organ], "dnd")
	LAZYADD(.[/obj/item/organ], "species")
	LAZYADD(.[/obj/item/organ], "damage")
	LAZYADD(.[/obj/item/organ], "rejecting")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/pipe
	//
	LAZYADD(.[/obj/item/pipe], "pipe_type")
	LAZYADD(.[/obj/item/pipe], "connect_types")
	LAZYADD(.[/obj/item/pipe], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/pizzabox
	//
	LAZYADD(.[/obj/item/pizzabox], "pizzd")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/rig_module
	//
	LAZYADD(.[/obj/item/rig_module], "holder")
	LAZYADD(.[/obj/item/rig_module], "active")
	LAZYADD(.[/obj/item/rig_module], "charges")
	LAZYADD(.[/obj/item/rig_module], "charge_selected")


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
	LAZYADD(.[/obj/item/seeds], "density")
	LAZYADD(.[/obj/item/seeds], "seed")
	LAZYADD(.[/obj/item/seeds], "seed_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/smallDelivery
	//
	LAZYADD(.[/obj/item/smallDelivery], "wrapped")
	LAZYADD(.[/obj/item/smallDelivery], "sortTag")
	LAZYADD(.[/obj/item/smallDelivery], "examtext")
	LAZYADD(.[/obj/item/smallDelivery], "nameset")
	LAZYADD(.[/obj/item/smallDelivery], "tag_x")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/stack/material/generic
	//
	LAZYADD(.[/obj/item/stack/material/generic], "material")


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
	LAZYADD(.[/obj/item/underwear], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/airlock_brace
	//
	LAZYADD(.[/obj/item/weapon/airlock_brace], "cur_health")
	LAZYADD(.[/obj/item/weapon/airlock_brace], "electronics")
	LAZYADD(.[/obj/item/weapon/airlock_brace], "airlock")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/airlock_electronics
	//
	LAZYADD(.[/obj/item/weapon/airlock_electronics], "conf_access")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/beach_ball
	//
	LAZYADD(.[/obj/item/weapon/beach_ball], "name")


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
	// /obj/item/weapon/cannonframe
	//
	LAZYADD(.[/obj/item/weapon/cannonframe], "buildstate")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/card/id
	//
	LAZYADD(.[/obj/item/weapon/card/id], "age")
	LAZYADD(.[/obj/item/weapon/card/id], "blood_type")
	LAZYADD(.[/obj/item/weapon/card/id], "dna_hash")
	LAZYADD(.[/obj/item/weapon/card/id], "fingerprint_hash")
	LAZYADD(.[/obj/item/weapon/card/id], "sex")
	LAZYADD(.[/obj/item/weapon/card/id], "assignment")
	LAZYADD(.[/obj/item/weapon/card/id], "rank")
	LAZYADD(.[/obj/item/weapon/card/id], "job_access_type")
	LAZYADD(.[/obj/item/weapon/card/id], "access")
	LAZYADD(.[/obj/item/weapon/card/id], "registered_name")
	LAZYADD(.[/obj/item/weapon/card/id], "associated_account_number")
	LAZYADD(.[/obj/item/weapon/card/id], "selected_faction")
	LAZYADD(.[/obj/item/weapon/card/id], "approved_factions")
	LAZYADD(.[/obj/item/weapon/card/id], "valid")
	LAZYADD(.[/obj/item/weapon/card/id], "validate_time")
	LAZYADD(.[/obj/item/weapon/card/id], "selected_business")


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
	// /obj/item/weapon/cell
	//
	LAZYADD(.[/obj/item/weapon/cell], "c_uid")
	LAZYADD(.[/obj/item/weapon/cell], "charge")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/deck/holder
	//
	LAZYADD(.[/obj/item/weapon/deck/holder], "contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/disk/botany
	//
	LAZYADD(.[/obj/item/weapon/disk/botany], "genesource")
	LAZYADD(.[/obj/item/weapon/disk/botany], "genes")
	LAZYADD(.[/obj/item/weapon/disk/botany], "desc")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/disk/tech_disk
	//
	LAZYADD(.[/obj/item/weapon/disk/tech_disk], "stored")
	LAZYADD(.[/obj/item/weapon/disk/tech_disk], "name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/ducttape
	//
	LAZYADD(.[/obj/item/weapon/ducttape], "stuck")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/flamethrower/full
	//
	LAZYADD(.[/obj/item/weapon/flamethrower/full], "ptank")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/flamethrower
	//
	LAZYADD(.[/obj/item/weapon/flamethrower], "weldtool")
	LAZYADD(.[/obj/item/weapon/flamethrower], "igniter")
	LAZYADD(.[/obj/item/weapon/flamethrower], "weldtool")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/grenade/chem_grenade
	//
	LAZYADD(.[/obj/item/weapon/grenade/chem_grenade], "beakers")
	LAZYADD(.[/obj/item/weapon/grenade/chem_grenade], "stage")
	LAZYADD(.[/obj/item/weapon/grenade/chem_grenade], "path")
	LAZYADD(.[/obj/item/weapon/grenade/chem_grenade], "detonator")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/grenade
	//
	LAZYADD(.[/obj/item/weapon/grenade], "det_time")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/energy/laser
	//
	LAZYADD(.[/obj/item/weapon/gun/energy/laser], "max_shots")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/energy/xray
	//
	LAZYADD(.[/obj/item/weapon/gun/energy/xray], "self_recharge")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/energy
	//
	LAZYADD(.[/obj/item/weapon/gun/energy], "cell_type")
	LAZYADD(.[/obj/item/weapon/gun/energy], "power_supply")
	LAZYADD(.[/obj/item/weapon/gun/energy], "charge_meter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/launcher/pneumatic
	//
	LAZYADD(.[/obj/item/weapon/gun/launcher/pneumatic], "item_storage")
	LAZYADD(.[/obj/item/weapon/gun/launcher/pneumatic], "tank")
	LAZYADD(.[/obj/item/weapon/gun/launcher/pneumatic], "pressure_setting")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/magnetic
	//
	LAZYADD(.[/obj/item/weapon/gun/magnetic], "cell")
	LAZYADD(.[/obj/item/weapon/gun/magnetic], "capacitor")
	LAZYADD(.[/obj/item/weapon/gun/magnetic], "loaded")
	LAZYADD(.[/obj/item/weapon/gun/magnetic], "load_type")
	LAZYADD(.[/obj/item/weapon/gun/magnetic], "load_type")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/gun/projectile
	//
	LAZYADD(.[/obj/item/weapon/gun/projectile], "ammo_magazine")


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
	LAZYADD(.[/obj/item/weapon/material], "color")


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
	// /obj/item/weapon/mop
	//
	LAZYADD(.[/obj/item/weapon/mop], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/ore
	//
	LAZYADD(.[/obj/item/weapon/ore], "geologic_datd")
	LAZYADD(.[/obj/item/weapon/ore], "matter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/paper
	//
	LAZYADD(.[/obj/item/weapon/paper], "info")
	LAZYADD(.[/obj/item/weapon/paper], "info_links")
	LAZYADD(.[/obj/item/weapon/paper], "icon_state")
	LAZYADD(.[/obj/item/weapon/paper], "ico")
	LAZYADD(.[/obj/item/weapon/paper], "stamped")
	LAZYADD(.[/obj/item/weapon/paper], "stamps")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/paper_bundle
	//
	LAZYADD(.[/obj/item/weapon/paper_bundle], "pages")
	LAZYADD(.[/obj/item/weapon/paper_bundle], "page")
	LAZYADD(.[/obj/item/weapon/paper_bundle], "contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/photo
	//
	LAZYADD(.[/obj/item/weapon/photo], "photo_size")
	LAZYADD(.[/obj/item/weapon/photo], "scribble")
	LAZYADD(.[/obj/item/weapon/photo], "icon")
	LAZYADD(.[/obj/item/weapon/photo], "transform")
	LAZYADD(.[/obj/item/weapon/photo], "tiny")
	LAZYADD(.[/obj/item/weapon/photo], "desc")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/rcd
	//
	LAZYADD(.[/obj/item/weapon/rcd], "stored_matter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/reagent_containers/food/snacks/grown
	//
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "color")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "filling_color")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "dried_type")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "seed")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "seed")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "reagents")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "germ_level")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "bitesize")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "amount_per_transfer_from_this")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "plantname")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "potency")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "potency")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "name")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "icon_state")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "cooked")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/grown], "dry")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
	//
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread], "filling_color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/reagent_containers/food/snacks/variable
	//
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "bitecount")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "bitesize")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "color")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "desc")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "icon")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "nutriment_amt")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "nutriment_desc")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "slices_num")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "slice_path")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "suffix")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "trash")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "cooked")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "dried_type")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "dry")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "possible_transfer_amounts")
	LAZYADD(.[/obj/item/weapon/reagent_containers/food/snacks/variable], "volume")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/reagent_containers/glass/bucket
	//
	LAZYADD(.[/obj/item/weapon/reagent_containers/glass/bucket], "volume")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/reagent_containers
	//
	LAZYADD(.[/obj/item/weapon/reagent_containers], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/rig
	//
	LAZYADD(.[/obj/item/weapon/rig], "hides_uniform")
	LAZYADD(.[/obj/item/weapon/rig], "air_supply")
	LAZYADD(.[/obj/item/weapon/rig], "boots")
	LAZYADD(.[/obj/item/weapon/rig], "chest")
	LAZYADD(.[/obj/item/weapon/rig], "helmet")
	LAZYADD(.[/obj/item/weapon/rig], "gloves")
	LAZYADD(.[/obj/item/weapon/rig], "cell")
	LAZYADD(.[/obj/item/weapon/rig], "selected_module")
	LAZYADD(.[/obj/item/weapon/rig], "visor")
	LAZYADD(.[/obj/item/weapon/rig], "speech")
	LAZYADD(.[/obj/item/weapon/rig], "wearer")
	LAZYADD(.[/obj/item/weapon/rig], "installed_modules")
	LAZYADD(.[/obj/item/weapon/rig], "open")
	LAZYADD(.[/obj/item/weapon/rig], "subverted")
	LAZYADD(.[/obj/item/weapon/rig], "interface_locked")
	LAZYADD(.[/obj/item/weapon/rig], "control_overridden")
	LAZYADD(.[/obj/item/weapon/rig], "ai_override_enabled")
	LAZYADD(.[/obj/item/weapon/rig], "locked")
	LAZYADD(.[/obj/item/weapon/rig], "security_check_enabled")
	LAZYADD(.[/obj/item/weapon/rig], "malfunctioning")
	LAZYADD(.[/obj/item/weapon/rig], "electrified")
	LAZYADD(.[/obj/item/weapon/rig], "locked_down")
	LAZYADD(.[/obj/item/weapon/rig], "offline")
	LAZYADD(.[/obj/item/weapon/rig], "airtight")
	LAZYADD(.[/obj/item/weapon/rig], "air_supply")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/robot_module/miner
	//
	LAZYADD(.[/obj/item/weapon/robot_module/miner], "modules")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/shield/energy
	//
	LAZYADD(.[/obj/item/weapon/shield/energy], "color")


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
	// /obj/item/weapon/storage/box/large
	//
	LAZYADD(.[/obj/item/weapon/storage/box/large], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/storage/internal
	//
	LAZYADD(.[/obj/item/weapon/storage/internal], "master_item")
	LAZYADD(.[/obj/item/weapon/storage/internal], "storage_slots")
	LAZYADD(.[/obj/item/weapon/storage/internal], "max_w_class")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/storage/secure/safe
	//
	LAZYADD(.[/obj/item/weapon/storage/secure/safe], "l_code")
	LAZYADD(.[/obj/item/weapon/storage/secure/safe], "pixel_x")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/storage/wallet/leather
	//
	LAZYADD(.[/obj/item/weapon/storage/wallet/leather], "contents")
	LAZYADD(.[/obj/item/weapon/storage/wallet/leather], "front_id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/storage
	//
	LAZYADD(.[/obj/item/weapon/storage], "max_storage_space")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/tank/anesthetic
	//
	LAZYADD(.[/obj/item/weapon/tank/anesthetic], "air_contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/tank/emergency
	//
	LAZYADD(.[/obj/item/weapon/tank/emergency], "air_contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/tank/oxygen
	//
	LAZYADD(.[/obj/item/weapon/tank/oxygen], "air_contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/tank
	//
	LAZYADD(.[/obj/item/weapon/tank], "air_contents")
	LAZYADD(.[/obj/item/weapon/tank], "volume")
	LAZYADD(.[/obj/item/weapon/tank], "starting_pressure")
	LAZYADD(.[/obj/item/weapon/tank], "distribute_pressure")
	LAZYADD(.[/obj/item/weapon/tank], "integrity")
	LAZYADD(.[/obj/item/weapon/tank], "valve_welded")
	LAZYADD(.[/obj/item/weapon/tank], "proxyassembly")
	LAZYADD(.[/obj/item/weapon/tank], "manipulated_by")
	LAZYADD(.[/obj/item/weapon/tank], "leaking")
	LAZYADD(.[/obj/item/weapon/tank], "wired")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/tape_roll
	//
	LAZYADD(.[/obj/item/weapon/tape_roll], "uses_left")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/item/weapon/welder_tank
	//
	LAZYADD(.[/obj/item/weapon/welder_tank], "reagents")


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
	// /obj/machinery/access_button
	//
	LAZYADD(.[/obj/machinery/access_button], "master_tag")
	LAZYADD(.[/obj/machinery/access_button], "frequency")
	LAZYADD(.[/obj/machinery/access_button], "command")
	LAZYADD(.[/obj/machinery/access_button], "on")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/airlock_sensor
	//
	LAZYADD(.[/obj/machinery/airlock_sensor], "id_tag")
	LAZYADD(.[/obj/machinery/airlock_sensor], "master_tag")
	LAZYADD(.[/obj/machinery/airlock_sensor], "frequency")
	LAZYADD(.[/obj/machinery/airlock_sensor], "command")
	LAZYADD(.[/obj/machinery/airlock_sensor], "on")
	LAZYADD(.[/obj/machinery/airlock_sensor], "alert")
	LAZYADD(.[/obj/machinery/airlock_sensor], "previousPressure")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/air_sensor
	//
	LAZYADD(.[/obj/machinery/air_sensor], "id_tag")
	LAZYADD(.[/obj/machinery/air_sensor], "frequency")
	LAZYADD(.[/obj/machinery/air_sensor], "output")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/alarm
	//
	LAZYADD(.[/obj/machinery/alarm], "target_temperature")
	LAZYADD(.[/obj/machinery/alarm], "TLV")
	LAZYADD(.[/obj/machinery/alarm], "wiresexposed")
	LAZYADD(.[/obj/machinery/alarm], "locked")
	LAZYADD(.[/obj/machinery/alarm], "mode")
	LAZYADD(.[/obj/machinery/alarm], "aidisabled")
	LAZYADD(.[/obj/machinery/alarm], "oxygen_dangerlevel")
	LAZYADD(.[/obj/machinery/alarm], "co2_dangerlevel")
	LAZYADD(.[/obj/machinery/alarm], "rcon_setting")
	LAZYADD(.[/obj/machinery/alarm], "regulating_temperature")
	LAZYADD(.[/obj/machinery/alarm], "report_danger_level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/binary/circulator
	//
	LAZYADD(.[/obj/machinery/atmospherics/binary/circulator], "anchored")
	LAZYADD(.[/obj/machinery/atmospherics/binary/circulator], "air1")
	LAZYADD(.[/obj/machinery/atmospherics/binary/circulator], "air2")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/binary/passive_gate
	//
	LAZYADD(.[/obj/machinery/atmospherics/binary/passive_gate], "unlocked")
	LAZYADD(.[/obj/machinery/atmospherics/binary/passive_gate], "icon_state")
	LAZYADD(.[/obj/machinery/atmospherics/binary/passive_gate], "target_pressure")
	LAZYADD(.[/obj/machinery/atmospherics/binary/passive_gate], "air1")
	LAZYADD(.[/obj/machinery/atmospherics/binary/passive_gate], "air2")
	LAZYADD(.[/obj/machinery/atmospherics/binary/passive_gate], "regulate_mode")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/binary/pump/high_power
	//
	LAZYADD(.[/obj/machinery/atmospherics/binary/pump/high_power], "target_pressure")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/binary/pump
	//
	LAZYADD(.[/obj/machinery/atmospherics/binary/pump], "target_pressure")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/omni/filter
	//
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "filtering_outputs")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "filters")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "input")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "output")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "ports")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "set_flow_rate")
	LAZYADD(.[/obj/machinery/atmospherics/omni/filter], "gas_filters")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/omni/mixer
	//
	LAZYADD(.[/obj/machinery/atmospherics/omni/mixer], "output")
	LAZYADD(.[/obj/machinery/atmospherics/omni/mixer], "a")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/omni
	//
	LAZYADD(.[/obj/machinery/atmospherics/omni], "overlays_on")
	LAZYADD(.[/obj/machinery/atmospherics/omni], "overlays_off")
	LAZYADD(.[/obj/machinery/atmospherics/omni], "initialize_directions")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	//
	LAZYADD(.[/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers], "icon")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/pipe/simple/hidden/supply
	//
	LAZYADD(.[/obj/machinery/atmospherics/pipe/simple/hidden/supply], "icon")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/pipe/simple
	//
	LAZYADD(.[/obj/machinery/atmospherics/pipe/simple], "air_temporary")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/pipe
	//
	LAZYADD(.[/obj/machinery/atmospherics/pipe], "air_temporary")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/pipeturbine
	//
	LAZYADD(.[/obj/machinery/atmospherics/pipeturbine], "node1")
	LAZYADD(.[/obj/machinery/atmospherics/pipeturbine], "node2")
	LAZYADD(.[/obj/machinery/atmospherics/pipeturbine], "network1")
	LAZYADD(.[/obj/machinery/atmospherics/pipeturbine], "network2")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/portables_connector
	//
	LAZYADD(.[/obj/machinery/atmospherics/portables_connector], "connected_device")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/trinary
	//
	LAZYADD(.[/obj/machinery/atmospherics/trinary], "airflow_speed")
	LAZYADD(.[/obj/machinery/atmospherics/trinary], "last_airflow")
	LAZYADD(.[/obj/machinery/atmospherics/trinary], "last_flow_rate")
	LAZYADD(.[/obj/machinery/atmospherics/trinary], "a")


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
	LAZYADD(.[/obj/machinery/atmospherics/unary/outlet_injector], "id")
	LAZYADD(.[/obj/machinery/atmospherics/unary/outlet_injector], "frequency")
	LAZYADD(.[/obj/machinery/atmospherics/unary/outlet_injector], "tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/unary/vent_pump
	//
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "pump_direction")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "welded")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "external_pressure_bound")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "pressure_checks")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "internal_pressure_bound")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_pump], "frequency")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/atmospherics/unary/vent_scrubber
	//
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_scrubber], "scrubbing")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_scrubber], "welded")
	LAZYADD(.[/obj/machinery/atmospherics/unary/vent_scrubber], "scrubbing_gas")


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
	LAZYADD(.[/obj/machinery/atmospherics], "level")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/beehive
	//
	LAZYADD(.[/obj/machinery/beehive], "frames")
	LAZYADD(.[/obj/machinery/beehive], "bee_count")


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
	// /obj/machinery/button
	//
	LAZYADD(.[/obj/machinery/button], "id")
	LAZYADD(.[/obj/machinery/button], "_wifi_id")
	LAZYADD(.[/obj/machinery/button], "wifi_sender")


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
	LAZYADD(.[/obj/machinery/chemical_dispenser], "contents")
	LAZYADD(.[/obj/machinery/chemical_dispenser], "cartridges")
	LAZYADD(.[/obj/machinery/chemical_dispenser], "container")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/chem_master
	//
	LAZYADD(.[/obj/machinery/chem_master], "beaker")


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
	// /obj/machinery/constructable_frame
	//
	LAZYADD(.[/obj/machinery/constructable_frame], "components")
	LAZYADD(.[/obj/machinery/constructable_frame], "req_components")
	LAZYADD(.[/obj/machinery/constructable_frame], "req_component_names")
	LAZYADD(.[/obj/machinery/constructable_frame], "state")
	LAZYADD(.[/obj/machinery/constructable_frame], "circuit")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/conveyor
	//
	LAZYADD(.[/obj/machinery/conveyor], "id")
	LAZYADD(.[/obj/machinery/conveyor], "forwards")
	LAZYADD(.[/obj/machinery/conveyor], "backwards")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/conveyor_switch
	//
	LAZYADD(.[/obj/machinery/conveyor_switch], "id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/cryopod
	//
	LAZYADD(.[/obj/machinery/cryopod], "applies_stasis")
	LAZYADD(.[/obj/machinery/cryopod], "network")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/deployable/barrier
	//
	LAZYADD(.[/obj/machinery/deployable/barrier], "anchored")
	LAZYADD(.[/obj/machinery/deployable/barrier], "locked")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/disposal
	//
	LAZYADD(.[/obj/machinery/disposal], "trunk")
	LAZYADD(.[/obj/machinery/disposal], "mode")
	LAZYADD(.[/obj/machinery/disposal], "air_contents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/disposal_switch
	//
	LAZYADD(.[/obj/machinery/disposal_switch], "on")
	LAZYADD(.[/obj/machinery/disposal_switch], "junctions")
	LAZYADD(.[/obj/machinery/disposal_switch], "id_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/airlock/command
	//
	LAZYADD(.[/obj/machinery/door/airlock/command], "color")


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
	LAZYADD(.[/obj/machinery/door/airlock], "id_tag")
	LAZYADD(.[/obj/machinery/door/airlock], "locked")
	LAZYADD(.[/obj/machinery/door/airlock], "frequency")
	LAZYADD(.[/obj/machinery/door/airlock], "welded")
	LAZYADD(.[/obj/machinery/door/airlock], "brace")
	LAZYADD(.[/obj/machinery/door/airlock], "lock_cut_state")
	LAZYADD(.[/obj/machinery/door/airlock], "secured_wires")
	LAZYADD(.[/obj/machinery/door/airlock], "safe")
	LAZYADD(.[/obj/machinery/door/airlock], "closeOtherId")
	LAZYADD(.[/obj/machinery/door/airlock], "closeOther")
	LAZYADD(.[/obj/machinery/door/airlock], "airlock_type")
	LAZYADD(.[/obj/machinery/door/airlock], "door_color")
	LAZYADD(.[/obj/machinery/door/airlock], "stripe_color")
	LAZYADD(.[/obj/machinery/door/airlock], "symbol_color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/blast
	//
	LAZYADD(.[/obj/machinery/door/blast], "opacity")
	LAZYADD(.[/obj/machinery/door/blast], "_wifi_id")
	LAZYADD(.[/obj/machinery/door/blast], "wifi_receiver")
	LAZYADD(.[/obj/machinery/door/blast], "id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/firedoor
	//
	LAZYADD(.[/obj/machinery/door/firedoor], "areas_added")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/door/unpowered/simple
	//
	LAZYADD(.[/obj/machinery/door/unpowered/simple], "lock")
	LAZYADD(.[/obj/machinery/door/unpowered/simple], "material")


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
	LAZYADD(.[/obj/machinery/door], "opacity")
	LAZYADD(.[/obj/machinery/door], "tile_air")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/embedded_controller/radio/airlock
	//
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "radio_filter")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_interior_door")
	LAZYADD(.[/obj/machinery/embedded_controller/radio/airlock], "tag_exterior_door")
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
	// /obj/machinery/floodlight
	//
	LAZYADD(.[/obj/machinery/floodlight], "cell")
	LAZYADD(.[/obj/machinery/floodlight], "anchored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/floorlayer
	//
	LAZYADD(.[/obj/machinery/floorlayer], "T")
	LAZYADD(.[/obj/machinery/floorlayer], "on")
	LAZYADD(.[/obj/machinery/floorlayer], "mode")
	LAZYADD(.[/obj/machinery/floorlayer], "old_turf")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/floor_light
	//
	LAZYADD(.[/obj/machinery/floor_light], "on")
	LAZYADD(.[/obj/machinery/floor_light], "anchored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/light
	//
	LAZYADD(.[/obj/machinery/light], "light_color")
	LAZYADD(.[/obj/machinery/light], "color")
	LAZYADD(.[/obj/machinery/light], "lightbulb")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/light_switch
	//
	LAZYADD(.[/obj/machinery/light_switch], "on")
	LAZYADD(.[/obj/machinery/light_switch], "icon_state")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/media/jukebox
	//
	LAZYADD(.[/obj/machinery/media/jukebox], "anchored")


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
	LAZYADD(.[/obj/machinery/mineral/processing_unit], "ores_stored")
	LAZYADD(.[/obj/machinery/mineral/processing_unit], "ores_processing")
	LAZYADD(.[/obj/machinery/mineral/processing_unit], "active")
	LAZYADD(.[/obj/machinery/mineral/processing_unit], "a")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/mineral/stacking_machine
	//
	LAZYADD(.[/obj/machinery/mineral/stacking_machine], "stacks")
	LAZYADD(.[/obj/machinery/mineral/stacking_machine], "a")


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
	LAZYADD(.[/obj/machinery/navbeacon], "codes")
	LAZYADD(.[/obj/machinery/navbeacon], "location")
	LAZYADD(.[/obj/machinery/navbeacon], "locked")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/organ_printer/flesh
	//
	LAZYADD(.[/obj/machinery/organ_printer/flesh], "stored_matter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/organ_printer
	//
	LAZYADD(.[/obj/machinery/organ_printer], "stored_matter")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/papershredder
	//
	LAZYADD(.[/obj/machinery/papershredder], "shred_amounts")
	LAZYADD(.[/obj/machinery/papershredder], "paperamount")


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
	LAZYADD(.[/obj/machinery/photocopier], "toner")
	LAZYADD(.[/obj/machinery/photocopier], "copies")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics/canister/air
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister/air], "valve_open")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics/canister/oxygen
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister/oxygen], "connected_port")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics/canister
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "air_contents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "destroyed")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "name")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "connected_port")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "anchored")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "health")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "valve_open")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "release_pressure")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "canister_color")
	LAZYADD(.[/obj/machinery/portable_atmospherics/canister], "heat")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/portable_atmospherics/hydroponics
	//
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "age")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "beneficial_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "anchored")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "base_name")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "toxic_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "weedkiller_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "dead")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "harvest")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "health")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "lastcycle")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "lastproduce")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "seed")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "water_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "pestkiller_reagents")
	LAZYADD(.[/obj/machinery/portable_atmospherics/hydroponics], "nutrient_reagents")
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
	LAZYADD(.[/obj/machinery/portable_atmospherics], "connected_port")
	LAZYADD(.[/obj/machinery/portable_atmospherics], "air_contents")
	LAZYADD(.[/obj/machinery/portable_atmospherics], "holding")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/porta_turret
	//
	LAZYADD(.[/obj/machinery/porta_turret], "health")
	LAZYADD(.[/obj/machinery/porta_turret], "locked")
	LAZYADD(.[/obj/machinery/porta_turret], "enabled")
	LAZYADD(.[/obj/machinery/porta_turret], "lethal")
	LAZYADD(.[/obj/machinery/porta_turret], "installation")
	LAZYADD(.[/obj/machinery/porta_turret], "check_access")
	LAZYADD(.[/obj/machinery/porta_turret], "check_faction")
	LAZYADD(.[/obj/machinery/porta_turret], "anchored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/porta_turret_construct
	//
	LAZYADD(.[/obj/machinery/porta_turret_construct], "target_type")
	LAZYADD(.[/obj/machinery/porta_turret_construct], "build_step")
	LAZYADD(.[/obj/machinery/porta_turret_construct], "finish_name")
	LAZYADD(.[/obj/machinery/porta_turret_construct], "installation")
	LAZYADD(.[/obj/machinery/porta_turret_construct], "gun_charge")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/apc
	//
	LAZYADD(.[/obj/machinery/power/apc], "cell")
	LAZYADD(.[/obj/machinery/power/apc], "cell_type")
	LAZYADD(.[/obj/machinery/power/apc], "opened")
	LAZYADD(.[/obj/machinery/power/apc], "shorted")
	LAZYADD(.[/obj/machinery/power/apc], "lighting")
	LAZYADD(.[/obj/machinery/power/apc], "equipment")
	LAZYADD(.[/obj/machinery/power/apc], "environ")
	LAZYADD(.[/obj/machinery/power/apc], "operating")
	LAZYADD(.[/obj/machinery/power/apc], "chargemode")
	LAZYADD(.[/obj/machinery/power/apc], "chargecount")
	LAZYADD(.[/obj/machinery/power/apc], "locked")
	LAZYADD(.[/obj/machinery/power/apc], "coverlocked")
	LAZYADD(.[/obj/machinery/power/apc], "aidisabled")
	LAZYADD(.[/obj/machinery/power/apc], "lastused_light")
	LAZYADD(.[/obj/machinery/power/apc], "terminal")
	LAZYADD(.[/obj/machinery/power/apc], "main_status")
	LAZYADD(.[/obj/machinery/power/apc], "has_electronics")
	LAZYADD(.[/obj/machinery/power/apc], "beenhit")
	LAZYADD(.[/obj/machinery/power/apc], "is_critical")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/emitter
	//
	LAZYADD(.[/obj/machinery/power/emitter], "anchored")
	LAZYADD(.[/obj/machinery/power/emitter], "locked")
	LAZYADD(.[/obj/machinery/power/emitter], "active")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/generator
	//
	LAZYADD(.[/obj/machinery/power/generator], "anchored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/port_gen/pacman
	//
	LAZYADD(.[/obj/machinery/power/port_gen/pacman], "sheets")
	LAZYADD(.[/obj/machinery/power/port_gen/pacman], "sheet_left")
	LAZYADD(.[/obj/machinery/power/port_gen/pacman], "temperature")
	LAZYADD(.[/obj/machinery/power/port_gen/pacman], "overheating")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/port_gen
	//
	LAZYADD(.[/obj/machinery/power/port_gen], "anchored")
	LAZYADD(.[/obj/machinery/power/port_gen], "active")
	LAZYADD(.[/obj/machinery/power/port_gen], "open")
	LAZYADD(.[/obj/machinery/power/port_gen], "recent_fault")


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
	LAZYADD(.[/obj/machinery/power/shield_generator], "max_energy")
	LAZYADD(.[/obj/machinery/power/shield_generator], "current_energy")
	LAZYADD(.[/obj/machinery/power/shield_generator], "input_cap")
	LAZYADD(.[/obj/machinery/power/shield_generator], "field_radius")
	LAZYADD(.[/obj/machinery/power/shield_generator], "running")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mitigation_em")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mitigation_heat")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mitigation_max")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mitigation_physical")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mode_changes_locked")
	LAZYADD(.[/obj/machinery/power/shield_generator], "upkeep_multiplier")
	LAZYADD(.[/obj/machinery/power/shield_generator], "upkeep_power_usage")
	LAZYADD(.[/obj/machinery/power/shield_generator], "mode_list")
	LAZYADD(.[/obj/machinery/power/shield_generator], "offline_for")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/smes/batteryrack
	//
	LAZYADD(.[/obj/machinery/power/smes/batteryrack], "max_cells")
	LAZYADD(.[/obj/machinery/power/smes/batteryrack], "internal_cells")
	LAZYADD(.[/obj/machinery/power/smes/batteryrack], "mode")
	LAZYADD(.[/obj/machinery/power/smes/batteryrack], "max_transfer_rate")


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


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/solar
	//
	LAZYADD(.[/obj/machinery/power/solar], "powernet")
	LAZYADD(.[/obj/machinery/power/solar], "power_channel")
	LAZYADD(.[/obj/machinery/power/solar], "sunfrac")
	LAZYADD(.[/obj/machinery/power/solar], "control")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/solar_control
	//
	LAZYADD(.[/obj/machinery/power/solar_control], "connected_tracker")
	LAZYADD(.[/obj/machinery/power/solar_control], "connected_panels")
	LAZYADD(.[/obj/machinery/power/solar_control], "track")
	LAZYADD(.[/obj/machinery/power/solar_control], "trackrate")
	LAZYADD(.[/obj/machinery/power/solar_control], "targetdir")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/power/terminal
	//
	LAZYADD(.[/obj/machinery/power/terminal], "master")
	LAZYADD(.[/obj/machinery/power/terminal], "invisibility")


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
	// /obj/machinery/r_n_d/circuit_imprinter
	//
	LAZYADD(.[/obj/machinery/r_n_d/circuit_imprinter], "materials")
	LAZYADD(.[/obj/machinery/r_n_d/circuit_imprinter], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/r_n_d/protolathe
	//
	LAZYADD(.[/obj/machinery/r_n_d/protolathe], "materials")
	LAZYADD(.[/obj/machinery/r_n_d/protolathe], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/sleeper
	//
	LAZYADD(.[/obj/machinery/sleeper], "beaker")
	LAZYADD(.[/obj/machinery/sleeper], "cartridges")
	LAZYADD(.[/obj/machinery/sleeper], "filtering")
	LAZYADD(.[/obj/machinery/sleeper], "occupant")
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
	LAZYADD(.[/obj/machinery/suit_cycler], "helmet")
	LAZYADD(.[/obj/machinery/suit_cycler], "suit")
	LAZYADD(.[/obj/machinery/suit_cycler], "target_department")
	LAZYADD(.[/obj/machinery/suit_cycler], "target_species")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/broadcaster
	//
	LAZYADD(.[/obj/machinery/telecomms/broadcaster], "links")
	LAZYADD(.[/obj/machinery/telecomms/broadcaster], "listening_levels")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/bus
	//
	LAZYADD(.[/obj/machinery/telecomms/bus], "change_frequency")
	LAZYADD(.[/obj/machinery/telecomms/bus], "listening_levels")
	LAZYADD(.[/obj/machinery/telecomms/bus], "links")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/hub/preset
	//
	LAZYADD(.[/obj/machinery/telecomms/hub/preset], "links")
	LAZYADD(.[/obj/machinery/telecomms/hub/preset], "listening_levels")
	LAZYADD(.[/obj/machinery/telecomms/hub/preset], "autolinkers")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/processor/preset_one
	//
	LAZYADD(.[/obj/machinery/telecomms/processor/preset_one], "autolinkers")
	LAZYADD(.[/obj/machinery/telecomms/processor/preset_one], "links")
	LAZYADD(.[/obj/machinery/telecomms/processor/preset_one], "listening_levels")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/processor
	//
	LAZYADD(.[/obj/machinery/telecomms/processor], "process_mode")
	LAZYADD(.[/obj/machinery/telecomms/processor], "links")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/receiver
	//
	LAZYADD(.[/obj/machinery/telecomms/receiver], "links")
	LAZYADD(.[/obj/machinery/telecomms/receiver], "listening_levels")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms/server
	//
	LAZYADD(.[/obj/machinery/telecomms/server], "log_entries")
	LAZYADD(.[/obj/machinery/telecomms/server], "stored_names")
	LAZYADD(.[/obj/machinery/telecomms/server], "TrafficActions")
	LAZYADD(.[/obj/machinery/telecomms/server], "logs")
	LAZYADD(.[/obj/machinery/telecomms/server], "links")
	LAZYADD(.[/obj/machinery/telecomms/server], "autoruncode")
	LAZYADD(.[/obj/machinery/telecomms/server], "rawcode")
	LAZYADD(.[/obj/machinery/telecomms/server], "memory")
	LAZYADD(.[/obj/machinery/telecomms/server], "channel_tags")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/machinery/telecomms
	//
	LAZYADD(.[/obj/machinery/telecomms], "autolinkers")
	LAZYADD(.[/obj/machinery/telecomms], "id")
	LAZYADD(.[/obj/machinery/telecomms], "network")
	LAZYADD(.[/obj/machinery/telecomms], "freq_listening")
	LAZYADD(.[/obj/machinery/telecomms], "machinetype")
	LAZYADD(.[/obj/machinery/telecomms], "toggled")
	LAZYADD(.[/obj/machinery/telecomms], "on")
	LAZYADD(.[/obj/machinery/telecomms], "integrity")
	LAZYADD(.[/obj/machinery/telecomms], "links_coords")
	LAZYADD(.[/obj/machinery/telecomms], "links_coords")


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
	LAZYADD(.[/obj/machinery], "reagents")
	LAZYADD(.[/obj/machinery], "anchored")
	LAZYADD(.[/obj/machinery], "health")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/screen/movable/action_button
	//
	LAZYADD(.[/obj/screen/movable/action_button], "extensions")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/barricade
	//
	LAZYADD(.[/obj/structure/barricade], "color")
	LAZYADD(.[/obj/structure/barricade], "material")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/bed/chair/comfy/brown
	//
	LAZYADD(.[/obj/structure/bed/chair/comfy/brown], "color")
	LAZYADD(.[/obj/structure/bed/chair/comfy/brown], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/bed
	//
	LAZYADD(.[/obj/structure/bed], "material")
	LAZYADD(.[/obj/structure/bed], "buckled_mob")


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
	LAZYADD(.[/obj/structure/cable], "color")
	LAZYADD(.[/obj/structure/cable], "d1")
	LAZYADD(.[/obj/structure/cable], "d2")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/closet/crate/large
	//
	LAZYADD(.[/obj/structure/closet/crate/large], "color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/closet/secure_closet/personal/empty
	//
	LAZYADD(.[/obj/structure/closet/secure_closet/personal/empty], "registered_name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/closet/secure_closet/personal
	//
	LAZYADD(.[/obj/structure/closet/secure_closet/personal], "registered_name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/closet
	//
	LAZYADD(.[/obj/structure/closet], "opened")
	LAZYADD(.[/obj/structure/closet], "locked")
	LAZYADD(.[/obj/structure/closet], "broken")
	LAZYADD(.[/obj/structure/closet], "anchored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/curtain
	//
	LAZYADD(.[/obj/structure/curtain], "opacity")


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
	LAZYADD(.[/obj/structure/disposalconstruct], "sortType")
	LAZYADD(.[/obj/structure/disposalconstruct], "ptype")
	LAZYADD(.[/obj/structure/disposalconstruct], "subtype")
	LAZYADD(.[/obj/structure/disposalconstruct], "dpdir")
	LAZYADD(.[/obj/structure/disposalconstruct], "base_state")


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
	LAZYADD(.[/obj/structure/disposalpipe/tagger], "sort_tag")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/disposalpipe
	//
	LAZYADD(.[/obj/structure/disposalpipe], "dpdir")
	LAZYADD(.[/obj/structure/disposalpipe], "health")
	LAZYADD(.[/obj/structure/disposalpipe], "base_icon_state")
	LAZYADD(.[/obj/structure/disposalpipe], "sortType")
	LAZYADD(.[/obj/structure/disposalpipe], "subtype")
	LAZYADD(.[/obj/structure/disposalpipe], "invisibility")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/dogbed
	//
	LAZYADD(.[/obj/structure/dogbed], "name")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/door_assembly
	//
	LAZYADD(.[/obj/structure/door_assembly], "fill_icon")
	LAZYADD(.[/obj/structure/door_assembly], "panel_icon")
	LAZYADD(.[/obj/structure/door_assembly], "glass_icon")
	LAZYADD(.[/obj/structure/door_assembly], "dir")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/girder
	//
	LAZYADD(.[/obj/structure/girder], "state")
	LAZYADD(.[/obj/structure/girder], "anchored")
	LAZYADD(.[/obj/structure/girder], "material")
	LAZYADD(.[/obj/structure/girder], "r_material")
	LAZYADD(.[/obj/structure/girder], "integrity")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/janitorialcart
	//
	LAZYADD(.[/obj/structure/janitorialcart], "mybag")
	LAZYADD(.[/obj/structure/janitorialcart], "mymop")
	LAZYADD(.[/obj/structure/janitorialcart], "myreplacer")
	LAZYADD(.[/obj/structure/janitorialcart], "myspray")
	LAZYADD(.[/obj/structure/janitorialcart], "signs")
	LAZYADD(.[/obj/structure/janitorialcart], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/lift/button
	//
	LAZYADD(.[/obj/structure/lift/button], "lift")
	LAZYADD(.[/obj/structure/lift/button], "floor")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/lift/panel
	//
	LAZYADD(.[/obj/structure/lift/panel], "lift")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/ore_box
	//
	LAZYADD(.[/obj/structure/ore_box], "stored_ore")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/reagent_dispensers
	//
	LAZYADD(.[/obj/structure/reagent_dispensers], "reagents")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/shuttle/engine/propulsion
	//
	LAZYADD(.[/obj/structure/shuttle/engine/propulsion], "anchored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/sign/poster
	//
	LAZYADD(.[/obj/structure/sign/poster], "desc")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/table/rack
	//
	LAZYADD(.[/obj/structure/table/rack], "density")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/table
	//
	LAZYADD(.[/obj/structure/table], "flipped")
	LAZYADD(.[/obj/structure/table], "health")
	LAZYADD(.[/obj/structure/table], "carpeted")
	LAZYADD(.[/obj/structure/table], "material")
	LAZYADD(.[/obj/structure/table], "reinforced")
	LAZYADD(.[/obj/structure/table], "anchored")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/wall_frame
	//
	LAZYADD(.[/obj/structure/wall_frame], "stripe_color")
	LAZYADD(.[/obj/structure/wall_frame], "color")
	LAZYADD(.[/obj/structure/wall_frame], "health")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure/window
	//
	LAZYADD(.[/obj/structure/window], "health")
	LAZYADD(.[/obj/structure/window], "silicate")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj/structure
	//
	LAZYADD(.[/obj/structure], "anchored")


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
	LAZYADD(.[/obj/vehicle], "open")
	LAZYADD(.[/obj/vehicle], "locked")
	LAZYADD(.[/obj/vehicle], "on")
	LAZYADD(.[/obj/vehicle], "health")
	LAZYADD(.[/obj/vehicle], "stat")
	LAZYADD(.[/obj/vehicle], "load")
	LAZYADD(.[/obj/vehicle], "cell")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /obj
	//
	LAZYADD(.[/obj], "req_access")
	LAZYADD(.[/obj], "req_one_access")
	LAZYADD(.[/obj], "fingerprints")
	LAZYADD(.[/obj], "fingerprintslast")
	LAZYADD(.[/obj], "suit_fibers")
	LAZYADD(.[/obj], "req_access_faction")
	LAZYADD(.[/obj], "req_access_personal")
	LAZYADD(.[/obj], "req_access_business")
	LAZYADD(.[/obj], "visibility")
	LAZYADD(.[/obj], "req_access_personal_list")
	LAZYADD(.[/obj], "designer_unit_saved_id")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /turf/simulated/floor/asteroid
	//
	LAZYADD(.[/turf/simulated/floor/asteroid], "has_resources")
	LAZYADD(.[/turf/simulated/floor/asteroid], "resources")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /turf/simulated/floor
	//
	LAZYADD(.[/turf/simulated/floor], "flooringburnt")
	LAZYADD(.[/turf/simulated/floor], "prior_floortype")
	LAZYADD(.[/turf/simulated/floor], "prior_resources")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /turf/simulated/mineral
	//
	LAZYADD(.[/turf/simulated/mineral], "resources")
	LAZYADD(.[/turf/simulated/mineral], "mineral")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /turf/simulated/wall
	//
	LAZYADD(.[/turf/simulated/wall], "opacity")
	LAZYADD(.[/turf/simulated/wall], "material")
	LAZYADD(.[/turf/simulated/wall], "material")
	LAZYADD(.[/turf/simulated/wall], "r_material")
	LAZYADD(.[/turf/simulated/wall], "p_material")
	LAZYADD(.[/turf/simulated/wall], "state")
	LAZYADD(.[/turf/simulated/wall], "integrity")
	LAZYADD(.[/turf/simulated/wall], "floor_type")
	LAZYADD(.[/turf/simulated/wall], "paint_color")
	LAZYADD(.[/turf/simulated/wall], "stripe_color")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /turf
	//
	LAZYADD(.[/turf], "fingerprints")
	LAZYADD(.[/turf], "fingerprintslast")
	LAZYADD(.[/turf], "density")
	LAZYADD(.[/turf], "saved_decals")
	LAZYADD(.[/turf], "a")


	//////////////////////////////////////////////////////////////////////////////
	//
	// /zone
	//
	LAZYADD(.[/zone], "air")
	LAZYADD(.[/zone], "turf_coords")


	for(var/type in .)
		for (var/subtype in subtypesof(type))
			for (var/v in .[type])
				LAZYDISTINCTADD(.[subtype], v)

