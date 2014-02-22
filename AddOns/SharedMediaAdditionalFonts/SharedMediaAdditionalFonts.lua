--[[

----
---- PLEASE READ BEFORE DOING ANYTHING ----
----

Only fonts should be added to this addon. If you wish to add textures, sounds, ... create your own addon or use an existing one if there is one.
All fonts must be able to display special characters such as é, è, à, ü, É, Ç, ... Remember that not all the users use the English client!

Don't add a font that you did not test. All fonts must be tested in game before upload.

Thanks for your cooperation! ;-)
pb_ee1

]]

-- registrations for media from the client itself belongs in LibSharedMedia-3.0

if not SharedMediaAdditionalFonts then return end
local revision = tonumber(string.sub("$Revision: 63551 $", 12, -3))
SharedMediaAdditionalFonts.revision = (revision > SharedMediaAdditionalFonts.revision) and revision or SharedMediaAdditionalFonts.revision

-- -----
-- FONT
-- -----
SharedMediaAdditionalFonts:Register("font", "Accidental Presidency", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\Accidental Presidency.ttf]])
SharedMediaAdditionalFonts:Register("font", "Alba Super", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\ALBAS___.ttf]])
SharedMediaAdditionalFonts:Register("font", "Arm Wrestler", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\ArmWrestler.ttf]])
SharedMediaAdditionalFonts:Register("font", "Baar Sophia", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\BAARS___.TTF]])
SharedMediaAdditionalFonts:Register("font", "Blazed", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\Blazed.ttf]])
SharedMediaAdditionalFonts:Register("font", "Boris Black Bloxx", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\BorisBlackBloxx.ttf]])
SharedMediaAdditionalFonts:Register("font", "Boris Black Bloxx Dirty", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\BorisBlackBloxxDirty.ttf]])
SharedMediaAdditionalFonts:Register("font", "Collegiate", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\COLLEGIA.ttf]])
SharedMediaAdditionalFonts:Register("font", "Diogenes", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\DIOGENES.ttf]])
SharedMediaAdditionalFonts:Register("font", "Disko", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\Disko.ttf]])
SharedMediaAdditionalFonts:Register("font", "Frakturika Spamless", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\FRAKS___.ttf]])
SharedMediaAdditionalFonts:Register("font", "Impact", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\impact.ttf]])
SharedMediaAdditionalFonts:Register("font", "Liberation Sans", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\LiberationSans-Regular.ttf]])
SharedMediaAdditionalFonts:Register("font", "Liberation Serif", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\LiberationSerif-Regular.ttf]])
SharedMediaAdditionalFonts:Register("font", "Mystic Orbs", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\MystikOrbs.ttf]])
SharedMediaAdditionalFonts:Register("font", "Pokemon Solid", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\Pokemon Solid.ttf]])
SharedMediaAdditionalFonts:Register("font", "Rock Show Whiplash", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\Rock Show Whiplash.ttf]])
SharedMediaAdditionalFonts:Register("font", "SF Diego Sans", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\SF Diego Sans.ttf]])
SharedMediaAdditionalFonts:Register("font", "Solange", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\Solange.ttf]])
SharedMediaAdditionalFonts:Register("font", "Star Cine", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\starcine.ttf]])
SharedMediaAdditionalFonts:Register("font", "Trashco", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\trashco.ttf]])
SharedMediaAdditionalFonts:Register("font", "Ubuntu Condensed", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\Ubuntu-C.ttf]])
SharedMediaAdditionalFonts:Register("font", "Ubuntu Light", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\Ubuntu-L.ttf]])
SharedMediaAdditionalFonts:Register("font", "Waltograph UI", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\waltographUI.ttf]])
SharedMediaAdditionalFonts:Register("font", "X360", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\X360.ttf]])
SharedMediaAdditionalFonts:Register("font", "Yanone Kaffeesatz Regular", [[Interface\Addons\SharedMediaAdditionalFonts\fonts\YanoneKaffeesatz-Regular.ttf]])
