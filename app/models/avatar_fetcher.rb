class AvatarFetcher
  attr_reader :user, :errors, :url

  def initialize(user)
    @user = user
    @errors = Array.new
  end

  def run
    return unless user.provider == "google"
    return unless api_key

    perform_request
    parse_response

    !!url
  end

  private

  def perform_request
    @response ||= begin
                    open(api_url).read
                  rescue => e
                    errors << e
                  end
  end

  def parse_response
    @url = JSON.parse(@response)["image"]["url"]
  rescue => e
    errors << e
  end

  def api_url
    "https://www.googleapis.com/plus/v1/people/#{uid}?fields=image&key=#{api_key}"
  end

  def uid
    @user.uid
  end

  def api_key
    ENV["GOOGLE_API_KEY"]
  end
end
