/obj/item/clothing/suit/storage/toggle/resomicoat
	name = "small coat"
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_suit_resomi.dmi'
	desc = "A cloak that seems too small to fit a human."
	icon_state = "resomicoat"
	//icon_open = "resomicoat_open"
	//icon_closed = "resomicoat"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
	species_restricted = list(SPECIES_RESOMI)

/obj/item/clothing/suit/storage/toggle/resomicoat/New()
	..()
	allowed += /obj/item/device/suit_cooling_unit/mini


/obj/item/clothing/suit/storage/toggle/resomicoat/white
 	icon_state = "white_resomicoat"
 	//icon_open = "white_resomicoat_open"
 	//icon_closed = "white_resomicoat"

/obj/item/clothing/suit/storage/toggle/resomilabcoat
	name = "small labcoat"
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_suit_resomi.dmi'
	desc = "A labcoat that seems too small to fit a human."
	icon_state = "resomi_labcoat"
	//icon_open = "resomi_labcoat_open"
	//icon_closed = "resomi_labcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	species_restricted = list(SPECIES_RESOMI)
	allowed = list(/obj/item/device/scanner/gas,/obj/item/stack/medical,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,/obj/item/device/scanner/health,/obj/item/device/flashlight/pen,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle,/obj/item/paper)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

//standart resomicloak

/obj/item/clothing/suit/storage/resomicloak
	name = "black and orange cloak"
	desc = "It drapes over a Resomes's shoulders and closes at the neck with pockets convienently placed inside."
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_suit_resomi.dmi'
	icon_state = "tesh_cloak_bo"
	slots = 2
	species_restricted = list(SPECIES_RESOMI)
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO

/obj/item/clothing/suit/storage/resomicloak/Initialize()
	. = ..()
	if(pockets)
		qdel(pockets)
	pockets = new/obj/item/storage/internal/pouch(src, slots*BASE_STORAGE_COST(ITEM_SIZE_SMALL))

/obj/item/clothing/suit/storage/resomicloak/New()
	..()
	allowed += /obj/item/device/suit_cooling_unit/mini


/obj/item/clothing/suit/storage/resomicloak/standard/black_grey
	name = "black and grey cloak"
	icon_state = "tesh_cloak_bg"
	item_state = "tesh_cloak_bg"

/obj/item/clothing/suit/storage/resomicloak/standard/black_midgrey
	name = "black and medium grey cloak"
	icon_state = "tesh_cloak_bmg"
	item_state = "tesh_cloak_bmg"

/obj/item/clothing/suit/storage/resomicloak/standard/black_lightgrey
	name = "black and light grey cloak"
	icon_state = "tesh_cloak_blg"
	item_state = "tesh_cloak_blg"

/obj/item/clothing/suit/storage/resomicloak/standard/black_white
	name = "black and white cloak"
	icon_state = "tesh_cloak_bw"
	item_state = "tesh_cloak_bw"

/obj/item/clothing/suit/storage/resomicloak/standard/black_red
	name = "black and red cloak"
	icon_state = "tesh_cloak_br"
	item_state = "tesh_cloak_br"

/obj/item/clothing/suit/storage/resomicloak/standard/black
	name = "black cloak"
	icon_state = "tesh_cloak_bn"
	item_state = "tesh_cloak_bn"

/obj/item/clothing/suit/storage/resomicloak/standard/black_yellow
	name = "black and yellow cloak"
	icon_state = "tesh_cloak_by"
	item_state = "tesh_cloak_by"

/obj/item/clothing/suit/storage/resomicloak/standard/black_green
	name = "black and green cloak"
	icon_state = "tesh_cloak_bgr"
	item_state = "tesh_cloak_bgr"

/obj/item/clothing/suit/storage/resomicloak/standard/black_blue
	name = "black and blue cloak"
	icon_state = "tesh_cloak_bbl"
	item_state = "tesh_cloak_bbl"

/obj/item/clothing/suit/storage/resomicloak/standard/black_purple
	name = "black and purple cloak"
	icon_state = "tesh_cloak_bp"
	item_state = "tesh_cloak_bp"

