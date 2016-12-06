require "http/client"

module Cristagiri
  # Represent an Html document who can be parsed
  class HTML
    getter :content

    # Initialize an Html object from Html source fetched
    # from the url
    def self.from_url(url : String) : HTML
      response = HTTP::Client.get url
      if response.status_code == 200
        return HTML.new response.body
      else
        raise ArgumentError.new "Host returned #{response.status_code}"
      end
    end

    # Initialize an Html object from content of file
    # designed by the given filepath
    def self.from_file(path : String) : HTML
      return HTML.new File.read(path)
    end

    # Initialize an Html object from Html source
    def initialize(@content : String)
    end
  end
end
