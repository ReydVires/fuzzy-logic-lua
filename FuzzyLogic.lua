-- by Ahmad Arsyel (1301164193)

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
  local family_list = {}
  -- output will saved in family_list table
  for line in io.lines(path) do
    local col1, col2, col3 = line:match("%i*(.-),%s*(.-),%s*(.*)") -- converting
    family_list[#family_list + 1] = {
      family_id = col1,
      income = tonumber(col2),
      charge = tonumber(col3)
    }
  end
  table.remove(family_list, 1) -- remove the title/header
  --[[print("Parsing result:")
  print_famtable(family_list)]]
  return family_list
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
----------

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

-- @param x Calculate number from crisp value of income
local function linguistic_var_income(x, fp) -- membership of income
  local member = {0.4, 0.8, 1.2, 1.6} -- lakukan analisis
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
  table.insert(fp.income, curr_linguistic)
end

-- @param x Calculate number from crisp value of chare
local function linguistic_var_charge(y, fp) -- membership of charge
  local member = {20, 30, 50, 60, 70, 80, 85, 95} -- lakukan analisis
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
  table.insert(fp.charge, curr_linguistic)
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

local function eliminating(label_j, label_k, score_j, score_k, tab)
  if (label_j == label_k) and (score_j > score_k) then
    if tab == nil then
      tab = score_j
    elseif score_j > tab then
      tab = score_j
    end
  elseif (label_j == label_k) then
    if tab == nil then
      tab = score_k
    elseif score_k > tab then
      tab = score_k
    end
  end
  return tab
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

local function convert_nil_to_zero(data, tab)
  if data == nil then
    data = find_val(str, tab, 4)
    if data == nil then
      data = 0
    end
  end
  return data
end

local function inference(tab_income, tab_charge)
  -- output will saved in family_result table
  local inference_tab = {}
  local result = {}
  local fin_result = {
    accepted = nil,
    consider = nil,
    rejected = nil
  }
  local tab_result = {}

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

    --[[print(i .. ")\nStates1", tab_income[i].f_state, tab_income[i].f_score, tab_charge[i].f_state, tab_charge[i].f_score)
    print("States2", tab_income[i].s_state, tab_income[i].s_score, tab_charge[i].s_state, tab_charge[i].s_score)
    print(("Result --> %s: %s"):format(result[1][1], result[1][2]))
    print(("Result --> %s: %s"):format(result[2][1], result[2][2]))
    print(("Result --> %s: %s"):format(result[3][1], result[3][2]))
    print(("Result --> %s: %s\n"):format(result[4][1], result[4][2]))]]
    table.insert(inference_tab, {
        label = {result[1][1], result[2][1], result[3][1], result[4][1]},
        value = {result[1][2], result[2][2], result[3][2], result[4][2]}
      })
  end

  -- eliminate duplicate with the highest score, cross product/combination
  for i, v in ipairs(inference_tab) do -- traversing 100 data
    for j=1, 4 do
      for k=1, 4 do
        if (v.label[j] == "accepted") then
          fin_result.accepted = eliminating(
              v.label[j], v.label[k], v.value[j], v.value[k], fin_result[v.label[j]]
            )
        elseif (v.label[j] == "consider") then
          fin_result.consider = eliminating(
              v.label[j], v.label[k], v.value[j], v.value[k], fin_result[v.label[j]]
            )
        elseif (v.label[j] == "rejected") then
          fin_result.rejected = eliminating(
              v.label[j], v.label[k], v.value[j], v.value[k], fin_result[v.label[j]]
            )
        end
      end
    end
    -- converting nil value into 0 (zero)
    fin_result.accepted = convert_nil_to_zero(fin_result.accepted, inference_tab)
    fin_result.consider = convert_nil_to_zero(fin_result.consider, inference_tab)
    fin_result.rejected = convert_nil_to_zero(fin_result.rejected, inference_tab)

    --[[print((i ..") accepted: %s, consider: %s, rejected: %s"):
      format(fin_result.accepted, fin_result.consider, fin_result.rejected))]]

    table.insert(tab_result, {fin_result.accepted, fin_result.consider, fin_result.rejected})

    -- reset state
    fin_result.accepted = nil
    fin_result.consider = nil
    fin_result.rejected = nil
  end
  return  tab_result
end

local function sugeno_func(acc, con, rej)
  return (acc*100 + con*75 + rej*50)/(acc+con+rej)
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

local function defuzzification(tab)
  local goals = {}
  for i, v in ipairs(tab) do
    table.insert(goals, {
      id = i,
      score = sugeno_func(tab[i][1], tab[i][2], tab[i][3])
    })
    print(i, goals[i].score)
    goals[i].label = label_defuzzification(goals[i].score)
  end
  return goals
end

local function membership(list, fp)
  -- output will saved in family_process table
  for _, v in pairs(list) do
    linguistic_var_income(v.income, fp)
    linguistic_var_charge(v.charge, fp)
  end
end

local function fuzzy_logic(fl)
  local tab_goal = {}
  local family_process = {
    income = {},
    charge = {}
  }
  local family_result = {}
  local family_selected = {}

  membership(fl, family_process) -- fuzzification

  family_result = inference(family_process.income, family_process.charge) -- inference

  tab_goal = defuzzification(family_result) -- defuzzification

  insertion_sort(tab_goal) -- sorting from the highest score

  for i, v in ipairs(tab_goal) do
    print(i .. ") " .. v.id, v.score, v.label)
  end

  local i=1
  while (#family_selected < 20) do -- picking 20 first family of fittest
    table.insert(family_selected, tab_goal[i].id) -- saving data to family_selected
    i = i + 1
  end
  return family_selected
end

-- main program
local families = parse_CSV(QUEST_PATH)
local helped_family = fuzzy_logic(families)
table_to_CSV(ANSWER_PATH, helped_family)
