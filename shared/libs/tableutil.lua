local tableutil = {}

function tableutil.Keys(tbl)
	local Keys = {}
	for Key in pairs(tbl) do
		table.insert(Keys, Key)
	end
	return Keys
end

function tableutil.RandomValue(tbl)
	return tbl[math.random(1, #tbl)]
end

function tableutil.RandomKey(tbl)
	return tableutil.RandomValue(tableutil.Keys(tbl))
end

return tableutil
