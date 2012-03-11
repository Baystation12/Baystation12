datum/os/proc/Prase(FY,list/var2,tex=0)
	if(FindFile(FY))
		var/datum/dir/file/F = FindFile(FY)
		new /datum/praser(src,F.contents)

datum/praser
	var/list/var1 = list()
	var/list/list1 = list()
	var/list/func = list()
	var/list/gotos = list()
	var/list/overflow = list()
	var/list/ifs = list()
	var/stop = 0
	var/ismain= 0
	var/background=0

datum/ifs
	var/list/lines = list()
	var/var1
	var/var2
	var/typek
	var/datum/praser/P
	var/datum/praser/owner

datum/ifs/New(v1,typex,v2,var/datum/praser/K)
	var1 = v1
	var2 = v2
	typek = typex
	P = K
	owner = P

datum/ifs/proc/compare(var/datum/os/client)
	var/v1 = P.var1[var1]
	var/v2 = P.var1[var2]
	if(typek == "==")
		if(v1 == v2)
			P.Prase(client,null,lines,0,1)
	else if(typek == "!=")
		if(v1 != v2)
			P.Prase(client,null,lines)
	else if(typek == ">=")
		if(v1 >= v2)
			P.Prase(client,null,lines)
	else if(typek == "<=")
		if(v1 <= v2)
			P.Prase(client,null,lines)
	else if(typek == "<")
		if(v1 < v2)
			P.Prase(client,null,lines)
	else if(typek == ">")
		if(v1 > v2)
			P.Prase(client,null,lines)


datum/praser/New(var/datum/os/client,var/text,var/list/notlines,bg=0,isscript=0)
	background=bg
	spawn() Prase(client,text,notlines,1,isscript)
	return src


datum/praser/proc/Prase(var/datum/os/client,var/text,var/list/notlines,ismain=0,isscript=0)
	client.process += src
