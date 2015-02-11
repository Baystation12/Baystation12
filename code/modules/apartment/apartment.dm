//To-do: split up this file

//Apartment areas
/area/apartments
	name = "Apartments"
	icon_state = "fpmaint"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

/area/apartments/house_1
	name = "House #1"
	icon_state = "fpmaint"

/area/apartments/house_2
	name = "House #2"
	icon_state = "fpmaint"

/area/apartments/house_3
	name = "House #3"
	icon_state = "fpmaint"

/area/apartments/house_4
	name = "House #4"
	icon_state = "fpmaint"

/area/apartments/house_5
	name = "House #5"
	icon_state = "fpmaint"

/area/apartments/house_6
	name = "House #6"
	icon_state = "fpmaint"

/area/apartments/house_7
	name = "House #7"
	icon_state = "fpmaint"

/area/apartments/house_8
	name = "House #8"
	icon_state = "fpmaint"

/area/apartments/house_9
	name = "House #9"
	icon_state = "fpmaint"

/area/apartments/house_10
	name = "House #10"
	icon_state = "fpmaint"

/area/apartments/house_11
	name = "House #11"
	icon_state = "fpmaint"

/area/apartments/house_12
	name = "House #12"
	icon_state = "fpmaint"

/area/apartments/house_13
	name = "House #13"
	icon_state = "fpmaint"

/area/apartments/house_14
	name = "House #14"
	icon_state = "fpmaint"

/area/apartments/house_15
	name = "House #15"
	icon_state = "fpmaint"

/area/apartments/house_16
	name = "House #16"
	icon_state = "fpmaint"

/area/apartments/house_17
	name = "House #17"
	icon_state = "fpmaint"

/area/apartments/house_18
	name = "House #18"
	icon_state = "fpmaint"

/area/apartments/house_19
	name = "House #19"
	icon_state = "fpmaint"

/area/apartments/house_20
	name = "House #20"
	icon_state = "fpmaint"

/area/apartments/house_1d
	name = "House D-01"
	icon_state = "fpmaint"

/area/apartments/house_2d
	name = "House D-02"
	icon_state = "fpmaint"

/area/apartments/house_3d
	name = "House D-03"
	icon_state = "fpmaint"

/area/apartments/house_4d
	name = "House D-04"
	icon_state = "fpmaint"

/area/apartments/house_5d
	name = "House D-05"
	icon_state = "fpmaint"

/area/apartments/house_6d
	name = "House D-06"
	icon_state = "fpmaint"

/area/apartments/house_7d
	name = "House D-07"
	icon_state = "fpmaint"

/area/apartments/house_8d
	name = "House D-08"
	icon_state = "fpmaint"

/area/apartments/house_1e
	name = "House E-01"
	icon_state = "fpmaint"

/area/apartments/house_2e
	name = "House E-02"
	icon_state = "fpmaint"

/area/apartments/house_3e
	name = "House E-03"
	icon_state = "fpmaint"

/area/apartments/house_4e
	name = "House E-04"
	icon_state = "fpmaint"

/area/apartments/house_5e
	name = "House E-05"
	icon_state = "fpmaint"

/area/apartments/sauna_lobby
	name = "Sauna lobby"
	icon_state = "fpmaint"

/area/apartments/sauna
	name = "Sauna"
	icon_state = "fpmaint"

/area/apartments/pub
	name = "Pub"
	icon_state = "fpmaint"

/area/apartments/meeting_room
	name = "Community Meeting Room"
	icon_state = "fpmaint"

/area/apartments/hidroponics
	name = "Community Hydroponics"
	icon_state = "fpmaint"

/area/apartments/engineering
	name = "Engineering Wing"
	icon_state = "fpmaint"

/area/apartments/aft_hallway
	name = "Aft Hallway"
	icon_state = "fpmaint"

/area/apartments/port_hallway
	name = "Port Hallway"
	icon_state = "fpmaint"