/obj/item/clothing/suit/storage/resomicloak/standard/black_pink
	name = "black and pink cloak"
	icon_state = "tesh_cloak_bpi"
	item_state = "tesh_cloak_bpi"

/obj/item/clothing/suit/storage/resomicloak/standard/black_brown
	name = "black and brown cloak"
	icon_state = "tesh_cloak_bbr"
	item_state = "tesh_cloak_bbr"

/obj/item/clothing/suit/storage/resomicloak/standard/orange_grey
	name = "orange and grey cloak"
	icon_state = "tesh_cloak_og"
	item_state = "tesh_cloak_og"

/obj/item/clothing/suit/storage/resomicloak/standard/rainbow
	name = "rainbow cloak"
	icon_state = "tesh_cloak_rainbow"
	item_state = "tesh_cloak_rainbow"

/obj/item/clothing/suit/storage/resomicloak/standard/lightgrey_grey
	name = "light grey and grey cloak"
	icon_state = "tesh_cloak_lgg"
	item_state = "tesh_cloak_lgg"

/obj/item/clothing/suit/storage/resomicloak/standard/white_grey
	name = "white and grey cloak"
	icon_state = "tesh_cloak_wg"
	item_state = "tesh_cloak_wg"

/obj/item/clothing/suit/storage/resomicloak/standard/red_grey
	name = "red and grey cloak"
	icon_state = "tesh_cloak_rg"
	item_state = "tesh_cloak_rg"

/obj/item/clothing/suit/storage/resomicloak/standard/orange
	name = "orange cloak"
	icon_state = "tesh_cloak_on"
	item_state = "tesh_cloak_on"

/obj/item/clothing/suit/storage/resomicloak/standard/yellow_grey
	name = "yellow and grey cloak"
	icon_state = "tesh_cloak_yg"
	item_state = "tesh_cloak_yg"

/obj/item/clothing/suit/storage/resomicloak/standard/green_grey
	name = "green and grey cloak"
	icon_state = "tesh_cloak_gg"
	item_state = "tesh_cloak_gg"

/obj/item/clothing/suit/storage/resomicloak/standard/blue_grey
	name = "blue and grey cloak"
	icon_state = "tesh_cloak_blug"
	item_state = "tesh_cloak_blug"

/obj/item/clothing/suit/storage/resomicloak/standard/purple_grey
	name = "purple and grey cloak"
	icon_state = "tesh_cloak_pg"
	item_state = "tesh_cloak_pg"

/obj/item/clothing/suit/storage/resomicloak/standard/pink_grey
	name = "pink and grey cloak"
	icon_state = "tesh_cloak_pig"
	item_state = "tesh_cloak_pig"

/obj/item/clothing/suit/storage/resomicloak/standard/brown_grey
	name = "brown and grey cloak"
	icon_state = "tesh_cloak_brg"
	item_state = "tesh_cloak_brg"

//job resomicloak

/obj/item/clothing/suit/storage/resomicloak/jobs/cargo
	name = "cargo cloak"
	desc = "A soft Resomi cloak made for the Cargo department"
	icon_state = "tesh_cloak_car"
	item_state = "tesh_cloak_car"

/obj/item/clothing/suit/storage/resomicloak/jobs/mining
	name = "mining cloak"
	desc = "A soft Resomi cloak made for Mining"
	icon_state = "tesh_cloak_mine"
	item_state = "tesh_cloak_mine"

/obj/item/clothing/suit/storage/resomicloak/jobs/command
	name = "command cloak"
	desc = "A soft Resomi cloak made for the Command department"
	icon_state = "tesh_cloak_comm"
	item_state = "tesh_cloak_comm"

/obj/item/clothing/suit/storage/resomicloak/jobs/ce
	name = "cheif engineer cloak"
	desc = "A soft Resomi cloak made the Chief Engineer"
	icon_state = "tesh_cloak_ce"
	item_state = "tesh_cloak_ce"

/obj/item/clothing/suit/storage/resomicloak/jobs/eningeer
	name = "engineering cloak"
	desc = "A soft Resomi cloak made for the Engineering department"
	icon_state = "tesh_cloak_engie"
	item_state = "tesh_cloak_engie"

