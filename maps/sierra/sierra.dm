#if !defined(using_map_DATUM)

	// --- MAP MAINTENANCE --- //
	#include "sierra_setup.dm"
	#include "sierra_announcements.dm"
	#include "sierra_antagonism.dm"
	#include "sierra_areas.dm"
	#include "sierra_decals.dm"
	#include "sierra_elevator.dm"
	#include "sierra_holodecks.dm"
	#include "sierra_lobby.dm"
	#include "sierra_npcs.dm"
	#include "sierra_overmap.dm"
	#include "sierra_presets.dm"
	#include "sierra_procs.dm"
	#include "sierra_ranks.dm"
	#include "sierra_security_state.dm"
	#include "sierra_shuttles.dm"
	#include "sierra_submaps.dm"
	#include "sierra_turfs.dm"
	#include "sierra_unit_testing.dm"

	// --- INCLUDES FROM ANOTHER MAPS --- //
	#include "sierra_snatch.dm"

	// --- DATUMS SECTION --- //
	#include "datums/uniforms.dm"
	#include "datums/uniforms_civilian.dm"
	#include "datums/uniforms_contractor.dm"
	#include "datums/uniforms_employee.dm"

	#include "datums/reports/command.dm"
	#include "datums/reports/deck.dm"
	#include "datums/reports/engineering.dm"
	#include "datums/reports/exploration.dm"
	#include "datums/reports/general.dm"
	#include "datums/reports/iaa.dm"
	#include "datums/reports/medical.dm"
	#include "datums/reports/security.dm"
	#include "datums/reports/science.dm"

	#include "datums/shackle_law_sets.dm"
	#include "datums/supplypacks/engineering.dm"
	#include "datums/supplypacks/security.dm"
	#include "datums/supplypacks/science.dm"

	#include "datums/species/species_overrides.dm"

	#include "game/languages.dm"
	#include "game/lockdown.dm"

	// --- ITEMS --- //
	#include "items/ammo.dm"
	#include "items/cards_ids.dm"
	#include "items/documents.dm"
	#include "items/encryption_keys.dm"
	#include "items/explo_shotgun.dm"
	#include "items/guns.dm"
	#include "items/headsets.dm"
	#include "items/items.dm"
	#include "items/lighting.dm"
	#include "items/machinery.dm"
	#include "items/modular_computer.dm"
	#include "items/manuals.dm"
	#include "items/mech.dm"
	#include "items/papers.dm"
	#include "items/rigs.dm"
	#include "items/stamps.dm"
	#include "items/pouches.dm"
	#include "items/backpack.dm"

	#include "items/clothing/clothing.dm"
	#include "items/clothing/exploration.dm"
	#include "items/clothing/override.dm"
	#include "items/clothing/storages.dm"

	// --- JOB SECTION --- //
	#include "job\_job_defines.dm"
	#include "job/access.dm"
	#include "job/jobs.dm"
	#include "job/outfits.dm"
	#include "job/infinity.dm"

	#include "job/jobs_cargo.dm"
	#include "job/jobs_command.dm"
	#include "job/jobs_engineering.dm"
	#include "job/jobs_exploration.dm"
	#include "job/jobs_medical.dm"
	#include "job/jobs_misc.dm"
	#include "job/jobs_research.dm"
	#include "job/jobs_security.dm"
	#include "job/jobs_service.dm"

	// --- MACHINERY --- //
	#include "machinery/alarm.dm"
	#include "machinery/doors.dm"
	#include "machinery/keycard authentication.dm"
	#include "machinery/machinery.dm"
	#include "machinery/navbeacons.dm"
	#include "machinery/power.dm"
	#include "machinery/random.dm"
	#include "machinery/suit_storage.dm"
	#include "machinery/tcomms.dm"
	#include "machinery/thrusters.dm"
	#include "machinery/uniform_vendor.dm"
	#include "machinery/vendors.dm"

	// --- STRUCTURES --- //
	#include "structures/closets.dm"
	#include "structures/other.dm"
	#include "structures/signs.dm"

	#include "structures/closets/_closets_appearances.dm"
	#include "structures/closets/armory.dm"
	#include "structures/closets/command.dm"
	#include "structures/closets/engineering.dm"
	#include "structures/closets/exploration.dm"
	#include "structures/closets/medical.dm"
	#include "structures/closets/misc.dm"
	#include "structures/closets/research.dm"
	#include "structures/closets/security.dm"
	#include "structures/closets/services.dm"
	#include "structures/closets/supply.dm"

	// --- LOADOUT --- //
	#include "loadout/_defines.dm"
	#include "loadout/loadout.dm"
	#include "loadout/loadout_accessories.dm"
	#include "loadout/loadout_ec_skillbages.dm"
	#include "loadout/loadout_eyes.dm"
	#include "loadout/loadout_gloves.dm"
	#include "loadout/loadout_head.dm"
	#include "loadout/loadout_pda.dm"
	#include "loadout/loadout_shoes.dm"
	#include "loadout/loadout_suit.dm"
	#include "loadout/loadout_tactical.dm"
	#include "loadout/loadout_uniform.dm"
	#include "loadout/loadout_xeno.dm"
	#include "loadout/~defines.dm"

	// --- MAP FILES --- //

		// ~SIERRA~ //
	#include "z1-z5_sierra.dmm"
	#include "z6_admin.dmm"
	#include "z7_transit.dmm"
	#include "../away/empty.dmm"

		// ~AWAY SITES~ //
	#include "../away/mining/mining.dm"
	#include "../away/derelict/derelict.dm"
	#include "../away/bearcat/bearcat.dm"
	#include "../away/lost_supply_base/lost_supply_base.dm"
	#include "../away/smugglers/smugglers.dm"
	#include "../away/magshield/magshield.dm"
	#include "../away/casino/casino.dm"
	#include "../away/yacht/yacht.dm"
	#include "../away/blueriver/blueriver.dm"
	#include "../away/slavers/slavers_base.dm"
	#include "../away/mobius_rift/mobius_rift.dm"
	#include "../away/errant_pisces/errant_pisces.dm"
	#include "../away/lar_maria/lar_maria.dm"
	#include "../away/voxship/voxship.dm"
	#include "../away/skrellscoutship/skrellscoutship.dm"
	#include "../away/meatstation/meatstation.dm"
	#include "../away/miningstation/miningstation.dm"
	#include "../away/mininghome/mininghome.dm"
	#include "../away/scavver/scavver_gantry.dm"
	#include "../away/abandoned_hotel/abandoned_hotel.dm"
	// #include "../event/iccgn_ship/icgnv_hound.dm" // SIERRA TODO: Пофиксить или удалить

	#include "../bluespace_interlude/bluespace_interlude.dm"
	#include "../bluespace_interlude/bluespace_interlude.dmm"

	// USED MODS
	// Keep them in ascending alphabetical order, please

	#include "../../mods/_maps/liberia/_map_liberia.dme"
	#include "../../mods/_maps/sentinel/_map_sentinel.dme"
	#include "../../mods/_maps/farfleet/_map_farfleet.dme"
	#include "../../mods/_maps/hand/_map_hand.dme"

	#include "../../mods/antagonists/_antagonists.dme"
	#include "../../mods/bluespace_kitty/_bluespace_kitty.dme"
	#include "../../mods/fancy_sofas/_fancy_sofas.dme"
	#include "../../mods/guns/_guns.dme"
	#include "../../mods/jukebox_tapes/_jukebox_tapes.dme"
	#include "../../mods/legalese_language/_legalese.dme"
	#include "../../mods/petting_zoo/_petting_zoo.dme"
	#include "../../mods/screentips/_screentips.dme"
	#include "../../mods/tajara/_tajara.dme"
	#include "../../mods/sauna_props/_sauna_props.dme"
	#include "../../mods/wyccbay_optimization/_wyccbay_optimization.dme"

	// UNUSED MODS
	// Keep them in ascending alphabetical order too, please

	// #include "../../mods/atmos_ret_field/_atm_ret_field.dme"
	// #include "../../mods/resomi/_resomi.dme"

	// Почему UNUSED MODS стоит хранить?
	// Потому что никто не проверяет использование тех или иных файлов
	// в коде, и мод просто исчезнет из поля зрения, когда находясь здесь
	// он всегда напоминает о своём существовании. Небольшая библиотека,
	// если так вообще можно выразиться.

	#include "../../packs/factions/iccgn/_pack.dm"
	#include "../../packs/factions/scga/_pack.dm"
	#include "../../packs/factions/fa/_pack.dm"
	#include "../../packs/infinity/_pack.dm"
	#include "../../packs/deepmaint/_pack.dm"


	#define using_map_DATUM /datum/map/sierra

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Sierra

#endif