//	if(!background)
//		client.boot = 0
	var/list/lines = list()
	if(notlines)
		if(notlines.len <= 0)
			return
		lines = notlines
		goto gohere
	var/done
	while (done!=1)
		var/X = findtext(text,"\n",1,0)
		if(!X)
			done = 1
			lines += text
		//	// "DONE"
			break
		else
			var/Y = copytext(text,1,X)
			text = copytext(
			text,X+1,0)
			lines += Y
		sleep(1)
	gohere
	var1["os_ip"] = ip2text(client.ip)
	var1["os_user"] = client.user.name
	if(client.connected)
		var1["os_isconnected"] = 1
	else
		var1["os_isconnected"] = 0
	var/datum/func/sendpacket/KKQ = new("SendPacket",list(1,2,3),src)
	func["SendPacket"] = KKQ
	for(var/countglobal, countglobal <= lines.len, countglobal++)
		if(!client)
			del(src)
			return 1
		if(client.stopprog)
			client.stopprog = 0
			client.boot = 1
			del(src)
			return 1
		if(stop || var1["stop"] == 1)
			//world << "stopping [ismain]"
			del(src)
			return 1
		var/A = lines[countglobal]
		if(findtext(A,"func:",1,0))
			var/loc1 = findtext(A,"<",1,0)
			var/loc2 = findtext(A,">",1,0)
			var/N = copytext(A,loc1+1,loc2)
			loc1 = findtext(A,"(",1,0)
			loc2 = findtext(A,")",1,0)
			var/xc = copytext(A,loc1+1,loc2)
			var/dones = 1
			var/list/xy = list()
			if(!xc)
				dones = 0
			while (dones==1)
				var/X = findtext(xc,",",1,0)
				if(!X)
					done = 1
					xy += xc
			//		world << "DONE"
					break
				else
					var/Y = copytext(xc,1,X)
					xc = copytext(xc,X+1,0)
					xy += Y
			var/datum/func/F = new(N,xy,src)
			src.func["[N]"] = F
			var/locI = lines.Find(A,1,0)
			var/test = 1
			var/count = locI+1
			var/list/xlist = list()
			while (test)
				var/X = lines[count]
			//	world << lines[count]
				if(X == "endf")
					xlist += X
					test = 0
				//	break
				else
					xlist += X
				count++
			lines.Remove(xlist)
			F.lines = xlist
		else if(findtext(A,"if:",1,0))
			var/loc1 = findtext(A,"<",1,0)
			var/loc2 = findtext(A,">",1,0)
			var/N = copytext(A,loc1+1,loc2)
			loc1 = findtext(A,"(",1,0)
			loc2 = findtext(A,")",1,0)
			var/xc = copytext(A,loc1+1,loc2)
			var/dones = 1
			var/list/xy = list()
			if(!xc)
				dones = 0
			while (dones==1)
				var/X = findtext(xc,",",1,0)
				if(!X)
					done = 1
					xy += xc
			//		world << "DONE"
					break
				else
					var/Y = copytext(xc,1,X)
					xc = copytext(xc,X+1,0)
					xy += Y
			var/k = 0
			for(var/X in xy)
				k++
				var/l = findtext(X,"$",1,0)
				xy[k] = copytext(X,l+1,0)
			var/datum/ifs/F = new(xy[1],xy[2],xy[3],src)
			src.ifs["[N]"] = F
			var/test = 1
			var/count = countglobal+1
			var/list/xlist = list()
			while (test)
				var/X = lines[count]
				if(X == "endi")
					xlist += X
					test = 0
				//	break
				else
					xlist += X
				count++
			lines.Remove(lines[countglobal])
			lines.Remove(xlist)
			F.lines = xlist
		else if(findtext(A,"label:",1,0))
			var/startloc = findtext(A,":",1,0)
			var/lname = copytext(A,startloc+1,0)
			var/loc = lines.Find(A)
			if(!loc)
				client.Message("Error")
				continue
			//world << lname
			gotos[lname] = loc
		else if(findtext(A,"goto(",1,0))
			var/startloc = findtext(A,"(",1,0)
			var/endloc = findtext(A,")",1,0)
			var/lname = copytext(A,startloc+1,endloc)
			countglobal = gotos[lname]-1
			sleep(1)
			continue
		else if(findtext(A,"echo(",1,0))
			var/output
			var/startloc = findtext(A,"(",1,0)
			var/endloc = findtext(A,")",length(A)-1,0)
			if(!startloc || !endloc)
				client.Message("Error..")
				return
			var/msg = copytext(A,startloc+1,endloc)
			if(findtext(msg,"\[",1,0))
				var/loc = findtext(msg,"\[",1,0)
				var/loc2 = findtext(msg,"\]",1,0)
				var/varname = copytext(msg,1+1,loc)
				var/num = copytext(msg,loc+1,loc2)
				num = text2num(num)
				var/list/X = var1[varname]
				output = X[num]
			else if(findtext(msg,"$",1,0))
				var/loc = findtext(msg,"$",1,0)
				var/varname = copytext(msg,loc+1,endloc)
				output = var1[varname]
			else if(findtext(msg,"\"",1,0))
				var/loc = findtext(msg,"\"",1,0)
				var/loc2 = findtext(msg,"\"",loc+1,0)
				output = copytext(msg,loc+1,loc2)
			client.Message("[output]")
		else if(findtext(A,"Lower(",1,0))
			var/output = null
			var/variable = null
			var/startloc = findtext(A,"(",1,0)
			var/endloc = findtext(A,")",length(A)-1,0)
			var/loc
			if(!startloc || !endloc)
				client.Message("Error..")
			var/msg = copytext(A,startloc+1,endloc)
			if(findtext(msg,"$",1,0))
				loc = findtext(msg,"$",1,0)
				var/varname
				if(findtext(msg,",",1,0))
					var/lock = findtext(msg,",",1,0)

					varname = copytext(msg,loc+1,lock)
				else
					varname = copytext(msg,loc+1,endloc)
				output = varname
			if(!output)
				break
			if(findtext(msg,"$",loc+1,endloc))
				var/loc2 = findtext(msg,"$",loc+1,0)
				var/varname1 = copytext(msg,loc2+1,endloc)
				variable = varname1
			if(variable && output)
				var1[variable] = lowertext(var1[output])
			else if(output)
				var1[output] = lowertext(var1[output])
		else if(findtext(A,"Upper(",1,0))
			var/output = null
			var/variable = null
			var/startloc = findtext(A,"(",1,0)
			var/endloc = findtext(A,")",1,0)
			var/loc
			if(!startloc || !endloc)
				client.Message("Errror")
			var/msg = copytext(A,startloc+1,endloc)
			if(findtext(msg,"$",1,0))
				loc = findtext(msg,"$",1,0)
				var/varname
				if(findtext(msg,",",1,0))
					var/lock = findtext(msg,",",1,0)

					varname = copytext(msg,loc+1,lock)
				else
					varname = copytext(msg,loc+1,endloc)
				output = varname
			if(!output)
				break
			if(findtext(msg,"$",loc+1,endloc))
				var/loc2 = findtext(msg,"$",loc+1,0)
				var/varname1 = copytext(msg,loc2+1,endloc)
				variable = varname1
			if(variable && output)
				var1[variable] = uppertext(var1[output])
			else if(output)
				var1[output] = uppertext (var1[output])
		else if(findtext(A,"num2text(",1,0))
			var/output = null
			var/variable = null
			var/startloc = findtext(A,"(",1,0)
			var/endloc = findtext(A,")",1,0)
			var/loc
			if(!startloc || !endloc)
				client.Message("Errror")
			var/msg = copytext(A,startloc+1,endloc)
			if(findtext(msg,"$",1,0))
				loc = findtext(msg,"$",1,0)
				var/varname
				if(findtext(msg,",",1,0))
					var/lock = findtext(msg,",",1,0)

					varname = copytext(msg,loc+1,lock)
				else
					varname = copytext(msg,loc+1,endloc)
				output = varname
			if(!output)
				break
			if(findtext(msg,"$",loc+1,endloc))
				var/loc2 = findtext(msg,"$",loc+1,0)
				var/varname1 = copytext(msg,loc2+1,endloc)
				variable = varname1
			if(variable && output)
				var1[variable] = num2text(var1[output])
			else if(output)
				var1[output] = num2text (var1[output])
		else if(findtext(A,"text2num(",1,0))
			var/output = null
			var/variable = null
			var/startloc = findtext(A,"(",1,0)
			var/endloc = findtext(A,")",1,0)
			var/loc
			if(!startloc || !endloc)
				client.Message("Errror")
			var/msg = copytext(A,startloc+1,endloc)
			if(findtext(msg,"$",1,0))
				loc = findtext(msg,"$",1,0)
				var/varname
				if(findtext(msg,",",1,0))
					var/lock = findtext(msg,",",1,0)

					varname = copytext(msg,loc+1,lock)
				else
					varname = copytext(msg,loc+1,endloc)
				output = varname
			if(!output)
				break
			if(findtext(msg,"$",loc+1,endloc))
				var/loc2 = findtext(msg,"$",loc+1,0)
				var/varname1 = copytext(msg,loc2+1,endloc)
				variable = varname1
			if(variable && output)
				var1[variable] = text2num(var1[output])
			else if(output)
				var1[output] = text2num(var1[output])
		else if(findtext(A,"$",1,0) && findtext(A,"=",1,0) && !findtext(A,"if",1,0) && !findtext(A,"+=",1,0) && !findtext(A,"-=",1,0))
			SetVar(A)
		else if(findtext(A,"sleep(",1,0))
			var/time = Sleep(A)
			sleep(time)
		else if(findtext(A,"GetInput(",1,0))
			var/endloc = findtext(A,")",length(A)-1,0)
			var/locr = findtext(A,"$",1,0)
			var/varname1 = copytext(A,locr+1,endloc)
			var1[varname1] = client.GetInput()
		else if(findtext(A,"exit(",1,0))
			break
		else if(findtext(A,"stop(",1,0))
			var1["stop"] = 1
			stop = 1
		//	world << "stopping [ismain]"
			del(src)
			return 1
		else if(findtext(A,"exec(",1,0))
			var/output
			var/startloc = findtext(A,"(",1,0)
			var/endloc = findtext(A,")",1,0)
			var/msg = copytext(A,startloc+1,endloc)
			if(findtext(msg,"$",1,0))
				var/locr = findtext(msg,"$",1,0)
				var/varname1 = copytext(msg,locr+1,0)
				output = var1[varname1]
			else if(findtext(msg,"\"",1,0))
				var/locr = findtext(msg,"\"",1,0)
				var/loc2r = findtext(msg,"\"",locr+1,0)
				output = copytext(msg,locr+1,loc2r)
		//	world << output
			client.command(output)
		else if(findtext(A,"length(",1,0))
			var/locstart = findtext(A,"(",1,0)
			var/locend = findtext(A,")",1,0)
			var/copy = copytext(A,locstart+1,locend)
			var/kloc = findtext(copy,",",1,0)
			var/sloc = findtext(copy,"$",kloc+1,0)
			var/vloc = findtext(copy,"$",1,kloc)
			var/varname = copytext(copy,sloc+1,0)
			var/sname = copytext(copy,vloc+1,kloc)
			if(findtext(varname,"\[",1,0))
				var/dloc = findtext(varname,"\[",1,0)
				varname = copytext(varname,1,dloc)
				var/k = var1[varname]
				var1[sname] = k:len
			else
				var1[sname] = length(var1[varname])
		else if(findtext(A,"if(",1,0))
			var/locstart = findtext(A,"(",1,0)
			var/locend = findtext(A,")",1,0)
			var/msg = copytext(A,locstart+1,locend)
			if(ifs[msg])
				var/datum/ifs/I = ifs[msg]
				I.compare(client)
				continue
		else if(findtext(A,"+=",1,0) || findtext(A,"-=",1,0))
			var/locS = findtext(A,"=",1,0)
			var/v1
			var/v1loc
			var/v1nam
			var/islist = 0
			var/v2
			if(findtext(A,"\[",1,locS))
				var/loc = findtext(A,"\[",1,locS)
				var/loc2 = findtext(A,"\]",1,locS)
				var/varname = copytext(A,loc+2,loc)
				var/num = copytext(A,loc+1,loc2)
				if(findtext(num,"$",1,0))
					var/x1 = findtext(num,"$",1,0)
					var/x2 = copytext(num,x1+1,0)
					num = text2num(var1[x2])
				num = text2num(num)
				var/list/X = var1[varname]
				v1 = X
			if(findtext(A,"$",1,0))
				v1 = findtext(A,"$",1,0)
				v1loc = v1
				v1nam = copytext(A,v1+1,locS-1)
				v1 = copytext(A,v1+1,locS-1)
				v1 = var1[v1]
			else if(findtext(A,"\"",1,0))
				var/loc1 = findtext(A,"\"",1,0)
				var/loc2 = findtext(A,"\"",loc1+1,0)
				v1 = copytext(A,loc1+1,loc2)
				v1loc = loc2
			else
				v1 = copytext(A,1,locS-1)
				v1 = text2num(v1)
			if(findtext(A,"\[",1,0))
				var/loc = findtext(A,"\[",locS,0)
				var/loc2 = findtext(A,"\]",locS,0)
				var/varname = copytext(A,1+2,loc)
				var/num = copytext(A,loc+1,loc2)
				if(findtext(num,"$",1,0))
					var/x1 = findtext(num,"$",1,0)
					var/x2 = copytext(num,x1+1,0)
					num = text2num(var1[x2])
				num = text2num(num)
				var/list/X = var1[varname]
				v2 = X[num]
			if(findtext(A,"$",v1loc+1,0))
				v2 = findtext(A,"$",v1loc+1,0)
				var/l = findtext(A," ",v2+1,0)
				v2 = copytext(A,v2+1,l)
				v2 = var1[v2]
			else if(findtext(A,"\"",v1loc+1,0))
				var/loc1 = findtext(A,"\"",v1loc+1,0)
				var/loc2 = findtext(A,"\"",loc1+1,0)
				v2 = copytext(A,loc1+1,loc2)
			else
				v2 = copytext(A,locS+1,0)
				v2 = text2num(v2)
			if(findtext(A,"+",1,0))
				if(islist)
					v1 += v2
				else
					var1[v1nam] = v1 + v2
			else if(findtext(A,"-",1,0))
				if(islist)
					v1 -= v2
				else
					var1[v1nam] = v1 - v2
		else if(findtext(A,"(",1,0))
			var/startloc = findtext(A,"(",1,0)
			var/endloc = findtext(A,")",1,0)
			var/fname = copytext(A,1,startloc)
			if(func[fname])
				var/xc = copytext(A,startloc+1,endloc)
				var/dones = 1
				var/list/xy = list()
				if(!xc)
					dones = 0
				while (dones==1)
					var/X = findtext(xc,",",1,0)
					if(!X)
						done = 1
						xy += xc
				//		world << "DONE"
						break
					else
						var/Y = copytext(xc,1,X)
						xc = copytext(xc,X+1,0)
						xy += Y
				var/count = 0
				for(var/msg in xy)
					count++
					if(findtext(msg,"\[",1,0))
						var/loc = findtext(msg,"\[",1,0)
						var/loc2 = findtext(msg,"\]",1,0)
						var/varname = copytext(msg,1+2,loc)
						var/num = copytext(msg,loc+1,loc2)
						if(findtext(num,"$",1,0))
							var/v1 = findtext(num,"$",1,0)
							var/v2 = copytext(num,v1+1,0)
							num = text2num(var1[v2])
						num = text2num(num)
						var/list/X = var1[varname]
						xy[count] = X[num]
					else if(findtext(msg,"$",1,0))
						var/loc = findtext(msg,"$",1,0)
						var/varname = copytext(msg,loc+1,0)
						xy[count] = var1[varname]
					else if(findtext(msg,"\"",1,0))
						var/loc = findtext(msg,"\"",1,0)
						var/loc2 = findtext(msg,"\"",loc+1,0)
						xy[count] = copytext(msg,loc+1,loc2)
				var/datum/func/F = func[fname]
				F.Run(client,xy)
			else
				client.Message("no function named [fname]")
				//doshit
