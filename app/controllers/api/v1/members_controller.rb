class Api::V1::MembersController < ApplicationController
    include AuthenticationCheck
  
    before_action :is_user_logged_in
    before_action :set_member, only: [:show, :update, :destroy]
  
    # GET /members
    def index
      @members = Member.all
      render json: @members
    end
  
    # GET /members/:id
    def show
        if @member
            render json: @member, status: 200
        else
            render json: {"No record of member with id #{params[:id]}."}, status: 404
        end
    end
  
    # POST /members
    def create
      @member = Member.new(member_params)
      if @member.save
        render json: @member, status: 201
      else
        render json: { error:
          "Unable to create member: #{@member.errors.full_messages.to_sentence}"},
          status: 400
      end
    end
  
    # PUT /members/:id
    def update
        if @member.update(member_params)
            render json: @member, status: ok
        else
            render json: { error:
            "Cannot update member record: #{@member.errors.full_messages.to_sentence}"},
            status: 400
        end
    end
  
    # DELETE /members/:id
    def destroy
      @member.destroy
      render json: { message: 'Member record successfully deleted.'}, status: 200
    end
  
    private
  
    def member_params
      params.require(:member).permit(:first_name, :last_name)
    end
  
    def set_member
      @member = Member.find(params[:id])
    end
  
end