/obj/item/clothing/suit/storage/resomicloak/jobs/atmos
	name = "atmospherics cloak"
	desc = "A soft Resomi cloak made for the Atmospheric Technician"
	icon_state = "tesh_cloak_atmos"
	item_state = "tesh_cloak_atmos"

/obj/item/clothing/suit/storage/resomicloak/jobs/cmo
	name = "chief medical officer cloak"
	desc = "A soft Resomi cloak made the Cheif Medical Officer"
	icon_state = "tesh_cloak_cmo"
	item_state = "tesh_cloak_cmo"

/obj/item/clothing/suit/storage/resomicloak/jobs/medical
	name = "medical cloak"
	desc = "A soft Resomi cloak made for the Medical department"
	icon_state = "tesh_cloak_doc"
	item_state = "tesh_cloak_doc"

/obj/item/clothing/suit/storage/resomicloak/jobs/chemistry
	name = "chemist cloak"
	desc = "A soft Resomi cloak made for the Chemist"
	icon_state = "tesh_cloak_chem"
	item_state = "tesh_cloak_chem"

/obj/item/clothing/suit/storage/resomicloak/jobs/viro
	name = "virologist cloak"
	desc = "A soft Resomi cloak made for the Virologist"
	icon_state = "tesh_cloak_viro"
	item_state = "tesh_cloak_viro"

/obj/item/clothing/suit/storage/resomicloak/jobs/para
	name = "paramedic cloak"
	desc = "A soft Resomi cloak made for the Paramedic"
	icon_state = "tesh_cloak_para"
	item_state = "tesh_cloak_para"

/obj/item/clothing/suit/storage/resomicloak/jobs/sci
	name = "scientist cloak"
	desc = "A soft Resomi cloak made for the Science department"
	icon_state = "tesh_cloak_sci"
	item_state = "tesh_cloak_sci"

/obj/item/clothing/suit/storage/resomicloak/jobs/robo
	name = "roboticist cloak"
	desc = "A soft Resomi cloak made for the roboticist"
	icon_state = "tesh_cloak_robo"
	item_state = "tesh_cloak_robo"

/obj/item/clothing/suit/storage/resomicloak/jobs/sec
	name = "security cloak"
	desc = "A soft Resomi cloak made for the Security department"
	icon_state = "tesh_cloak_sec"
	item_state = "tesh_cloak_sec"

/obj/item/clothing/suit/storage/resomicloak/jobs/qm
	name = "quartermaster cloak"
	desc = "A soft Resomi cloak made for the Quartermaster"
	icon_state = "tesh_cloak_qm"
	item_state = "tesh_cloak_qm"

/obj/item/clothing/suit/storage/resomicloak/jobs/service
	name = "service cloak"
	desc = "A soft Resomi cloak made for the Service department"
	icon_state = "tesh_cloak_serv"
	item_state = "tesh_cloak_serv"

/obj/item/clothing/suit/storage/resomicloak/jobs/iaa
	name = "internal affairs cloak"
	desc = "A soft Resomi cloak made for the Internal Affairs Agent"
	icon_state = "tesh_cloak_iaa"
	item_state = "tesh_cloak_iaa"

/obj/item/clothing/suit/storage/resomicloak_alt
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_suit_resomi.dmi'
	name = "resomi cloak dretrowave"
	desc = "A soft Resomi cloak"
	icon_state = "tesh_cloak_dretrowave"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO

/obj/item/clothing/suit/storage/resomicloak_alt/New()
	..()
	allowed += /obj/item/device/suit_cooling_unit/mini


/obj/item/clothing/suit/storage/resomicloak_alt/tesh_cloak_dretrowave
	name = "resomi cloak dretrowave"
	icon_state = "tesh_cloak_dretrowave"

