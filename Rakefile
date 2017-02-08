require_relative 'lib/list_fetcher'

task default: %w(populate server)

desc 'Populate data file with list info'
task :populate do
  puts '=====> Create yaml data file from awesome list repo...'
  ListFetcher.save_lists_to_data_file
  puts '=====> Finished creating yaml data file'
end

desc 'Run the Middleman server'
task :server do
  sh '#############################'
  sh '# Starting middleman server #'
  sh '#############################'

  sh 'bundle exec middleman'
end

desc 'Publish to GitHub Pages'
task :publish do
  sh '########################################'
  sh '# Pushing the latest changes to master #'
  sh '########################################'

  sh 'git push'

  sh '##############################'
  sh '# Publishing to GitHub Pages #'
  sh '##############################'

  sh 'bundle exec middleman deploy'

  sh '##################################################'
  sh '# Successfully published to https://thelove.fund #'
  sh '##################################################'
end

task s: :server
task p: :populate

