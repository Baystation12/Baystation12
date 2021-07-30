/obj/item/weapon/robot_module/huragok_lifeworker
	name = "huragok lifeworker specialization"
	sprites = list(
					"Lifeworker" = "engineer",
					)
	languages = list(
		LANGUAGE_ENGLISH   = 0,
		LANGUAGE_MANDARIN  = 0,
		LANGUAGE_GERMAN    = 0,
		LANGUAGE_FRENCH    = 0,
		LANGUAGE_TRADEBAND = 0,
		LANGUAGE_GUTTER    = 0,
		LANGUAGE_UNGGOY    = 0,
		LANGUAGE_KIGYAR    = 0,
		LANGUAGE_SANGHEILI = 0,
		LANGUAGE_BRUTE     = 0,
		LANGUAGE_SIGN      = 1)

/obj/item/weapon/robot_module/huragok_lifeworker/New()
	src.modules += new /obj/item/weapon/crowbar/covenant(src)
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/med(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/roller_holder(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/crisis(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/huragok(src)
	src.modules += new /obj/item/weapon/shockpaddles/robot(src)
	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.modules += new /obj/item/weapon/gripper/chemistry(src)
	src.modules += new /obj/item/weapon/gripper/cilia(src)
	src.modules += new /obj/item/weapon/scalpel/manager(src)
	src.modules += new /obj/item/weapon/scalpel/covenant(src)
	src.modules += new /obj/item/weapon/hemostat/covenant(src)
	src.modules += new /obj/item/weapon/retractor/covenant(src)
	src.modules += new /obj/item/weapon/cautery/covenant(src)
	src.modules += new /obj/item/weapon/bonegel(src)
	src.modules += new /obj/item/weapon/FixOVein(src)
	src.modules += new /obj/item/weapon/bonesetter/covenant(src)
	src.modules += new /obj/item/weapon/circular_saw(src)
	src.modules += new /obj/item/weapon/surgicaldrill/covenant(src)
	src.modules += new /obj/item/weapon/gripper/organ(src)

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(20000)
	synths += medicine

	var/obj/item/stack/medical/advanced/ointment/O = new /obj/item/stack/medical/advanced/ointment(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	var/obj/item/stack/medical/splint/S = new /obj/item/stack/medical/splint(src)
	O.uses_charge = 1
	O.charge_costs = list(0.1)
	O.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(0.1)
	B.synths = list(medicine)
	S.uses_charge = 1
	S.charge_costs = list(0.1)
	S.synths = list(medicine)
	src.modules += O
	src.modules += B
	src.modules += S

	. = ..()

/obj/item/weapon/robot_module/huragok_engineer
	name = "huragok engineer specialization"
	supported_upgrades = list(/obj/item/borg/upgrade/rcd)
	sprites = list(
					"Huragok Engineer" = "engineer"
					)
	languages = list(
		LANGUAGE_ENGLISH   = 0,
		LANGUAGE_MANDARIN  = 0,
		LANGUAGE_GERMAN    = 0,
		LANGUAGE_FRENCH    = 0,
		LANGUAGE_TRADEBAND = 0,
		LANGUAGE_GUTTER    = 0,
		LANGUAGE_UNGGOY    = 0,
		LANGUAGE_KIGYAR    = 0,
		LANGUAGE_SANGHEILI = 0,
		LANGUAGE_BRUTE     = 0,
		LANGUAGE_SIGN      = 1)
	no_slip = 1

/obj/item/weapon/robot_module/huragok_engineer/New()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/weapon/weldingtool/covenant(src)
	src.modules += new /obj/item/weapon/screwdriver/covenant(src)
	src.modules += new /obj/item/weapon/wrench/covenant(src)
	src.modules += new /obj/item/weapon/crowbar/covenant(src)
	src.modules += new /obj/item/weapon/wirecutters/covenant(src)
	src.modules += new /obj/item/device/multitool/covenant(src)
	src.modules += new /obj/item/device/t_scanner(src)
	src.modules += new /obj/item/device/analyzer(src)
	src.modules += new /obj/item/device/geiger(src)
	src.modules += new /obj/item/weapon/gripper(src)
	src.modules += new /obj/item/weapon/gripper/cilia(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/weapon/armor_patch/huragok(src)
//	src.modules += new /obj/item/weapon/inflatable_dispenser/robot(src)	//Might as well make a new version of this that deploys weak energy barriers that act as a temporaru fix for breaches.

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(600000000)	//When an alternative is coded in for the huragoks to regenerate matter outside a cyborg recharge station, let's get rid of this infinite resource.
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(600000000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(600000000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(600000000)
	var/datum/matter_synth/nanolaminate = new /datum/matter_synth/nanolaminate(600000000)
	synths += metal
	synths += glass
	synths += plasteel
	synths += wire
	synths += nanolaminate

	var/obj/item/weapon/matter_decompiler/MD = new /obj/item/weapon/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/high_cap/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/high_cap/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(metal)
	src.modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/high_cap/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/material/cyborg/plasteel/high_cap/PL = new (src)
	PL.synths = list(plasteel)
	src.modules += PL

	var/obj/item/stack/material/cyborg/nanolaminate/ZW = new (src)
	ZW.synths = list(nanolaminate)
	src.modules += ZW

	. = ..()

/obj/item/weapon/robot_module/engineering/general/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	..()