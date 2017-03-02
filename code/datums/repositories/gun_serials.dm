// var/repository/gun_serials/gun_serials_repository = new()
//
// /repository/gun_serials
// 	var/list/created_serials
//
// /repository/gun_serials/New()
// 	created_serials = list()
//
// /repository/gun_serials/proc/add_entry(var/item/weapon/gun/associated_gun)
//   var/gun_serial =
//   if(created_serials[])
//
//   var/armoryArea = /area/constructionsite // change here 
//   var/currentArea = get_area(src)
//   to_world(currentArea)
//
//   var/gun_serial_entry/new_entry = new()
//   new_entry.associated_gun = associated_gun
//
//   var/new_serial = random_id("gun_serials", 10000, 99999)
//   new_entry.serial = new_serial
//   associated_gun.serial_number = new_serial
//
//   if(istype(currentArea, armoryArea))
//     new_entry.is_in_armory = 1
//
//   created_serials.Insert()
//
// /gun_serial_entry
//   var/item/weapon/gun/associated_gun
//   var/serial
//
//   var/is_in_armory
//
// /gun_serial_entry/proc/New()
//   is_in_armory = 0
