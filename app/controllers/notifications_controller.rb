class NotificationsController < ApplicationController
  def notified
    @userprofile = current_user
    # @notifications = Notification.where(
    #   notified_id: current_user.id
    # ).where.not(
    #   notifier_id: current_user.id
    # ).page(params[:page]).per(5)
    
    @notifications = Notification.where(
        notified_id: current_user.id
      ).where.not(
        notifier_id: current_user.id
      ).page(params[:page]).per(10)
  end


  def activity
    @userprofile = current_user
    # MySQL
    # marge_activity_ids = "with marge_microposts as(
    #                           SELECT id, notificable_id, notificable_type, MAX(updated_at) FROM notifications WHERE notificable_type = 'Micropost' GROUP BY notificable_id, notificable_type
    #                           UNION
    #                           SELECT id, notificable_id, notificable_type, updated_at FROM notifications WHERE notificable_type != 'Micropost'
    #                           )
    #                           SELECT id FROM marge_microposts"
    #
    # PostgreSQL
    # marge_activity_ids = "SELECT id FROM (SELECT DISTINCT ON (notificable_id, notificable_type) * FROM notifications WHERE notificable_type = 'Micropost') t1 ORDER BY updated_at DESC
    #                       UNION
    #                       SELECT id FROM notifications WHERE notificable_type != 'Micropost'"
    #
    # math
    marge_activity_ids = "SELECT id FROM notifications WHERE id IN (SELECT MAX(id) FROM notifications WHERE notificable_type = 'Micropost' GROUP BY notificable_id, notificable_type)
                          UNION
                          SELECT id FROM notifications WHERE notificable_type != 'Micropost'"
    @activities = Notification.where(
      "id IN (#{marge_activity_ids})"
    ).where(
      notifier_id: @userprofile.id
    ).where.not(
      notified_id: @userprofile.id
    ).where.not(
      notificable_type: 'Relationship'
    ).page(params[:page]).per(10)
  end
end
