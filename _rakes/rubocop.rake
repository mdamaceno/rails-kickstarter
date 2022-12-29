if Gem::Specification.find_all_by_name('rubocop').present?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = ['--display-cop-names', '--autocorrect']
    t.fail_on_error = false
  end
end
