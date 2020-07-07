
/datum/techprint/autopsy
	category_type = /datum/techprint/autopsy
	desc = "Perform autopsies using the autosurgeon on this species"
	hidden = TRUE

/datum/techprint/autopsy/human
	name = "Human autopsy"
	hidden = FALSE
	required_objs = list(/obj/item/weapon/paper/autopsy_report/human = "A human autopsy report")

/datum/techprint/autopsy/sangheili
	name = "Sangheili autopsy"
	required_objs = list(/obj/item/weapon/paper/autopsy_report/sangheili = "A Sangheili autopsy report")

/datum/techprint/autopsy/jiralhanae
	name = "Jiralhanae autopsy"
	required_objs = list(/obj/item/weapon/paper/autopsy_report/jiralhanae = "A Jiralhanae autopsy report")

/datum/techprint/autopsy/ruuhtian
	name = "Ruuhtian Kig\'Yar autopsy"
	required_objs = list(/obj/item/weapon/paper/autopsy_report/ruuhtian = "A Ruuhtian Kig\'Yar autopsy report")

/datum/techprint/autopsy/tvoan
	name = "T\'Voan Kig\'Yar autopsy"
	required_objs = list(/obj/item/weapon/paper/autopsy_report/tvoan = "A T\'Voan Kig\'Yar autopsy report")

/datum/techprint/autopsy/unggoy
	name = "Unggoy autopsy"
	required_objs = list(/obj/item/weapon/paper/autopsy_report/unggoy = "An Unggoy autopsy report")

/datum/techprint/autopsy/sanshyuum
	name = "San\'Shyuum autopsy"
	required_objs = list(/obj/item/weapon/paper/autopsy_report/sanshyuum = "A San\'Shyuum autopsy report")

/datum/techprint/autopsy/yanmee
	name = "Yan\'Mee autopsy"
	required_objs = list(/obj/item/weapon/paper/autopsy_report/yanmee = "A Yan\'Mee autopsy report")