/area/apartments/garden
	name = "Park"
	icon_state = "fpmaint"

/area/apartments/mid_hallway
	name = "Center Hallway"
	icon_state = "fpmaint"

/area/apartments/aft_secd_hallway
	name = "Second Deck Aft Hallway"
	icon_state = "fpmaint"

/area/apartments/cent_secd_hallway
	name = "Second Deck Central Hallway"
	icon_state = "fpmaint"

/area/apartments/chapel/main
	name = "\improper Chapel"
	icon_state = "chapel"
	ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg','sound/music/traitor.ogg')

/area/apartments/library
 	name = "\improper Library"
 	icon_state = "library"

/area/apartments/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	music = "signal"

/area/apartments/medical/medbay
	name = "\improper Medbay"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

/area/apartments/medical/chemistry
	name = "\improper Chemistry"
	icon_state = "chem"

/area/apartments/medical/surgery
	name = "\improper Operating Theatre 1"
	icon_state = "surgery"


//Shuttle areas

/area/shuttle/marina/transport
	name = "\improper Marina Transport Shuttle"
	icon_state = "shuttle"

area/shuttle/marina/transport/station
	icon_state = "shuttle2"

/area/shuttle/marina/transport/centcom
	icon_state = "shuttle"

/area/shuttle/marina/elevator
	name = "\improper Marina elevator"
	icon_state = "shuttle"

area/shuttle/marina/elevator/groundfloor
	icon_state = "shuttle2"
	music = "music/lift.wav"

/area/shuttle/marina/elevator/upperfloor
	icon_state = "shuttle"
	music = "music/lift.wav"

//Signs
/obj/structure/sign/directions/onetofive
	name = "\improper 'Pasillo Amarillo' (A)"
	desc = "A direction sign, pointing out the direction of the Hallway 'A'."
	icon_state = "direction_onetofive"

/obj/structure/sign/directions/sixtonine
	name = "\improper 'Blue Hallway' (B)"
	desc = "A direction sign, pointing out the direction of the Hallway 'B'."
	icon_state = "direction_sixtonine"

/obj/structure/sign/directions/tentoeighteen
	name = "\improper 'Pasillo Calabaza' (C)"
	desc = "A direction sign, pointing out the direction of the Hallway 'C'."
	icon_state = "direction_tentoeighteen"

/obj/structure/sign/directions/meeting
	name = "\improper Meeting Room"
	desc = "A direction sign, pointing out which way the meeting room is."
	icon_state = "direction_meeting"

/obj/structure/sign/directions/administration
	name = "\improper Administration Office"
	desc = "A direction sign, pointing out which way the administration office is."
	icon_state = "direction_admin"

/obj/structure/sign/directions/park
	name = "\improper Park"
	desc = "A direction sign, pointing out which way the park is."
	icon_state = "direction_park"

/obj/structure/sign/directions/hydroponics
	name = "\improper Community Hydroponics"
	desc = "A direction sign, pointing out which way the Community Hydroponics is."
	icon_state = "direction_hydroponics"

/obj/structure/sign/directions/pool
	name = "\improper Pool"
	desc = "A direction sign, pointing out which way the Pool is."
	icon_state = "direction_pool"

/obj/structure/sign/directions/holodeck
	name = "\improper Holodeck"
	desc = "A direction sign, pointing out which way the Holodeck is."
	icon_state = "direction_holodeck"

/obj/structure/sign/directions/sauna
	name = "\improper Sauna"
	desc = "A direction sign, pointing out which way the Sauna is."
	icon_state = "direction_sauna"

/obj/structure/sign/directions/dhallway
	name = "\improper 'Dusty Rose Hallway' (D)"
	desc = "A direction sign, pointing out the direction of the hallway 'D'."
	icon_state = "direction_dhallway"

