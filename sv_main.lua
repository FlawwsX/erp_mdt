-- (Start) Opening the MDT and sending data

AddEventHandler('erp_mdt:AddLog', function(text)
	exports.oxmysql:executeSync('INSERT INTO `pd_logs` (`text`, `time`) VALUES (:text, :time)', { text = text, time = os.time() * 1000 })
end)

local function GetNameFromId(cid, cb)
	cb(exports.oxmysql:executeSync('SELECT firstname, lastname FROM `users` WHERE id = :id LIMIT 1', { id = cid }))
end

RegisterCommand("mdt", function(source, args, rawCommand)
	TriggerEvent('erp_mdt:open', source)
end, false)

RegisterCommand("showmdt", function(source, args, rawCommand)
	TriggerEvent('erp_mdt:open', source)
end, false)

local known100s = {}

RegisterCommand("signal100", function(source, args, rawCommand)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or (result.job.name == 'ambulance' or result.job.name == 'doj')) then
				local channel = tonumber(args[1])
				if known100s[channel] then
					known100s[channel] = nil
					TriggerClientEvent('erp_mdt:sig100', -1, channel, false)
				else
					known100s[channel] = true
					TriggerClientEvent('erp_mdt:sig100', -1, channel, true)
				end

			end
		end
	end)
end, false)

RegisterNetEvent('erp_mdt:open')
AddEventHandler('erp_mdt:open', function(source)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or (result.job.name == 'ambulance' or result.job.name == 'doj')) then
				TriggerEvent('echorp:getJobInfo', result.job.name, function(jobInfo)
					if jobInfo then
						TriggerClientEvent('erp_mdt:open', result.source, result.job, jobInfo['grades'][result.job.grade]['label'], result.lastname, result.firstname)
					end
				end)
			end
		end
	end)
end)

RegisterNetEvent('echorp:playerSpawned')
AddEventHandler('echorp:playerSpawned', function(PlayerData)
	local cid = PlayerData['cid']
	if cid then
		local callsign = GetCallsign(cid)
		if callsign then
			TriggerClientEvent('erp_mdt:updateCallsign', PlayerData['source'], callsign)
		end
	end
end)

function GetCallsign(cid) return GetResourceKvpString(cid..'-callsign') end
exports('GetCallsign', GetCallsign) -- exports['erp_mdt']:GetCallsign(cid)

AddEventHandler('erp_mdt:open', function(source)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or (result.job.name == 'ambulance' or result.job.name == 'doj')) then
				local cs = GetCallsign(result.cid)
				if cs then TriggerClientEvent('erp_mdt:updateCallsign', result['source'], cs) end
				local lspd, bcso, sast, sasp, doc, sapr, pa, ems = {}, {}, {}, {}, {}, {}, {}, {}
				local players = exports['echorp']:GetFXPlayers()
				for k,v in pairs(players) do				
					if v.job.name == 'lspd' then
						local Radio = Player(v.source).state.radioChannel or 0
						if Radio > 100 then
							Radio = 0
						end
						table.insert(lspd, {
							cid = v.cid,
							name = v.fullname,
							callsign = GetResourceKvpString(v['cid']..'-callsign'),
							duty = v.job.duty,
							radio = Radio,
							sig100 = known100s[Radio]
						})
					elseif v.job.name == 'bcso' then
						local Radio = Player(v.source).state.radioChannel or 0
						if Radio > 100 then
							Radio = 0
						end
						table.insert(bcso, {
							cid = v.cid,
							name = v.fullname,
							callsign = GetResourceKvpString(v['cid']..'-callsign'),
							duty = v.job.duty,
							radio = Radio,
							sig100 = known100s[Radio]
						})
					elseif v.job.name == 'sast' then
						local Radio = Player(v.source).state.radioChannel or 0
						if Radio > 100 then
							Radio = 0
						end
						table.insert(sast, {
							cid = v.cid,
							name = v.fullname,
							callsign = GetResourceKvpString(v['cid']..'-callsign'),
							duty = v.job.duty,
							radio = Radio,
							sig100 = known100s[Radio]
						})
					elseif v.job.name == 'sasp' then
						local Radio = Player(v.source).state.radioChannel or 0
						if Radio > 100 then
							Radio = 0
						end
						table.insert(sasp, {
							cid = v.cid,
							name = v.fullname,
							callsign = GetResourceKvpString(v['cid']..'-callsign'),
							duty = v.job.duty,
							radio = Radio,
							sig100 = known100s[Radio]
						})
					elseif v.job.name == 'doc' then
						local Radio = Player(v.source).state.radioChannel or 0
						if Radio > 100 then
							Radio = 0
						end
						table.insert(doc, {
							cid = v.cid,
							name = v.fullname,
							callsign = GetResourceKvpString(v['cid']..'-callsign'),
							duty = v.job.duty,
							radio = Radio,
							sig100 = known100s[Radio]
						})
					elseif v.job.name == 'sapr' then
						local Radio = Player(v.source).state.radioChannel or 0
						if Radio > 100 then
							Radio = 0
						end
						table.insert(sapr, {
							cid = v.cid,
							name = v.fullname,
							callsign = GetResourceKvpString(v['cid']..'-callsign'),
							duty = v.job.duty,
							radio = Radio
						})
					elseif v.job.name == 'pa' then
						local Radio = Player(v.source).state.radioChannel or 0
						if Radio > 100 then
							Radio = 0
						end
						table.insert(pa, {
							cid = v.cid,
							name = v.fullname,
							callsign = GetResourceKvpString(v['cid']..'-callsign'),
							duty = v.job.duty,
							radio = Radio,
							sig100 = known100s[Radio]
						})
					elseif v.job.name == 'ambulance' then
						local Radio = Player(v.source).state.radioChannel or 0
						if Radio > 100 then
							Radio = 0
						end
						table.insert(ems, {
							cid = v.cid,
							name = v.fullname,
							callsign = GetResourceKvpString(v['cid']..'-callsign'),
							duty = v.job.duty,
							radio = Radio,
							sig100 = known100s[Radio]
						})
					end
				end
				TriggerClientEvent('erp_mdt:getActiveUnits', source, lspd, bcso, sast, sasp, doc, sapr, pa, ems)
			end
		end
	end)
end)

local function GetIncidentName(id, cb)
	cb(exports.oxmysql:executeSync('SELECT title FROM `pd_incidents` WHERE id = :id LIMIT 1', { id = id }))
end

AddEventHandler('erp_mdt:open', function(source)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or result.job.name == 'doj') then
				-- get warrants
				exports.oxmysql:execute("SELECT * FROM pd_convictions WHERE warrant='1'", {}, function(warrants)
					for i=1, #warrants do
						GetNameFromId(warrants[i]['cid'], function(res)
							if res and res[1] then
								warrants[i]['name'] = res[1]['firstname']..' '..res[1]['lastname']
							else
								warrants[i]['name'] = "Unknown"
							end
						end)
						GetIncidentName(warrants[i]['linkedincident'], function(res)
							if res and res[1] then warrants[i]['reporttitle'] = res[1]['title']
							else warrants[i]['reporttitle'] = "Unknown report title" end
						end)
						warrants[i]['firsttime'] = i == 1
						TriggerClientEvent('erp_mdt:dashboardWarrants', result.source, warrants[i])
					end
				end)
			elseif result.job and (result.job.name == 'ambulance') then
				exports.oxmysql:execute("SELECT * FROM `ems_reports` ORDER BY `id` DESC LIMIT 20", {}, function(matches)
					TriggerClientEvent('erp_mdt:getAllReports', result.source, matches)		
				end)
			end
		end
	end)
end)

AddEventHandler('erp_mdt:open', function(source)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			local calls = exports['erp_dispatch']:GetDispatchCalls()
			for id, information in pairs(calls) do
				if information['job'] then
					local found = false
					for i=1, #information['job'] do
						if information['job'][i] == result['job']['name'] then
							found = true
							break
						end
					end
					if not found then calls[id] = nil end
				end
			end
			TriggerClientEvent('erp_mdt:dashboardCalls', result.source, calls)
		end
	end)
end)

-- (End) Opening the MDT and sending data

-- (Start) Requesting profile information

local function GetConvictions(cid, cb)
	cb((exports.oxmysql:executeSync('SELECT * FROM `pd_convictions` WHERE `cid`=:cid', { cid = cid })))
end

local function GetLicenseInfo(cid, cb)
	cb(exports.oxmysql:executeSync('SELECT * FROM `licenses` WHERE `cid`=:cid', { cid = cid }))
end

RegisterNetEvent('erp_mdt:searchProfile')
AddEventHandler('erp_mdt:searchProfile', function(sentData)
	if sentData then
		local function PpPpPpic(gender, profilepic)
			if profilepic then return profilepic end;
			if gender == "f" then return "img/female.png" end;
			return "img/male.png"
		end
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					exports.oxmysql:execute("SELECT id, firstname, lastname, gender, profilepic FROM `users` WHERE LOWER(`firstname`) LIKE :query OR LOWER(`lastname`) LIKE :query OR LOWER(`id`) LIKE :query OR CONCAT(LOWER(`firstname`), ' ', LOWER(`lastname`)) LIKE :query LIMIT 20", {
						query = string.lower('%'..sentData..'%')
					}, function(people)
						for i=1, #people do

							people[i]['warrant'] = false

							people[i]['theory'] = false
							people[i]['car'] = false
							people[i]['bike'] = false
							people[i]['truck'] = false

							people[i]['weapon'] = false
							people[i]['hunting'] = false
							people[i]['pilot'] = false
							people[i]['convictions'] = 0
							people[i]['pp'] = PpPpPpic(people[i]['gender'], people[i]['profilepic'])

							GetConvictions(people[i]['id'], function(cc)
								if cc then
									for x=1, #cc do
										if cc[x] then
											if cc[x]['warrant'] then people[i]['warrant'] = true end
											if cc[x]['associated'] == "0" then
												local charges = json.decode(cc[x]['charges'])
												people[i]['convictions'] = people[i]['convictions'] + #charges
											end
										end
									end
								end				
							end)

							GetLicenseInfo(people[i]['id'], function(licenseinfo)
								if licenseinfo and #licenseinfo > 0 then
									for suckdick=1, #licenseinfo do
										if licenseinfo[suckdick]['type'] == 'weapon' then
											people[i]['weapon'] = true
										elseif licenseinfo[suckdick]['type'] == 'theory' then
											people[i]['theory'] = true
										elseif licenseinfo[suckdick]['type'] == 'drive' then
											people[i]['car'] = true
										elseif licenseinfo[suckdick]['type'] == 'drive_bike' then
											people[i]['bike'] = true
										elseif licenseinfo[suckdick]['type'] == 'drive_truck' then
											people[i]['truck'] = true
										elseif licenseinfo[suckdick]['type'] == 'hunting' then
											people[i]['hunting'] = true
										elseif licenseinfo[suckdick]['type'] == 'pilot' then
											people[i]['pilot'] = true
										end
									end
								end
							end)
						end

						TriggerClientEvent('erp_mdt:searchProfile', result.source, people)
					end)
				elseif result.job and (result.job.name == 'ambulance') then
					exports.oxmysql:execute("SELECT id, firstname, lastname, gender, profilepic, dateofbirth FROM `users` WHERE LOWER(`firstname`) LIKE :query OR LOWER(`lastname`) LIKE :query OR LOWER(`id`) LIKE :query OR CONCAT(LOWER(`firstname`), ' ', LOWER(`lastname`)) LIKE :query LIMIT 20", {
						query = string.lower('%'..sentData..'%')
					}, function(people)
						for i=1, #people do
							people[i]['warrant'] = false
							people[i]['theory'] = false
							people[i]['car'] = false
							people[i]['bike'] = false
							people[i]['truck'] = false
							people[i]['weapon'] = false
							people[i]['hunting'] = false
							people[i]['pilot'] = false
							people[i]['pp'] = PpPpPpic(people[i]['gender'], people[i]['profilepic'])
							GetLicenseInfo(people[i]['id'], function(licenseinfo)
								if licenseinfo and #licenseinfo > 0 then
									for suckdick=1, #licenseinfo do
										if licenseinfo[suckdick]['type'] == 'weapon' then
											people[i]['weapon'] = true
										elseif licenseinfo[suckdick]['type'] == 'theory' then
											people[i]['theory'] = true
										elseif licenseinfo[suckdick]['type'] == 'drive' then
											people[i]['car'] = true
										elseif licenseinfo[suckdick]['type'] == 'drive_bike' then
											people[i]['bike'] = true
										elseif licenseinfo[suckdick]['type'] == 'drive_truck' then
											people[i]['truck'] = true
										elseif licenseinfo[suckdick]['type'] == 'hunting' then
											people[i]['hunting'] = true
										elseif licenseinfo[suckdick]['type'] == 'pilot' then
											people[i]['pilot'] = true
										end
									end
								end
							end)
						end

						TriggerClientEvent('erp_mdt:searchProfile', result.source, people, true)
					end)
				end
			end
		end)
	end
end)

-- (End) Requesting profile information

-- (Start) Bulletin

