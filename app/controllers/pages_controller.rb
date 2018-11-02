class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :set_paper_trail_whodunnit

  def version
    @version = Page.find(params[:id]).versions.find(params[:version_id])
    @page = @version.reify

    respond_to do |format|
      format.html { render :show }
      format.text { render plain: @page.body }
    end
  end

  def versions
    @page = Page.find(params[:id])
    @versions = @page.versions.limit(200)
  end

  def display
    @page = Page.find_by(path: params[:path])

    if @page
      respond_to do |format|
        format.html { render :show }
        format.text { render plain: @page.body }
      end
    else
      redirect_to new_page_path(path: params[:path]),
                  notice: "No page found at '/#{params[:path]}' but you can create one now"
    end
  end

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all
    case params.fetch(:sort, "path")
    when "updated"
      @pages = @pages.order(updated_at: :desc)
    when "created"
      @pages = @pages.order(created_at: :desc)
    else
      @pages = @pages.order(path: :asc)
    end

    @pages = @pages.page params[:page]
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    respond_to do |format|
      format.html { }
      format.text { render plain: @page.body }
    end
  end

  # GET /pages/new
  def new
    @page = Page.new
    @page.path = params[:path] if params[:path]
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html {
          redirect_to helpers.display_page_path(@page),
                      notice: "Page was successfully created."
        }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html {
          redirect_to helpers.display_page_path(@page),
                      notice: "Page was successfully updated."
        }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: "Page was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params[:page][:path].gsub!(/^\//, '')
      params.require(:page).permit(:title, :comment, :path, :body)
    end

    def name
      host_with_port
    end
end
