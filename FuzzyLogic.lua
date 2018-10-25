local family_list = {}
local family_process = {
  income = {},
  charge = {}
}
local family_result = {}
local family_selected = {}

local QUEST_PATH = "DataTugas2.csv"
local ANSWER_PATH = "D:/TelkomUniversity/AI/Tugas_FuzzyLogic/fuzzy-logic/TebakanTugas2.csv"

-- @param table Print traverse of table
local function print_famtable(table)
  for _, v in ipairs(table) do -- show parsing from CSV file
    print(v.family_id,v.income,v.charge)
  end
end

-- @param path Use your path for .csv file
local function parse_CSV(path)
  -- by Ahmad Arsyel (1301164193)
  for line in io.lines(path) do
    local col1, col2, col3 = line:match("%i*(.-),%s*(.-),%s*(.*)") -- converting
    family_list[#family_list + 1] = {
      family_id = col1,
      income = tonumber(col2),
      charge = tonumber(col3)
    }
  end
  table.remove(family_list, 1) -- remove the title/header
  print("Parsing result:")
  print_famtable(family_list)
end

-- @param path Use your own path for .csv raw file targeted
-- @param data_table Saving file to .csv from table
local function table_to_CSV(path, data_table, sep)
  --relative path:/home/reydvires/Development/Lua Project/FuzzyLogic/TebakanTugas2.csv
  sep = sep or ','
  local file = assert(io.open(path, "w")) -- w mean write
  file:write("The 20 Selected Family:\n")
  for _, v in pairs(data_table) do
    file:write(v["family_id"] .. "," .. v["income"] .. "," .. v["charge"])
    file:write('\n')
  end
  file:close()
  print("Answer result:")
  print_famtable(family_selected)
end

-- @param a, b Returning the minimum value
local function minim(a, b)
  if a > b then
    return b
  else
    return a
  end
end

local function member_on_up(x, on_low, to_top)
  return (x-on_low)/(to_top-on_low)
end

local function member_on_down(x, on_top, to_low)
  return -(x-to_low/to_low-on_top)
end

