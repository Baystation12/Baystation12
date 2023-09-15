/obj/item/robot_module/clerical/set_map_specific_access()
	access += list(
		access_emergency_storage,
		access_cargo,
		access_cargo_bot,
		access_commissary,
		access_hangar,
		access_mailsorting,
		access_radio_serv,
		access_radio_sup
	)

/obj/item/robot_module/clerical/butler/set_map_specific_access()
	access = list(
		access_commissary,
		access_hydroponics,
		access_kitchen,
		access_radio_serv
	)

/obj/item/robot_module/medical/set_map_specific_access()
	access += list(
		access_chemistry,
		access_crematorium,
		access_emergency_storage,
		access_eva,
		access_external_airlocks,
		access_hangar,
		access_medical,
		access_medical_equip,
		access_morgue,
		access_senmed,
		access_surgery,
		access_virology,
		access_radio_med
	)

/obj/item/robot_module/engineering/set_map_specific_access()
	access = list(
		access_atmospherics,
		access_construction,
		access_emergency_storage,
		access_engine,
		access_engine_equip,
		access_eva,
		access_external_airlocks,
		access_hangar,
		access_network,
		access_robotics,
		access_seneng,
		access_tcomsat,
		access_tech_storage,
		access_radio_eng
	)

/obj/item/robot_module/janitor/set_map_specific_access()
	access = list(
		access_emergency_storage,
		access_janitor,
		access_radio_serv
	)

/obj/item/robot_module/miner/set_map_specific_access()
	access = list(
		access_eva,
		access_expedition_shuttle,
		access_guppy,
		access_hangar,
		access_mining,
		access_mining_office,
		access_mining_station,
		access_radio_exp,
		access_radio_sup
	)

/obj/item/robot_module/research/set_map_specific_access()
	access = list(
		access_expedition_shuttle,
		access_hangar,
		access_mining_office,
		access_mining_station,
		access_petrov,
		access_petrov_analysis,
		access_petrov_chemistry,
		access_petrov_maint,
		access_petrov_phoron,
		access_petrov_toxins,
		access_research,
		access_tox,
		access_tox_storage,
		access_xenoarch,
		access_xenobiology,
		access_radio_exp,
		access_radio_sci
	)

/obj/item/robot_module/flying/cultivator/set_map_specific_access()
	access = list(
		access_hydroponics,
		access_kitchen,
		access_research,
		access_radio_sci,
		access_radio_serv
	)

/obj/item/robot_module/flying/emergency/set_map_specific_access()
	access = list(
		access_chemistry,
		access_crematorium,
		access_emergency_storage,
		access_eva,
		access_external_airlocks,
		access_hangar,
		access_medical,
		access_medical_equip,
		access_morgue,
		access_senmed,
		access_surgery,
		access_virology,
		access_radio_med
	)

/obj/item/robot_module/flying/filing/set_map_specific_access()
	access = list(
		access_emergency_storage,
		access_cargo,
		access_cargo_bot,
		access_commissary,
		access_hangar,
		access_mailsorting,
		access_radio_serv,
		access_radio_sup
	)

/obj/item/robot_module/flying/forensics/set_map_specific_access()
	access = list(
		access_brig,
		access_emergency_storage,
		access_forensics_lockers,
		access_morgue,
		access_sec_doors,
		access_security,
		access_radio_sec
	)

/obj/item/robot_module/flying/repair/set_map_specific_access()
	access = list(
		access_atmospherics,
		access_construction,
		access_emergency_storage,
		access_engine,
		access_engine_equip,
		access_eva,
		access_external_airlocks,
		access_hangar,
		access_network,
		access_robotics,
		access_seneng,
		access_tcomsat,
		access_tech_storage,
		access_radio_eng
	)

/obj/item/robot_module/security/set_map_specific_access()
	access = list(
		access_brig,
		access_emergency_storage,
		access_eva,
		access_external_airlocks,
		access_sec_doors,
		access_security,
		access_radio_sec
	)
