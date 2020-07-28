--[[---------------------------------------------------------
		Super Cooking Panic for Garry's Mod
				by Xperidia (2020)
-----------------------------------------------------------]]

local	scale_ratio_cache = {}
local	scale_cache = {}
		scale_cache.width = {}
		scale_cache.height = {}

--[[---------------------------------------------------------
	Name: GM:ScreenScaleMin(size)
	Desc:	Return a value scaled with screen height from 1080p.
-----------------------------------------------------------]]
function GM:ScreenScaleMin(size)

	--Calculate ratio from original 1080p dev size
	local ratio = scale_ratio_cache[size] or size / 1080

	--Cache the ratio
	if not scale_ratio_cache[size] then
		scale_ratio_cache[size] = ratio
	end

	return ScrH() * ratio

end

--[[---------------------------------------------------------
	Name: GM:ScreenScale(width, height)
	Desc:	Return values scaled with screen height from 1080p.
-----------------------------------------------------------]]
function GM:ScreenScale(width, height)

	if not scale_ratio_cache.last_height then

		--Save current screen height
		scale_ratio_cache.last_height = ScrH()

	elseif scale_ratio_cache.last_height ~= ScrH() then

		--Empty the cache if the resolution has changed
		table.Empty(scale_cache.width)
		table.Empty(scale_cache.height)

		scale_ratio_cache.last_height = ScrH()

	end

	--Use the cache instead of redoing the operation every frame
	if scale_cache.width[width] and scale_cache.height[height] then

		return scale_cache.width[width], scale_cache.height[height]

	end

	--Cache the current values to save on CPU
	scale_cache.width[width]	=	self:ScreenScaleMin(width)
	scale_cache.height[height]	=	self:ScreenScaleMin(height)

	return scale_cache.width[width], scale_cache.height[height]

end