/obj/item/clothing/suit/storage/resomicloak_alt/green_grey
	name = "green and grey cloak"
	icon_state = "tesh_cloak_gg_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/blue_grey
	name = "blue and grey cloak"
	icon_state = "tesh_cloak_blug_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/purple_grey
	name = "purple and grey cloak"
	icon_state = "tesh_cloak_pg_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/cmo
	name = "chief medical officer cloak"
	desc = "A soft Resomi cloak made the Cheif Medical Officer"
	icon_state = "tesh_cloak_cmo_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/medical
	name = "medical cloak"
	desc = "A soft Resomi cloak made for the Medical department"
	icon_state = "tesh_cloak_doc_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/chemistry
	name = "chemist cloak"
	desc = "A soft Resomi cloak made for the Chemist"
	icon_state = "tesh_cloak_chem_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/psych
	name = "psychiatrist cloak"
	desc = "A soft Resomi cloak made for the Psychiatrist"
	icon_state = "tesh_cloak_psych"

/obj/item/clothing/suit/storage/resomicloak_alt/ce
	name = "cheif engineer cloak"
	desc = "A soft Resomi cloak made the Chief Engineer"
	icon_state = "tesh_cloak_ce_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/engineer
	name = "engineering cloak"
	desc = "A soft Resomi cloak made for the Engineering department"
	icon_state = "tesh_cloak_engie_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/atmos
	name = "atmospherics cloak"
	desc = "A soft Resomi cloak made for the Atmospheric Technician"
	icon_state = "tesh_cloak_atmos_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/hos
	name = "head of security cloak"
	desc = "A soft Resomi cloak made for the Head of Security"
	icon_state = "tesh_cloak_hos"
/obj/item/clothing/suit/storage/resomicloak_alt/qm
	name = "quartermaster cloak"
	desc = "A soft Resomi cloak made for the Quartermaster"
	icon_state = "tesh_cloak_qm_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/cargo
	name = "cargo cloak"
	desc = "A soft Resomi cloak made for the Cargo department"
	icon_state = "tesh_cloak_car_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/mining
	name = "mining cloak"
	desc = "A soft Resomi cloak made for Mining"
	icon_state = "tesh_cloak_mine_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/hop
	name = "head of personnel cloak"
	desc = "A soft Resomi cloak made for the Head of Personnel"
	icon_state = "tesh_cloak_hop"

/obj/item/clothing/suit/storage/resomicloak_alt/service
	name = "service cloak"
	desc = "A soft Resomi cloak made for the Service department"
	icon_state = "tesh_cloak_serv_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/sec
	name = "security cloak"
	desc = "A soft Resomi cloak made for the Security department"
	icon_state = "tesh_cloak_sec_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/iaa
	name = "internal affairs cloak"
	desc = "A soft Resomi cloak made for the Internal Affairs Agent"
	icon_state = "tesh_cloak_iaa"

/obj/item/clothing/suit/storage/resomicloak_alt/robo
	name = "roboticist cloak"
	desc = "A soft Resomi cloak made for the Roboticist"
	icon_state = "tesh_cloak_robo_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/rd
	name = "research director cloak"
	desc = "A soft Resomi cloak made for the Research Director"
	icon_state = "tesh_cloak_rd"

/obj/item/clothing/suit/storage/resomicloak_alt/sci
	name = "scientist cloak"
	desc = "A soft Resomi cloak made for the Science department"
	icon_state = "tesh_cloak_sci_alt"

/obj/item/clothing/suit/storage/resomicloak_alt/iaa
	name = "internal affairs cloak"
	desc = "A soft Resomi cloak made for the Internal Affairs Agent"
	icon_state = "tesh_cloak_iaa"
	item_state = "tesh_cloak_iaa"

//Belted cloaks
/obj/item/clothing/suit/storage/resomicloak_belted
	name = "belted cloak"
	desc = "A more ridged and stylized Resomi cloak."
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_suit_resomi.dmi'
	icon_state = "tesh_beltcloak_bo"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO
	species_restricted = list(SPECIES_RESOMI)

/obj/item/clothing/suit/storage/resomicloak_belted/New()
	..()
	allowed += /obj/item/device/suit_cooling_unit/mini


