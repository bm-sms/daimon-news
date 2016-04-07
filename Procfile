web: (vmstat 1 | tee vmstat.log &) && (while true; do echo ps; ps aux; sleep 1; done &) && bundle exec ruby groonga/init.rb && bundle exec puma -C config/puma.rb
