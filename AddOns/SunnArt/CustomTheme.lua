SunnCustomTheme = {}
SunnCustomOverlap = {}
SunnCustomPanels = {}
--[[
Add your custom themes here.

the format is:
	SunnCustomTheme["<folder>\\<filename prefix>"] = "<theme name>"

eg.  If your artwork files are called custom1.tga,  custom2.tga and custom3.tga then you should 
place these files in SunnArt folder and add the following lines at the bottom of this file:

	SunnCustomTheme["SunnArt\\custom"] = "Custom"
	SunnCustomOverlap["SunnArt\\custom"] = 0
	SunnCustomPanels["SunnArt\\custom"] = 3

or if your artwork is called MyArtWork1.tga, MyArtWork2.tga and MyArtWork3.tga
then add the lines:

	SunnCustomTheme["SunnArt\\MyArtWork"] = "My Artwork"
	SunnCustomOverlap["SunnArt\\MyArtWork"] = 0
	SunnCustomPanels["SunnArt\\MyArtWork"] = 3

You can add as many of these custom themes as you like in this file.


OVERLAP
Sometimes,  the top of your artwork may need to overlap the viewport (when the viewport option is enabled) if your artwork contains transparent pixels.

The overlap value is a percentage of the total height of the artwork.

eg.  If your artwork is 256 pixels high and the top 75 pixels of this artwork contain transparent pixels, 
set the SunnCustomOverlap value of your theme to 75 divided by 256 times 100 (75/256*100) = 29.297


PANELS
if your artwork consists of more (or less) than 3 sections then set SunnCustomPanels to match the number that you have.

--]]

SunnCustomTheme["SunnArt\\custom"] = "Custom"
SunnCustomOverlap["SunnArt\\custom"] = 0
SunnCustomPanels["SunnArt\\custom"] = 3