/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_orange
	name = "black belted cloak (orange)"
	icon_state = "tesh_beltcloak_bo"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_grey
	name = "black belted cloak"
	icon_state = "tesh_beltcloak_bg"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_midgrey
	name = "black belted cloak (medium grey)"
	icon_state = "tesh_beltcloak_bmg"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_lightgrey
	name = "black belted cloak (light grey)"
	icon_state = "tesh_beltcloak_blg"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_white
	name = "black belted cloak (white)"
	icon_state = "tesh_beltcloak_bw"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_red
	name = "black belted cloak (red)"
	icon_state = "tesh_beltcloak_br"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black
	name = "black simple belted cloak"
	icon_state = "tesh_beltcloak_bn"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_yellow
	name = "black belted cloak (yellow)"
	icon_state = "tesh_beltcloak_by"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_green
	name = "black belted cloak (green)"
	icon_state = "tesh_beltcloak_bgr"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_blue
	name = "black belted cloak (blue)"
	icon_state = "tesh_beltcloak_bbl"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_purple
	name = "black belted cloak (purple)"
	icon_state = "tesh_beltcloak_bp"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_pink
	name = "black belted cloak (pink)"
	icon_state = "tesh_beltcloak_bpi"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/black_brown
	name = "black belted cloak (brown)"
	icon_state = "tesh_beltcloak_bbr"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/orange_grey
	name = "orange belted cloak"
	icon_state = "tesh_beltcloak_og"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/rainbow
	name = "rainbow belted cloak"
	icon_state = "tesh_beltcloak_rainbow"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/lightgrey_grey
	name = "light grey belted cloak"
	icon_state = "tesh_beltcloak_lgg"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/white_grey
	name = "white belted cloak"
	icon_state = "tesh_beltcloak_wg"

/obj/item/clothing/suit/storage/resomicloak_belted/standard/brown_grey
	name = "brown belted cloak"
	icon_state = "tesh_beltcloak_brg"

//Belted job cloaks
/obj/item/clothing/suit/storage/resomicloak_belted/jobs/cargo
	name = "cargo belted cloak"
	desc = "A soft Resomi cloak made for the Cargo department"
	icon_state = "tesh_beltcloak_car"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/mining
	name = "mining belted cloak"
	desc = "A soft Resomi cloak made for Mining"
	icon_state = "tesh_beltcloak_mine"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/command
	name = "command belted cloak"
	desc = "A soft Resomi cloak made for the Command department"
	icon_state = "tesh_beltcloak_comm"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/ce
	name = "chief engineer belted cloak"
	desc = "A soft Resomi cloak made the Chief Engineer"
	icon_state = "tesh_beltcloak_ce"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/engineer
	name = "engineering belted cloak"
	desc = "A soft Resomi cloak made for the Engineering department"
	icon_state = "tesh_beltcloak_engie"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/atmos
	name = "atmospherics belted cloak"
	desc = "A soft Resomi cloak made for the Atmospheric Technician"
	icon_state = "tesh_beltcloak_atmos"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/cmo
	name = "chief medical officer belted  cloak"
	desc = "A soft Resomi cloak made the Chief Medical Officer"
	icon_state = "tesh_beltcloak_cmo"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/medical
	name = "medical belted cloak"
	desc = "A soft Resomi cloak made for the Medical department"
	icon_state = "tesh_beltcloak_doc"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/chemistry
	name = "chemist belted cloak"
	desc = "A soft Resomi cloak made for the Chemist"
	icon_state = "tesh_beltcloak_chem"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/viro
	name = "virologist belted cloak"
	desc = "A soft Resomi cloak made for the Virologist"
	icon_state = "tesh_beltcloak_viro"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/sci
	name = "scientist belted cloak"
	desc = "A soft Resomi cloak made for the Science department"
	icon_state = "tesh_beltcloak_sci"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/robo
	name = "roboticist belted cloak"
	desc = "A soft Resomi cloak made for the Roboticist"
	icon_state = "tesh_beltcloak_robo"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/sec
	name = "security belted cloak"
	desc = "A soft Resomi cloak made for the Security department"
	icon_state = "tesh_beltcloak_sec"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/qm
	name = "quartermaster belted cloak"
	desc = "A soft Resomi cloak made for the Quartermaster"
	icon_state = "tesh_beltcloak_qm"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/service
	name = "service belted cloak"
	desc = "A soft Resomi cloak made for the Service department"
	icon_state = "tesh_beltcloak_serv"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/iaa
	name = "internal affairs belted cloak"
	desc = "A soft Resomi cloak made for the Internal Affairs Agent"
	icon_state = "tesh_beltcloak_iaa"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/wrdn
	name = "warden belted cloak"
	desc = "A soft Resomi cloak made for the Warden"
	icon_state = "tesh_beltcloak_wrdn"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/hos
	name = "security chief belted cloak"
	desc = "A soft Resomi cloak made for the Head of Security"
	icon_state = "tesh_beltcloak_hos"

