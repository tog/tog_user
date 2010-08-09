module Admin
  module UserHelper
    
    def select_state_tag(user)
      default_state = user.new_record? ? :passive : user.aasm_current_state

      events  = user.aasm_events_for_current_state.collect do |x| 
        [ I18n.t("tog_user.model.states.actions.#{x}"), x ] 
      end

      options = events.insert(0, [ "", '' ])

      select_tag("state_event", options_for_select(options.uniq, default_state))
    end
        
    # Return link to sort column with toggled sort order
    def link_to_sortable_column_header(field, order_by, sort_order, name)
      if order_by == field.to_s
        sort_order = (sort_order || '').upcase == 'DESC' ? 'ASC' : 'DESC'
        arrow = (sort_order == 'ASC') ? 'down' : 'up' 
      else
        sort_order = 'ASC'
        arrow = nil
      end
      new_params = params.merge(:order_by => field.to_s, :sort_order => sort_order)
      html = link_to(name, new_params)
      html << image_tag("/tog_core/images/ico/arrow-#{arrow}.gif") if arrow
      html
    end
  
 
  end
end
