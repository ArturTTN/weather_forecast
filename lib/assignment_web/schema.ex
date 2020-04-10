defmodule AssignmentWeb.Schema do
  use Absinthe.Schema

  import_types(AssignmentWeb.WeatherForecastTypes)

  query do
    import_fields(:weather_forecast_queries)
  end
end