/obj/item/clothing/suit/storage/resomicloak_belted/jobs/jani
	name = "janitor belted cloak"
	desc = "A soft Resomi cloak made for the Janitor"
	icon_state = "tesh_beltcloak_jani"

//Hooded Resomi cloaks
/obj/item/clothing/suit/storage/hooded/resomi
	name = "Hooded Resomi Cloak"
	desc = "A soft resomi cloak with an added hood."
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_suit_resomi.dmi'
	icon_state = "tesh_hcloak_bo"
	//item_state_slots = list(slot_r_hand_str = "tesh_hcloak_bo", slot_l_hand_str = "tesh_hcloak_bo")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	//flags_inv = HIDEHOLSTER|HIDETIE
	action_button_name = "Toggle Cloak Hood"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood
	//allowed = list (/obj/item/weapon/pen, /obj/item/weapon/paper, /obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen, /obj/item/weapon/storage/fancy/cigarettes, /obj/item/weapon/storage/box/matches, /obj/item/weapon/reagent_containers/food/drinks/flask)
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(SPECIES_RESOMI = 'mods/resomi/icons/clothing/onmob_suit_resomi.dmi')

/obj/item/clothing/suit/storage/hooded/resomi/New()
	..()
	if(pockets)
		qdel(pockets)
	pockets = new/obj/item/storage/internal/pouch(src, slots*BASE_STORAGE_COST(ITEM_SIZE_SMALL))

/obj/item/clothing/suit/storage/hooded/resomi/New()
	..()
	allowed += /obj/item/device/suit_cooling_unit/mini


/obj/item/clothing/suit/storage/hooded/resomi/on_update_icon()
	..()
	update_clothing_icon()

/obj/item/clothing/suit/storage/hooded/resomi/polychromic
	name = "polychromic cloak"
	desc = "Resomi cloak. Seems to be coated with polychrome paint. There is also a sewn hood. DO NOT MIX WITH EMP!"
	icon_state = "polychromic"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/polychromic_hood

/obj/item/clothing/suit/storage/hooded/resomi/polychromic/verb/change_color()
	set name = "Change Cloak Color"
	set category = "Object"
	set desc = "Change the color of the cloak."
	set src in usr

	if(usr.incapacitated())
		return

	var/new_color = input(usr, "Pick a new color", "Cloak Color", color) as color|null
	if(!new_color || new_color == color || usr.incapacitated())
		return
	color = new_color
	hood.color = color
	hood.update_icon()
	update_icon()

/obj/item/clothing/suit/storage/hooded/resomi/polychromic/on_update_icon()
	..()
	update_clothing_icon()
	hood.color = color
	hood.update_clothing_icon()

/obj/item/clothing/suit/storage/hooded/resomi/polychromic/emp_act(severity)
	color = null
	hood.color = null
	update_icon()
	..()

/obj/item/clothing/suit/storage/hooded/resomi/black_orange
	name = "black and orange hooded cloak"
	icon_state = "tesh_hcloak_bo"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_orange

/obj/item/clothing/suit/storage/hooded/resomi/black_grey
	name = "black and grey hooded cloak"
	icon_state = "tesh_hcloak_bg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_grey

