
--[[
	Instructions:

	A project has a name, a path where its mods are located and an enabled status.
	There's 2 types of replacement mods: model & texture replacements.
		
		- Model replacements MUST be declared AFTER ALL TEXTURE replacements.
		- A model replacement consists of a DFF replacement + a COL replacement if necessery.
		- You can enable/disable the alpha transparency setting used by engineReplaceModel
		
		- Texture replacements MUST be declared BEFORE ALL MODEL replacements.
		- A texture replacement consists of a TXD replacement.

		- Model/texture replacements require one or more model IDs.
]]
replaceMods = {

	{
		project="East LS Basketball Court", path="files/eastLSbasket/", enabled=true, mods={
	
			{
				txd="landlae2e.txd",
				modelIDs={
					17513, --lae2_ground04.dff
					17866, --grass_bank.dff
				},
			},
			{
				txd="bskball_standext.txd",
				modelIDs={
					946, --bskball_lax.dff
					947, --bskballhub_lax01.dff
				},
			},
			{
				dff="lae2_ground04.dff",
				alphaTransparency = true,
				col="lae2_ground04.col",
				modelIDs={
					17513,
				},
			},
		},
	},
}