class SearchController < ApplicationController
  def index
    @parcels = if params[:tracking_number].present?
                 Parcel.where(tracking_number: params[:tracking_number])
               else
                 []
               end
  end
end