RegisterNetEvent('erp_mdt:opendashboard')
AddEventHandler('erp_mdt:opendashboard', function()
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and result.job.isPolice then
				exports.oxmysql:execute('SELECT * FROM `pd_bulletin`', {}, function(bulletin)
					TriggerClientEvent('erp_mdt:dashboardbulletin', result.source, bulletin)
				end)
			elseif result.job and (result.job.name == 'ambulance') then
				exports.oxmysql:execute('SELECT * FROM `ems_bulletin`', {}, function(bulletin)
					TriggerClientEvent('erp_mdt:dashboardbulletin', result.source, bulletin)
				end)
			elseif result.job and (result.job.name == 'doj') then
				exports.oxmysql:execute('SELECT * FROM `doj_bulletin`', {}, function(bulletin)
					TriggerClientEvent('erp_mdt:dashboardbulletin', result.source, bulletin)
				end)
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:newBulletin')
AddEventHandler('erp_mdt:newBulletin', function(title, info, time)
	if title and info and time then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and result.job.isPolice then
					exports.oxmysql:insert('INSERT INTO `pd_bulletin` (`title`, `desc`, `author`, `time`) VALUES (:title, :desc, :author, :time)', {
						title = title,
						desc = info,
						author = result.fullname,
						time = tostring(time)
					}, function(sqlResult)
						TriggerEvent('erp_mdt:AddLog', "A new bulletin was added by "..result.firstname.." "..result.lastname.." with the title: "..title.."!")
						TriggerClientEvent('erp_mdt:newBulletin', -1, result.source, {id = sqlResult, title = title, info = info, time = time, author = result.fullname}, 'police')
					end)
				elseif result.job and (result.job.name == 'ambulance') then
					exports.oxmysql:insert('INSERT INTO `ems_bulletin` (`title`, `desc`, `author`, `time`) VALUES (:title, :desc, :author, :time)', {
						title = title,
						desc = info,
						author = result.fullname,
						time = tostring(time)
					}, function(sqlResult)
						TriggerEvent('erp_mdt:AddLog', "A new bulletin was added by "..result.firstname.." "..result.lastname.." with the title: "..title.."!")
						TriggerClientEvent('erp_mdt:newBulletin', -1, result.source, {id = sqlResult, title = title, info = info, time = time, author = result.fullname}, result.job.name)
					end)
				elseif result.job and (result.job.name == 'doj') then
					exports.oxmysql:insert('INSERT INTO `doj_bulletin` (`title`, `desc`, `author`, `time`) VALUES (:title, :desc, :author, :time)', {
						title = title,
						desc = info,
						author = result.fullname,
						time = tostring(time)
					}, function(sqlResult)
						TriggerEvent('erp_mdt:AddLog', "A new bulletin was added by "..result.firstname.." "..result.lastname.." with the title: "..title.."!")
						TriggerClientEvent('erp_mdt:newBulletin', -1, result.source, {id = sqlResult, title = title, info = info, time = time, author = result.fullname}, result.job.name)
					end)
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:deleteBulletin')
AddEventHandler('erp_mdt:deleteBulletin', function(id)
	if id then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and result.job.isPolice then
					exports.oxmysql:execute('SELECT `title` FROM `pd_bulletin` WHERE id=:id LIMIT 1', { id = id}, function(res)
						if res and res[1] then
							exports.oxmysql:executeSync("DELETE FROM `pd_bulletin` WHERE id=:id", { id = id })
							TriggerEvent('erp_mdt:AddLog', "A bulletin was deleted by "..result.firstname.." "..result.lastname.." with the title: "..res[1]['title'].."!")
							TriggerClientEvent('erp_mdt:deleteBulletin', -1, result.source, id, 'police')
						end
					end)
				elseif result.job and (result.job.name == 'ambulance') then
					exports.oxmysql:execute('SELECT `title` FROM `ems_bulletin` WHERE id=:id LIMIT 1', { id = id}, function(res)
						if res and res[1] then
							exports.oxmysql:executeSync("DELETE FROM `ems_bulletin` WHERE id=:id", { id = id })
							TriggerEvent('erp_mdt:AddLog', "A bulletin was deleted by "..result.firstname.." "..result.lastname.." with the title: "..res[1]['title'].."!")
							TriggerClientEvent('erp_mdt:deleteBulletin', -1, result.source, id, result.job.name)
						end
					end)
				elseif result.job and (result.job.name == 'doj') then
					exports.oxmysql:execute('SELECT `title` FROM `doj_bulletin` WHERE id=:id LIMIT 1', { id = id}, function(res)
						if res and res[1] then
							exports.oxmysql:executeSync("DELETE FROM `doj_bulletin` WHERE id=:id", { id = id })
							TriggerEvent('erp_mdt:AddLog', "A bulletin was deleted by "..result.firstname.." "..result.lastname.." with the title: "..res[1]['title'].."!")
							TriggerClientEvent('erp_mdt:deleteBulletin', -1, result.source, id, result.job.name)
						end
					end)
				end
			end
		end)
	end
end)

local function CreateUser(cid, dbname, cb)
	cb(exports.oxmysql:insert("INSERT INTO `"..dbname.."` (cid) VALUES (:cid)", { cid = cid }))
	TriggerEvent('erp_mdt:AddLog', "A user was created with the CID: "..cid)
end

local function GetPersonInformation(cid, table, cb)
	cb(exports.oxmysql:executeSync('SELECT information, tags, gallery FROM '..table..' WHERE cid=:cid', { cid = cid }))
end

local function GetVehicleInformation(cid, cb)
	cb(exports.oxmysql:executeSync('SELECT id, plate, vehicle FROM owned_vehicles WHERE owner=:cid', { cid = cid }))
end

RegisterNetEvent('erp_mdt:getProfileData')
AddEventHandler('erp_mdt:getProfileData', function(sentId)
	local sentId = tonumber(sentId)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or result.job.name == 'doj') then
				exports.oxmysql:execute('SELECT id, firstname, lastname, job, profilepic, gender, dateofbirth FROM users WHERE id=:id LIMIT 1', { id = sentId }, function(user)
					if user and user[1] then

						local function PpPpPpic(gender, profilepic)
							if profilepic then return profilepic end;
							if gender == "f" then return "img/female.png" end;
							return "img/male.png"
						end

						local object = {
							cid = user[1]['id'],
							firstname = user[1]['firstname'],
							lastname = user[1]['lastname'],
							job = user[1]['job'],
							dateofbirth = user[1]['dateofbirth'],
							profilepic = PpPpPpic(user[1]['gender'], user[1]['profilepic']),
							policemdtinfo = '',
							theory = false,
							car = false,
							bike = false,
							truck = false,
							weapon = false,
							hunting = false,
							pilot = false,
							tags = {},
							vehicles = {},
							properties = {},
							gallery = {},
							convictions = {}
						}

						TriggerEvent('echorp:getJobInfo', object['job'], function(res)
							if res then
								object['job'] = res['label']
							end
						end)

						GetConvictions(sentId, function(cc)
							for x=1, #cc do
								if cc[x] then
									if cc[x]['associated'] == "0" then
										local charges = json.decode(cc[x]['charges'])
										for suckdick=1, #charges do
											table.insert(object['convictions'], charges[suckdick])
										end
									end
								end
							end
						end)
						
						--print(json.encode(object['convictions']))

						GetPersonInformation(sentId, 'policemdtdata', function(information)
							if information[1] then
								object['policemdtinfo'] = information[1]['information']
								object['tags'] = json.decode(information[1]['tags'])
								object['gallery'] = json.decode(information[1]['gallery'])
							end
						end) -- Tags, Gallery, User Information

						GetLicenseInfo(object['cid'], function(licenseinfo)
							if licenseinfo and #licenseinfo > 0 then
								for suckdick=1, #licenseinfo do
									if licenseinfo[suckdick]['type'] == 'weapon' then
										object['weapon'] = true
									elseif licenseinfo[suckdick]['type'] == 'theory' then
										object['theory'] = true
									elseif licenseinfo[suckdick]['type'] == 'drive' then
										object['car'] = true
									elseif licenseinfo[suckdick]['type'] == 'drive_bike' then
										object['bike'] = true
									elseif licenseinfo[suckdick]['type'] == 'drive_truck' then
										object['truck'] = true
									elseif licenseinfo[suckdick]['type'] == 'hunting' then
										object['hunting'] = true
									elseif licenseinfo[suckdick]['type'] == 'pilot' then
										object['pilot'] = true
									end
								end
							end
						end) -- Licenses

						GetVehicleInformation(sentId, function(res)
							local vehicleInfo = {}
							for i=1, #res do
								local vehicle = json.decode(res[i]['vehicle'])
								local model = "Unknown"
								if json.encode(vehicle) ~= "null" then
									model = vehicle['model']
								end
								table.insert(vehicleInfo, {id = res[i]['id'], model = model, plate = res[i]['plate']})
							end
							object['vehicles'] = vehicleInfo

						end) -- Vehicles

						--local houses = exports['erp-housing']:GetHouses()
						local myHouses = {}
						--[[for i=1, #houses do
							local thisHouse = houses[i]
							if thisHouse['cid'] == cid then
								table.insert(myHouses, thisHouse)
							end 
						end]]

						object['properties'] = myHouses
						TriggerClientEvent('erp_mdt:getProfileData', result.source, object)
					end
				end)
			elseif result.job and (result.job.name == 'ambulance') then
				exports.oxmysql:execute('SELECT id, firstname, lastname, job, profilepic, gender, dateofbirth FROM users WHERE id=:id LIMIT 1', { id = sentId }, function(user)
					if user and user[1] then

						local function PpPpPpic(gender, profilepic)
							if profilepic then return profilepic end;
							if gender == "f" then return "img/female.png" end;
							return "img/male.png"
						end

						local object = {
							cid = user[1]['id'],
							firstname = user[1]['firstname'],
							lastname = user[1]['lastname'],							
							dateofbirth = user[1]['dateofbirth'],
							job = user[1]['job'],
							profilepic = PpPpPpic(user[1]['gender'], user[1]['profilepic']),
							policemdtinfo = '',
							theory = false,
							car = false,
							bike = false,
							truck = false,
							weapon = false,
							hunting = false,
							pilot = false,
							tags = {},
							properties = {},
							gallery = {}
						}

						TriggerEvent('echorp:getJobInfo', object['job'], function(res) if res then object['job'] = res['label'] end end)

						GetPersonInformation(sentId, 'emsmdtdata', function(information)
							if information[1] then
								object['policemdtinfo'] = information[1]['information']
								object['tags'] = json.decode(information[1]['tags'])
								object['gallery'] = json.decode(information[1]['gallery'])
							end
						end) -- Tags, Gallery, User Information

						GetLicenseInfo(object['cid'], function(licenseinfo)
							if licenseinfo and #licenseinfo > 0 then
								for suckdick=1, #licenseinfo do
									if licenseinfo[suckdick]['type'] == 'weapon' then
										object['weapon'] = true
									elseif licenseinfo[suckdick]['type'] == 'theory' then
										object['theory'] = true
									elseif licenseinfo[suckdick]['type'] == 'drive' then
										object['car'] = true
									elseif licenseinfo[suckdick]['type'] == 'drive_bike' then
										object['bike'] = true
									elseif licenseinfo[suckdick]['type'] == 'drive_truck' then
										object['truck'] = true
									elseif licenseinfo[suckdick]['type'] == 'hunting' then
										object['hunting'] = true
									elseif licenseinfo[suckdick]['type'] == 'pilot' then
										object['pilot'] = true
									end
								end
							end
						end) -- Licenses

						TriggerClientEvent('erp_mdt:getProfileData', result.source, object, true)
					end
				end)
			end
		end
	end)
end)

RegisterNetEvent("erp_mdt:saveProfile")
AddEventHandler('erp_mdt:saveProfile', function(pfp, information, cid, fName, sName)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or result.job.name == 'doj') then
				local function UpdateInfo(id, pfp, desc)
					exports.oxmysql:executeSync("UPDATE policemdtdata SET `information`=:information WHERE `id`=:id LIMIT 1", { id = id, information = information })
					exports.oxmysql:executeSync("UPDATE users SET `profilepic`=:profilepic WHERE `id`=:id LIMIT 1", { id = cid, profilepic = pfp })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..cid.." was updated by "..result.fullname)

					if result.job.name == 'doj' then
						exports.oxmysql:executeSync("UPDATE users SET `firstname`=:firstname, `lastname`=:lastname WHERE `id`=:id LIMIT 1", { firstname = fName, lastname = sName, id = cid })
					end
				end

				exports.oxmysql:execute('SELECT id FROM policemdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						UpdateInfo(user[1]['id'], pfp, information)
					else
						CreateUser(cid, 'policemdtdata', function(result)
							UpdateInfo(result, pfp, information)
						end)
					end
				end)
			elseif result.job and (result.job.name == 'ambulance') then
				local function UpdateInfo(id, pfp, desc)
					exports.oxmysql:executeSync("UPDATE emsmdtdata SET `information`=:information WHERE `id`=:id LIMIT 1", { id = id, information = information })
					exports.oxmysql:executeSync("UPDATE users SET `profilepic`=:profilepic WHERE `id`=:id LIMIT 1", { id = cid, profilepic = pfp })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..cid.." was updated by "..result.fullname)
				end

				exports.oxmysql:execute('SELECT id FROM emsmdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						UpdateInfo(user[1]['id'], pfp, information)
					else
						CreateUser(cid, 'emsmdtdata', function(result)
							UpdateInfo(result, pfp, information)
						end)
					end
				end)
			end
		end
	end)
end)

RegisterNetEvent("erp_mdt:newTag")
AddEventHandler('erp_mdt:newTag', function(cid, tag)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or result.job.name == 'doj') then
				local function UpdateTags(id, tags)
					exports.oxmysql:executeSync("UPDATE policemdtdata SET `tags`=:tags WHERE `id`=:id LIMIT 1", { id = id, tags = json.encode(tags) })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..id.." was added a new tag with the text ("..tag..") by "..result.fullname)
				end

				exports.oxmysql:execute('SELECT id, tags FROM policemdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						local tags = json.decode(user[1]['tags'])
						table.insert(tags, tag)
						UpdateTags(user[1]['id'], tags)
					else
						CreateUser(cid, 'policemdtdata', function(result)
							local tags = {}
							table.insert(tags, tag)
							UpdateTags(result, tags)
						end)
					end
				end)
			elseif result.job and (result.job.name == 'ambulance') then
				local function UpdateTags(id, tags)
					exports.oxmysql:executeSync("UPDATE emsmdtdata SET `tags`=:tags WHERE `id`=:id LIMIT 1", { id = id, tags = json.encode(tags) })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..id.." was added a new tag with the text ("..tag..") by "..result.fullname)
				end

				exports.oxmysql:execute('SELECT id, tags FROM emsmdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						local tags = json.decode(user[1]['tags'])
						table.insert(tags, tag)
						UpdateTags(user[1]['id'], tags)
					else
						CreateUser(cid, 'emsmdtdata', function(result)
							local tags = {}
							table.insert(tags, tag)
							UpdateTags(result, tags)
						end)
					end
				end)
			end
		end
	end)
