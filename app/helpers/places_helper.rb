module PlacesHelper
  def vote_comment(vote)
    if vote.person == @current_user
      link_to t('.comment'), edit_vote_path(vote), remote: true, class: 'comment-button'
    elsif !vote.comment.blank?
      tag :span, {class: 'vote-comment ui-icon-comment ui-icon', title: vote.comment}, true
    end
  end

  def car_list(owner, votes)
    render partial: 'places/car_list', locals: {owner: owner, votes: votes}
  end

  def tab_active(place, tab)
    active_tab = params[place.id.to_s]
    return " active" if tab.start_with?('info') and !active_tab
    if active_tab and active_tab == tab
      " active"
    else
      ""
    end
  end

  def car_active(place)
    if params[place.id.to_s].try(:start_with?,'car')
      " active"
    else
      ""
    end
  end
end
