class SearchController < ApplicationController
  skip_before_action :authenticate_admin!
  skip_before_action :authenticate_sender!
  skip_before_action :authenticate_receiver!
  
  def index
    @parcels = if params[:tracking_number].present?
                 Parcel.where(tracking_number: params[:tracking_number])
               else
                 []
               end
  end
end