/obj/structure/sign/directions/ehallway
	name = "\improper 'Pasillo Esmeralda' (E)"
	desc = "A direction sign, pointing out the direction of the hallway 'E'."
	icon_state = "direction_ehallway"

/obj/structure/sign/directions/market
	name = "\improper Market"
	desc = "A direction sign, pointing out the direction of the Market."
	icon_state = "direction_market"

/obj/structure/sign/hallwaysigns/hallway_a
	name = "\improper 'Amarillo' (A) Hallway"
	desc = "A sign which shows in which hallway you are. This one shows 'A'."
	icon_state = "hallway_a"

/obj/structure/sign/hallwaysigns/hallway_b
	name = "\improper 'Blue' (B) Hallway"
	desc = "A sign which shows in which hallway you are. This one shows 'B'."
	icon_state = "hallway_b"

/obj/structure/sign/hallwaysigns/hallway_c
	name = "\improper 'Calabaza' (C) Hallway"
	desc = "A sign which shows in which hallway you are. This one shows 'C'."
	icon_state = "hallway_c"

/obj/structure/sign/hallwaysigns/hallway_d
	name = "\improper 'Dusty Rose' (D) Hallway"
	desc = "A sign which shows in which hallway you are. This one shows 'D'."
	icon_state = "hallway_d"

/obj/structure/sign/hallwaysigns/hallway_e
	name = "\improper 'Esmeralda' (E) Hallway"
	desc = "A sign which shows in which hallway you are. This one shows 'E'."
	icon_state = "hallway_e"

/obj/structure/sign/hallwaysigns/marina_left
	name = "\improper Marina Apartments"
	desc = "Where your dreams come true!."
	icon_state = "marinasignleft"

/obj/structure/sign/hallwaysigns/marina_middle
	name = "\improper Marina Apartments"
	desc = "Where your dreams come true!."
	icon_state = "marinasignmiddle"

/obj/structure/sign/hallwaysigns/marina_right
	name = "\improper Marina Apartments"
	desc = "Where your dreams come true!."
	icon_state = "marinasignright"

/obj/structure/sign/hallwaysigns/sauna_right
	name = "\improper Sauna"
	desc = "This sign indicates this is the Sauna."
	icon_state = "saunaright"

/obj/structure/sign/hallwaysigns/sauna_left
	name = "\improper Sauna"
	desc = "This sign indicates this is the Sauna."
	icon_state = "saunaleft"

/obj/structure/sign/hallwaysigns/sauna_men
	name = "\improper Male Changing Room"
	desc = "This is where males should change their clothes."
	icon_state = "saunamen"

/obj/structure/sign/hallwaysigns/sauna_women
	name = "\improper Female Changing Room"
	desc = "This is where females should change their clothes."
	icon_state = "saunawomen"

/obj/structure/sign/ads_monitor
	name = "\improper Advertising Monitor"
	desc = "A NT advertising monitor."
	icon_state = "ads_monitor"

/obj/structure/sign/ads_monitor2
	name = "\improper Advertising Monitor"
	desc = "A NT advertising monitor."
	icon_state = "ads_monitor2"

/obj/structure/sign/apartment/apartment_1a
	name = "\improper Apartment A-01"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_1a"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_2a
	name = "\improper Apartment A-02"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_2a"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_3a
	name = "\improper Apartment A-03"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_3a"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_4a
	name = "\improper Apartment A-04"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_4a"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_5a
	name = "\improper Apartment A-05"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_5a"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_1b
	name = "\improper Apartment B-01"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_1b"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_2b
	name = "\improper Apartment B-02"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_2b"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_3b
	name = "\improper Apartment B-03"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_3b"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_4b
	name = "\improper Apartment B-04"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_4b"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_1c
	name = "\improper Apartment C-01"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_1c"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_2c
	name = "\improper Apartment C-02"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_2c"
	pixel_y = -32

/obj/structure/sign/apartment/apartment_3c
	name = "\improper Apartment C-03"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_3c"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_4c
	name = "\improper Apartment C-04"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_4c"
	pixel_y = -32

