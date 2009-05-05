module UserHelper

  def select_state_tag(user)
    default_state = user.new_record? ? :passive : user.current_state

    events  = user.next_events_for_current_state.collect do |x| 
      [ I18n.t("tog_user.model.states.actions.#{x}"), x ] 
    end

    options = events.insert(0, [ "", '' ])

    select_tag("state_event", options_for_select(options.uniq, default_state))
  end

end