//			else if(findtext(A,"!=",1,0)
				//doshit
		continue
	if(isscript)
		if(!client.connected)
			isscript:Stop(client)
		else
			isscript:Stop(client.connected)
	if(ismain)
		client.boot = 1
		del(src)
	return 1

datum/praser/proc/Sleep(A)
	var/output
	var/startloc = findtext(A,"(",1,0)
	var/endloc = findtext(A,")",length(A)-1,0)
	var/msg = copytext(A,startloc+1,endloc)
	if(findtext(msg,"$",1,0))
		var/locr = findtext(msg,"$",1,0)
		var/varname1 = copytext(msg,locr+1,0)
		output = var1[varname1]
	else
		output = text2num(msg)
	output *= 10
//	world << "TIME IS [output]"
	return output

datum/praser/proc/SetVar(A)
	var/output
	var/loc = findtext(A,"$",1,0)
	var/loc2 = findtext(A,"=",1,0)
	var/varname = copytext(A,loc+1,loc2)
	var/islist = 0
	var/listnum = 0
	if(findtext(A,"\[",1,loc2))
		islist = 1
		var/k1 = findtext(A,"\[",1,0)
		var/k2 = findtext(A,"]",1,0)
		varname = copytext(A,loc+1,k1)
		if(findtext(A,"$",k1+1,k2))
			var/v1 = findtext(A,"$",k1+1,k2)
			var/v2 = copytext(A,v1+1,k2)
			listnum = text2num(var1[v2])
		else
			listnum = text2num(copytext(A,k1+1,k2))
	var/msg = copytext(A,loc2+1,0)
	if(findtext(msg,"\[",1,0) && findtext(msg,"]",1,0))
		output = list()
		var/done = 1
		var/startloc = findtext(msg,"\[",1,0)
		var/endloc = findtext(msg,"]",1,0)
		var/text = copytext(msg,startloc+1,endloc)
		if(!findtext(msg,"$",1,0))
			while (done==1)
				var/X = findtext(text,",",1,0)
				if(!X)
					done = 1
					output += text
				//	world << "DONE"
					break
				else
					var/Y = copytext(text,1,X)
					text = copytext(text,X+1,0)
					output += Y
				//	world << "added [Y]"
				sleep(1)
			var/count = 0
			for(var/V in output)
				count++
				if(findtext(V,"\"",1,0))
				//	world << V
					var/locx = findtext(V,"\"",1,0)
					var/locx2 = findtext(V,"\"",locx+1,0)
					if(locx == locx2)
						world << "LOCX IS EQUAL TO LOCX2"
				//	world << locx
				//	world << locx2
					var/t = copytext(V,locx+1,locx2)
					output[count] = t
				else if(findtext(V,"$",1,0))
					var/locx = findtext(V,"$",1,0)
					var/varx = copytext(V,locx+1,0)
					output[count] = var1[varx]
				else
					output[count] = text2num(V)
		else
			var/xloc = findtext(msg,"$",1,0)
			var/varname2 = copytext(msg,xloc+1,startloc)
		//	world << varname
			output = var1[varname2]
			if(output:len <= 0)
				output = "NOT A LIST"
			var/num = copytext(msg,startloc+1,endloc)
			if(findtext(num,"$",1,0))
				var/v1 = findtext(num,"$",1,0)
				var/v2 = copytext(num,v1+1,0)
				num = text2num(var1[v2])
			output = output[num]
		//	world << output
	else if(findtext(msg,"$",1,0))
		var/locr = findtext(msg,"$",1,0)
		var/varname1 = copytext(msg,locr+1,0)
		output = var1[varname1]
	else if(findtext(msg,"\"",1,0))
		var/locr = findtext(msg,"\"",1,0)
		var/loc2r = findtext(msg,"\"",locr+1,0)
		output = copytext(msg,locr+1,loc2r)
	else //assume its a int
		output = copytext(A,loc2+1,0)
		output = text2num(output)

	if(!islist)
		var1[varname] = output
	else
		var/T = var1[varname]
	//	world << listnum
	//	world << "varname:[varname]"
		if(T:len < listnum)
			T:len = listnum
			T[listnum] = output
		else
			T[listnum] = output