end)

RegisterNetEvent("erp_mdt:removeProfileTag")
AddEventHandler('erp_mdt:removeProfileTag', function(cid, tagtext)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or result.job.name == 'doj') then

				local function UpdateTags(id, tag)
					exports.oxmysql:executeSync("UPDATE policemdtdata SET `tags`=:tags WHERE `id`=:id LIMIT 1", { id = id, tags = json.encode(tag) })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..id.." was removed of a tag with the text ("..tagtext..") by "..result.fullname)
				end

				exports.oxmysql:execute('SELECT id, tags FROM policemdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						local tags = json.decode(user[1]['tags'])
						for i=1, #tags do
							if tags[i] == tagtext then
								table.remove(tags, i)
							end
						end
						UpdateTags(user[1]['id'], tags)
					else
						CreateUser(cid, 'policemdtdata', function(result)
							UpdateTags(result, {})
						end)
					end
				end)
			elseif result.job and (result.job.name == 'ambulance') then

				local function UpdateTags(id, tag)
					exports.oxmysql:executeSync("UPDATE emsmdtdata SET `tags`=:tags WHERE `id`=:id LIMIT 1", { id = id, tags = json.encode(tag) })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..id.." was removed of a tag with the text ("..tagtext..") by "..result.fullname)
				end

				exports.oxmysql:execute('SELECT id, tags FROM emsmdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						local tags = json.decode(user[1]['tags'])
						for i=1, #tags do
							if tags[i] == tagtext then
								table.remove(tags, i)
							end
						end
						UpdateTags(user[1]['id'], tags)
					else
						CreateUser(cid, 'emsmdtdata', function(result)
							UpdateTags(result, {})
						end)
					end
				end)
			end
		end
	end)
end)

RegisterNetEvent("erp_mdt:updateLicense")
AddEventHandler('erp_mdt:updateLicense', function(cid, type, status)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or (result.job.name == 'doj' and result.job.grade == 11)) then
				if status == 'give' then
					TriggerEvent('erp-license:addLicense', type, cid)
				elseif status == 'revoke' then
					TriggerEvent('erp-license:removeLicense', type, cid)
				end
			end
		end
	end)
end)

RegisterNetEvent("erp_mdt:addGalleryImg")
AddEventHandler('erp_mdt:addGalleryImg', function(cid, img)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or result.job.name == 'doj') then

				local function UpdateGallery(id, gallery)
					exports.oxmysql:executeSync("UPDATE policemdtdata SET `gallery`=:gallery WHERE `id`=:id LIMIT 1", { id = id, gallery = json.encode(gallery) })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..id.." had their gallery updated (+) by "..result.fullname)
				end

				exports.oxmysql:execute('SELECT id, gallery FROM policemdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						local imgs = json.decode(user[1]['gallery'])
						table.insert(imgs, img)
						UpdateGallery(user[1]['id'], imgs)
					else
						CreateUser(cid, 'policemdtdata', function(result)
							local imgs = {}
							table.insert(imgs, img)
							UpdateGallery(result, imgs)
						end)
					end
				end)
			elseif result.job and (result.job.name == 'ambulance') then

				local function UpdateGallery(id, gallery)
					exports.oxmysql:executeSync("UPDATE emsmdtdata SET `gallery`=:gallery WHERE `id`=:id LIMIT 1", { id = id, gallery = json.encode(gallery) })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..id.." had their gallery updated (+) by "..result.fullname)
				end

				exports.oxmysql:execute('SELECT id, gallery FROM emsmdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						local imgs = json.decode(user[1]['gallery'])
						table.insert(imgs, img)
						UpdateGallery(user[1]['id'], imgs)
					else
						CreateUser(cid, 'emsmdtdata', function(result)
							local imgs = {}
							table.insert(imgs, img)
							UpdateGallery(result, imgs)
						end)
					end
				end)
			end
		end
	end)
end)

RegisterNetEvent("erp_mdt:removeGalleryImg")
AddEventHandler('erp_mdt:removeGalleryImg', function(cid, img)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or result.job.name == 'doj') then

				local function UpdateGallery(id, gallery)
					exports.oxmysql:executeSync("UPDATE policemdtdata SET `gallery`=:gallery WHERE `id`=:id LIMIT 1", { id = id, gallery = json.encode(gallery) })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..id.." had their gallery updated (-) by "..result.fullname)
				end

				exports.oxmysql:execute('SELECT id, gallery FROM policemdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						local imgs = json.decode(user[1]['gallery'])
						--table.insert(imgs, img)
						for i=1, #imgs do
							if imgs[i] == img then
								table.remove(imgs, i)
							end
						end

						UpdateGallery(user[1]['id'], imgs)
					else
						CreateUser(cid, 'policemdtdata', function(result)
							local imgs = {}
							UpdateGallery(result, imgs)
						end)
					end
				end)
			elseif result.job and (result.job.name == 'ambulance') then

				local function UpdateGallery(id, gallery)
					exports.oxmysql:executeSync("UPDATE emsmdtdata SET `gallery`=:gallery WHERE `id`=:id LIMIT 1", { id = id, gallery = json.encode(gallery) })
					TriggerEvent('erp_mdt:AddLog', "A user with the Citizen ID "..id.." had their gallery updated (-) by "..result.fullname)
				end

				exports.oxmysql:execute('SELECT id, gallery FROM emsmdtdata WHERE cid=:cid LIMIT 1', { cid = cid }, function(user)
					if user and user[1] then
						local imgs = json.decode(user[1]['gallery'])
						--table.insert(imgs, img)
						for i=1, #imgs do
							if imgs[i] == img then
								table.remove(imgs, i)
							end
						end

						UpdateGallery(user[1]['id'], imgs)
					else
						CreateUser(cid, 'emsmdtdata', function(result)
							local imgs = {}
							UpdateGallery(result, imgs)
						end)
					end
				end)
			end
		end
	end)
end)

-- Incidents


RegisterNetEvent('erp_mdt:getAllIncidents')
AddEventHandler('erp_mdt:getAllIncidents', function()
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or result.job.name == 'doj') then
				exports.oxmysql:execute("SELECT * FROM `pd_incidents` ORDER BY `id` DESC LIMIT 30", {}, function(matches)
					TriggerClientEvent('erp_mdt:getAllIncidents', result.source, matches)		
				end)
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:searchIncidents')
AddEventHandler('erp_mdt:searchIncidents', function(query)
	if query then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					exports.oxmysql:execute("SELECT * FROM `pd_incidents` WHERE `id` LIKE :query OR LOWER(`title`) LIKE :query OR LOWER(`author`) LIKE :query OR LOWER(`details`) LIKE :query OR LOWER(`tags`) LIKE :query OR LOWER(`officersinvolved`) LIKE :query OR LOWER(`civsinvolved`) LIKE :query OR LOWER(`author`) LIKE :query ORDER BY `id` DESC LIMIT 50", {
						query = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
					}, function(matches)
						TriggerClientEvent('erp_mdt:getIncidents', result.source, matches)		
					end)
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:getIncidentData')
AddEventHandler('erp_mdt:getIncidentData', function(sentId)
	if sentId then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					exports.oxmysql:execute("SELECT * FROM `pd_incidents` WHERE `id` = :id", {
						id = sentId
					}, function(matches)
						local data = matches[1]
						data['tags'] = json.decode(data['tags'])
						data['officersinvolved'] = json.decode(data['officersinvolved'])
						data['civsinvolved'] = json.decode(data['civsinvolved'])
						data['evidence'] = json.decode(data['evidence'])
						exports.oxmysql:execute("SELECT * FROM `pd_incidents` WHERE `id` = :id", {
							id = sentId
						}, function(matches)
							exports.oxmysql:execute("SELECT * FROM `pd_convictions` WHERE `linkedincident` = :id", {
								id = sentId
							}, function(convictions)
								for i=1, #convictions do
									GetNameFromId(convictions[i]['cid'], function(res)
										if res and res[1] then
											convictions[i]['name'] = res[1]['firstname']..' '..res[1]['lastname']
										else
											convictions[i]['name'] = "Unknown"
										end
									end)
									convictions[i]['charges'] = json.decode(convictions[i]['charges'])
								end
								TriggerClientEvent('erp_mdt:getIncidentData', result.source, data, convictions)
							end)
						end)
					end)
				end
			end
		end)
	end
end)

local debug = false

if debug then
	CreateThread(function()
		local data = {
			[1] = { cid = 1990, name = "Flakey" },
			[2] = { cid = 1523, name = "Test User" }
		}
		print(json.encode(data))
	end)
end

