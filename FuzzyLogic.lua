local family_list = {}
local family_selected = {
    {
      family_id = 9,
      income = 9999,
      charge = 0
    }
}

local answer_path = "/home/reydvires/Development/Lua Project/FuzzyLogic/TebakanTugas2.csv"
local quest_path = "DataTugas2.csv"

-- @param table Print traverse of table
local function print_CSVtable(table)
  for _, v in ipairs(table) do -- show parsing from CSV file
    print(v.family_id,v.income,v.charge)
  end
end

-- @param path Use your path for .csv file
local function parse_CSV(path)
  -- by Ahmad Arsyel (1301164193)
  for line in io.lines(path) do
    local col1, col2, col3 = line:match("%i*(.-),%d*(.-),%d*(.*)") -- converting
    family_list[#family_list + 1] = {
      family_id = col1,
      income = col2,
      charge = col3
    }
  end
  table.remove(family_list, 1) -- remove the title/header
  print("Parsing result:")
  print_CSVtable(family_list)
end

-- @param path Use your own path for .csv raw file targeted
-- @param data_table Saving file to .csv from table
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
  print("Answer result:")
  print_CSVtable(family_selected)
end

-- main program
parse_CSV(quest_path)
table_to_CSV(answer_path, family_selected)