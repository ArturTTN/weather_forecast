defmodule AssignmentWeb.WeatherForecastTypes do
  use Absinthe.Schema.Notation

  alias AssignmentWeb.WeatherForecastResolver

  @desc """
  WeatherForecast Root Object
  """
  object :weather_forecast do
    field :date, non_null(:integer),
      resolve: fn parent, _, _ ->
        {:ok, Map.get(parent, :dt)}
      end

    field :sunrise, :integer
    field :sunset, :integer
    field :feels_like, :float

    field :weather, :weather_forecast_description do
      resolve(&WeatherForecastResolver.description/3)
    end

    field :temperature, non_null(:float),
      resolve: fn parent, _, _ ->
        {:ok, Map.get(parent, :temp)}
      end

    field :feels_like, :float

    field :daily, list_of(:weather_forecast_daily) do
      resolve(&WeatherForecastResolver.daily/3)
    end
  end

  @desc """
  WeatherForecast Description Object
  """
  object :weather_forecast_description do
    field :main, :string
    field :description, :string
  end

  @desc """
  WeatherForecast Daily Object
  """
  object :weather_forecast_daily do
    field :date, non_null(:integer),
      resolve: fn parent, _, _ ->
        {:ok, Map.get(parent, :dt)}
      end

    field :pressure, :integer
    field :humidity, :integer

    field :temperature, :weather_forecast_temperature do
      resolve(&WeatherForecastResolver.temperature/3)
    end

    field :feels_like, :weather_forecast_fiels_like do
      resolve(&WeatherForecastResolver.feels_like/3)
    end
  end

  @desc """
  WeatherForecast Daily Feels Like Object
  """
  object :weather_forecast_fiels_like do
    field :day, :float
    field :night, :float

    field :evening, non_null(:float),
      resolve: fn parent, _, _ ->
        {:ok, Map.get(parent, :eve)}
      end

    field :morning, non_null(:float),
      resolve: fn parent, _, _ ->
        {:ok, Map.get(parent, :morn)}
      end
  end

  @desc """
  WeatherForecast Daily Temperature Object
  """
  object :weather_forecast_temperature do
    field :day, :float
    field :min, :float
    field :max, :float
    field :night, :float

    field :evening, non_null(:float),
      resolve: fn parent, _, _ ->
        {:ok, Map.get(parent, :eve)}
      end

    field :morning, non_null(:float),
      resolve: fn parent, _, _ ->
        {:ok, Map.get(parent, :morn)}
      end
  end

  object :weather_forecast_queries do
    field :weather_forecast, :weather_forecast do
      arg(:input, non_null(:coordinate_input))
      resolve(&WeatherForecastResolver.forecast/3)
    end
  end

  input_object :coordinate_input do
    field :latitude, non_null(:string)
    field :longitude, non_null(:string)
  end
end
