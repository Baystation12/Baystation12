/decl/prefab/ic_assembly/test_heatercooler
	assembly_name = "heating-cooling-test"
	data = {"{'assembly':{'type':'type-c electronic machine'},'components':\[{'type':'starter'},{'type':'reagent funnel'},{'type':'big reagent storage'},{'type':'reagent pump','name':'Hot Pump','inputs':\[\[3,0,5]]},{'type':'reagent pump','name':'Cool Pump','inputs':\[\[3,0,5]]},{'type':'reagent heater','name':'Heater','inputs':\[\[1,0,80]]},{'type':'reagent cooler','name':'Cooler','inputs':\[\[1,0,-50]]},{'type':'button','name':'Heat And Cool'},{'type':'and gate','name':'Heater Active Check','inputs':\[\[1,0,0],\[2,0,1]]},{'type':'and gate','name':'Cooler Active Check','inputs':\[\[1,0,0],\[2,0,1]]},{'type':'custom delay circuit','name':'Heater Delay','inputs':\[\[1,0,100]]},{'type':'custom delay circuit','name':'Cooler Delay','inputs':\[\[1,0,100]]}],'wires':\[\[\[1,'A',1],\[3,'A',1]],\[\[1,'A',1],\[6,'A',3]],\[\[1,'A',1],\[7,'A',3]],\[\[2,'I',1],\[3,'O',2]],\[\[3,'O',2],\[4,'I',1]],\[\[3,'O',2],\[5,'I',1]],\[\[4,'I',2],\[6,'O',4]],\[\[4,'A',1],\[8,'A',1]],\[\[4,'A',2],\[6,'A',1]],\[\[5,'I',2],\[7,'O',4]],\[\[5,'A',1],\[8,'A',1]],\[\[5,'A',2],\[7,'A',1]],\[\[6,'O',3],\[9,'I',1]],\[\[6,'A',1],\[11,'A',2]],\[\[6,'A',2],\[9,'A',1]],\[\[7,'O',3],\[10,'I',1]],\[\[7,'A',1],\[12,'A',2]],\[\[7,'A',2],\[10,'A',1]],\[\[9,'A',2],\[11,'A',1]],\[\[10,'A',2],\[12,'A',1]]]}"}
	power_cell_type = /obj/item/weapon/cell/hyper

/obj/prefab/test_heatcool
	name = "heating-cooling test"
	prefab_type = /decl/prefab/ic_assembly/test_heatercooler
