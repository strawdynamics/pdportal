class('BoardState').extends()
local BoardState <const> = BoardState

function BoardState:init()
	self.grid = {}
	for i = 1, 9 do
		table.insert(self.grid, BoardCell(i))
	end
end

function BoardState:trySetCell(row, col, state)
	local cellIndex = self_:_getCellIndex(row, col)
	local currentCellState = self.grid[cellIndex].state

	if currentCellState == 0 then
		self.grid[cellIndex]:setState(state)
		return true
	else
		return false
	end
end

function BoardState:unsetCellHover(row, col)
	local cellIndex = self_:_getCellIndex(row, col)
	local currentCellState = self.grid[cellIndex].state

	-- Hover state, unset
	if currentCellState == 3 or currentCellState == 4 then
		self.grid[cellIndex]:setState(0)
		return true
	end

	return false
end

function BoardState:_getCellIndex(row, col)
	return ((row - 1) * 3) + col
end

-- Returns 0 for no winner, 1 for x win, 2 for o win
function BoardState:checkWin()
	if self:_checkWinForState(1) then
		return 1
	elseif self:_checkWinForState(2) then
		return 2
	end

	return 0
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
