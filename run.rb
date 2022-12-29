RAILS_KICKSTART_DIR = __dir__
APP_PATH = ARGV.first

puts "RUBY VERSION: #{`ruby -v`}"

system("rails new #{APP_PATH} -d postgresql --css bootstrap")

Dir.chdir(APP_PATH)

system("bundle add devise bundler-audit brakeman view_component sassc-rails")
system('bundle add rails_best_practices rubocop-rails license_finder --group "development"')
system('bundle add rspec-rails --group "test"')
system('bundle add pry-rails --group "development test"')
system('bundle remove jbuilder')

system('bin/rails generate rspec:install')
system('rm -rf test')

puts "All done!"
