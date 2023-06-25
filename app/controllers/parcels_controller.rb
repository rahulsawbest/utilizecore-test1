class ParcelsController < ApplicationController
  before_action :set_parcel, only: %i[show edit update destroy]
  before_action :load_users_and_service_types, only: %i[new edit]

  # GET /parcels or /parcels.json
  def index
    @parcels = Parcel.all
  end

  # GET /parcels/1 or /parcels/1.json
  def show
  end

  # GET /parcels/new
  def new
    @parcel = Parcel.new
    @parcel.build_sender
    @parcel.build_receiver
  end

  # GET /parcels/1/edit
  def edit
  end

  # POST /parcels or /parcels.json
  def create
    @parcel = Parcel.new(parcel_params)

    respond_to do |format|
      if @parcel.valid? && @parcel.save
        format.html { redirect_to @parcel, notice: 'Parcel was successfully created.' }
        format.json { render :show, status: :created, location: @parcel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parcels/1 or /parcels/1.json
  def update
    respond_to do |format|
      if @parcel.update(parcel_params)
        format.html { redirect_to @parcel, notice: 'Parcel was successfully updated.' }
        format.json { render :show, status: :ok, location: @parcel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parcels/1 or /parcels/1.json
  def destroy
    @parcel.destroy
    respond_to do |format|
      format.html { redirect_to parcels_url, notice: 'Parcel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_parcel
    @parcel = Parcel.find(params[:id])
  end

  # using before action for common code
  def load_users_and_service_types
    @users = User.pluck(:name_with_address, :id)
    @service_types = ServiceType.pluck(:name, :id)
  end

  # Only allow a list of trusted parameters through.
  def parcel_params
    params.require(:parcel).permit(
      :weight, :status, :service_type_id, :payment_mode, :cost, :tracking_number,
      sender_attributes: %i[id name address mobile pincode],
      receiver_attributes: %i[id name address mobile pincode]
    )
  end
end
