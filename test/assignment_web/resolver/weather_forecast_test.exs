defmodule AssignmentWeb.NoteResolverTest do
  use AssignmentWeb.ConnCase

  alias AssignmentWeb.AbsintheHelpers

  alias AssignmentWeb.WeatherForecastResolver

  import Mock

  describe "WeatherForecast Resolver" do
    test "coordinateInput/2 returns a forecast", context do
      query = """
      {
        weatherForecast(input: {latitude: "31", longitude: "23"}) {
          date
        }
      }
      """

      with_mock WeatherForecastResolver, [:passthrough],
        forecast: fn _, _, _ ->
          {:ok, %{dt: 1586514439}}
        end do
        res =
          context.conn
          |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "weatherForecast"))

        assert json_response(res, 200)["data"]["weatherForecast"]["date"] == 1586514439
      end
    end
  end
end
