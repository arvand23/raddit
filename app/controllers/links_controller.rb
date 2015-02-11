class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy] #created with the scaffold
  before_filter :authenticate_user!, :except => [:index, :show] #authenticate everything except for index and show
  #authenticate_user! is a helper provided by devise
  #checks if a user is signed in before they hit anything, except for index and show. user does not have to be logged in to hit index and show.
  #user must be logged in to hit everything except index and show.

  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = current_user.links.build #was Link.new - the user_id gets assigned to the link

    #could be the following:
    #@link = Link.new
    #@link.user = current_user
    #but you dont even need to assign the current user here because thats done under create

  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    @link = current_user.links.build(link_params) #was Link.new - the user_id gets assigned to the link #link_params would allow any userID to be passed,, rather than current_user

    #.build is a synonym for .new. same ish.
    #could also be the following:
    #@link = Link.new(link_params)
    #@link.user = current_user  OR  @link.user_id = current_user.id


    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @link = Link.find(params[:id])#?what exactly does this do again?
    @link.upvote_by current_user #?whats this upvote by method? where u get it?-- search by typing "t" on the github page of gem and search for it. its a method that has many synonyms that the gem defined.
    redirect_to :back #redirects user to same page their currently on
  end

  def downvote
    @link = link.find(params[:id])
    @link.downvote_by current_user #?whats this downvote by method? where u get it?
    redirect_to :back
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:title, :url)
    end
end
