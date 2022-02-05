--[[
	Resource: envmods-loader
	
	File: client.lua
	
	Author: https://github.com/Fernando-A-Rocha
	
	Description:	
		Declare list of environment mods (dff/txd/col models)
		that can either replace objects to be directly applied in the world
		or added as new objects and placed manually

	Commands:
		- /rmods
]]

--[[
	Clientside error logs file name
]]
local errFileName = "errors.log"

local waitClose, errFile
local downloadMods = {}
local downloaded = 0
local loadTime

function outputError(msg)
	if errFile then
		
		if isTimer(waitClose) then killTimer(waitClose) end
		waitClose = setTimer(function()
			if errFile then
				fileClose(errFile)
				errFile = nil
				-- outputDebugString("CLOSED "..errFileName)
			end
			waitClose = nil
		end, 5000, 1)

		local content = fileRead(errFile, fileGetSize(errFile))
		fileWrite(errFile, content.."\n"..msg)
		-- outputDebugString(msg)
	end
end

function startupChecks()

	-- Object replacement mods
	for k,v in pairs(replaceMods) do

		local project, path, mods, enabled = v.project, v.path, v.mods, v.enabled
		if project and path and (enabled~=nil) and type(enabled)=="boolean" and (mods~=nil) and type(mods)=="table" then

			for j,w in pairs(mods) do
				if type(w.modelIDs) ~= "table" then
					outputDebugString("modelIDs missing/invalid for mod #"..j.." in project #"..k, 1)
					return false
				end
			end
		else
			outputDebugString("Missing/invalid attributes for project project #"..k, 1)
			return false
		end
	end

	-- print("ALL CHECKS PASSED")
	return true
end

function downloadAllMods()
	-- Object replacement mods
	for k,v in pairs(replaceMods) do

		local project, path, mods, enabled = v.project, v.path, v.mods, v.enabled
		if enabled==true then
			for j,w in pairs(mods) do

				local txd = w.txd
				local dff = w.dff
				local col = w.col

				if txd then
					txd = path..txd
					downloadMods[txd] = "waiting"
				end
				if dff then
					dff = path..dff
					downloadMods[dff] = "waiting"
				end
				if col then
					col = path..col
					downloadMods[col] = "waiting"
				end
			end
		end
	end

	for fileName,_ in pairs(downloadMods) do
		downloadFile(fileName)
	end
end

addEventHandler( "onClientFileDownloadComplete", resourceRoot, 
function (fileName, success)
	local v = downloadMods[fileName]
	if v == "waiting" then
		if success then
			downloadMods[fileName] = "success"
		else
			downloadMods[fileName] = "fail"
		end
		downloaded = downloaded + 1
	end

	if downloaded == table.size(downloadMods) then
		-- print("All downloaded, continuing")
		loadAllMods()
	end
end)

function loadAllMods()

	-- Object replacement mods
	for k,v in pairs(replaceMods) do

		local project, path, mods, enabled = v.project, v.path, v.mods, v.enabled
		if enabled==true then

			local rcount = 0
			for j,w in pairs(mods) do

				local modelIDs = w.modelIDs
				local txd = w.txd
				local dff = w.dff
				local alphaTransparency = w.alphaTransparency or false
				local col = w.col

				if txd then
					txd = path..txd
					if downloadMods[txd] == "success" then
						local txdElement = engineLoadTXD(txd)
						if txdElement then
							for _,model_id in pairs(modelIDs) do
								local txdWorked = engineImportTXD(txdElement, model_id)
								if txdWorked then
									rcount = rcount + 1
								end
							end
						end
					else
						outputDebugString("Failed to download file: "..txd, 1)
					end
				end
				if dff then
					dff = path..dff
					if downloadMods[dff] == "success" then
						local dffElement = engineLoadDFF(dff)
						if dffElement then
							for _,model_id in pairs(modelIDs) do
								local dffWorked = engineReplaceModel(dffElement, model_id, alphaTransparency)
								if dffWorked then
									rcount = rcount + 1
								end
							end
						end
					else
						outputDebugString("Failed to download file: "..dff, 1)
					end
				end
				if col then
					col = path..col
					if downloadMods[col] == "success" then
						local colElement = engineLoadCOL(col)
						if colElement then
							for _,model_id in pairs(modelIDs) do
								local colWorked = engineReplaceCOL(colElement, model_id)
								if colWorked then
									rcount = rcount + 1
								end
							end
						end
					else
						outputDebugString("Failed to download file: "..col, 1)
					end
				end
			end

			print(project, "Loaded "..rcount.." mod files")
		end
	end
	setTimer(function()
		for fileName,v in pairs(downloadMods) do
			if v == "success" then
				if fileDelete(fileName) then -- remove from cache ;)
					-- print("Deleted: "..fileName)
				end
			end
		end


		local timeTook = getTickCount() - loadTime
		outputChatBox("Env-mods loading finished in "..timeTook.."ms", 0,255,0)

		-- Clear memory
		loadTime = nil
		downloadMods = nil
		downloaded = nil
	end, 500, 1)
	return true
end

addEventHandler( "onClientResourceStart", resourceRoot, 
function()

	loadTime = getTickCount()

	if not startupChecks() then return end

	if fileExists(errFileName) then
		errFile = fileOpen(errFileName)
		-- outputDebugString("OPENED "..errFileName)
	else
		errFile = fileCreate(errFileName)
		-- outputDebugString("CREATED "..errFileName)
	end

	waitClose = setTimer(function()
		if errFile then
			fileClose(errFile)
			errFile = nil
			-- outputDebugString("CLOSED "..errFileName)
		end
		waitClose = nil
	end, 5000, 1)

	downloadAllMods()
end)

function listReplacementMods()
	for k,v in pairs(replaceMods) do

		local project, path, mods, enabled = v.project, v.path, v.mods, v.enabled
		if project and path and mods and type(mods)=="table" then
			outputChatBox(project.." "..(enabled==true and "#00ff00(Enabled)" or "#ffff00(Disabled)").." #ffffff"..table.size(mods).." mod files", 255,194,14, true)
		end
	end
end
addCommandHandler("rmods", listReplacementMods, false)


function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end