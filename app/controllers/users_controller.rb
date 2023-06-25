class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :authenticate_admin!, only: %i[new create destroy]
  before_action :authenticate_sender!, only: %i[edit update]
  before_action :authenticate_receiver!, only: %i[index show]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.build_address
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, address_attributes: %i[address_line_one address_line_two
                                                                       city state country
                                                                       pincode mobile_number])
  end

  # Authentication for Admin user
  def authenticate_admin!
    unless current_user && current_user.admin?
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to root_path
    end
  end

  # Authentication for Sender user
  def authenticate_sender!
    unless current_user && current_user.sender?
      flash[:alert] = 'You are not authorized to perform this action as a sender.'
      redirect_to root_path
    end
  end

  # Authentication for Receiver user
  def authenticate_receiver!
    unless current_user && current_user.receiver?
      flash[:alert] = 'You are not authorized to perform this action as a receiver.'
      redirect_to root_path
    end
  end
end
