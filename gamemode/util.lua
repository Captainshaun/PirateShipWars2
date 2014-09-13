function AccessorFuncDT(tbl, varname, name)
	tbl["Get" .. name] = function(s) return s.dt and s.dt[varname] end
	tbl["Set" .. name] = function(s, v) if s.dt then s.dt[varname] = v end end
end