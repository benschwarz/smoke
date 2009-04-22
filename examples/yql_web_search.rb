Smoke.yql(:ruby) do
  select :all
  from "search.web"
  where :query, "ruby"
  
  emit do
    sort :title
    rename :url => :link
    truncate 5
  end
end