# frozen_string_literal: true

module Admin
  class VisitRequestsController < ::Admin::BaseController
    helper_method :visit_requests, :event, :visitors_ids, :confirmed_ids, :applied_ids,
                  :pending_ids, :approved_ids

    before_action :only_supervisor!

    def index
      add_breadcrumb 'events.plural', path: :admin_events_path
      add_breadcrumb event, path: edit_admin_event_path(event)
      add_breadcrumb 'visit_requests.plural'
    end

    private

    def event
      @event ||= Event.friendly.find(params[:event_id])
    end

    def visit_requests
      @visit_requests ||= if search?
                            search_against(base_scope).includes(:user, :event)
                          else
                            base_scope.includes(:user, :event).order('users.first_name, users.last_name')
                          end
    end

    def search?
      params[:query].present?
    end

    def base_scope
      event.send(event.live? ? :final_visit_requests : :visit_requests)
    end

    def visitors_ids
      @visitors_ids ||= User::EventAttendeesWithoutRefusedAndCanceled.call(event_id: event.id).ids
    end
  end
end
