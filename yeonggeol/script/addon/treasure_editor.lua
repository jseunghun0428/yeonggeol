-- Copy only the stats and skills edited in the desktop tool into save-resident rows.
local T={}
local CODE,TYPE,SKILL=0,216,256
local FIRST_COPY=1000 -- same copy range as engrave.lua
local FIELD={[220]=true,[222]=true,[224]=true,[226]=true,[228]=true,[230]=true,[232]=true,[272]=true}
local EQUIPPED={"\206\228\198\247","\183\192\190\223","\184\168\214\250"}
local SLOT="\215\176\177\184\206\187"
local SKILL_LABEL="\129\120\131\071:"
local OPTIONS={
 {"\185\165\187\247","\130\074\130\112"}, -- 공격
 {"\178\223\194\212\185\165\187\247","\130\117\130\118"}, -- 책략
 {"\183\192\211\249","\132\078\130\083"}, -- 방어
}
local LEGACY_LABELS={"\130\117\130\118 \130\074\130\112","\130\117\130\118\130\074\130\112"}
for _,option in ipairs(OPTIONS) do LEGACY_LABELS[#LEGACY_LABELS+1]=option[2] end
local BASE_LABELS={"\129\073\131\125","\130\067\131\125","\132\119\132\120","\129\071\130\108"}

local function optionNumber(text)
 text=text:gsub("\163\171","+"):gsub("\163\173","-"):gsub("\163\165","%%"):gsub("\161\161"," ")
 text=text:gsub("\163([\176-\185])",function(digit) return tostring(digit:byte()-176) end)
 return text:match("^%s*[+-]%s*%d+%%?%s*$")
end

local function withoutOldOption(line)
 local hasBase=false
 for _,label in ipairs(BASE_LABELS) do
  if line:sub(1,#label)==label and line:sub(#label+1):match("^%s*[+%-\163]") then hasBase=true break end
 end
 for _,label in ipairs(LEGACY_LABELS) do
  local start,finish=line:find(label,1,true)
  if start and optionNumber(line:sub(finish+1)) then
   if start==1 then return "" end
   local before=line:sub(1,start-1)
   if hasBase and (before:match("%s$") or before:sub(-2)=="\161\161") then
    return (before:gsub("\161\161$"," "):gsub("%s+$",""))
   end
  end
 end
 return line
end

function T.description(item,description,skillName)
 if not item or (item[SLOT] or 0)<=0 then return description end
 local lines={}
 local skillLine=skillName and skillName~="" and (SKILL_LABEL.." "..skillName) or nil
 for line in (description.."*"):gmatch("(.-)%*") do
  if line:sub(1,#SKILL_LABEL)==SKILL_LABEL then
   if skillLine and (line==skillLine or (line:sub(1,#skillLine)==skillLine and
      (line:sub(#skillLine+1,#skillLine+1)==" " or line:sub(#skillLine+1,#skillLine+1)=="("))) then
    skillLine=line
   end
  else
   line=withoutOldOption(line)
   if line~="" then lines[#lines+1]=line end
  end
 end
 local index=math.min(1,#lines)+1
 for _,option in ipairs(OPTIONS) do
  local value=item[option[1]] or 0
  if value~=0 then
   table.insert(lines,index,string.format("%s %+d%%",option[2],value))
   index=index+1
  end
 end
 if skillLine then table.insert(lines,index,skillLine) end
 return table.concat(lines,"*")
end

function T.apply(path,items,base,size,count)
 local regular={}
 CC.koTreasureRegular=regular
 local file=io.open(path,"r")
 if not file then return end
 local edits={}
 for line in file:lines() do
  local number,field,history=line:match("^(%d+) (%d+)([ %d]*)%s*$")
  number,field=tonumber(number),tonumber(field)
  if number and number>0 and number<math.min(count,FIRST_COPY) then
   local itemType=Byte.get16(base,number*size+TYPE)
   if field==SKILL and (itemType==4 or itemType==5 or itemType==6) then
    local defaults={}
    for previous in history:gmatch("%d+") do defaults[tonumber(previous)]=true end
    if next(defaults) then regular[number]=defaults end
   elseif FIELD[field] and itemType~=0 then
    edits[number]=edits[number] or {}
    edits[number][field]=Byte.get16(base,number*size+field)
   end
  end
 end
 file:close()

 local changed={}
 -- A legacy save can store a player engraving on the base row itself. An
 -- individual engraving uses a copy row, whose ordinary skill is never migrated.
 for number,defaults in pairs(regular) do
  local start=number*size
  local saved,default=Byte.get16(items,start+SKILL),Byte.get16(base,start+SKILL)
  -- Type 4 weapon treasures use their built-in skill and do not accept engravings.
  if saved~=default and (Byte.get16(base,start+TYPE)==4 or defaults[saved]) then
   Byte.set16(items,start+SKILL,default)
   changed[number]=true
  end
 end
 if not next(edits) then return next(changed) and changed or nil end
 local function copyFields(number,fields)
  local start=number*size
  for field,value in pairs(fields) do
   if Byte.get16(items,start+field)~=value then
    Byte.set16(items,start+field,value)
    changed[number]=true
   end
  end
 end
 for number,fields in pairs(edits) do copyFields(number,fields) end
 for number=FIRST_COPY,count-1 do
  local start=number*size
  local fields=edits[Byte.get16(items,start+CODE)]
  if fields and Byte.get16(items,start+TYPE)~=0 then copyFields(number,fields) end
 end
 return next(changed) and changed or nil
end

function T.refresh(changed)
 if not changed then return end
 for number=1,JY.PersonNum-1 do
  local person=JY.Person[number]
  for _,key in ipairs(EQUIPPED) do
   if changed[person[key]] then
    ReSetAttrib(number,false)
    break
   end
  end
 end
end

return T
