local family_list = {}

local function parse_CSV()
  for line in io.lines("DataTugas2.csv") do
    local col1, col2, col3 = line:match("%i*(.-),%d*(.-),%d*(.*)") -- converting
    family_list[#family_list + 1] = {
      family_id = col1,
      income = col2,
      charge = col3
    }
  end
  table.remove(family_list, 1) -- remove the title/header
  print("Parsing result:")
  for i,v in ipairs(family_list) do -- show parsing from CSV file
    print(v.family_id,v.income,v.charge)
  end
end

-- @param path Use your own path for .csv raw file targeted
local function table_to_CSV(path, data_table, sep)
  --relative path:/home/reydvires/Development/Lua Project/FuzzyLogic/TebakanTugas2.csv
  sep = sep or ','
  local file = assert(io.open(path, "w")) -- w mean write
  file:write("Answer of Family number\n")
  for _, v in pairs(data_table) do
    file:write(v["family_id"] .. "," .. v["income"] .. "," .. v["charge"])
    file:write('\n')
  end
  file:close()
end

-- main program
parse_CSV()
table_to_CSV("/home/reydvires/Development/Lua Project/FuzzyLogic/TebakanTugas2.csv", family_list)
