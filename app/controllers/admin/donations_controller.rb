# frozen_string_literal: true

module Admin
  class DonationsController < BaseController
    helper_method :donations
    add_breadcrumb 'donations.plural', :admin_talks_path

    before_action :only_supervisor!

    private

    def donations
      @donations ||= search_against(Donation)
                     .includes(:user)
                     .page(params[:page])
                     .order(created_at: :desc)
    end
  end
end
