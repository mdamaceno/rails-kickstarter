RAILS_KICKSTART_DIR = __dir__
APP_PATH = ARGV.first

puts "RUBY VERSION: #{`ruby -v`}"

system("rails new #{APP_PATH} -d postgresql --css bootstrap")

Dir.chdir(APP_PATH)

system('bundle add devise bundler-audit brakeman view_component sassc-rails')
system('bundle add rails_best_practices rubocop-rails --group "development"')
system('bundle add rspec-rails --group "test"')
system('bundle add pry-rails --group "development test"')
system('bundle remove jbuilder')

system('bin/rails generate rspec:install')
system('rm -rf test')

system("cp #{RAILS_KICKSTART_DIR}/_config/.rubocop.yml .")
system("cp #{RAILS_KICKSTART_DIR}/_rakes/* lib/tasks")
rakefile = File.open('Rakefile', 'a')
rakefile << """
task default: %i[
  rubocop
  spec
  rails_best_practices
  brakeman:check
  bundle:audit
]
"""
rakefile.close

system('bundle exec rake')

puts "All done!"
