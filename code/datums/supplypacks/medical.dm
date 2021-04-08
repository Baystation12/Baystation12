/decl/hierarchy/supply_pack/medical
	name = "Medical"
	containertype = /obj/structure/closet/crate/medical

/decl/hierarchy/supply_pack/medical/gloves
	name = "Refills - Sterile gloves"
	contains = list(/obj/item/storage/box/gloves = 4)
	cost = 20
	containername = "medical crate"

/decl/hierarchy/supply_pack/medical/medical
	name = "Refills - Medical supplies"
	contains = list(/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/trauma,
					/obj/item/storage/firstaid/fire,
					/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/adv,
					/obj/item/storage/firstaid/stab,
					/obj/item/reagent_containers/glass/bottle/antitoxin,
					/obj/item/reagent_containers/glass/bottle/inaprovaline,
					/obj/item/reagent_containers/glass/bottle/stoxin,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/autoinjectors)
	cost = 70
	containername = "medical crate"

/decl/hierarchy/supply_pack/medical/atk
	name = "Triage - Advanced trauma supplies"
	contains = list(/obj/item/stack/medical/advanced/bruise_pack = 6)
	cost = 30
	containername = "advanced trauma crate"

/decl/hierarchy/supply_pack/medical/abk
	name = "Triage - Advanced burn supplies"
	contains = list(/obj/item/stack/medical/advanced/ointment = 6)
	cost = 30
	containername = "advanced burn crate"

/decl/hierarchy/supply_pack/medical/trauma
	name = "EMERGENCY - Trauma pouches"
	contains = list(/obj/item/storage/firstaid/trauma = 3)
	cost = 10
	containername = "trauma pouch crate"

/decl/hierarchy/supply_pack/medical/burn
	name = "EMERGENCY - Burn pouches"
	contains = list(/obj/item/storage/firstaid/fire = 3)
	cost = 10
	containername = "burn pouch crate"

/decl/hierarchy/supply_pack/medical/toxin
	name = "EMERGENCY - Toxin pouches"
	contains = list(/obj/item/storage/firstaid/toxin = 3)
	cost = 10
	containername = "toxin pouch crate"

/decl/hierarchy/supply_pack/medical/oxyloss
	name = "EMERGENCY - Low oxygen pouches"
	contains = list(/obj/item/storage/firstaid/o2 = 3)
	cost = 10
	containername = "low oxygen pouch crate"

/decl/hierarchy/supply_pack/medical/stab
	name = "Triage - Stability kit"
	contains = list(/obj/item/storage/firstaid/stab = 3)
	cost = 60
	containername = "stability kit crate"

/decl/hierarchy/supply_pack/medical/bloodpack
	name = "Refills - Blood packs"
	contains = list(/obj/item/storage/box/bloodpacks = 3)
	cost = 10
	containername = "blood pack crate"

/decl/hierarchy/supply_pack/medical/blood
	name = "Refills - Nanoblood"
	contains = list(/obj/item/reagent_containers/ivbag/nanoblood = 4)
	cost = 15
	containername = "nanoblood crate"

/decl/hierarchy/supply_pack/medical/bodybag
	name = "Equipment - Body bags"
	contains = list(/obj/item/storage/box/bodybags = 3)
	cost = 10
	containername = "body bag crate"

/decl/hierarchy/supply_pack/medical/stretcher
	name = "Equipment - Roller bed crate"
	contains = list(/obj/item/roller = 3)
	cost = 10
	containername = "\improper Roller bed crate"

/decl/hierarchy/supply_pack/medical/wheelchair
	name = "Equipment - Wheelchair crate"
	contains = list(/obj/structure/bed/chair/wheelchair)
	cost = 15
	containertype = /obj/structure/closet/crate/large
	containername = "\improper Wheelchair crate"

/decl/hierarchy/supply_pack/medical/rescuebag
	name = "Equipment - Rescue bags"
	contains = list(/obj/item/bodybag/rescue = 3)
	cost = 30
	containername = "\improper Rescue bag crate"

/decl/hierarchy/supply_pack/medical/medicalextragear
	name = "Gear - Medical surplus equipment"
	contains = list(/obj/item/storage/belt/medical = 3,
					/obj/item/clothing/glasses/hud/health = 3)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "medical surplus equipment crate"
	access = access_medical

/decl/hierarchy/supply_pack/medical/cmogear
	name = "Gear - Chief medical officer equipment"
	contains = list(/obj/item/storage/belt/medical,
					/obj/item/device/radio/headset/heads/cmo,
					/obj/item/clothing/under/rank/chief_medical_officer,
					/obj/item/reagent_containers/hypospray/vial,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
					/obj/item/clothing/mask/surgical,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/gloves/latex,
					/obj/item/device/scanner/health,
					/obj/item/device/flashlight/pen,
					/obj/item/reagent_containers/syringe)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "chief medical officer equipment crate"
	access = access_cmo

/decl/hierarchy/supply_pack/medical/doctorgear
	name = "Gear - Medical Doctor equipment"
	contains = list(/obj/item/storage/belt/medical,
					/obj/item/device/radio/headset/headset_med,
					/obj/item/clothing/under/rank/medical,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/mask/surgical,
					/obj/item/storage/firstaid/adv,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/gloves/latex,
					/obj/item/device/scanner/health,
					/obj/item/device/flashlight/pen,
					/obj/item/reagent_containers/syringe)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "medical Doctor equipment crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/chemistgear
	name = "Gear - Pharmacist equipment"
	contains = list(/obj/item/storage/box/beakers,
					/obj/item/device/radio/headset/headset_med,
					/obj/item/storage/box/autoinjectors,
					/obj/item/clothing/under/rank/chemist,
					/obj/item/clothing/glasses/science,
					/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
					/obj/item/clothing/mask/surgical,
					/obj/item/clothing/shoes/white,
					/obj/item/clothing/gloves/latex,
					/obj/item/reagent_containers/dropper,
					/obj/item/device/scanner/health,
					/obj/item/storage/box/pillbottles,
					/obj/item/reagent_containers/syringe)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "pharmacist equipment crate"
	access = access_chemistry

