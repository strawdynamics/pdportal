class('BoardState').extends()
local BoardState <const> = BoardState

function BoardState:init()
	self.grid = {}
	for i = 1, 9 do
		table.insert(self.grid, BoardCell(i))
	end
end

function BoardState:destroy()
	for i, boardCell in ipairs(self.grid) do
		boardCell:destroy()
	end
end

function BoardState:update()
	for i, boardCell in ipairs(self.grid) do
		boardCell:update()
	end
end

function BoardState:trySetCell(cellIndex, state)
	local currentCellState = self.grid[cellIndex].state

	if (
		currentCellState == 1 or
		currentCellState == 4 or
		currentCellState == 5
	) then
		self.grid[cellIndex]:setState(state)
		return true
	else
		return false
	end
end

function BoardState:unsetCellHover(cellIndex)
	local currentCellState = self.grid[cellIndex].state

	-- Hover state, unset
	if currentCellState == 4 or currentCellState == 5 then
		self.grid[cellIndex]:setState(1)
		return true
	end

	return false
end

function BoardState:getFirstEmptyCellIndex()
	for i, cell in ipairs(self.grid) do
		if cell.state == 1 then
			return i
		end
	end

	error('No empty cells!')
end

function BoardState:_getCellIndex(row, col)
	return ((row - 1) * 3) + col
end

-- Returns 1 for no winner, 2 for x win, 3 for o win
function BoardState:checkWinStatus()
	if self:_checkWinForState(2) then
		return 2
	elseif self:_checkWinForState(3) then
		return 3
	end

	return 1
end

function BoardState:_checkWinForState(s)
	local g = self.grid

	-- Check rows, columns
	for i = 1, 3 do
		if
			(
				g[self:_getCellIndex(i, 1)].state == s and
				g[self:_getCellIndex(i, 2)].state == s and
				g[self:_getCellIndex(i, 3)].state == s
			) or
			(
				g[i].state == s
				and g[i + 3].state == s
				and g[i + 6].state == s
			)
		then
			return true
		end
	end

	-- Check diagonals
	if
		(
			g[1].state == s and
			g[5].state == s and
			g[9].state == s
		) or
		(
			g[3].state == s and
			g[5].state == s and
			g[7].state == s
		)
	then
		return true
	end

	return false
end