datum/os/proc/GetIP()
	if(connected)
		return ip2text(connected.ip)
	else
		return ip2text(src.ip)





datum/func
	var/name = "func"
	var/list/lines = list()
	var/list/xargs = list()
	var/numofargs = 0
	var/datum/praser/owned

datum/func/proc/Run(client,var/list/args)
	var/count = 0
	for(var/B in args)
		count++
		owned.var1["arg[count]"] = args[count]
	owned.var1["argtotal"] = count
	owned.Prase(client,null,lines)
	count = 0
	for(var/B in xargs)
		count++
		owned.var1["arg[count]"] = null
		owned.var1["argtotal"] = null

datum/func/New(N,var/list/X,var/datum/praser/K)
	xargs = X
	name = N
	owned = K

datum/func/sendpacket/New(N,var/list/X,var/datum/praser/K)
	xargs = X
	name = N
	owned = K

datum/func/sendpacket/Run(var/datum/os/client,var/list/args)
//	return
	var/too = args[1]
	var/label = args[2]
	args -= label
	args -= too
	new /datum/packet (label,too,ip2text(client.ip),args)
	return
/*
	var/datum/dir/file/F = FindFile(FY)
	if(var2)
		goto notfile
	var/list/lines = list()

	var/text
	if(tex)
		text = FY
	else
		text = F.contents
	var/list/iflist = list()
	var/done = 0

	//for(var/A in lines)
	//	world << A
	var/list/var1 = list()
	var1["sourceip"] = src.ip
	notfile
	if(tex)
		text = FY
	if(var2)
		lines = FY
		var1 = var2
	for(var/A in lines)
	//	if(findtext(A,"L$",1,0))
/*			var/loc1 = findtext(A,"=",1,0)
			var/loc2 = findtext(A,"\[",1,0)
			var/loc3 = findtext(A,",",loc2,0)
			var/locend = findtext(A,"\]",1,0)
			var/list/ls = list()
			var/name = copytext(A,loc2+1,loc3)
				*/
		if(findtext(A,"!$",1,0))
			var/loc1 = findtext(A,"$",1,0)
			var/loc2 = findtext(A,"=",1,0)
			if(findtext(A,"$",loc2+1,0))
			//	Were assign a variable apperntly
				var/loc3 = findtext(A,"$",loc2+1,0)
				var/oldvar = copytext(A,loc3+1,0)
				if(!oldvar)
					return
				var/output = var1[oldvar]
				if(!output)
					return
				loc1+=1
				loc2+=1
				var/varname = copytext(A,loc1,loc2-1)
				var1[varname] = output
				continue
			loc1+=1
			loc2+=1
			var/con = copytext(A,loc2,0)
			var/varname = copytext(A,loc1,loc2-1)
			//world << "VARNAME=[varname]"
			var/int = 1
			var/derp = findtext(A,"\"",loc2)
			if(derp)
				var/derp2 = findtext(A,"\"",loc2+1)
				if(derp && derp2)
					con = copytext(A,derp+1,derp2)
					int = 0
			if(!int)
				var1[varname] = con
			else
				var1[varname] = text2num(con)
				// "int = [con]"
		else if(findtext(A,"echo",1,0))
			// "echo"
			var/loc1 = findtext(A,"echo",1,0)
			var/loc2 = findtext(A," ",loc1,0)
			if(findtext(A,"\"",loc2+1,0))
				var/loc3 = findtext(A,"\"",loc2+1,0)
				var/loc4 = findtext(A,"\"",loc3+1,0)
				if(!loc4)
					return
				var/string = copytext(A,loc3+1,loc4)
				src.owner << "[string]"
			else if(findtext(A,"$",loc2,0))
				var/loc3 = findtext(A,"$",1,0)
				var/varname = copytext(A,loc3+1,0)
				var/output = var1[varname]
			//	world << output
				if(!output)
					return
				else
					src.owner << "[output]"
			else
				src.owner << "broken echo at line [lines.Find(A)]"

		else if(findtext(A,"exec",1,0))
			var/loc1 = findtext(A,"exec",1,0)
			var/loc2 = findtext(A," ",loc1,0)
			if(findtext(A,"\"",loc2+1,0))
				var/loc3 = findtext(A,"\"",loc2+1,0)
				var/loc4 = findtext(A,"\"",loc3+1,0)
				if(!loc4)
					return
				var/string = copytext(A,loc3+1,loc4)
				src.command(string)
				continue
			else if(findtext(A,"$",loc2+1,0))
				var/loc3 = findtext(A,"$",1,0)
				var/varname = copytext(A,loc3+1,0)
				var/string = var1[varname]
				src.command(string)
				continue
		else if(findtext(A,"return",1,0))
			return
		else if(findtext(A,"text2num(",1,0))
			var/loc1 = findtext(A,")")
			var/loc2 = findtext(A,"$")
			var/varname = copytext(A,loc2+1,loc1)
			var1[varname] = text2num(var1[varname])
		else if(findtext(A,"if",1,0))
			var/loc1 = findtext(A,"if",1,0)
			var/loc2 = findtext(A,"==",loc1,0)
			var/v1 = copytext(A,loc1+3,loc2-1)
			var/v2 = copytext(A,loc2+3,0)
			if(findtext(v1,"$",1,0))
				var/v1c = findtext(v1,"$",1,0)
				v1 = copytext(v1,v1c+1,0)
				v1 = var1[v1]
			else if(findtext(v1,"\"",1,0))
				var/v1c = findtext(v1,"\"",1,0)
				var/v1b = findtext(v1,"\"",v1c,0)
				v1 = copytext(v1,v1c+1,v1b-1)
			if(findtext(v2,"$",1,0))
				var/v1c = findtext(v2,"$",1,0)
				v2 = copytext(v2,v1c+1,0)
				v2 = var1[v2]
			else if(findtext(v2,"\"",1,0))
				var/v2c = findtext(v2,"\"",1,0)
				var/v2b = findtext(v2,"\"",v2c,0)
				v2 = copytext(v2,v2c+1,v2b-1)
			var/locI = lines.Find(A,1,0)
			var/test = 1
			var/count = locI +1
			while (test)
				var/X = lines[count]
				if(findtext(X,"end",1,0))
					test = 0
				else
					iflist += X
					//world << "Count:[count];X:[X]"
				count++
			lines.Remove(iflist)
			if(findtext(A,"==",1,0))
				if(v1 == v2)
					Prase(iflist,var1)
			else if(findtext(A,"!=",1,0))
				if(v1 != v2)
					Prase(iflist,var1)
		else if(findtext(A,"sleep:",1,0))
			var/v1 = findtext(A,":",1,0)
			var/x = copytext(A,v1+2,0)
			x = text2num(x)
			sleep(x*10)
			continue
		else if(findtext(A,"+=",1,0))
			var/loc1 = findtext(A,"+=",1,0)
			var/v1 = copytext(A,1,loc1-1)
			var/v2 = copytext(A,loc1+3,0)
			var/v1n
			var/v2n
			if(findtext(v1,"$",1,0))
				var/v1c = findtext(v1,"$",1,0)
				v1n = copytext(v1,v1c+1,0)

				v1 = var1[v1n]
			else
				src.owner << "Error:first argument to += needs to be a variable"
				continue
			if(findtext(v2,"$",1,0))
				var/v1c = findtext(v2,"$",1,0)
				v2n = copytext(v2,v1c+1,0)
				v2 = var1[v2n]
				/// v2
			else if(findtext(v2,"\"",1,0))
				var/v2c = findtext(v2,"\"",1,0)
				var/v2b = findtext(v2,"\"",v2c+1,0)
				v2 = copytext(v2,v2c+1,v2b)
			else
				v2 = text2num(v2)
				// v2
			if(isnum(v1) && isnum(v2))
				var1[v1n] = v1 + v2
			else if(istext(v1) && istext(v2))
				var1[v1n] = v1 + v2
			else if(istext(v1) && isnum(v2))
				var1[v1n] = v1 + num2text(v2)
			else if(isnum(v1) && istext(v2))
				var1[v1n] = num2text(v1) + v2
		else if(findtext(A,"-=",1,0))
			var/loc1 = findtext(A,"-=",1,0)
			var/v1 = copytext(A,1,loc1-1)
			var/v2 = copytext(A,loc1+3,0)
			var/v1n
			var/v2n
			if(findtext(v1,"$",1,0))
				var/v1c = findtext(v1,"$",1,0)
				v1n = copytext(v1,v1c+1,0)

				v1 = var1[v1n]
			else
				src.owner << "Error:first argument to += needs to be a variable"
				continue
			if(findtext(v2,"$",1,0))
				var/v1c = findtext(v2,"$",1,0)
				v2n = copytext(v2,v1c+1,0)
				v2 = var1[v2n]
				/// v2
			else if(findtext(v2,"\"",1,0))
				var/v2c = findtext(v2,"\"",1,0)
				var/v2b = findtext(v2,"\"",v2c+1,0)
				v2 = copytext(v2,v2c+1,v2b)
			else
				v2 = text2num(v2)
				// v2
			if(isnum(v1) && isnum(v2))
				var1[v1n] = v1 - v2
			else
				src.owner << "both args need to be numers at line [lines.Find(A)]"
		else if(findtext(A,"GetInput("))
			var/loc1 = findtext(A,")")
			var/loc2 = findtext(A,"$")
			var/varname = copytext(A,loc2+1,loc1)
			var1[varname] = src.GetInput()
		else if(findtext(A,"GetInput("))
			var/loc1 = findtext(A,")")
			var/loc2 = findtext(A,"$")
			var/varname = copytext(A,loc2+1,loc1)
			var1[varname] = src.GetPacket()
		else if(findtext(A,"GetIP("))
			var/loc1 = findtext(A,")")
			var/loc2 = findtext(A,"$")
			var/varname = copytext(A,loc2+1,loc1)
			var1[varname] = GetIP()
		else if(findtext(A,"Replace("))
			var/loc1 = findtext(A,")")
			var/loc2 = findtext(A,"$")
			var/loc3 = findtext(A,",")
			var/loc4 = findtext(A,",",loc3+1)
			var/varname = copytext(A,loc2+1,loc3)
			var/varname2
			var/varname3
			if(findtext(A,"$",loc3+1,loc1))
				var/loc5 = findtext(A,"$",loc3+1,loc4)
				varname2 = copytext(A,loc5+1,loc4)
			//	world << varname2
				varname2 = var1[varname2]
			else if(findtext(A,"\"",loc3+1,loc1))
				var/loc5 = findtext(A,"\"",loc3+1,loc4)
				var/loc6 = findtext(A,"\"",loc5+1,loc4)
				varname2 = copytext(A,loc5+1,loc6)
			if(findtext(A,"$",loc4+1,loc1))
				var/loc5 = findtext(A,"$",loc4+1,loc1)
				varname3 = copytext(A,loc5+1,loc1)
				varname3 = var1[varname3]
			else if(findtext(A,"\"",loc4+1,loc1))
				var/loc5 = findtext(A,"\"",loc4+1,loc1)
				var/loc6 = findtext(A,"\"",loc5+1,loc1)
				varname3 = copytext(A,loc5+1,loc6)
			var1[varname] = replacetext(var1[varname],varname2,varname3)
*/