module PlacesHelper
  def vote_comment(vote)
    if vote.person == @current_user
      link_to t('.comment'), edit_vote_path(vote), remote: true, class: 'comment-button'
    elsif !vote.comment.blank?
      tag :span, {class: 'vote-comment ui-icon-comment ui-icon', title: vote.comment}, true
    end
  end
end
