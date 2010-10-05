if not Load"align" then
	return
end

local GridFrame = CreateFrame("Frame", nil, UIParent)
GridFrame.boxSize = 32
GridFrame.isAligning = false
GridFrame.size = 1

SlashCmdList.TOGGLEGRID = function(size)
    if GridFrame.isAligning then
        GridFrame.grid:Hide()
        GridFrame.isAligning = false
    else
		local recreate = false
	    if tonumber(size) then
			if (math.ceil(tonumber(size)) / 32) * 32 ~= GridFrame.boxSize then
				GridFrame.boxSize = (math.ceil(tonumber(size)) / 32) * 32
				recreate = true
			end
		end
		if GridFrame.boxSize > 256 then
			GridFrame.boxSize = 256
		end
		if recreate or not GridFrame.grid then
			CreateAlignGrid()
		end
		GridFrame.grid:Show()
        GridFrame.isAligning = true
    end
end
SLASH_TOGGLEGRID1 = "/align"

function CreateAlignGrid()
	GridFrame.grid = CreateFrame("Frame", nil, UIParent)
	GridFrame.grid:SetAllPoints(UIParent) 
	local width = GetScreenWidth()
	local ratio = width / GetScreenHeight()
	local height = GetScreenHeight() * ratio
	local wStep = width / GridFrame.boxSize
	local hStep = height / GridFrame.boxSize
	for i = 0, GridFrame.boxSize do 
		local tx = GridFrame.grid:CreateTexture(nil, "BACKGROUND") 
		if i == GridFrame.boxSize / 2 then 
			tx:SetTexture(1, 0, 0, .5) 
		else 
			tx:SetTexture(0, 0, 0, .5) 
		end 
		tx:SetPoint("TOPLEFT", GridFrame.grid, "TOPLEFT", i * wStep - (GridFrame.size / 2), 0) 
		tx:SetPoint("BOTTOMRIGHT", GridFrame.grid, "BOTTOMLEFT", i * wStep + (GridFrame.size / 2), 0) 
	end 
	height = GetScreenHeight()
	do
		local tx = GridFrame.grid:CreateTexture(nil, "BACKGROUND") 
		tx:SetTexture(1, 0, 0, .5)
		tx:SetPoint("TOPLEFT", GridFrame.grid, "TOPLEFT", 0, -(height / 2) + (GridFrame.size / 2))
		tx:SetPoint("BOTTOMRIGHT", GridFrame.grid, "TOPRIGHT", 0, -(height / 2 + GridFrame.size / 2))
	end
	for i = 1, math.floor((height / 2) / hStep) do
		local tx = GridFrame.grid:CreateTexture(nil, "BACKGROUND") 
		tx:SetTexture(0, 0, 0, .5)
		tx:SetPoint("TOPLEFT", GridFrame.grid, "TOPLEFT", 0, -(height / 2 + i * hStep) + (GridFrame.size / 2))
		tx:SetPoint("BOTTOMRIGHT", GridFrame.grid, "TOPRIGHT", 0, -(height / 2 + i * hStep + GridFrame.size / 2))
		tx = GridFrame.grid:CreateTexture(nil, "BACKGROUND") 
		tx:SetTexture(0, 0, 0, .5)
		tx:SetPoint("TOPLEFT", GridFrame.grid, "TOPLEFT", 0, -(height / 2 - i * hStep) + (GridFrame.size / 2))
		tx:SetPoint("BOTTOMRIGHT", GridFrame.grid, "TOPRIGHT", 0, -(height / 2 - i * hStep + GridFrame.size / 2))
	end
	
end