RegisterNetEvent('erp_mdt:getAllBolos')
AddEventHandler('erp_mdt:getAllBolos', function()
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or result.job.name == 'doj') then
				exports.oxmysql:execute("SELECT * FROM `pd_bolos`", {}, function(matches)
					TriggerClientEvent('erp_mdt:getAllBolos', result.source, matches)		
				end)
			elseif result.job and (result.job.name == 'ambulance') then
				exports.oxmysql:execute("SELECT * FROM `ems_icu`", {}, function(matches)
					TriggerClientEvent('erp_mdt:getAllBolos', result.source, matches)		
				end)
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:searchBolos')
AddEventHandler('erp_mdt:searchBolos', function(sentSearch)
	if sentSearch then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					exports.oxmysql:execute("SELECT * FROM `pd_bolos` WHERE `id` LIKE :query OR LOWER(`title`) LIKE :query OR `plate` LIKE :query OR LOWER(`owner`) LIKE :query OR LOWER(`individual`) LIKE :query OR LOWER(`detail`) LIKE :query OR LOWER(`officersinvolved`) LIKE :query OR LOWER(`tags`) LIKE :query OR LOWER(`author`) LIKE :query", {
						query = string.lower('%'..sentSearch..'%') -- % wildcard, needed to search for all alike results
					}, function(matches)
						TriggerClientEvent('erp_mdt:getBolos', result.source, matches)		
					end)
				elseif result.job and (result.job.name == 'ambulance') then
					exports.oxmysql:execute("SELECT * FROM `ems_icu` WHERE `id` LIKE :query OR LOWER(`title`) LIKE :query OR `plate` LIKE :query OR LOWER(`owner`) LIKE :query OR LOWER(`individual`) LIKE :query OR LOWER(`detail`) LIKE :query OR LOWER(`officersinvolved`) LIKE :query OR LOWER(`tags`) LIKE :query OR LOWER(`author`) LIKE :query", {
						query = string.lower('%'..sentSearch..'%') -- % wildcard, needed to search for all alike results
					}, function(matches)
						TriggerClientEvent('erp_mdt:getBolos', result.source, matches)
					end)
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:getBoloData')
AddEventHandler('erp_mdt:getBoloData', function(sentId)
	if sentId then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					exports.oxmysql:execute("SELECT * FROM `pd_bolos` WHERE `id` = :id LIMIT 1", {
						id = sentId
					}, function(matches)
						local data = matches[1]
						data['tags'] = json.decode(data['tags'])
						data['officersinvolved'] = json.decode(data['officersinvolved'])
						data['gallery'] = json.decode(data['gallery'])
						TriggerClientEvent('erp_mdt:getBoloData', result.source, data)		
					end)

				elseif result.job and (result.job.name == 'ambulance') then
					exports.oxmysql:execute("SELECT * FROM `ems_icu` WHERE `id` = :id LIMIT 1", {
						id = sentId
					}, function(matches)
						local data = matches[1]
						data['tags'] = json.decode(data['tags'])
						data['officersinvolved'] = json.decode(data['officersinvolved'])
						data['gallery'] = json.decode(data['gallery'])
						TriggerClientEvent('erp_mdt:getBoloData', result.source, data)		
					end)
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:newBolo')
AddEventHandler('erp_mdt:newBolo', function(existing, id, title, plate, owner, individual, detail, tags, gallery, officersinvolved, time)
	if id then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then

					local function InsertBolo()
						exports.oxmysql:insert('INSERT INTO `pd_bolos` (`title`, `author`, `plate`, `owner`, `individual`, `detail`, `tags`, `gallery`, `officersinvolved`, `time`) VALUES (:title, :author, :plate, :owner, :individual, :detail, :tags, :gallery, :officersinvolved, :time)', {
							title = title,
							author = result.fullname,
							plate = plate,
							owner = owner,
							individual = individual,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officersinvolved),
							time = tostring(time),
						}, function(r)
							if r then
								TriggerClientEvent('erp_mdt:boloComplete', result.source, r)
								TriggerEvent('erp_mdt:AddLog', "A new BOLO was created by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					local function UpdateBolo()
						exports.oxmysql:update("UPDATE pd_bolos SET `title`=:title, plate=:plate, owner=:owner, individual=:individual, detail=:detail, tags=:tags, gallery=:gallery, officersinvolved=:officersinvolved WHERE `id`=:id LIMIT 1", { 
							title = title,
							plate = plate,
							owner = owner,
							individual = individual,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officersinvolved),
							id = id
						}, function(r)
							if r then
								TriggerClientEvent('erp_mdt:boloComplete', result.source, id)
								TriggerEvent('erp_mdt:AddLog', "A BOLO was updated by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					if existing then
						UpdateBolo()
					elseif not existing then
						InsertBolo()
					end
				elseif result.job and (result.job.name == 'ambulance') then

					local function InsertBolo()
						exports.oxmysql:insert('INSERT INTO `ems_icu` (`title`, `author`, `plate`, `owner`, `individual`, `detail`, `tags`, `gallery`, `officersinvolved`, `time`) VALUES (:title, :author, :plate, :owner, :individual, :detail, :tags, :gallery, :officersinvolved, :time)', {
							title = title,
							author = result.fullname,
							plate = plate,
							owner = owner,
							individual = individual,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officersinvolved),
							time = tostring(time),
						}, function(r)
							if r then
								TriggerClientEvent('erp_mdt:boloComplete', result.source, r)
								TriggerEvent('erp_mdt:AddLog', "A new ICU Check-in was created by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					local function UpdateBolo()
						exports.oxmysql:update("UPDATE `ems_icu` SET `title`=:title, plate=:plate, owner=:owner, individual=:individual, detail=:detail, tags=:tags, gallery=:gallery, officersinvolved=:officersinvolved WHERE `id`=:id LIMIT 1", { 
							title = title,
							plate = plate,
							owner = owner,
							individual = individual,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officersinvolved),
							id = id
						}, function(affectedRows)
							if affectedRows > 0 then
								TriggerClientEvent('erp_mdt:boloComplete', result.source, id)
								TriggerEvent('erp_mdt:AddLog', "A ICU Check-in was updated by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					if existing then
						UpdateBolo()
					elseif not existing then
						InsertBolo()
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:deleteBolo')
AddEventHandler('erp_mdt:deleteBolo', function(id)
	if id then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					exports.oxmysql:executeSync("DELETE FROM `pd_bolos` WHERE id=:id", { id = id })
					TriggerEvent('erp_mdt:AddLog', "A BOLO was deleted by "..result.fullname.." with the ID ("..id..")")
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:deleteICU')
AddEventHandler('erp_mdt:deleteICU', function(id)
	if id then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.name == 'ambulance') then
					exports.oxmysql:executeSync("DELETE FROM `ems_icu` WHERE id=:id", { id = id })
					TriggerEvent('erp_mdt:AddLog', "A ICU Check-in was deleted by "..result.fullname.." with the ID ("..id..")")
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:incidentSearchPerson')
AddEventHandler('erp_mdt:incidentSearchPerson', function(name)
    if name then
        TriggerEvent('echorp:getplayerfromid', source, function(result)
            if result then
                if result.job and (result.job.isPolice or result.job.name == 'doj') then

                    local function PpPpPpic(gender, profilepic)
                        if profilepic then return profilepic end;
                        if gender == "f" then return "img/female.png" end;
                        return "img/male.png"
                    end

                    exports.oxmysql:execute("SELECT id, firstname, lastname, profilepic, gender FROM `users` WHERE LOWER(`firstname`) LIKE :query OR LOWER(`lastname`) LIKE :query OR LOWER(`id`) LIKE :query OR CONCAT(LOWER(`firstname`), ' ', LOWER(`lastname`)) LIKE :query LIMIT 30", {
                        query = string.lower('%'..name..'%') -- % wildcard, needed to search for all alike results
                    }, function(data)
                        for i=1, #data do
                            data[i]['profilepic'] = PpPpPpic(data[i]['gender'], data[i]['profilepic'])
                        end
                        TriggerClientEvent('erp_mdt:incidentSearchPerson', result.source, data)
                    end)
                end
            end
        end)
    end
end)

-- Reports

RegisterNetEvent('erp_mdt:getAllReports')
AddEventHandler('erp_mdt:getAllReports', function()
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice) then
				exports.oxmysql:execute("SELECT * FROM `pd_reports` ORDER BY `id` DESC LIMIT 30", {}, function(matches)
					TriggerClientEvent('erp_mdt:getAllReports', result.source, matches)		
				end)
			elseif result.job and (result.job.name == 'ambulance') then
				exports.oxmysql:execute("SELECT * FROM `ems_reports` ORDER BY `id` DESC LIMIT 30", {}, function(matches)
					TriggerClientEvent('erp_mdt:getAllReports', result.source, matches)		
				end)
			elseif result.job and (result.job.name == 'doj') then
				exports.oxmysql:execute("SELECT * FROM `doj_reports` ORDER BY `id` DESC LIMIT 30", {}, function(matches)
					TriggerClientEvent('erp_mdt:getAllReports', result.source, matches)		
				end)
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:getReportData')
AddEventHandler('erp_mdt:getReportData', function(sentId)
	if sentId then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and result.job.isPolice then
					exports.oxmysql:execute("SELECT * FROM `pd_reports` WHERE `id` = :id LIMIT 1", {
						id = sentId
					}, function(matches)
						local data = matches[1]
						data['tags'] = json.decode(data['tags'])
						data['officersinvolved'] = json.decode(data['officersinvolved'])
						data['civsinvolved'] = json.decode(data['civsinvolved'])
						data['gallery'] = json.decode(data['gallery'])
						TriggerClientEvent('erp_mdt:getReportData', result.source, data)		
					end)
				elseif result.job and (result.job.name == 'ambulance') then
					exports.oxmysql:execute("SELECT * FROM `ems_reports` WHERE `id` = :id LIMIT 1", {
						id = sentId
					}, function(matches)
						local data = matches[1]
						data['tags'] = json.decode(data['tags'])
						data['officersinvolved'] = json.decode(data['officersinvolved'])
						data['civsinvolved'] = json.decode(data['civsinvolved'])
						data['gallery'] = json.decode(data['gallery'])
						TriggerClientEvent('erp_mdt:getReportData', result.source, data)		
					end)
				elseif result.job and (result.job.name == 'doj') then
					exports.oxmysql:execute("SELECT * FROM `doj_reports` WHERE `id` = :id LIMIT 1", {
						id = sentId
					}, function(matches)
						local data = matches[1]
						data['tags'] = json.decode(data['tags'])
						data['officersinvolved'] = json.decode(data['officersinvolved'])
						data['civsinvolved'] = json.decode(data['civsinvolved'])
						data['gallery'] = json.decode(data['gallery'])
						TriggerClientEvent('erp_mdt:getReportData', result.source, data)		
					end)
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:searchReports')
AddEventHandler('erp_mdt:searchReports', function(sentSearch)
	if sentSearch then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and result.job.isPolice then
					exports.oxmysql:execute("SELECT * FROM `pd_reports` WHERE `id` LIKE :query OR LOWER(`author`) LIKE :query OR LOWER(`title`) LIKE :query OR LOWER(`type`) LIKE :query OR LOWER(`detail`) LIKE :query OR LOWER(`tags`) LIKE :query ORDER BY `id` DESC LIMIT 50", {
						query = string.lower('%'..sentSearch..'%') -- % wildcard, needed to search for all alike results
					}, function(matches)
						TriggerClientEvent('erp_mdt:getAllReports', result.source, matches)
					end)
				elseif result.job and (result.job.name == 'ambulance') then
					exports.oxmysql:execute("SELECT * FROM `ems_reports` WHERE `id` LIKE :query OR LOWER(`author`) LIKE :query OR LOWER(`title`) LIKE :query OR LOWER(`type`) LIKE :query OR LOWER(`detail`) LIKE :query OR LOWER(`tags`) LIKE :query ORDER BY `id` DESC LIMIT 50", {
						query = string.lower('%'..sentSearch..'%') -- % wildcard, needed to search for all alike results
					}, function(matches)
						TriggerClientEvent('erp_mdt:getAllReports', result.source, matches)
					end)
				elseif result.job and (result.job.name == 'doj') then
					exports.oxmysql:execute("SELECT * FROM `doj_reports` WHERE `id` LIKE :query OR LOWER(`author`) LIKE :query OR LOWER(`title`) LIKE :query OR LOWER(`type`) LIKE :query OR LOWER(`detail`) LIKE :query OR LOWER(`tags`) LIKE :query ORDER BY `id` DESC LIMIT 50", {
						query = string.lower('%'..sentSearch..'%') -- % wildcard, needed to search for all alike results
					}, function(matches)
						TriggerClientEvent('erp_mdt:getAllReports', result.source, matches)
					end)
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:newReport')
AddEventHandler('erp_mdt:newReport', function(existing, id, title, reporttype, detail, tags, gallery, officers, civilians, time)
	if id then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and result.job.isPolice then

					local function InsertBolo()
						exports.oxmysql:insert('INSERT INTO `pd_reports` (`title`, `author`, `type`, `detail`, `tags`, `gallery`, `officersinvolved`, `civsinvolved`, `time`) VALUES (:title, :author, :type, :detail, :tags, :gallery, :officersinvolved, :civsinvolved, :time)', {
							title = title,
							author = result.fullname,
							type = reporttype,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officers),
							civsinvolved = json.encode(civilians),
							time = tostring(time),
						}, function(r)
							if r then
								TriggerClientEvent('erp_mdt:reportComplete', result.source, r)
								TriggerEvent('erp_mdt:AddLog', "A new report was created by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					local function UpdateBolo()
						exports.oxmysql:update("UPDATE `pd_reports` SET `title`=:title, type=:type, detail=:detail, tags=:tags, gallery=:gallery, officersinvolved=:officersinvolved, civsinvolved=:civsinvolved WHERE `id`=:id LIMIT 1", { 
							title = title,
							type = reporttype,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officers),
							civsinvolved = json.encode(civilians),
							id = id,
						}, function(affectedRows)
							if affectedRows > 0 then
								TriggerClientEvent('erp_mdt:reportComplete', result.source, id)
								TriggerEvent('erp_mdt:AddLog', "A report was updated by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					if existing then
						UpdateBolo()
					elseif not existing then
						InsertBolo()
					end
				elseif result.job and (result.job.name == 'ambulance') then

					local function InsertBolo()
						exports.oxmysql:insert('INSERT INTO `ems_reports` (`title`, `author`, `type`, `detail`, `tags`, `gallery`, `officersinvolved`, `civsinvolved`, `time`) VALUES (:title, :author, :type, :detail, :tags, :gallery, :officersinvolved, :civsinvolved, :time)', {
							title = title,
							author = result.fullname,
							type = reporttype,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officers),
							civsinvolved = json.encode(civilians),
							time = tostring(time),
						}, function(r)
							if r > 0 then
								TriggerClientEvent('erp_mdt:reportComplete', result.source, r)
								TriggerEvent('erp_mdt:AddLog', "A new report was created by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					local function UpdateBolo()
						exports.oxmysql:update("UPDATE `ems_reports` SET `title`=:title, type=:type, detail=:detail, tags=:tags, gallery=:gallery, officersinvolved=:officersinvolved, civsinvolved=:civsinvolved WHERE `id`=:id LIMIT 1", { 
							title = title,
							type = reporttype,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officers),
							civsinvolved = json.encode(civilians),
							id = id,
						}, function(r)
							if r > 0 then
								TriggerClientEvent('erp_mdt:reportComplete', result.source, id)
								TriggerEvent('erp_mdt:AddLog', "A report was updated by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					if existing then
						UpdateBolo()
					elseif not existing then
						InsertBolo()
					end
				elseif result.job and (result.job.name == 'doj') then

					local function InsertBolo()
						exports.oxmysql:insert('INSERT INTO `doj_reports` (`title`, `author`, `type`, `detail`, `tags`, `gallery`, `officersinvolved`, `civsinvolved`, `time`) VALUES (:title, :author, :type, :detail, :tags, :gallery, :officersinvolved, :civsinvolved, :time)', {
							title = title,
							author = result.fullname,
							type = reporttype,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officers),
							civsinvolved = json.encode(civilians),
							time = tostring(time),
						}, function(r)
							if r > 0 then
								TriggerClientEvent('erp_mdt:reportComplete', result.source, r)
								TriggerEvent('erp_mdt:AddLog', "A new report was created by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					local function UpdateBolo()
						exports.oxmysql:update("UPDATE `doj_reports` SET `title`=:title, type=:type, detail=:detail, tags=:tags, gallery=:gallery, officersinvolved=:officersinvolved, civsinvolved=:civsinvolved WHERE `id`=:id LIMIT 1", { 
							title = title,
							type = reporttype,
							detail = detail,
							tags = json.encode(tags),
							gallery = json.encode(gallery),
							officersinvolved = json.encode(officers),
							civsinvolved = json.encode(civilians),
							id = id,
						}, function(r)
							if r > 0 then
								TriggerClientEvent('erp_mdt:reportComplete', result.source, id)
								TriggerEvent('erp_mdt:AddLog', "A report was updated by "..result.fullname.." with the title ("..title..") and ID ("..id..")")
							end
						end)
					end

					if existing then
						UpdateBolo()
					elseif not existing then
						InsertBolo()
					end
				end
			end
		end)
	end
end)

-- DMV

local function GetImpoundStatus(vehicleid, cb)
	cb( #(exports.oxmysql:executeSync('SELECT id FROM `impound` WHERE `vehicleid`=:vehicleid', {['vehicleid'] = vehicleid })) > 0 )
end

local function GetBoloStatus(plate, cb)
	cb(exports.oxmysql:executeSync('SELECT id FROM `pd_bolos` WHERE LOWER(`plate`)=:plate', { plate = string.lower(plate)}))
end

local function GetOwnerName(cid, cb)
	cb(exports.oxmysql:executeSync('SELECT firstname, lastname FROM `users` WHERE id=:cid LIMIT 1', { cid = cid}))
end

local function GetVehicleInformation(plate, cb)
	cb(exports.oxmysql:executeSync('SELECT id, information FROM `pd_vehicleinfo` WHERE plate=:plate', { plate = plate}))
end

RegisterNetEvent('erp_mdt:searchVehicles')
AddEventHandler('erp_mdt:searchVehicles', function(search, hash)
	if search then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					exports.oxmysql:execute("SELECT id, owner, plate, vehicle, code, stolen, image FROM `owned_vehicles` WHERE LOWER(`plate`) LIKE :query OR LOWER(`vehicle`) LIKE :hash LIMIT 25", {
						query = string.lower('%'..search..'%'),
						hash = string.lower('%'..hash..'%'),
					}, function(vehicles)
						for i=1, #vehicles do

							-- Impound Status
							GetImpoundStatus(vehicles[i]['id'], function(impoundStatus)
								vehicles[i]['impound'] = impoundStatus
							end)

							vehicles[i]['bolo'] = false

							if tonumber(vehicles[i]['code']) == 5 then
								vehicles[i]['code'] = true
							else
								vehicles[i]['code'] = false
							end

							-- Bolo Status
							GetBoloStatus(vehicles[i]['plate'], function(boloStatus)
								if boloStatus and boloStatus[1] then
									vehicles[i]['bolo'] = true
								end
							end)

							GetOwnerName(vehicles[i]['owner'], function(name)
								if name and name[1] then
									vehicles[i]['owner'] = name[1]['firstname']..' '..name[1]['lastname']
								end
							end)

							if vehicles[i]['image'] == nil then vehicles[i]['image'] = "img/not-found.jpg" end

						end

						TriggerClientEvent('erp_mdt:searchVehicles', result.source, vehicles)
					end)
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:getVehicleData')
AddEventHandler('erp_mdt:getVehicleData', function(plate)
	if plate then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					exports.oxmysql:execute("SELECT id, owner, plate, vehicle, code, stolen, image FROM `owned_vehicles` WHERE plate=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1")}, function(vehicle)
						if vehicle and vehicle[1] then
							vehicle[1]['impound'] = false
							GetImpoundStatus(vehicle[1]['id'], function(impoundStatus)
								vehicle[1]['impound'] = impoundStatus
							end)

							vehicle[1]['bolo'] = false
							vehicle[1]['information'] = ""

							if tonumber(vehicle[1]['code']) == 5 then vehicle[1]['code'] = true
							else vehicle[1]['code'] = false end -- Used to get the code 5 status

							-- Bolo Status
							GetBoloStatus(vehicle[1]['plate'], function(boloStatus)
								if boloStatus and boloStatus[1] then vehicle[1]['bolo'] = true end
							end) -- Used to get BOLO status.

							vehicle[1]['name'] = "Unknown Person"

							GetOwnerName(vehicle[1]['owner'], function(name)
								if name and name[1] then 
									vehicle[1]['name'] = name[1]['firstname']..' '..name[1]['lastname'] 
								end
							end) -- Get's vehicle owner name name.

							vehicle[1]['dbid'] = 0

							GetVehicleInformation(vehicle[1]['plate'], function(info)
								if info and info[1] then
									vehicle[1]['information'] = info[1]['information']
									vehicle[1]['dbid'] = info[1]['id']
								end
							end) -- Vehicle notes and database ID if there is one.

							if vehicle[1]['image'] == nil then vehicle[1]['image'] = "img/not-found.jpg" end -- Image
						end
						TriggerClientEvent('erp_mdt:getVehicleData', result.source, vehicle)
					end)
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:saveVehicleInfo')
AddEventHandler('erp_mdt:saveVehicleInfo', function(dbid, plate, imageurl, notes)
	if plate then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					if dbid == nil then dbid = 0 end;
					exports.oxmysql:executeSync("UPDATE owned_vehicles SET `image`=:image WHERE `plate`=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1"), image = imageurl })
					TriggerEvent('erp_mdt:AddLog', "A vehicle with the plate ("..plate..") has a new image ("..imageurl..") edited by "..result['fullname'])
					if tonumber(dbid) == 0 then
						exports.oxmysql:insert('INSERT INTO `pd_vehicleinfo` (`plate`, `information`) VALUES (:plate, :information)', { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1"), information = notes }, function(infoResult)
							if infoResult then
								TriggerClientEvent('erp_mdt:updateVehicleDbId', result.source, infoResult)
								TriggerEvent('erp_mdt:AddLog', "A vehicle with the plate ("..plate..") was added to the vehicle information database by "..result['fullname'])
							end
						end)
					elseif tonumber(dbid) > 0 then
						exports.oxmysql:executeSync("UPDATE pd_vehicleinfo SET `information`=:information WHERE `plate`=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1"), information = notes })
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('erp_mdt:knownInformation')
AddEventHandler('erp_mdt:knownInformation', function(dbid, type, status, plate)
	if plate then
		TriggerEvent('echorp:getplayerfromid', source, function(result)
			if result then
				if result.job and (result.job.isPolice or result.job.name == 'doj') then
					if dbid == nil then dbid = 0 end;

					if type == 'code5' and status == true then
						exports.oxmysql:executeSync("UPDATE owned_vehicles SET `code`=:code WHERE `plate`=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1"), code = 5 })
						TriggerEvent('erp_mdt:AddLog', "A vehicle with the plate ("..plate..") was set to CODE 5 by "..result['fullname'])
					elseif type == 'code5' and not status then
						exports.oxmysql:executeSync("UPDATE owned_vehicles SET `code`=:code WHERE `plate`=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1"), code = 0 })
						TriggerEvent('erp_mdt:AddLog', "A vehicle with the plate ("..plate..") had it's CODE 5 status removed by "..result['fullname'])
					elseif type == 'stolen' and status then
						exports.oxmysql:executeSync("UPDATE owned_vehicles SET `stolen`=:stolen WHERE `plate`=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1"), stolen = 1 })
						TriggerEvent('erp_mdt:AddLog', "A vehicle with the plate ("..plate..") was set to STOLEN by "..result['fullname'])
					elseif type == 'stolen' and not status then
						exports.oxmysql:executeSync("UPDATE owned_vehicles SET `stolen`=:stolen WHERE `plate`=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1"), stolen = 0 })
						TriggerEvent('erp_mdt:AddLog', "A vehicle with the plate ("..plate..") had it's STOLEN status removed by "..result['fullname'])
					end

					if tonumber(dbid) == 0 then
						exports.oxmysql:insert('INSERT INTO `pd_vehicleinfo` (`plate`) VALUES (:plate)', { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1") }, function(infoResult)
							if infoResult then
								TriggerClientEvent('erp_mdt:updateVehicleDbId', result.source, infoResult)
								TriggerEvent('erp_mdt:AddLog', "A vehicle with the plate ("..plate..") was added to the vehicle information database by "..result['fullname'])
							end
						end)
					end
				end
			end
		end)
	end
end)

local LogPerms = {
	['ambulance'] = {
		[7] = true,
		[8] = true,
		[15] = true,
		[16] = true
	},
	['bcso'] = {
		[6] = true,
		[7] = true,
		[8] = true,
	},
	['doc'] = {
		[8] = true,
		[9] = true,
	},
	['doj'] = {
		[11] = true,
	},
	['lspd'] = {
		[6] = true,
		[7] = true,
		[8] = true,
	},
	['sast'] = {
		[5] = true,
		[6] = true,
	},
	['sapr'] = {
		[4] = true,
		[5] = true,
	},
	['sapr'] = {
		[4] = true,
		[5] = true,
	}
}

RegisterNetEvent('erp_mdt:getAllLogs')
AddEventHandler('erp_mdt:getAllLogs', function()
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if LogPerms[result.job.name][result.job.grade] then
				exports.oxmysql:execute('SELECT * FROM pd_logs ORDER BY `id` DESC LIMIT 250', {}, function(infoResult)
					TriggerLatentClientEvent('erp_mdt:getAllLogs', result.source, 30000, infoResult)
				end)
			end
		end
	end)
end)

-- Penal Code

local PenalCodeTitles = {
	[1] = 'OFFENSES AGAINST PERSONS',
	[2] = 'OFFENSES INVOLVING THEFT',
	[3] = 'OFFENSES INVOLVING FRAUD',
	[4] = 'OFFENSES INVOLVING DAMAGE TO PROPERTY',
	[5] = 'OFFENSES AGAINST PUBLIC ADMINISTRATION',
	[6] = 'OFFENSES AGAINST PUBLIC ORDER',
	[7] = 'OFFENSES AGAINST HEALTH AND MORALS',
	[8] = 'OFFENSES AGAINST PUBLIC SAFETY',
	[9] = 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE',
	[10] = 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE',
}

local PenalCode = {
	[1] = {
			[1] = { title = 'Simple Assault', class = 'Misdemeanor', id = 'P.C. 1001', months = 7, fine = 500, color = 'green' },
			[2] = { title = 'Assault', class = 'Misdemeanor', id = 'P.C. 1002', months = 15, fine = 850, color = 'orange' },
			[3] = { title = 'Aggravated Assault', class = 'Felony', id = 'P.C. 1003', months = 20, fine = 1250, color = 'orange' },
			[4] = { title = 'Assault with a Deadly Weapon', class = 'Felony', id = 'P.C. 1004', months = 30, fine = 3750, color = 'red' },
			[5] = { title = 'Involuntary Manslaughter', class = 'Felony', id = 'P.C. 1005', months = 60, fine = 7500, color = 'red' },
			[6] = { title = 'Vehicular Manslaughter', class = 'Felony', id = 'P.C. 1006', months = 75, fine = 7500, color = 'red' },
			[7] = { title = 'Attempted Murder of a Civilian', class = 'Felony', id = 'P.C. 1007', months = 50, fine = 7500, color = 'red' },
			[8] = { title = 'Second Degree Murder', class = 'Felony', id = 'P.C. 1008', months = 100, fine = 15000, color = 'red' },
			[9] = { title = 'Accessory to Second Degree Murder', class = 'Felony', id = 'P.C. 1009', months = 50, fine = 5000, color = 'red' },
			[10] = { title = 'First Degree Murder', class = 'Felony', id = 'P.C. 1010', months = 0, fine = 0, color = 'red' },
			[11] = { title = 'Accessory to First Degree Murder', class = 'Felony', id = 'P.C. 1011', months = 0, fine = 0, color = 'red' },
			[12] = { title = 'Murder of a Public Servant or Peace Officer', class = 'Felony', id = 'P.C. 1012', months = 0, fine = 0, color = 'red' },
			[13] = { title = 'Attempted Murder of a Public Servant or Peace Officer', class = 'Felony', id = 'P.C. 1013', months = 65, fine = 10000, color = 'red' },
			[14] = { title = 'Accessory to the Murder of a Public Servant or Peace Officer', class = 'Felony', id = 'P.C. 1014', months = 0, fine = 0, color = 'red' },
			[15] = { title = 'Unlawful Imprisonment', class = 'Misdemeanor', id = 'P.C. 1015', months = 10, fine = 600, color = 'green' },
			[16] = { title = 'Kidnapping', class = 'Felony', id = 'P.C. 1016', months = 15, fine = 900, color = 'orange' },
			[17] = { title = 'Accessory to Kidnapping', class = 'Felony', id = 'P.C. 1017', months = 7, fine = 450, color = 'orange' },
			[18] = { title = 'Attempted Kidnapping', class = 'Felony', id = 'P.C. 1018', months = 10, fine = 450, color = 'orange' },
			[19] = { title = 'Hostage Taking', class = 'Felony', id = 'P.C. 1019', months = 20, fine = 1200, color = 'orange' },
			[20] = { title = 'Accessory to Hostage Taking', class = 'Felony', id = 'P.C. 1020', months = 10, fine = 600, color = 'orange' },
			[21] = { title = 'Unlawful Imprisonment of a Public Servant or Peace Officer.', class = 'Felony', id = 'P.C. 1021', months = 25, fine = 4000, color = 'orange' },
			[22] = { title = 'Criminal Threats', class = 'Misdemeanor', id = 'P.C. 1022', months = 5, fine = 500, color = 'orange' },
			[23] = { title = 'Reckless Endangerment', class = 'Misdemeanor', id = 'P.C. 1023', months = 10, fine = 1000, color = 'orange' },
			[24] = { title = 'Gang Related Shooting', class = 'Felony', id = 'P.C. 1024', months = 30, fine = 2500, color = 'red' },
			[25] = { title = 'Cannibalism', class = 'Felony', id = 'P.C. 1025', months = 0, fine = 0, color = 'red' },
			[26] = { title = 'Torture', class = 'Felony', id = 'P.C. 1026', months = 40, fine = 4500, color = 'red' },
	},
	[2] = {       
			[1] = { title = 'Petty Theft', class = 'Infraction', id = 'P.C. 2001', months = 0, fine = 250, color = 'green' }, 
			[2] = { title = 'Grand Theft', class = 'Misdemeanor', id = 'P.C. 2002', months = 10, fine = 600, color = 'green' },
			[3] = { title = 'Grand Theft Auto A', class = 'Felony', id = 'P.C. 2003', months = 15, fine = 900, color = 'green' },
			[4] = { title = 'Grand Theft Auto B', class = 'Felony', id = 'P.C. 2004', months = 35, fine = 3500, color = 'green' },
			[5] = { title = 'Carjacking', class = 'Felony', id = 'P.C. 2005', months = 30, fine = 2000, color = 'orange' },
			[6] = { title = 'Burglary', class = 'Misdemeanor', id = 'P.C. 2006', months = 10, fine = 500, color = 'green' },
			[7] = { title = 'Robbery', class = 'Felony', id = 'P.C. 2007', months = 25, fine = 2000, color = 'green' },
			[8] = { title = 'Accessory to Robbery', class = 'Felony', id = 'P.C. 2008', months = 12, fine = 1000, color = 'green' },		
			[9] = { title = 'Attempted Robbery', class = 'Felony', id = 'P.C. 2009', months = 20, fine = 1000, color = 'green' },			
			[10] = { title = 'Armed Robbery', class = 'Felony', id = 'P.C. 2010', months = 30, fine = 3000, color = 'orange' },
			[11] = { title = 'Accessory to Armed Robbery', class = 'Felony', id = 'P.C. 2011', months = 15, fine = 1500, color = 'orange' },		
			[12] = { title = 'Attempted Armed Robbery', class = 'Felony', id = 'P.C. 2012', months = 25, fine = 1500, color = 'orange' },
			[13] = { title = 'Grand Larceny', class = 'Felony', id = 'P.C. 2013', months = 45, fine = 7500, color = 'orange' },
			[14] = { title = 'Leaving Without Paying', class = 'Infraction', id = 'P.C. 2014', months = 0, fine = 500, color = 'green' },
			[15] = { title = 'Possession of Nonlegal Currency', class = 'Misdemeanor', id = 'P.C. 2015', months = 10, fine = 750, color = 'green' },
			[16] = { title = 'Possession of Government-Issued Items', class = 'Misdemeanor', id = 'P.C. 2016', months = 15, fine = 1000, color = 'green' },
			[17] = { title = 'Possession of Items Used in the Commission of a Crime', class = 'Misdemeanor', id = 'P.C. 2017', months = 10, fine = 500, color = 'green' },			
			[18] = { title = 'Sale of Items Used in the Commission of a Crime', class = 'Felony', id = 'P.C. 2018', months = 15, fine = 1000, color = 'orange' },			
			[19] = { title = 'Theft of an Aircraft', class = 'Felony', id = 'P.C. 2019', months = 20, fine = 1000, color = 'green' },
	},
	[3] = { 
			[1] = { title = 'Impersonating', class = 'Misdemeanor', id = 'P.C. 3001', months = 15, fine = 1250, color = 'green' }, 
			[2] = { title = 'Impersonating a Peace Officer or Public Servant', class = 'Felony', id = 'P.C. 3002', months = 25, fine = 2750, color = 'green' },
			[3] = { title = 'Impersonating a Judge', class = 'Felony', id = 'P.C. 3003', months = 0, fine = 0, color = 'green' },
			[4] = { title = 'Possession of Stolen Identification', class = 'Misdemeanor', id = 'P.C. 3004', months = 10, fine = 750, color = 'green' },
			[5] = { title = 'Possession of Stolen Government Identification', class = 'Misdemeanor', id = 'P.C. 3005', months = 20, fine = 2000, color = 'green' },			
			[6] = { title = 'Extortion', class = 'Felony', id = 'P.C. 3006', months = 20, fine = 900, color = 'orange' },
			[7] = { title = 'Fraud', class = 'Misdemeanor', id = 'P.C. 3007', months = 10, fine = 450, color = 'green' },
			[8] = { title = 'Forgery', class = 'Misdemeanor', id = 'P.C. 3008', months = 15, fine = 750, color = 'green' },
			[9] = { title = 'Money Laundering', class = 'Felony', id = 'P.C. 3009', months = 0, fine = 0, color = 'red' },
	},
	[4] = { 
			[1] = { title = 'Trespassing', class = 'Misdemeanor', id = 'P.C. 4001', months = 10, fine = 450, color = 'green' },
			[2] = { title = 'Felony Trespassing', class = 'Felony', id = 'P.C. 4002', months = 15, fine = 1500, color = 'green' },
			[3] = { title = 'Arson', class = 'Felony', id = 'P.C. 4003', months = 15, fine = 1500, color = 'orange' },
			[4] = { title = 'Vandalism', class = 'Infraction', id = 'P.C. 4004', months = 0, fine = 300, color = 'green' },
			[5] = { title = 'Vandalism of Government Property', class = 'Felony', id = 'P.C. 4005', months = 20, fine = 1500, color = 'green' },
			[6] = { title = 'Littering', class = 'Infraction', id = 'P.C. 4006', months = 0, fine = 200, color = 'green' },
	},
	[5] = { 
			[1] = { title = 'Bribery of a Government Official', class = 'Felony', id = 'P.C. 5001', months = 20, fine = 3500, color = 'green' },
			[2] = { title = 'Anti-Mask Law', class = 'Infraction', id = 'P.C. 5002', months = 0, fine = 750, color = 'green' },
			[3] = { title = 'Possession of Contraband in a Government Facility', class = 'Felony', id = 'P.C. 5003', months = 25, fine = 1000, color = 'green' },
			[4] = { title = 'Criminal Possession of Stolen Property', class = 'Misdemeanor', id = 'P.C. 5004', months = 10, fine = 500, color = 'green' },
			[5] = { title = 'Escaping', class = 'Felony', id = 'P.C. 5005', months = 10, fine = 450, color = 'green' },
			[6] = { title = 'Jailbreak', class = 'Felony', id = 'P.C. 5006', months = 30, fine = 2500, color = 'orange' },
			[7] = { title = 'Accessory to Jailbreak', class = 'Felony', id = 'P.C. 5007', months = 25, fine = 2000, color = 'orange' },
			[8] = { title = 'Attempted Jailbreak', class = 'Felony', id = 'P.C. 5008', months = 20, fine = 1500, color = 'orange' },
			[9] = { title = 'Perjury', class = 'Felony', id = 'P.C. 5009', months = 0, fine = 0, color = 'green' },
			[10] = { title = 'Violation of a Restraining Order', class = 'Felony', id = 'P.C. 5010', months = 20, fine = 2250, color = 'green' },
			[11] = { title = 'Embezzlement', class = 'Felony', id = 'P.C. 5011', months = 45, fine = 10000, color = 'green' },
			[12] = { title = 'Unlawful Practice', class = 'Felony', id = 'P.C. 5012', months = 15, fine = 1500, color = 'orange' },
			[13] = { title = 'Misuse of Emergency Systems', class = 'Infraction', id = 'P.C. 5013', months = 0, fine = 600, color = 'orange' },
			[14] = { title = 'Conspiracy', class = 'Misdemeanor', id = 'P.C. 5014', months = 10, fine = 450, color = 'green' },
			[15] = { title = 'Violating a Court Order', class = 'Misdemeanor', id = 'P.C. 5015', months = 0, fine = 0, color = 'orange' },
			[16] = { title = 'Failure to Appear', class = 'Misdemeanor', id = 'P.C. 5016', months = 0, fine = 0, color = 'orange' },
			[17] = { title = 'Contempt of Court', class = 'Felony', id = 'P.C. 5017', months = 0, fine = 0, color = 'orange' },
			[18] = { title = 'Resisting Arrest', class = 'Misdemeanor', id = 'P.C. 5018', months = 5, fine = 300, color = 'orange' },
	},
	[6] = { 
			[1] = { title = 'Disobeying a Peace Officer', class = 'infraction', id = 'P.C. 6001', months = 0, fine = 750, color = 'green' },
			[2] = { title = 'Disorderly Conduct', class = 'Infraction', id = 'P.C. 6002', months = 0, fine = 250, color = 'green' },
			[3] = { title = 'Disturbing the Peace', class = 'infraction', id = 'P.C. 6003', months = 0, fine = 350, color = 'green' },
			[4] = { title = 'False Reporting', class = 'Misdemeanor', id = 'P.C. 6004', months = 10, fine = 750, color = 'green' },
			[5] = { title = 'Harassment', class = 'Misdemeanor', id = 'P.C. 6005', months = 10, fine = 500, color = 'orange' },
			[6] = { title = 'Misdemeanor Obstruction of Justice', class = 'Misdemeanor', id = 'P.C. 6006', months = 10, fine = 500, color = 'green' },
			[7] = { title = 'Felony Obstruction of Justice', class = 'Felony', id = 'P.C. 6007', months = 15, fine = 900, color = 'green' },
			[8] = { title = 'Inciting a Riot', class = 'Felony', id = 'P.C. 6008', months = 25, fine = 1000, color = 'orange' },
			[9] = { title = 'Loitering on Government Properties', class = 'Infraction', id = 'P.C. 6009', months = 0, fine = 500, color = 'green' },
			[10] = { title = 'Tampering', class = 'Misdemeanor', id = 'P.C. 6010', months = 10, fine = 500, color = 'green' },
			[11] = { title = 'Vehicle Tampering', class = 'Misdemeanor', id = 'P.C. 6011', months = 15, fine = 750, color = 'green' },
			[12] = { title = 'Evidence Tampering', class = 'Felony', id = 'P.C. 6012', months = 20, fine = 1000, color = 'green' },
			[13] = { title = 'Witness Tampering', class = 'Felony', id = 'P.C. 6013', months = 0, fine = 0, color = 'green' },
			[14] = { title = 'Failure to Provide Identification', class = 'Misdemeanor', id = 'P.C. 6014', months = 15, fine = 1500, color = 'green' },
			[15] = { title = 'Vigilantism', class = 'Felony', id = 'P.C. 6015', months = 30, fine = 1500, color = 'orange' },
			[16] = { title = 'Unlawful Assembly', class = 'Misdemeanor', id = 'P.C. 6016', months = 10, fine = 750, color = 'orange' },
			[17] = { title = 'Government Corruption', class = 'Felony', id = 'P.C. 6017', months = 0, fine = 0, color = 'red' },
			[18] = { title = 'Stalking', class = 'Felony', id = 'P.C. 6018', months = 40, fine = 1500, color = 'orange' },
			[19] = { title = 'Aiding and Abetting', class = 'Misdemeanor', id = 'P.C. 6019', months = 15, fine = 450, color = 'orange' },
			[20] = { title = 'Harboring a Fugitive', class = 'Misdemeanor', id = 'P.C. 6020', months = 10, fine = 1000, color = 'green' },
	},
	[7] = { 
			[1] = { title = 'Misdemeanor Possession of Marijuana', class = 'Mask', id = 'P.C. 7001', months = 5, fine = 250, color = 'green' },
			[2] = { title = 'Felony Possession of Marijuana', class = 'Felony', id = 'P.C. 7002', months = 15, fine = 1000, color = 'green' },
			[3] = { title = 'Cultivation of Marijuana A', class = 'Misdemeanor', id = 'P.C. 7003', months = 10, fine = 750, color = 'green' },
			[4] = { title = 'Cultivation of Marijuana B', class = 'Felony', id = 'P.C. 7004', months = 30, fine = 1500, color = 'orange' },
			[5] = { title = 'Possession of Marijuana with Intent to Distribute', class = 'Felony', id = 'P.C. 7005', months = 30, fine = 3000, color = 'orange' },
			[6] = { title = 'Misdemeanor Possession of Cocaine', class = 'Misdemeanor', id = 'P.C. 7006', months = 7, fine = 500, color = 'green' },
			[7] = { title = 'Felony Possession of Cocaine', class = 'Felony', id = 'P.C. 7007', months = 25, fine = 1500, color = 'green' },
			[8] = { title = 'Possession of Cocaine with Intent to Distribute', class = 'Felony', id = 'P.C. 7008', months = 35, fine = 4500, color = 'orange' },
			[9] = { title = 'Misdemeanor Possession of Methamphetamine', class = 'Misdemeanor', id = 'P.C. 7009', months = 7, fine = 500, color = 'green' },
			[10] = { title = 'Felony Possession of Methamphetamine', class = 'Felony', id = 'P.C. 7010', months = 25, fine = 1500, color = 'green' },
			[11] = { title = 'Possession of Methamphetamine with Intent to Distribute', class = 'Felony', id = 'P.C. 7011', months = 35, fine = 4500, color = 'orange' },
			[12] = { title = 'Misdemeanor Possession of Oxy / Vicodin', class = 'Felony', id = 'P.C. 7012', months = 7, fine = 500, color = 'green' },
			[13] = { title = 'Felony Possession of Oxy / Vicodin', class = 'Felony', id = 'P.C. 7013', months = 25, fine = 1500, color = 'green' },
			[14] = { title = 'Felony Possession of Oxy / Vicodin with Intent to Distribute', class = 'Felony', id = 'P.C. 7014', months = 35, fine = 4500, color = 'orange' },
			[15] = { title = 'Misdemeanor Possession of Ecstasy', class = 'Misdemeanor', id = 'P.C. 7015', months = 7, fine = 500, color = 'green' },
			[16] = { title = 'Felony Possession of Ecstasy', class = 'Felony', id = 'P.C. 7016', months = 25, fine = 1500, color = 'green' },
			[17] = { title = 'Possession of Ecstasy with Intent to Distribute', class = 'Felony', id = 'P.C. 7017', months = 35, fine = 4500, color = 'orange' },
			[18] = { title = 'Misdemeanor Possession of Opium', class = 'Misdemeanor', id = 'P.C. 7018', months = 7, fine = 500, color = 'green' },
			[19] = { title = 'Felony Possession of Opium', class = 'Felony', id = 'P.C. 7019', months = 25, fine = 1500, color = 'green' },
			[20] = { title = 'Possession of Opium with Intent to Distribute', class = 'Felony', id = 'P.C. 7020', months = 35, fine = 4500, color = 'orange' },
			[21] = { title = 'Misdemeanor Possession of Adderall', class = 'Misdemeanor', id = 'P.C. 7021', months = 7, fine = 500, color = 'green' },
			[22] = { title = 'Felony Possession of Adderall', class = 'Felony', id = 'P.C. 7022', months = 25, fine = 1500, color = 'green' },
			[23] = { title = 'Possession of Adderall with Intent to Distribute', class = 'Felony', id = 'P.C. 7023', months = 35, fine = 4500, color = 'orange' },
			[24] = { title = 'Misdemeanor Possession of Xanax', class = 'Misdemeanor', id = 'P.C. 7024', months = 7, fine = 500, color = 'green' },
			[25] = { title = 'Felony Possession of Xanax', class = 'Felony', id = 'P.C. 7025', months = 25, fine = 1500, color = 'green' },
			[26] = { title = 'Possession of Xanax with Intent to Distribute', class = 'Felony', id = 'P.C. 7026', months = 35, fine = 4500, color = 'orange' },
			[27] = { title = 'Misdemeanor Possession of Shrooms', class = 'Misdemeanor', id = 'P.C. 7027', months = 7, fine = 500, color = 'green' },
			[28] = { title = 'Felony Possession of Shrooms', class = 'Felony', id = 'P.C. 7028', months = 25, fine = 1500, color = 'green' },
			[29] = { title = 'Possession of Shrooms with Intent to Distribute', class = 'Felony', id = 'P.C. 7029', months = 35, fine = 4500, color = 'orange' },
			[30] = { title = 'Misdemeanor Possession of Lean', class = 'Misdemeanor', id = 'P.C. 7030', months = 7, fine = 500, color = 'green' },
			[31] = { title = 'Felony Possession of Lean', class = 'Felony', id = 'P.C. 7031', months = 25, fine = 1500, color = 'green' },
			[32] = { title = 'Possession of Lean with Intent to Distribute', class = 'Felony', id = 'P.C. 7032', months = 35, fine = 4500, color = 'orange' },
			[33] = { title = 'Sale of a controlled substance', class = 'Misdemeanor', id = 'P.C. 7033', months = 10, fine = 1000, color = 'green' },
			[34] = { title = 'Drug Trafficking', class = 'Felony', id = 'P.C. 7034', months = 0, fine = 0, color = 'red' },
			[35] = { title = 'Desecration of a Human Corpse', class = 'Felony', id = 'P.C. 7035', months = 20, fine = 1500, color = 'orange' },
			[36] = { title = 'Public Intoxication', class = 'Infraction', id = 'P.C. 7036', months = 0, fine = 500, color = 'green' },
			[37] = { title = 'Public Indecency', class = 'Misdemeanor', id = 'P.C. 7037', months = 10, fine = 750, color = 'green' },
	},
	[8] = { 
			[1] = { title = 'Criminal Possession of Weapon Class A', class = 'Felony', id = 'P.C. 8001', months = 10, fine = 500, color = 'green' },
			[2] = { title = 'Criminal Possession of Weapon Class B', class = 'Felony', id = 'P.C. 8002', months = 15, fine = 1000, color = 'green' },
			[3] = { title = 'Criminal Possession of Weapon Class C', class = 'Felony', id = 'P.C. 8003', months = 30, fine = 3500, color = 'green' },
			[4] = { title = 'Criminal Possession of Weapon Class D', class = 'Felony', id = 'P.C. 8004', months = 25, fine = 1500, color = 'green' },
			[5] = { title = 'Criminal Sale of Weapon Class A', class = 'Felony', id = 'P.C. 8005', months = 15, fine = 1000, color = 'orange' },
			[6] = { title = 'Criminal Sale of Weapon Class B', class = 'Felony', id = 'P.C. 8006', months = 20, fine = 2000, color = 'orange' },
			[7] = { title = 'Criminal Sale of Weapon Class C', class = 'Felony', id = 'P.C. 8007', months = 35, fine = 7000, color = 'orange' },
			[8] = { title = 'Criminal Sale of Weapon Class D', class = 'Felony', id = 'P.C. 8008', months = 30, fine = 3000, color = 'orange' },
			[9] = { title = 'Criminal Use of Weapon', class = 'Misdemeanor', id = 'P.C. 8009', months = 10, fine = 450, color = 'orange' },
			[10] = { title = 'Possession of Illegal Firearm Modifications', class = 'Misdemeanor', id = 'P.C. 8010', months = 10, fine = 300, color = 'green' },
			[11] = { title = 'Weapon Trafficking', class = 'Felony', id = 'P.C. 8011', months = 0, fine = 0, color = 'red' },
			[12] = { title = 'Brandishing a Weapon', class = 'Misdemeanor', id = 'P.C. 8012', months = 15, fine = 500, color = 'orange' },
			[13] = { title = 'Insurrection', class = 'Felony', id = 'P.C. 8013', months = 0, fine = 0, color = 'red' },
			[14] = { title = 'Flying into Restricted Airspace', class = 'Felony', id = 'P.C. 8014', months = 20, fine = 1500, color = 'green' },
			[15] = { title = 'Jaywalking', class = 'Infraction', id = 'P.C. 8015', months = 0, fine = 150, color = 'green' },
			[16] = { title = 'Criminal Use of Explosives', class = 'Felony', id = 'P.C. 8016', months = 30, fine = 2500, color = 'orange' },
	},
	[9] = {
			[1] = { title = 'Driving While Intoxicated', class = 'Misdemeanor', id = 'P.C. 9001', months = 5, fine = 300, color = 'green' },
			[2] = { title = 'Evading', class = 'Misdemeanor', id = 'P.C. 9002', months = 5, fine = 400, color = 'green' },
			[3] = { title = 'Reckless Evading', class = 'Felony', id = 'P.C. 9003', months = 10, fine = 800, color = 'orange' },
			[4] = { title = 'Failure to Yield to Emergency Vehicle', class = 'Infraction', id = 'P.C. 9004', months = 0, fine = 600, color = 'green' },
			[5] = { title = 'Failure to Obey Traffic Control Device', class = 'Infraction', id = 'P.C. 9005', months = 0, fine = 150, color = 'green' },
			[6] = { title = 'Nonfunctional Vehicle', class = 'Infraction', id = 'P.C. 9006', months = 0, fine = 75, color = 'green' },
			[7] = { title = 'Negligent Driving', class = 'Infraction', id = 'P.C. 9007', months = 0, fine = 300, color = 'green' },
			[8] = { title = 'Reckless Driving', class = 'Misdemeanor', id = 'P.C. 9008', months = 10, fine = 750, color = 'orange' },
			[9] = { title = 'Third Degree Speeding', class = 'Infraction', id = 'P.C. 9009', months = 0, fine = 225, color = 'green' },
			[10] = { title = 'Second Degree Speeding', class = 'Infraction', id = 'P.C. 9010', months = 0, fine = 450, color = 'green' },
			[11] = { title = 'First Degree Speeding', class = 'Infraction', id = 'P.C. 9011', months = 0, fine = 750, color = 'green' },
			[12] = { title = 'Unlicensed Operation of Vehicle', class = 'Infraction', id = 'P.C. 9012', months = 0, fine = 500, color = 'green' },
			[13] = { title = 'Illegal U-Turn', class = 'Infraction', id = 'P.C. 9013', months = 0, fine = 75, color = 'green' },
			[14] = { title = 'Illegal Passing', class = 'Infraction', id = 'P.C. 9014', months = 0, fine = 300, color = 'green' },
			[15] = { title = 'Failure to Maintain Lane', class = 'Infraction', id = 'P.C. 9015', months = 0, fine = 300, color = 'green' },
			[16] = { title = 'Illegal Turn', class = 'Infraction', id = 'P.C. 9016', months = 0, fine = 150, color = 'green' },
			[17] = { title = 'Failure to Stop', class = 'Infraction', id = 'P.C. 9017', months = 0, fine = 600, color = 'green' },
			[18] = { title = 'Unauthorized Parking', class = 'Infraction', id = 'P.C. 9018', months = 0, fine = 300, color = 'green' },
			[19] = { title = 'Hit and Run', class = 'Misdemeanor', id = 'P.C. 9019', months = 10, fine = 500, color = 'green' },
			[20] = { title = 'Driving without Headlights or Signals', class = 'Infraction', id = 'P.C. 9020', months = 0, fine = 300, color = 'green' },
			[21] = { title = 'Street Racing', class = 'Felony', id = 'P.C. 9021', months = 15, fine = 1500, color = 'green' },
			[22] = { title = 'Piloting without Proper Licensing', class = 'Felony', id = 'P.C. 9022', months = 20, fine = 1500, color = 'orange' },
			[23] = { title = 'Unlawful Use of a Motorvehicle', class = 'Misdemeanor', id = 'P.C. 9023', months = 10, fine = 750, color = 'green' },
	},
	[10] = {
			[1] = { title = 'Hunting in Restricted Areas', class = 'Infraction', id = 'P.C. 10001', months = 0, fine = 450, color = 'green' },
			[2] = { title = 'Unlicensed Hunting', class = 'Infraction', id = 'P.C. 10002', months = 0, fine = 450, color = 'green' },
			[3] = { title = 'Animal Cruelty', class = 'Misdemeanor', id = 'P.C. 10003', months = 10, fine = 450, color = 'green' },
			[4] = { title = 'Hunting with a Non-Hunting Weapon', class = 'Misdemeanor', id = 'P.C. 10004', months = 10, fine = 750, color = 'green' },
      [5] = { title = 'Hunting outside of hunting hours', class = 'Infraction', id = 'P.C. 10005', months = 0, fine = 750, color = 'green' },	
			[6] = { title = 'Overhunting', class = 'Misdemeanor', id = 'P.C. 10006', months = 10, fine = 1000, color = 'green' },
			[7] = { title = 'Poaching', class = 'Felony', id = 'P.C. 10007', months = 20, fine = 1250, color = 'red' },
	}
}

local function IsCidFelon(sentCid, cb)
	if sentCid then
		exports.oxmysql:execute('SELECT charges FROM pd_convictions WHERE cid=:cid', { cid = sentCid }, function(convictions)
			local Charges = {}
			for i=1, #convictions do
				local currCharges = json.decode(convictions[i]['charges'])
				for x=1, #currCharges do
					table.insert(Charges, currCharges[x])
				end
			end
			for i=1, #Charges do
				for p=1, #PenalCode do
					for x=1, #PenalCode[p] do
						if PenalCode[p][x]['title'] == Charges[i] then 
							if PenalCode[p][x]['class'] == 'Felony' then
								cb(true)
								return
							end
							break
						end
					end
				end
			end
			cb(false)
		end)
	end
end

exports('IsCidFelon', IsCidFelon) -- exports['erp_mdt']:IsCidFelon()

RegisterCommand("isfelon", function(source, args, rawCommand)
	IsCidFelon(1998, function(res)
		print(res)
	end)
end, false)

RegisterNetEvent('erp_mdt:getPenalCode')
AddEventHandler('erp_mdt:getPenalCode', function()
	TriggerClientEvent('erp_mdt:getPenalCode', source, PenalCodeTitles, PenalCode)
end)

local policeJobs = {
	['lspd'] = true,
	['bcso'] = true,
	['sast'] = true,
	['sasp'] = true,
	['doc'] = true,
	['sapr'] = true,
	['pa'] = true
}

RegisterNetEvent('erp_mdt:toggleDuty')
AddEventHandler('erp_mdt:toggleDuty', function(cid, status)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		local player = exports['echorp']:GetPlayerFromCid(tonumber(cid)) 
		if player then
			if player.job.name == "ambulance" and player.job.duty == 0 then
                local mzDist = #(GetEntityCoords(GetPlayerPed(source)) - vector3(-475.15, -314.0, 62.15))
                if mzDist > 100 then TriggerClientEvent('erp_notifications:client:SendAlert', source, { type = 'error', text = 'You must be at Mount Zonah to clock in!!', length = 5000 }) TriggerClientEvent('erp_mdt:exitMDT',source) return end
            end
			if player.job.isPolice or player.job.name == 'ambulance' or player.job.name == 'doj' then
				local isPolice = false
				if policeJobs[player.job.name] then isPolice = true end;
				exports['echorp']:SetPlayerData(player.source, 'job', {name = player.job.name, grade = player.job.grade, duty = status, isPolice = isPolice})
				exports.oxmysql:executeSync("UPDATE users SET duty=:duty WHERE id=:cid", { duty = status, cid = cid})
				if status == 0 then
					TriggerEvent('erp_mdt:AddLog', result['fullname'].." set "..player['fullname']..'\'s duty to 10-7')
				else
					TriggerEvent('erp_mdt:AddLog', result['fullname'].." set "..player['fullname']..'\'s duty to 10-8')
				end
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:setCallsign')
AddEventHandler('erp_mdt:setCallsign', function(cid, newcallsign)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		local player = exports['echorp']:GetPlayerFromCid(tonumber(cid)) 
		if player then
			if player.job.isPolice or player.job.name == 'ambulance' or player.job.name == 'doj' then
				SetResourceKvp(cid..'-callsign', newcallsign)
				TriggerClientEvent('erp_mdt:updateCallsign', player.source, newcallsign)
				TriggerEvent('erp_mdt:AddLog', result['fullname'].." set "..player['fullname']..'\'s callsign to '..newcallsign)
			end
		end
	end)
end)

local function fuckme(cid, incident, data, cb)
	cb(exports.oxmysql:executeSync('SELECT * FROM pd_convictions WHERE cid=:cid AND linkedincident=:linkedincident', { cid = cid, linkedincident = id }), data)
end

RegisterNetEvent('erp_mdt:saveIncident')
AddEventHandler('erp_mdt:saveIncident', function(id, title, information, tags, officers, civilians, evidence, associated, time)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			if (player.job.isPolice or player.job.name == 'doj') then
				if id == 0 then
					exports.oxmysql:insert('INSERT INTO `pd_incidents` (`author`, `title`, `details`, `tags`, `officersinvolved`, `civsinvolved`, `evidence`, `time`) VALUES (:author, :title, :details, :tags, :officersinvolved, :civsinvolved, :evidence, :time)', 
					{ 
						author = player.fullname,
						title = title,
						details = information,
						tags = json.encode(tags),
						officersinvolved = json.encode(officers),
						civsinvolved = json.encode(civilians),
						evidence = json.encode(evidence),
						time = time
					}, function(infoResult)
						if infoResult then
							for i=1, #associated do
								exports.oxmysql:executeSync('INSERT INTO `pd_convictions` (`cid`, `linkedincident`, `warrant`, `guilty`, `processed`, `associated`, `charges`, `fine`, `sentence`, `recfine`, `recsentence`, `time`) VALUES (:cid, :linkedincident, :warrant, :guilty, :processed, :associated, :charges, :fine, :sentence, :recfine, :recsentence, :time)', {
									cid = tonumber(associated[i]['Cid']),
									linkedincident = infoResult,
									warrant = associated[i]['Warrant'],
									guilty = associated[i]['Guilty'],
									processed = associated[i]['Processed'],
									associated = associated[i]['Isassociated'],
									charges = json.encode(associated[i]['Charges']),
									fine = tonumber(associated[i]['Fine']),
									sentence = tonumber(associated[i]['Sentence']),
									recfine = tonumber(associated[i]['recfine']),
									recsentence = tonumber(associated[i]['recsentence']),
									time = time
								})
							end
							TriggerClientEvent('erp_mdt:updateIncidentDbId', player.source, infoResult)
							--TriggerEvent('erp_mdt:AddLog', "A vehicle with the plate ("..plate..") was added to the vehicle information database by "..player['fullname'])
						end
					end)
				elseif id > 0 then
					exports.oxmysql:executeSync("UPDATE pd_incidents SET title=:title, details=:details, civsinvolved=:civsinvolved, tags=:tags, officersinvolved=:officersinvolved, evidence=:evidence WHERE id=:id", {
						title = title,
						details = information,
						tags = json.encode(tags),
						officersinvolved = json.encode(officers),
						civsinvolved = json.encode(civilians),
						evidence = json.encode(evidence),
						id = id
					})
					for i=1, #associated do
						TriggerEvent('erp_mdt:handleExistingConvictions', associated[i], id, time)
					end
				end
			end
		end
	end)
end)

AddEventHandler('erp_mdt:handleExistingConvictions', function(data, incidentid, time)
	exports.oxmysql:execute('SELECT * FROM pd_convictions WHERE cid=:cid AND linkedincident=:linkedincident', {
		cid = data['Cid'],
		linkedincident = incidentid
	}, function(convictionRes)
		if convictionRes and convictionRes[1] and convictionRes[1]['id'] then
			exports.oxmysql:executeSync('UPDATE pd_convictions SET cid=:cid, linkedincident=:linkedincident, warrant=:warrant, guilty=:guilty, processed=:processed, associated=:associated, charges=:charges, fine=:fine, sentence=:sentence, recfine=:recfine, recsentence=:recsentence WHERE cid=:cid AND linkedincident=:linkedincident', {
				cid = data['Cid'],
				linkedincident = incidentid,
				warrant = data['Warrant'],
				guilty = data['Guilty'],
				processed = data['Processed'],
				associated = data['Isassociated'],
				charges = json.encode(data['Charges']),
				fine = tonumber(data['Fine']),
				sentence = tonumber(data['Sentence']),
				recfine = tonumber(data['recfine']),
				recsentence = tonumber(data['recsentence']),
			})
		else
			exports.oxmysql:executeSync('INSERT INTO `pd_convictions` (`cid`, `linkedincident`, `warrant`, `guilty`, `processed`, `associated`, `charges`, `fine`, `sentence`, `recfine`, `recsentence`, `time`) VALUES (:cid, :linkedincident, :warrant, :guilty, :processed, :associated, :charges, :fine, :sentence, :recfine, :recsentence, :time)', {
				cid = tonumber(data['Cid']),
				linkedincident = incidentid,
				warrant = data['Warrant'],
				guilty = data['Guilty'],
				processed = data['Processed'],
				associated = data['Isassociated'],
				charges = json.encode(data['Charges']),
				fine = tonumber(data['Fine']),
				sentence = tonumber(data['Sentence']),
				recfine = tonumber(data['recfine']),
				recsentence = tonumber(data['recsentence']),
				time = time
			})
		end
	end)
end)

RegisterNetEvent('erp_mdt:removeIncidentCriminal')
AddEventHandler('erp_mdt:removeIncidentCriminal', function(cid, incident)
	exports.oxmysql:executeSync('DELETE FROM pd_convictions WHERE cid=:cid AND linkedincident=:linkedincident', { 
		cid = cid,
		linkedincident = incident
	})
end)

-- Dispatch

RegisterNetEvent('erp_mdt:setWaypoint')
AddEventHandler('erp_mdt:setWaypoint', function(callid)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			if player.job.isPolice or player.job.name == 'ambulance' then
				if callid then
					local calls = exports['erp_dispatch']:GetDispatchCalls()
					TriggerClientEvent('erp_mdt:setWaypoint', player.source, calls[callid])
				end
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:callDetach')
AddEventHandler('erp_mdt:callDetach', function(callid)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			if player.job.isPolice or player.job.name == 'ambulance' then
				if callid then
					TriggerEvent('dispatch:removeUnit', callid, player, function(newNum)
						TriggerClientEvent('erp_mdt:callDetach', -1, callid, newNum)
					end)
				end
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:callAttach')
AddEventHandler('erp_mdt:callAttach', function(callid)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			if player.job.isPolice or player.job.name == 'ambulance' then
				if callid then
					TriggerEvent('dispatch:addUnit', callid, player, function(newNum)
						TriggerClientEvent('erp_mdt:callAttach', -1, callid, newNum)
					end)
				end
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:attachedUnits')
AddEventHandler('erp_mdt:attachedUnits', function(callid)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			if player.job.isPolice or player.job.name == 'ambulance' then
				if callid then
					local calls = exports['erp_dispatch']:GetDispatchCalls()
					TriggerClientEvent('erp_mdt:attachedUnits', player.source, calls[callid]['units'], callid)
				end
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:callDispatchDetach')
AddEventHandler('erp_mdt:callDispatchDetach', function(callid, cid)
	local player = exports['echorp']:GetPlayerFromCid(cid)
	local callid = tonumber(callid)
	if player then
		if player.job.isPolice or player.job.name == 'ambulance' then
			if callid then
				TriggerEvent('dispatch:removeUnit', callid, player, function(newNum)
					TriggerClientEvent('erp_mdt:callDetach', -1, callid, newNum)
				end)
			end
		end
	end
end)

RegisterNetEvent('erp_mdt:setDispatchWaypoint')
AddEventHandler('erp_mdt:setDispatchWaypoint', function(callid, cid)
	local player = exports['echorp']:GetPlayerFromCid(cid)
	local callid = tonumber(callid)
	if player then
		if player.job.isPolice or player.job.name == 'ambulance' then
			if callid then
				local calls = exports['erp_dispatch']:GetDispatchCalls()
				TriggerClientEvent('erp_mdt:setWaypoint', player.source, calls[callid])
			end
		end
	end
end)

RegisterNetEvent('erp_mdt:callDragAttach')
AddEventHandler('erp_mdt:callDragAttach', function(callid, cid)
	local player = exports['echorp']:GetPlayerFromCid(cid)
	local callid = tonumber(callid)
	if player then
		if player.job.isPolice or player.job.name == 'ambulance' then
			if callid then
				TriggerEvent('dispatch:addUnit', callid, player, function(newNum)
					TriggerClientEvent('erp_mdt:callAttach', -1, callid, newNum)
				end)
			end
		end
	end
end)

RegisterNetEvent('erp_mdt:setWaypoint:unit')
AddEventHandler('erp_mdt:setWaypoint:unit', function(cid)
	local source = source
	TriggerEvent('echorp:getplayerfromid', source, function(me)
		local player = exports['echorp']:GetPlayerFromCid(cid)
		if player then
			TriggerClientEvent('erp_notifications:client:SendAlert', player.source, { type = 'inform', text = me['fullname']..' set a waypoint on you!', length = 5000 })
			TriggerClientEvent('erp_mdt:setWaypoint:unit', source, GetEntityCoords(GetPlayerPed(player.source)))
		end
	end)
end)

-- Dispatch chat

local dispatchmessages = {}

--[[
	profilepic
	name
	message
	time
]]

local function PpPpPpic(gender, profilepic)
	if profilepic then return profilepic end;
	if gender == "f" then return "img/female.png" end;
	return "img/male.png"
end

RegisterNetEvent('erp_mdt:sendMessage')
AddEventHandler('erp_mdt:sendMessage', function(message, time)
	if message and time then
		TriggerEvent('echorp:getplayerfromid', source, function(player)
			if player then
				exports.oxmysql:execute("SELECT id, profilepic, gender FROM `users` WHERE id=:id LIMIT 1", {
					id = player['cid'] -- % wildcard, needed to search for all alike results
				}, function(data)
					if data and data[1] then
						local ProfilePicture = PpPpPpic(data[1]['gender'], data[1]['profilepic'])
						local callsign = GetResourceKvpString(player['cid']..'-callsign') or "000"
						local Item = {
							profilepic = ProfilePicture,
							callsign = callsign,
							cid = player['cid'],
							name = '('..callsign..') '..player['fullname'],
							message = message,
							time = time,
							job = player['job']['name']
						}
						table.insert(dispatchmessages, Item)
						TriggerClientEvent('erp_mdt:dashboardMessage', -1, Item)
						-- Send to all clients, for auto updating stuff, ya dig.
					end
				end)
			end
		end)
	end
end)

AddEventHandler('erp_mdt:open', function(source)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or (result.job.name == 'ambulance' or result.job.name == 'doj')) then
				TriggerClientEvent('erp_mdt:dashboardMessages', result['source'], dispatchmessages)
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:refreshDispatchMsgs')
AddEventHandler('erp_mdt:refreshDispatchMsgs', function()
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or (result.job.name == 'ambulance' or result.job.name == 'doj')) then
				TriggerClientEvent('erp_mdt:dashboardMessages', result['source'], dispatchmessages)
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:getCallResponses')
AddEventHandler('erp_mdt:getCallResponses', function(callid)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or (result.job.name == 'ambulance')) then
				local calls = exports['erp_dispatch']:GetDispatchCalls()
				TriggerClientEvent('erp_mdt:getCallResponses', result.source, calls[callid]['responses'], callid)
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:sendCallResponse')
AddEventHandler('erp_mdt:sendCallResponse', function(message, time, callid)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job and (result.job.isPolice or (result.job.name == 'ambulance')) then
				TriggerEvent('dispatch:sendCallResponse', result, callid, message, time, function(isGood)
					if isGood then
						TriggerClientEvent('erp_mdt:sendCallResponse', -1, message, time, callid, result['fullname'])
					end
				end)
			end
		end
	end)
end)

CreateThread(function()
	Wait(1800000)
	dispatchmessages = {}
end)

RegisterNetEvent('erp_mdt:setRadio')
AddEventHandler('erp_mdt:setRadio', function(cid, newcallsign)
	TriggerEvent('echorp:getplayerfromid', source, function(result)
		if result then
			if result.job.isPolice or result.job.name == 'ambulance' or result.job.name == 'doj' then
				local tgtPlayer = exports['echorp']:GetPlayerFromCid(tonumber(cid)) 
				if tgtPlayer then
					TriggerClientEvent('erp_mdt:setRadio', tgtPlayer['source'], newcallsign, result['fullname'])
					TriggerClientEvent('erp_notifications:client:SendAlert', result['source'], { type = 'success', text = 'Radio updated.', length = 5000 })
				end
			end
		end
	end)
end)

local Impound = {}

function isRequestVehicle(vehId) 
	local found = false
	for i=1, #Impound do 
		if Impound[i]['vehicle'] == vehId then
			found = true
			Impound[i] = nil
			break
		end
	end
	return found
end
exports('isRequestVehicle', isRequestVehicle) -- exports['erp_mdt']:isRequestVehicle()

RegisterNetEvent('erp_mdt:impoundVehicle')
AddEventHandler('erp_mdt:impoundVehicle', function(sentInfo, sentVehicle)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			if player.job.isPolice then	
				if sentInfo and type(sentInfo) == 'table' then
					local plate, linkedreport, fee, time = sentInfo['plate'], sentInfo['linkedreport'], sentInfo['fee'], sentInfo['time']
					if (plate and linkedreport and fee and time) then
						exports.oxmysql:execute("SELECT id, plate FROM `owned_vehicles` WHERE plate=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1")}, function(vehicle)
							if vehicle and vehicle[1] then
								local data = vehicle[1]
								exports.oxmysql:insert('INSERT INTO `impound` (`vehicleid`, `linkedreport`, `fee`, `time`) VALUES (:vehicleid, :linkedreport, :fee, :time)', {
									vehicleid = data['id'],
									linkedreport = linkedreport,
									fee = fee,
									time = os.time() + (time * 60)
								}, function(res)
									-- notify?
									local data = {
										vehicleid = data['id'],
										plate = plate,
										beingcollected = 0,
										vehicle = sentVehicle,
										officer = player['fullname'],
										number = player['phone_number'],
										time = os.time() * 1000,
										src = player['source']
									}
									local vehicle = NetworkGetEntityFromNetworkId(sentVehicle)
									FreezeEntityPosition(vehicle, true)
									table.insert(Impound, data)
									TriggerClientEvent('erp_mdt:notifyMechanics', -1, data)
								end)
							end
						end)
					end
				end
			end
		end
	end)
end)

-- erp_mdt:getImpoundVehicles

RegisterNetEvent('erp_mdt:getImpoundVehicles')
AddEventHandler('erp_mdt:getImpoundVehicles', function()
	TriggerClientEvent('erp_mdt:getImpoundVehicles', source, Impound)
end)

RegisterNetEvent('erp_mdt:collectVehicle')
AddEventHandler('erp_mdt:collectVehicle', function(sentId)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			local source = source
			for i=1, #Impound do
				local id = Impound[i]['vehicleid']
				if tostring(id) == tostring(sentId) then
					local vehicle = NetworkGetEntityFromNetworkId(Impound[i]['vehicle'])
					if not DoesEntityExist(vehicle) then
						TriggerClientEvent('erp_phone:sendNotification', source, {img = 'vehiclenotif.png', title = "Impound", content = "This vehicle has already been impounded.", time = 5000 })
						Impound[i] = nil
						return
					end
					local collector = Impound[i]['beingcollected']
					if collector ~= 0 and GetPlayerPing(collector) >= 0 then
						TriggerClientEvent('erp_phone:sendNotification', source, {img = 'vehiclenotif.png', title = "Impound", content = "This vehicle is being collected.", time = 5000 })
						return
					end
					Impound[i]['beingcollected'] = source
					TriggerClientEvent('erp_mdt:collectVehicle', source, GetEntityCoords(vehicle))
					TriggerClientEvent('erp_phone:sendNotification', Impound[i]['src'], {img = 'vehiclenotif.png', title = "Impound", content = player['fullname'].." is collecing the vehicle with plate "..Impound[i]['plate'].."!", time = 5000 })
					break
				end
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:removeImpound')
AddEventHandler('erp_mdt:removeImpound', function(plate)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			if player.job.isPolice then	
				exports.oxmysql:execute("SELECT id, plate FROM `owned_vehicles` WHERE plate=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1")}, function(vehicle)
					if vehicle and vehicle[1] then
						local data = vehicle[1]
						exports.oxmysql:executeSync("DELETE FROM `impound` WHERE vehicleid=:vehicleid", { vehicleid = data['id'] })
					end
				end)
			end
		end
	end)
end)

RegisterNetEvent('erp_mdt:statusImpound')
AddEventHandler('erp_mdt:statusImpound', function(plate)
	TriggerEvent('echorp:getplayerfromid', source, function(player)
		if player then
			if player.job.isPolice then	
				exports.oxmysql:execute("SELECT id, plate FROM `owned_vehicles` WHERE plate=:plate LIMIT 1", { plate = string.gsub(plate, "^%s*(.-)%s*$", "%1")}, function(vehicle)
					if vehicle and vehicle[1] then
						local data = vehicle[1]
						exports.oxmysql:execute("SELECT * FROM `impound` WHERE vehicleid=:vehicleid LIMIT 1", { vehicleid = data['id'] }, function(impoundinfo)
							if impoundinfo and impoundinfo[1] then 
								TriggerClientEvent('erp_mdt:statusImpound', player['source'], impoundinfo[1], plate)
							end
						end)
					end
				end)
			end
		end
	end)
end)

				