/obj/structure/sign/apartment/apartment_5c
	name = "\improper Apartment C-05"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_5c"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_6c
	name = "\improper Apartment C-06"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_6c"
	pixel_y = -32

/obj/structure/sign/apartment/apartment_7c
	name = "\improper Apartment C-07"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_7c"
	pixel_y = -32

/obj/structure/sign/apartment/apartment_8c
	name = "\improper Apartment C-08"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_8c"

/obj/structure/sign/apartment/apartment_9c
	name = "\improper Apartment C-09"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_9c"

/obj/structure/sign/apartment/apartment_10c
	name = "\improper Apartment C-10"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_10c"
	pixel_x = 32

/obj/structure/sign/apartment/apartment_11c
	name = "\improper Apartment C-11"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_11c"
	pixel_x = 32

/obj/structure/sign/apartment/apartment_1d
	name = "\improper Apartment D-01"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_1d"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_2d
	name = "\improper Apartment D-02"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_2d"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_3d
	name = "\improper Apartment D-03"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_3d"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_4d
	name = "\improper Apartment D-04"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_4d"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_5d
	name = "\improper Apartment D-05"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_5d"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_6d
	name = "\improper Apartment D-06"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_6d"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_7d
	name = "\improper Apartment D-07"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_7d"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_8d
	name = "\improper Apartment D-08"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_8d"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_1e
	name = "\improper Apartment E-01"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_1e"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_2e
	name = "\improper Apartment E-02"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_2e"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_3e
	name = "\improper Apartment E-03"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_3e"
	pixel_y = 32

/obj/structure/sign/apartment/apartment_4e
	name = "\improper Apartment E-04"
	desc = "A sign which shows the number and hallway of the apartment."
	icon_state = "apartment_4e"
	pixel_y = 32

/obj/structure/sign/stores/bistro
	name = "\improper Carol's Bistro!"
	desc = "Hungry? Just come and ask for a take-away meal!"
	icon_state = "bistro"

/obj/structure/sign/stores/clinic
	name = "\improper Coldwell's Clinic!"
	desc = "Feeling unhealthy? Dr. Coldwell has the solution!"
	icon_state = "clinic"

/obj/structure/sign/stores/veggies
	name = "\improper David's Veggies"
	desc = "Making parent's delight and children's nightmares since 2569!"
	icon_state = "veggies"

/obj/structure/sign/stores/bakery
	name = "\improper The Candy Shoppe."
	desc = "Your greatest bakery all accross the galaxy! Now with more sweets and 'Candis'!"
	icon_state = "bakery"

/obj/structure/sign/tank
	name = "\improper DO NOT DAMAGE AIR TANKS"
	desc = "A warning sign which reads 'DO NOT DAMAGE AIR TANKS. This could cause an overhelming damage and immediate death.'."
	icon_state = "tank"

/obj/structure/sign/doors
	name = "\improper CLOSE DOORS BEHIND YOU"
	desc = "A warning sign which reads 'CLOSE DOORS BEHIND YOU'."
	icon_state = "doors"

//Structures

/obj/structure/stool/bed/chair/couch
	name = "Couch"
	desc = "A big comfy chair! Now, all the family can seat together!"

/obj/structure/stool/bed/chair/couch/black_1
	icon_state = "couchblack1"

/obj/structure/stool/bed/chair/couch/black_2
	icon_state = "couchblack2"

/obj/structure/stool/bed/chair/couch/beige_1
	icon_state = "couchbeige1"

/obj/structure/stool/bed/chair/couch/beige_2
	icon_state = "couchbeige2"

/obj/structure/stool/bed/chair/couch/lime_1
	icon_state = "couchlime1"

/obj/structure/stool/bed/chair/couch/lime_2
	icon_state = "couchlime2"

