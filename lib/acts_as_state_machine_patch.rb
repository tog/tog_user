module ScottBarron
  module Acts
    module StateMachine
      module InstanceMethods

          def next_events_for_current_state
            events = []
            self.class.read_inheritable_attribute(:transition_table).each_pair do |event, transitions|
              transitions.each do |transition|
                events << event if transition.from == current_state()
              end
            end
            events
          end

       end
    end
  end
end