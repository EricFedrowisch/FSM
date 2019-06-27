--Finite State Machine Class.
--FSMs have a set of states that can have transitions between them. Transitions
--are triggered by inputs.
--Copyright Jun. 27th, 2019 Eric Fedrowisch All rights reserved.

local State = require "state"

local FSM = {}

function FSM.new()
   local f = {}
   f.states = {} --Table of States
   f.transitions = {} --Table of state transitions
   f.enabled = false --Whether FSM is fully initialized and ready to go
   f.current = "" --Current state of FSM
   f.tick = "tick" --String input that triggers "during" method of current state
   setmetatable(f, {__index = FSM})
   return f
end

function FSM:register_state(name, enter, exit, during)
   if type(name) ~= "string" then error("State name not string") end
   local s = State.new(self, name, enter, exit, during)
   self.states[name]=s
   self.transitions[name] = {}
end

function FSM:register_transition(input, start_state, end_state)
   if type(input) ~= "string" then error("Transition input name not string") end
   if not self.states[start_state] then error("No such start state " .. start_state) end
   if not self.states[end_state] then error("No such end state " .. end_state) end
   self.transitions[start_state][input]=end_state
end

function FSM:enable(initial_state, args)
   if self.states[initial_state] ~= nil then --If initial state legal...
      self.states[initial_state]:transition(args) --Then transition to that state
      self.current = initial_state
   else
      error("Attempt to enable FSM with invalid state " .. tostring(initial_state))
   end
   self.enabled = true
end

function FSM:get_input(input, args)
   if not self.enabled then error("FSM not enabled.") end
   if input ~= self.tick then
      if self.transitions[self.current] ~= nil then
         if self.transitions[self.current][input] ~= nil then
            self:transition(self.current, self.transitions[self.current][input], args)
         end
      end
   else
      if self.states[self.current] ~= nil then
         if self.states[self.current].during ~= nil then
            self.states[self.current].during(args)
         end
      end
   end
end

function FSM:transition(exit, start, args)
   self.states[exit]:transition()
   self.states[start]:transition()
end

return FSM