/obj/structure/stool/bed/chair/couch/brown_1
	icon_state = "couchbrown1"

/obj/structure/stool/bed/chair/couch/brown_2
	icon_state = "couchbrown2"

/obj/structure/stool/bed/chair/couch/teal_1
	icon_state = "couchteal1"

/obj/structure/stool/bed/chair/couch/teal_2
	icon_state = "couchteal2"

/obj/structure/stool/bed/chair/couch/saunabench1
	icon_state = "saunabench1"

/obj/structure/stool/bed/chair/couch/saunabench2
	icon_state = "saunabench2"

/obj/structure/closet/liftlocker
	desc = "A wall mounted storage with some lift-related emergencies in it."
	name = "Lift Emergency Equipment"
	icon = 'icons/obj/walllocker.dmi'
	icon_state = "lift-locker"
	density = 0
	anchored = 1
	icon_closed = "lift-locker"
	icon_opened = "wall-lockeropen"

//Sauna

/obj/machinery/alarm/sauna/New()
	..()
	req_access = list(access_rd, access_atmospherics, access_engine_equip)
	TLV["oxygen"] =			list(16, 19, 135, 140) // Partial pressure, kpa
	TLV["carbon dioxide"] = list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
	TLV["plasma"] =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["other"] =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] =		list(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.30,ONE_ATMOSPHERE*1.40) /* kpa */
	TLV["temperature"] =	list(T0C-26, T0C, T0C+75, T0C+80) // K
	target_temperature = 343.15

//Apartment doors. Sigh.

/var/const/access_a1 = 110
/var/const/access_a2 = 111
/var/const/access_a3 = 112
/var/const/access_a4 = 113
/var/const/access_a5 = 114
/var/const/access_a6 = 115
/var/const/access_a7 = 116
/var/const/access_a8 = 117
/var/const/access_a9 = 118
/var/const/access_a10 = 119
/var/const/access_a11 = 120
/var/const/access_a12 = 121
/var/const/access_a13 = 122
/var/const/access_b1 = 123
/var/const/access_b2 = 124
/var/const/access_b3 = 125
/var/const/access_b4 = 126
/var/const/access_c1 = 127
/var/const/access_c2 = 128
/var/const/access_c3 = 129
/var/const/access_c4 = 130
/var/const/access_c5 = 131
/var/const/access_c6 = 132
/var/const/access_c7 = 133
/var/const/access_c8 = 134
/var/const/access_d1 = 135
/var/const/access_d2 = 136
/var/const/access_d3 = 137
/var/const/access_d4 = 138
/var/const/access_d5 = 139
/var/const/access_d6 = 140
/var/const/access_d7 = 141
/var/const/access_d8 = 142
/var/const/access_d9 = 143
/var/const/access_d10 = 144
/var/const/access_d11 = 145
/var/const/access_d12 = 146
/var/const/access_e1 = 147
/var/const/access_e2 = 148
/var/const/access_e3 = 149
/var/const/access_e4 = 151
/var/const/access_e5 = 152
/var/const/access_e6 = 153
/var/const/access_e7 = 154
/var/const/access_e8 = 155
/var/const/access_e9 = 156
/var/const/access_e10 = 157
/var/const/access_e11 = 158
/var/const/access_e12 = 159
/var/const/access_e13 = 160
/var/const/access_e14 = 161
/var/const/access_e15 = 162
/var/const/access_ship1 = 300

/obj/item/weapon/card/id/apartment
	name = "resident card"
	desc = "A card used to provide ID and give access to apartments."
	assignment = "Resident"

/obj/item/weapon/card/id/apartment/a1
	access = list(access_a1)

/obj/item/weapon/card/id/apartment/a2
	access = list(access_a2)

/obj/item/weapon/card/id/apartment/a3
	access = list(access_a3)

/obj/item/weapon/card/id/apartment/a4
	access = list(access_a4)

/obj/item/weapon/card/id/apartment/a5
	access = list(access_a5)

