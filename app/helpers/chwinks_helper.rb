module ChwinksHelper
  def build_activity_logs(actv)
    message = nil 
    action = nil
    modifier = nil
    data = nil
    user = User.where(id: actv[:modifier_id]).first
    user_image =  "<img width='16px' height ='16px' class='user_image' src=#{user.try(:image)}" + " />"
    modifier = actv[:modifier_id].blank? ? "Someone" : user.nickname
    modifier = user_image + modifier
    if actv.association_chain[0]["name"] == "Comment"
      comment = Comment.where(id: actv.association_chain[0]["id"]).first
      chwink = comment.try(:chwink)
      if actv[:action] == "create"
        action = " commented on chiwnk "
      end
      data = "<a href=#{chwink_path(id: chwink.try(:id))}> #{chwink.try(:name)}</a>"
    else
      chwink = Chwink.where(id:  actv.association_chain[0]["id"]).first  
      data = "<a href=#{chwink_path(id: chwink.id)}> #{chwink.name}</a>"
      if actv[:action] == "create"
        action = " added a chwink called "
      elsif actv[:action] == "update"
        modifier = actv[:modifier_id].blank? ? "Someone" : user.nickname
        action = " has updated information"
      end
    end
 
    message = modifier + action + data  
    message.html_safe  
  end
end