/obj/item/clothing/suit/storage/hooded/resomi/black_midgrey
	name = "black and medium grey hooded cloak"
	icon_state = "tesh_hcloak_bmg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_midgrey

/obj/item/clothing/suit/storage/hooded/resomi/black_lightgrey
	name = "black and light grey hooded cloak"
	icon_state = "tesh_hcloak_blg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_lightgrey

/obj/item/clothing/suit/storage/hooded/resomi/black_white
	name = "black and white hooded cloak"
	icon_state = "tesh_hcloak_bw"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_white

/obj/item/clothing/suit/storage/hooded/resomi/black_red
	name = "black and red hooded cloak"
	icon_state = "tesh_hcloak_br"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_red

/obj/item/clothing/suit/storage/hooded/resomi/black
	name = "black hooded cloak"
	icon_state = "tesh_hcloak_bn"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black

/obj/item/clothing/suit/storage/hooded/resomi/black_yellow
	name = "black and yellow hooded cloak"
	icon_state = "tesh_hcloak_by"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_yellow

/obj/item/clothing/suit/storage/hooded/resomi/black_green
	name = "black and green hooded cloak"
	icon_state = "tesh_hcloak_bgr"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_green

/obj/item/clothing/suit/storage/hooded/resomi/black_blue
	name = "black and blue hooded cloak"
	icon_state = "tesh_hcloak_bbl"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_blue

/obj/item/clothing/suit/storage/hooded/resomi/black_purple
	name = "black and purple hooded cloak"
	icon_state = "tesh_hcloak_bp"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_purple

/obj/item/clothing/suit/storage/hooded/resomi/black_pink
	name = "black and pink hooded cloak"
	icon_state = "tesh_hcloak_bpi"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_pink

/obj/item/clothing/suit/storage/hooded/resomi/black_brown
	name = "black and brown hooded cloak"
	icon_state = "tesh_hcloak_bbr"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/black_brown

/obj/item/clothing/suit/storage/hooded/resomi/orange_grey
	name = "orange and grey hooded cloak"
	icon_state = "tesh_hcloak_og"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/orange_grey

/obj/item/clothing/suit/storage/hooded/resomi/lightgrey_grey
	name = "light grey and grey hooded cloak"
	icon_state = "tesh_hcloak_lgg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/lightgrey_grey

/obj/item/clothing/suit/storage/hooded/resomi/white_grey
	name = "white and grey hooded cloak"
	icon_state = "tesh_hcloak_wg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/white_grey

/obj/item/clothing/suit/storage/hooded/resomi/red_grey
	name = "red and grey hooded cloak"
	icon_state = "tesh_hcloak_rg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/red_grey

/obj/item/clothing/suit/storage/hooded/resomi/orange
	name = "orange hooded cloak"
	icon_state = "tesh_hcloak_on"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/orange

/obj/item/clothing/suit/storage/hooded/resomi/yellow_grey
	name = "yellow and grey hooded cloak"
	icon_state = "tesh_hcloak_yg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/yellow_grey

/obj/item/clothing/suit/storage/hooded/resomi/green_grey
	name = "green and grey hooded cloak"
	icon_state = "tesh_hcloak_gg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/green_grey

/obj/item/clothing/suit/storage/hooded/resomi/blue_grey
	name = "blue and grey hooded cloak"
	icon_state = "tesh_hcloak_blug"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/blue_grey

/obj/item/clothing/suit/storage/hooded/resomi/purple_grey
	name = "purple and grey hooded cloak"
	icon_state = "tesh_hcloak_pg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/purple_grey

/obj/item/clothing/suit/storage/hooded/resomi/pink_grey
	name = "pink and grey hooded cloak"
	icon_state = "tesh_hcloak_pig"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/pink_grey

/obj/item/clothing/suit/storage/hooded/resomi/brown_grey
	name = "brown and grey hooded cloak"
	icon_state = "tesh_hcloak_brg"
	hoodtype = /obj/item/clothing/head/resomi/resomi_hood/brown_grey