-- @param x Calculate number from crisp value
local function linguistic_var_income(x)
  local curr_linguistic -- table that contain 4 key, saved in family_process.income
  if x <= 0.35 then
    curr_linguistic = {
        f_state = "poor", f_score = 1,
        s_state = nil, s_score = nil
      } 
  elseif x > 0.35 and x < 0.75 then
    curr_linguistic = {
        f_state = "poor", f_score = member_on_down(x, 0.35, 0.75),
        s_state = "medium", s_score = member_on_up(x, 0.35, 0.75)
      }
  elseif x >= 0.75 and x <= 1.35 then
    curr_linguistic = {
        f_state = "medium", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif x > 1.35 and x < 1.75 then
    curr_linguistic = {
        f_state = "medium", f_score = member_on_down(x, 1.35, 1.75),
        s_state = "rich", s_score = member_on_up(x, 1.35, 1.75)
      }
  else -- if x >= 1.75 and x <= 2 then
    curr_linguistic = {
        f_state = "rich", f_score = 1,
        s_state = nil, s_score = nil
      }
  end
  table.insert(family_process.income, curr_linguistic)
end

local function linguistic_var_charge(y)
  local curr_linguistic -- table that contain 4 key, saved in family_process.charge
  if y <= 15 then
    curr_linguistic = {
        f_state = "very low", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif y > 15 and y < 25 then
    curr_linguistic = {
        f_state = "very low", f_score = member_on_down(y, 15, 25),
        s_state = "low", s_score = member_on_up(y, 15, 25)
      }
  elseif y >= 25 and y <= 35 then
    curr_linguistic = {
        f_state = "low", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif y > 35 and y < 45 then
    curr_linguistic = {
        f_state = "low", f_score = member_on_down(y, 35, 45),
        s_state = "average", s_score = member_on_up(y, 35, 45)
      }
  elseif y >= 45 and y <= 55 then
    curr_linguistic = {
        f_state = "average", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif y > 55 and y < 65 then
    curr_linguistic = {
        f_state = "average", f_score = member_on_down(y, 55, 65),
        s_state = "high", s_score = member_on_up(y, 55, 65)
      }
  elseif y >= 65 and y <= 75 then
    curr_linguistic = {
        f_state = "high", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif y > 75 and y < 85 then
    curr_linguistic = {
        f_state = "high", f_score = member_on_down(y, 75, 85),
        s_state = "very high", s_score = member_on_up(y, 75, 85)
      }
  else -- if y >= 85 and y <= 100
    curr_linguistic = {
        f_state = "very high", f_score = 1,
        s_state = nil, s_score = nil
      }
  end
  table.insert(family_process.charge, curr_linguistic)
end

local function rules_analyzing(income_state, income_score, charge_state, charge_score)
  local curr_linscore = nil
  if (income_state == "poor" and charge_state == "very low") then
    curr_linscore = {"consider", minim(income_score, charge_score)}
  elseif (income_state == "poor" and charge_state == "low") then
    curr_linscore = {"accepted", minim(income_score, charge_score)}
  elseif (income_state == "poor" and charge_state == "average") then
    curr_linscore = {"accepted", minim(income_score, charge_score)}
  elseif (income_state == "poor" and charge_state == "high") then
    curr_linscore = {"accepted", minim(income_score, charge_score)}
  elseif (income_state == "poor"  and charge_state == "very high") then
    curr_linscore = {"accepted", minim(income_score, charge_score)}
  elseif (income_state == "medium" and charge_state == "very low") then
    curr_linscore = {"rejected", minim(income_score, charge_score)}
  elseif (income_state == "medium" and charge_state == "low") then
    curr_linscore = {"consider", minim(income_score, charge_score)}
  elseif (income_state == "medium" and charge_state == "average") then
    curr_linscore = {"accepted", minim(income_score, charge_score)}
  elseif (income_state == "medium" and charge_state == "high") then
    curr_linscore = {"accepted", minim(income_score, charge_score)}
  elseif (income_state == "medium" and charge_state == "very high") then
    curr_linscore = {"accepted", minim(income_score, charge_score)}
  elseif (income_state == "rich" and charge_state == "very low") then
    curr_linscore = {"rejected", minim(income_score, charge_score)}
  elseif (income_state == "rich" and charge_state == "low") then
    curr_linscore = {"rejected", minim(income_score, charge_score)}
  elseif (income_state == "rich" and charge_state == "average") then
    curr_linscore = {"rejected", minim(income_score, charge_score)}
  elseif (income_state == "rich" and charge_state == "high") then
    curr_linscore = {"consider", minim(income_score, charge_score)}
  elseif (income_state == "rich" and charge_state == "very high") then
    curr_linscore = {"accepted", minim(income_score, charge_score)}
  end
  return curr_linscore
end

local function find_val(value, an_array, in_number)
  for i=1, in_number do
    if an_array[i][1] == value then
      return an_array[i][2]
    else
      return nil
    end
  end
end

local function inference(tab_income, tab_charge)
  local result = {}
  local fin_result = {
    accepted = {},
    consider = {},
    rejected = {}
  }
  
  for i=1, #tab_income do
    result[1] = rules_analyzing(tab_income[i].f_state, tab_income[i].f_score, tab_charge[i].f_state, tab_charge[i].f_score)
    print(">>>", result[1][1]) -- TODO: Not complete, apply for all
    if (tab_income.s_state == nil and not tab_charge.s_state) then
      result[2] = rules_analyzing(tab_income.f_state, tab_income.f_score, tab_charge.s_state, tab_charge.s_score)
    else
      result[2] = rules_analyzing(tab_income.s_state, tab_income.s_score, tab_charge.s_state, tab_charge.s_score)
    end
    if (tab_charge.s_state == nil and not tab_income.s_state) then
      result[3] = rules_analyzing(tab_income.f_state, tab_income.f_score, tab_charge.f_state, tab_charge.f_score)
    else
      result[3] = rules_analyzing(tab_income.f_state, tab_income.f_score, tab_charge.s_state, tab_charge.s_score)
    end
    if (tab_charge.s_state == nil and tab_income.s_state == nil) then
      result[4] = rules_analyzing(tab_income.f_state, tab_income.f_score, tab_charge.f_state, tab_charge.f_score)
    else
      result[4] = rules_analyzing(tab_income.s_state, tab_income.s_score, tab_charge.f_state, tab_charge.f_score)
    end
  end
  -- eliminate duplicate with the highest score
  for i=1, 4 do
    for j=1, 4 do
      if result[i][1] == result[j][1] then
        if result[i][1] == "accepted" then
          if result[i][2] > result[j][2] then
            fin_result.accepted = result[i][2]
          else
            fin_result.accepted = result[j][2]
          end
        elseif result[i][1] == "consider" then
          if result[i][2] > result[j][2] then
            fin_result.consider = result[i][2]
          else
            fin_result.consider = result[j][2]
          end
        else
          if result[i][2] > result[j][2] then
            fin_result.rejected = result[i][2]
          else
            fin_result.rejected = result[j][2]
          end
        end
      end
    end
  end
  
  if fin_result.accepted == nil then
    fin_result.accepted = find_val("accpeted", result, 4)
  elseif fin_result.consider == nil then
    fin_result.consider = find_val("consider", result, 4)
  elseif fin_result.rejected == nil then
    fin_result.rejected = find_val("rejected", result, 4)
  end
  return fin_result
end

local function defuzzification(acc, con, rej)
  return (acc*100 + con*70 + rej*55)/(acc+con+rej)
end

local function insertion_sort(tab)
  for i=2, #tab do
    local x = tab[i]
    local j = i-1
    while (j > 0) and (tab[j].charge > x.charge) do
      tab[j+1] = tab[j]
      j = j - 1
    end
    tab[j+1] = x
  end
end

local function fuzzy_logic()
  --[[for i=math.random(1, 50), math.random(51, 100) do -- debugging and nothing
    table.insert(family_selected, family_list[i])
  end
  insertion_sort(family_selected)]]
  for _, v in pairs(family_list) do
    linguistic_var_income(v.income)
    linguistic_var_charge(v.charge)
  end
  print "debug"
  for _, v in pairs(family_list) do
    inference(family_process.income, family_process.charge)
  end
  --[[print "-- debug income --"
  for _, v in pairs(family_process.income) do
    print(("Status1: %s Score1: %s Status2: %s Score2: %s"):format(v.f_state, v.f_score, v.s_state, v.s_score))
  end
  print "-- debug charge --"
  for _, v in pairs(family_process.charge) do
    print(("Status1: %s Score1: %s Status2: %s Score2: %s"):format(v.f_state, v.f_score, v.s_state, v.s_score))
  end]]
end

-- main program
math.randomseed(os.time())
parse_CSV(QUEST_PATH)
fuzzy_logic()
table_to_CSV(ANSWER_PATH, family_selected)