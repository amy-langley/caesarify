source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem "rspec", "~> 3.8"


gem "panoptes-client", "~> 0.3.8"


gem "dotenv", "~> 2.7"

gem "symbolized", "~> 0.0.1"

gem "pry", "~> 0.12.2", :groups => [:development, :test]

gem "faraday", "~> 0.15.4"

gem "faraday_middleware", "~> 0.13.1"

gem "faraday-panoptes", "~> 0.3.0"
