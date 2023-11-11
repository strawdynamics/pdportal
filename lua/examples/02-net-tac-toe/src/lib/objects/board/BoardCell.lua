class('BoardCell').extends()
local BoardCell <const> = BoardCell

local geometry <const> = playdate.geometry

local getIndexPoint <const> = getIndexPoint

-- TODO: prebuild images: x, o, hoverX, hoverO

-- 0 empty, 1 x, 2 o, 3 hoverX, 4 hoverO
function BoardCell:init(index)
	self.index = index
	self.state = 0
end

function BoardCell:setState(newState)
	self.state = newState
end

function BoardCell:_getImage()

end

function BoardCell:update()
	-- draw char
end
