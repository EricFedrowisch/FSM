--Test script for exercising FSM
--Copyright Jun. 27th, 2019 Eric Fedrowisch All rights reserved.

local fsm = require "fsm"

local function line(text)
   if text ~= nil then print(tostring(text)) end
   print("--------------------------------------------")
end

--1st make new FSM
local f = fsm:new()
--Create State object functions for entering, exiting and during a state
---State A
local a_in = function () print("<EnTeR state A>") end
local a_out = function () print("<ExIt state A>") end
local a_dur = function (args) print("<DuRiNg state A>") end
---State B
local b_in = function () print("<EnTeR state B>") end
local b_out = function () print("<ExIt state B>") end
local b_dur = function () print("<DuRiNg state B>") end
--Register the states with the FSM BEFORE registering transitions between states
f:register_state("A", a_in, a_out, a_dur)
f:register_state("B", b_in, b_out, b_dur)
--Register transitions between states
f:register_transition("AtoB", "A", "B")
f:register_transition("BtoA", "B", "A")

line()
line("Enabling FSM")
--FSM must be enabled by giving it a valid initial state
f:enable("A")

--Exercise the FSM with various inputs
line();line("Do Inputs")
local inputs = {"AtoB", "BtoA", "nothing", "BtoA", "AtoB"}
local args = {{"hi"},{"what"},{"you"},{"doing"},{"buddy"}}
for i, v in ipairs(inputs) do
   print("Current State", f.current)
   print("Input", v)
   f:get_input(v)
   print("During")
   f:get_input("tick", args[i])
   print("State After Input", f.current)
   line()
end
