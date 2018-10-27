local family_list = {}
local family_process = {
  income = {},
  charge = {}
}
local family_result = {}
local family_selected = {}

local QUEST_PATH = "DataTugas2.csv"
local ANSWER_PATH = "/home/reydvires/Development/Lua Project/FuzzyLogic/TebakanTugas2.csv"

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
-- @param sep Separator of file
local function table_to_CSV(path, data_table, sep)
  --relative path:/home/reydvires/Development/Lua Project/FuzzyLogic/TebakanTugas2.csv
  --relative path:D:/TelkomUniversity/AI/Tugas_FuzzyLogic/fuzzy-logic/TebakanTugas2.csv
  sep = sep or ','
  local file = assert(io.open(path, "w")) -- w mean write
  file:write("The 20 Selected Family:\n")
  for _, v in ipairs(data_table) do
    file:write(v)
    file:write('\n')
  end
  file:close()
  print("file saved")
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
  return (to_low-x)/(to_low-on_top)
end

-- @param x Calculate number from crisp value
local function linguistic_var_income(x)
  local member = {0.35, 0.75, 1.35, 1.75}
  local curr_linguistic
  if x <= member[1] then
    curr_linguistic = {
        f_state = "poor", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif x > member[1] and x < member[2] then
    curr_linguistic = {
        f_state = "poor", f_score = member_on_down(x, member[1], member[2]),
        s_state = "medium", s_score = member_on_up(x, member[1], member[2])
      }
  elseif x >= member[2] and x <= member[3] then
    curr_linguistic = {
        f_state = "medium", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif x > member[3] and x < member[4] then
    curr_linguistic = {
        f_state = "medium", f_score = member_on_down(x, member[3], member[4]),
        s_state = "rich", s_score = member_on_up(x, member[3], member[4])
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
  local member = {20, 30, 50, 60, 70, 80, 85, 95}
  local curr_linguistic
  if y <= member[1] then
    curr_linguistic = {
        f_state = "very low", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif y > member[1] and y < member[2] then
    curr_linguistic = {
        f_state = "very low", f_score = member_on_down(y, member[1], member[2]),
        s_state = "low", s_score = member_on_up(y, member[1], member[2])
      }
  elseif y >= member[2] and y <= member[3] then
    curr_linguistic = {
        f_state = "low", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif y > member[3] and y < member[4] then
    curr_linguistic = {
        f_state = "low", f_score = member_on_down(y, member[3], member[4]),
        s_state = "average", s_score = member_on_up(y, member[3], member[4])
      }
  elseif y >= member[4] and y <= member[5] then
    curr_linguistic = {
        f_state = "average", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif y > member[5] and y < member[6] then
    curr_linguistic = {
        f_state = "average", f_score = member_on_down(y, member[5], member[6]),
        s_state = "high", s_score = member_on_up(y, member[5], member[6])
      }
  elseif y >= member[6] and y <= member[7] then
    curr_linguistic = {
        f_state = "high", f_score = 1,
        s_state = nil, s_score = nil
      }
  elseif y > member[7] and y < member[8] then
    curr_linguistic = {
        f_state = "high", f_score = member_on_down(y, member[7], member[8]),
        s_state = "very high", s_score = member_on_up(y, member[7], member[8])
      }
  else
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
  local inference_tab = {}
  local result = {}
  local fin_result = {
    accepted = nil,
    consider = nil,
    rejected = nil
  }

  for i=1, #tab_income do
    result[1] = rules_analyzing(tab_income[i].f_state, tab_income[i].f_score, tab_charge[i].f_state, tab_charge[i].f_score)

    if (tab_income[i].s_state == nil and tab_charge[i].s_state ~= nil) then
      result[2] = rules_analyzing(tab_income[i].f_state, tab_income[i].f_score, tab_charge[i].s_state, tab_charge[i].s_score)
    elseif (tab_income[i].s_state ~= nil and tab_charge[i].s_state ~= nil) then
      result[2] = rules_analyzing(tab_income[i].f_state, tab_income[i].f_score, tab_charge[i].s_state, tab_charge[i].s_score)
    else
      result[2] = result[1]
    end

    if (tab_income[i].s_state ~= nil and tab_charge[i].s_state == nil) then
      result[3] = rules_analyzing(tab_income[i].s_state, tab_income[i].s_score, tab_charge[i].f_state, tab_charge[i].f_score)
    elseif (tab_income[i].s_state ~= nil and tab_charge[i].s_state ~= nil) then
      result[3] = rules_analyzing(tab_income[i].s_state, tab_income[i].s_score, tab_charge[i].f_state, tab_charge[i].f_score)
    else
      result[3] = result[1]
    end

    if (tab_income[i].s_state ~= nil and tab_charge[i].s_state ~= nil) then
      result[4] = rules_analyzing(tab_income[i].s_state, tab_income[i].s_score, tab_charge[i].s_state, tab_charge[i].s_score)
    else
      result[4] = result[1]
    end

    print(i .. ")\nStates1", tab_income[i].f_state, tab_income[i].f_score, tab_charge[i].f_state, tab_charge[i].f_score)
    print("States2", tab_income[i].s_state, tab_income[i].s_score, tab_charge[i].s_state, tab_charge[i].s_score)
    print(("Result --> %s: %s"):format(result[1][1], result[1][2]))
    print(("Result --> %s: %s"):format(result[2][1], result[2][2]))
    print(("Result --> %s: %s"):format(result[3][1], result[3][2]))
    print(("Result --> %s: %s\n"):format(result[4][1], result[4][2]))
    table.insert(inference_tab, {
        label = {result[1][1], result[2][1], result[3][1], result[4][1]},
        value = {result[1][2], result[2][2], result[3][2], result[4][2]}
      })
  end

  -- eliminate duplicate with the highest score
  for i, v in ipairs(inference_tab) do -- traversing 100 data
    for j=1, 4 do
      for k=1, 4 do
        if (v.label[j] == "accepted") then -- accepted condition stable
          if (v.label[j] == v.label[k]) and (v.value[j] > v.value[k]) then
            if fin_result.accepted == nil then
              fin_result.accepted = v.value[j]
            elseif v.value[j] > fin_result.accepted then
              fin_result.accepted = v.value[j]
            end
          elseif (v.label[j] == v.label[k]) then
            if fin_result.accepted == nil then
              fin_result.accepted = v.value[k]
            elseif v.value[k] > fin_result.accepted then
              fin_result.accepted = v.value[k]
            end
          end
          --print("accepted",fin_result.accepted)
        elseif (v.label[j] == "consider") then
          if ((v.label[j] == v.label[k])) and (v.value[j] > v.value[k]) then
            if fin_result.consider == nil then
              fin_result.consider = v.value[j]
            elseif v.value[j] > fin_result.consider then
              fin_result.consider = v.value[j]
            end
          elseif (v.label[j] == v.label[k]) then
            if fin_result.consider == nil then
              fin_result.consider = v.value[k]
            elseif v.value[k] > fin_result.consider then
              fin_result.consider = v.value[k]
            end
          end
          --print("consider",fin_result.consider)
        elseif (v.label[j] == "rejected") then
          if ((v.label[j] == v.label[k])) and (v.value[j] > v.value[k]) then
            if fin_result.rejected == nil then
              fin_result.rejected = v.value[j]
            elseif v.value[j] > fin_result.rejected then
              fin_result.rejected = v.value[j]
            end
          elseif (v.label[j] == v.label[k]) then
            if fin_result.rejected == nil then
              fin_result.rejected = v.value[k]
            elseif v.value[k] > fin_result.rejected then
              fin_result.rejected = v.value[k]
            end
          end
          --print("rejected",fin_result.rejected)
        end
      end
    end

    if fin_result.accepted == nil then
      fin_result.accepted = find_val("accepted", inference_tab, 4)
      if fin_result.accepted == nil then
        fin_result.accepted = 0
      end
    end
    if fin_result.consider == nil then
      fin_result.consider = find_val("consider", inference_tab, 4)
      if fin_result.consider == nil then
        fin_result.consider = 0
      end
    end
    if fin_result.rejected == nil then
      fin_result.rejected = find_val("rejected", inference_tab, 4)
      if fin_result.rejected == nil then
        fin_result.rejected = 0
      end
    end
    print((i ..") accepted: %s, consider: %s, rejected: %s"):
      format(fin_result.accepted, fin_result.consider, fin_result.rejected))

    table.insert(family_result, {fin_result.accepted, fin_result.consider, fin_result.rejected})

    -- reset state
    fin_result.accepted = nil
    fin_result.consider = nil
    fin_result.rejected = nil
  end
end

local function defuzzification(acc, con, rej)
  return (acc*100 + con*75 + rej*50)/(acc+con+rej)
end

local function insertion_sort(tab)
  for i=2, #tab do
    local x = tab[i]
    local j = i-1
    while (j > 0) and (tab[j].score < x.score) do
      tab[j+1] = tab[j]
      j = j - 1
    end
    tab[j+1] = x
  end
end

local function label_defuzzification(score)
  if score == 100 then
    return "ACCEPTED"
  elseif score > 50 and score < 100 then
    return "CONSIDER"
  else
    return "REJECTED"
  end
end

local function fuzzy_logic()
  local tab_goal = {}
  for _, v in pairs(family_list) do
    linguistic_var_income(v.income) -- fuzzification
    linguistic_var_charge(v.charge)
  end
  print "end fuzzification"

  inference(family_process.income, family_process.charge) -- inference
  print "end inference"

  for i, v in ipairs(family_result) do -- defuzzification
    table.insert(tab_goal, {
      id = i,
      score = defuzzification(family_result[i][1], family_result[i][2], family_result[i][3])
    })
    print(i, tab_goal[i].score)
    tab_goal[i].label = label_defuzzification(tab_goal[i].score)
  end
  print "end defuzzification"

  insertion_sort(tab_goal)

  for i, v in ipairs(tab_goal) do
    print(i .. ") " .. v.id, v.score, v.label)
  end

  local i=1
  while (#family_selected < 20) do
    table.insert(family_selected, tab_goal[i].id) -- saving data
    i = i + 1
  end
end

-- main program
parse_CSV(QUEST_PATH)
fuzzy_logic()
table_to_CSV(ANSWER_PATH, family_selected)
