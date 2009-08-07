Smoke.yql(:python) do
  select :all
  from "search.web"
  where :query, "python"
  
  path :query, :results, :result
end

Smoke.yql(:ruby) do
  select :all
  from "search.web"
  where :query, "ruby"
  
  path :query, :results, :result
end

Smoke.join(:ruby, :python)