//The actual hoods
/obj/item/clothing/head/resomi/resomi_hood
	name = "Cloak Hood"
	desc = "A hood attached to a resomi cloak."
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_head_resomi.dmi'
	icon_state = "tesh_hcloak_bo_hood"
	flags_inv = BLOCKHAIR | HIDEEARS
	body_parts_covered = HEAD
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(SPECIES_RESOMI = 'mods/resomi/icons/clothing/onmob_head_resomi.dmi')

/obj/item/clothing/head/resomi/resomi_hood/polychromic_hood
	name = "polychromic hood"
	icon_state = "polychromic_hood"
	desc = "It's hood that covers the head."

/obj/item/clothing/head/resomi/resomi_hood/black_orange
	name = "black and orange cloak hood"
	icon_state = "tesh_hcloak_bo_hood"
/obj/item/clothing/head/resomi/resomi_hood/black_grey
	name = "black and grey cloak hood"
	icon_state = "tesh_hcloak_bg_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_midgrey
	name = "black and medium grey cloak hood"
	icon_state = "tesh_hcloak_bmg_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_lightgrey
	name = "black and light grey cloak hood"
	icon_state = "tesh_hcloak_blg_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_white
	name = "black and white cloak hood"
	icon_state = "tesh_hcloak_bw_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_red
	name = "black and red cloak hood"
	icon_state = "tesh_hcloak_br_hood"

/obj/item/clothing/head/resomi/resomi_hood/black
	name = "black cloak hood"
	icon_state = "tesh_hcloak_bn_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_yellow
	name = "black and yellow cloak hood"
	icon_state = "tesh_hcloak_by_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_green
	name = "black and green cloak hood"
	icon_state = "tesh_hcloak_bgr_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_blue
	name = "black and blue cloak hood"
	icon_state = "tesh_hcloak_bbl_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_purple
	name = "black and purple cloak hood"
	icon_state = "tesh_hcloak_bp_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_pink
	name = "black and pink cloak hood"
	icon_state = "tesh_hcloak_bpi_hood"

/obj/item/clothing/head/resomi/resomi_hood/black_brown
	name = "black and brown cloak hood"
	icon_state = "tesh_hcloak_bbr_hood"

/obj/item/clothing/head/resomi/resomi_hood/orange_grey
	name = "orange and grey cloak hood"
	icon_state = "tesh_hcloak_og_hood"

/obj/item/clothing/head/resomi/resomi_hood/rainbow
	name = "rainbow cloak hood"
	icon_state = "tesh_hood_rainbow"

/obj/item/clothing/head/resomi/resomi_hood/lightgrey_grey
	name = "light grey and grey cloak hood"
	icon_state = "tesh_hcloak_lgg_hood"

/obj/item/clothing/head/resomi/resomi_hood/white_grey
	name = "white and grey cloak hood"
	icon_state = "tesh_hcloak_wg_hood"

/obj/item/clothing/head/resomi/resomi_hood/red_grey
	name = "red and grey cloak hood"
	icon_state = "tesh_hcloak_rg_hood"

/obj/item/clothing/head/resomi/resomi_hood/orange
	name = "orange cloak hood"
	icon_state = "tesh_hcloak_on_hood"

/obj/item/clothing/head/resomi/resomi_hood/yellow_grey
	name = "yellow and grey cloak hood"
	icon_state = "tesh_hcloak_yg_hood"

/obj/item/clothing/head/resomi/resomi_hood/green_grey
	name = "green and grey cloak hood"
	icon_state = "tesh_hcloak_gg_hood"

/obj/item/clothing/head/resomi/resomi_hood/blue_grey
	name = "blue and grey cloak hood"
	icon_state = "tesh_hcloak_blug_hood"

/obj/item/clothing/head/resomi/resomi_hood/purple_grey
	name = "purple and grey cloak hood"
	icon_state = "tesh_hcloak_pg_hood"

/obj/item/clothing/head/resomi/resomi_hood/pink_grey
	name = "pink and grey cloak hood"
	icon_state = "tesh_hcloak_pig_hood"

/obj/item/clothing/head/resomi/resomi_hood/brown_grey
	name = "brown and grey cloak hood"
	icon_state = "tesh_hcloak_brg_hood"
