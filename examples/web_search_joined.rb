require 'lib/smoke'
Smoke.configure do |c|
  c[:enable_logging] = true
  c[:cache][:enabled] = true
  c[:cache][:store] = :memory
end
Smoke.yql(:python) do
  select :all
  from "search.web"
  where :query, "python"
  
  path :query, :results, :result
end
Smoke[:python].output


Smoke.yql(:ruby) do
  select :all
  from "search.web"
  where :query, "ruby"
  
  path :query, :results, :result
end

Smoke.join(:ruby, :python)