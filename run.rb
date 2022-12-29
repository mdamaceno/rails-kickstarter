RAILS_KICKSTART_DIR = __dir__
APP_PATH = ARGV.first

puts "RUBY VERSION: #{`ruby -v`}"

system("rails new #{APP_PATH} -d postgresql --css bootstrap")

Dir.chdir(APP_PATH)

dirname = File.basename(Dir.getwd)

system('bundle add devise bundler-audit brakeman view_component sassc-rails')
system('bundle add rails_best_practices rubocop-rails --group "development"')
system('bundle add rspec-rails --group "test"')
system('bundle add dotenv-rails pry-rails --group "development test"')
system('bundle remove jbuilder')

system('bin/rails generate rspec:install')
system('rm -rf test')

system('rm -f config/database.yml')

system("cp #{RAILS_KICKSTART_DIR}/_envs/env .env")

envfile = File.open(".env", 'a')
envfile << "
DATABASE_NAME=#{dirname}
"
envfile.close

new_application_rb_content = ''
File.readlines("config/application.rb").each do |line|
  if line.include?('Bundler')
    line << "
unless Rails.env.production?
  require \"dotenv/rails\"
  Dotenv::Railtie.load
end
"
  end

  new_application_rb_content << line
end

system('rm -f config/application.rb && touch config/application.rb')
File.write('config/application.rb', new_application_rb_content)

system("cp #{RAILS_KICKSTART_DIR}/_config/database.yml ./config/database.yml")
system("cp #{RAILS_KICKSTART_DIR}/_config/docker-compose.yml .")
system("cp #{RAILS_KICKSTART_DIR}/_config/.rubocop.yml .")
system("cp #{RAILS_KICKSTART_DIR}/_rakes/* lib/tasks")
rakefile = File.open('Rakefile', 'a')
rakefile << "
task default: %i[
  rubocop
  spec
  rails_best_practices
  brakeman:check
  bundle:audit
]
"
rakefile.close

system('rake')

puts "All done!"
