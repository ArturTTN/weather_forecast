defmodule AssignmentWeb.WeatherForecastResolver do
  alias AssignmentWeb.ForecastStruct

  @url "http://api.openweathermap.org/data/2.5/onecall"

  # TODO: move to config ENV
  @appid "e17cc902b5ee6565033199bc27a7c43e"

  def forecast(_, %{input: %{latitude: lat, longitude: lon}}, _) do
    {:ok, response} = Tesla.get(@url, query: [lat: lat, lon: lon, appid: @appid])

    @url
    |> Tesla.get(query: [lat: lat, lon: lon, appid: @appid])
    |> prepare_response
  end

  def daily(parent, _, _), do: {:ok, parent[:daily]}

  def temperature(parent, _, _), do: {:ok, parent[:temp]}

  def feels_like(parent, _, _), do: {:ok, parent[:feels_like]}

  def description(parent, _, _), do: {:ok, Enum.at(parent[:weather], 0)}

  defp prepare_response({:ok, response}) do
    with 200 <- response.status,
         {:ok, forecast} <- Jason.decode(response.body, keys: :atoms) do
      daily = %{daily: forecast[:daily]}
      {:ok, Map.merge(forecast[:current], daily)}
    else
      _error -> error_response("bad request")
    end
  end

  defp prepare_response(_), do: error_response("provider not responding")

  defp error_response(msg) do
    {
      :error,
      "provider not responding"
    }
  end
end
