local LZ77 = {}

LZ77.__index = LZ77

LZ77.compress = function(self, data)
	local output = {}
	local position = 0

	while(position < #data) do 
		local offset, len = self:find_longest_match(data, position)
		print("len" ,len, "offset", offset)
		table.insert(output, offset)

		if offset == 0 then
			table.insert(output, data:sub(position))
			position = position + 1
		else
			table.insert(output, data:sub(position))
			position = position + len
		end
	end

	return output
end

LZ77.find_longest_match = function(self, data, position)
	local best_offset = 0
	local best_len = 0
	local start = 0

	if position > 255 then
		start = position - 255
	end

	for offset = start, position do
		local len = self:matcher(data, offset, position)
		if len > best_len then
			best_offset = position - offset
			best_len = len
		end
	end

	return best_offset, best_len
end

LZ77.matcher = function(self, data, offset, position)
	local offset = offset
	local position = position
	local len = 0

	while offset < position 
		and position < #data 
		and data:sub(offset) == data:sub(position) 
		and len < 255 do

			offset = offset + 1
			position = position + 1
			len = len + 1
	end

	return len
end

local compressed = LZ77:compress("test test")
print("compressed", compressed)

-- for _, i in pairs(compressed) do
-- 	print(i)
-- end