/decl/hierarchy/supply_pack/medical/paramedicgear
	name = "Gear - Paramedic equipment"
	contains = list(/obj/item/storage/belt/medical/emt,
					/obj/item/device/radio/headset/headset_med,
					/obj/item/clothing/under/rank/medical/scrubs/black,
					/obj/item/clothing/accessory/armband/medgreen,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/under/rank/medical/paramedic,
					/obj/item/clothing/suit/storage/toggle/fr_jacket,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/under/rank/medical/paramedic,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/storage/firstaid/adv,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/clothing/gloves/latex,
					/obj/item/device/scanner/health,
					/obj/item/device/flashlight/pen,
					/obj/item/reagent_containers/syringe,
					/obj/item/clothing/accessory/storage/white_vest)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "paramedic equipment crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/psychiatristgear
	name = "Gear - Psychiatrist equipment"
	contains = list(/obj/item/clothing/under/rank/psych,
					/obj/item/device/radio/headset/headset_med,
					/obj/item/clothing/under/rank/psych/turtleneck,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/shoes/white,
					/obj/item/material/clipboard,
					/obj/item/folder/white,
					/obj/item/pen)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "psychiatrist equipment crate"
	access = access_psychiatrist

/decl/hierarchy/supply_pack/medical/medicalscrubs
	name = "Gear - Medical scrubs"
	contains = list(/obj/item/clothing/shoes/white = 4,
					/obj/item/clothing/under/rank/medical/scrubs/blue,
					/obj/item/clothing/under/rank/medical/scrubs/green,
					/obj/item/clothing/under/rank/medical/scrubs/purple,
					/obj/item/clothing/under/rank/medical/scrubs/black,
					/obj/item/clothing/head/surgery/black,
					/obj/item/clothing/head/surgery/purple,
					/obj/item/clothing/head/surgery/blue,
					/obj/item/clothing/head/surgery/green,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "medical scrubs crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/autopsy
	name = "Gear - Autopsy equipment"
	contains = list(/obj/item/folder/white,
					/obj/item/device/camera,
					/obj/item/device/camera_film = 2,
					/obj/item/autopsy_scanner,
					/obj/item/scalpel,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves,
					/obj/item/pen)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "autopsy equipment crate"
	access = access_morgue

/decl/hierarchy/supply_pack/medical/medicaluniforms
	name = "Gear - Medical uniforms"
	contains = list(/obj/item/clothing/shoes/white = 3,
					/obj/item/clothing/under/rank/chief_medical_officer,
					/obj/item/clothing/under/rank/geneticist,
					/obj/item/clothing/under/rank/virologist,
					/obj/item/clothing/under/rank/nursesuit,
					/obj/item/clothing/under/rank/nurse,
					/obj/item/clothing/under/rank/orderly,
					/obj/item/clothing/under/rank/medical = 3,
					/obj/item/clothing/under/rank/medical/paramedic = 3,
					/obj/item/clothing/suit/storage/toggle/labcoat = 3,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
					/obj/item/clothing/suit/storage/toggle/labcoat/genetics,
					/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
					/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "medical uniform crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/medicalbiosuits
	name = "Gear - Medical biohazard gear"
	contains = list(/obj/item/clothing/head/bio_hood = 3,
					/obj/item/clothing/suit/bio_suit = 3,
					/obj/item/clothing/head/bio_hood/virology = 2,
					/obj/item/clothing/suit/bio_suit/cmo = 2,
					/obj/item/clothing/mask/gas = 5,
					/obj/item/tank/oxygen = 5,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "medical biohazard equipment crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/portablefreezers
	name = "Equipment - Portable freezers"
	contains = list(/obj/item/storage/box/freezer = 7)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "portable freezers crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/surgery
	name = "Gear - Surgery tools"
	contains = list(/obj/item/cautery,
					/obj/item/surgicaldrill,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/tank/anesthetic,
					/obj/item/FixOVein,
					/obj/item/hemostat,
					/obj/item/scalpel,
					/obj/item/bonegel,
					/obj/item/retractor,
					/obj/item/bonesetter,
					/obj/item/circular_saw)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "surgery crate"
	access = access_medical

/decl/hierarchy/supply_pack/medical/sterile
	name = "Gear - Sterile clothes"
	contains = list(/obj/item/clothing/under/rank/medical/scrubs/green = 2,
					/obj/item/clothing/head/surgery/green = 2,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves,
					/obj/item/storage/belt/medical = 3)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "sterile clothes crate"

/decl/hierarchy/supply_pack/medical/scanner_module
	name = "Electronics - Medical scanner modules"
	contains = list(/obj/item/stock_parts/computer/scanner/medical = 4)
	cost = 20
	containername = "medical scanner module crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/defib
	name = "Electronics - Defibrilator crate"
	contains = list(/obj/item/defibrillator)
	cost = 60
	containername = "\improper Defibrilator crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/beltdefib
	name = "Electronics - Compact Defibrilator crate"
	contains = list(/obj/item/defibrillator/compact)
	cost = 75
	containername = "\improper Compact Defibrilator crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/autocomp
	name = "Electronics - Auto-Compressor crate"
	contains = list(/obj/item/auto_cpr)
	cost = 50
	containername = "\improper Auto-Compressor crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_medical_equip