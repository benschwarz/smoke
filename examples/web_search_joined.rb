Smoke.yql(:python) do
  select :all
  from "search.web"
  where :query, "python"
end

Smoke.yql(:python) do
  select :all
  from "search.web"
  where :query, "ruby"
end

Smoke.join(:ruby, :python)