/obj/item/weapon/card/id/apartment/a6
	access = list(access_a6)

/obj/item/weapon/card/id/apartment/a7
	access = list(access_a7)

/obj/item/weapon/card/id/apartment/a8
	access = list(access_a8)

/obj/item/weapon/card/id/apartment/a9
	access = list(access_a9)

/obj/item/weapon/card/id/apartment/a10
	access = list(access_a10)

/obj/item/weapon/card/id/apartment/a11
	access = list(access_a11)

/obj/item/weapon/card/id/apartment/a12
	access = list(access_a12)

/obj/item/weapon/card/id/apartment/a13
	access = list(access_a13)

/obj/item/weapon/card/id/apartment/b1
	access = list(access_b1)

/obj/item/weapon/card/id/apartment/b2
	access = list(access_b2)

/obj/item/weapon/card/id/apartment/b3
	access = list(access_b3)

/obj/item/weapon/card/id/apartment/b4
	access = list(access_b4)

/obj/item/weapon/card/id/apartment/c1
	access = list(access_c1)

/obj/item/weapon/card/id/apartment/c2
	access = list(access_c2)

/obj/item/weapon/card/id/apartment/c3
	access = list(access_c3)

/obj/item/weapon/card/id/apartment/c4
	access = list(access_c4)

/obj/item/weapon/card/id/apartment/c5
	access = list(access_c5)

/obj/item/weapon/card/id/apartment/c6
	access = list(access_c6)

/obj/item/weapon/card/id/apartment/c7
	access = list(access_c7)

/obj/item/weapon/card/id/apartment/c8
	access = list(access_c8)

/obj/item/weapon/card/id/apartment/d1
	access = list(access_d1)

/obj/item/weapon/card/id/apartment/d2
	access = list(access_d2)

/obj/item/weapon/card/id/apartment/d3
	access = list(access_d3)

/obj/item/weapon/card/id/apartment/d4
	access = list(access_d4)

/obj/item/weapon/card/id/apartment/d5
	access = list(access_d5)

/obj/item/weapon/card/id/apartment/d6
	access = list(access_d6)

/obj/item/weapon/card/id/apartment/d7
	access = list(access_d7)

/obj/item/weapon/card/id/apartment/d9
	access = list(access_d9)

/obj/item/weapon/card/id/apartment/d10
	access = list(access_d10)

/obj/item/weapon/card/id/apartment/d11
	access = list(access_d11)

/obj/item/weapon/card/id/apartment/d12
	access = list(access_d12)

/obj/item/weapon/card/id/apartment/e1
	access = list(access_e1)

/obj/item/weapon/card/id/apartment/e2
	access = list(access_e2)

/obj/item/weapon/card/id/apartment/e3
	access = list(access_e3)

/obj/item/weapon/card/id/apartment/e4
	access = list(access_e4)

/obj/item/weapon/card/id/apartment/e5
	access = list(access_e5)

/obj/item/weapon/card/id/apartment/e6
	access = list(access_e6)

/obj/item/weapon/card/id/apartment/e7
	access = list(access_e7)

/obj/item/weapon/card/id/apartment/e8
	access = list(access_e8)

/obj/item/weapon/card/id/apartment/e9
	access = list(access_e9)

/obj/item/weapon/card/id/apartment/e10
	access = list(access_e10)

/obj/item/weapon/card/id/apartment/e11
	access = list(access_e11)

/obj/item/weapon/card/id/apartment/e12
	access = list(access_e12)

/obj/item/weapon/card/id/apartment/e13
	access = list(access_e13)

/obj/item/weapon/card/id/apartment/e14
	access = list(access_e14)

/obj/item/weapon/card/id/apartment/e15
	access = list(access_e15)
	name = "A-11 resident card"
	registered_name = "Vasily Surov"

/obj/item/weapon/card/id/apartment/ship1
	access = list(access_ship1)