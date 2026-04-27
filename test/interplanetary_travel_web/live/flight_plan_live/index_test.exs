defmodule InterplanetaryTravelWeb.FlightPlanLive.IndexTest do
  use InterplanetaryTravelWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "handle_event/3 - validate" do
    test "Apollo 11 Mission", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/")

      params = %{
        "mass" => "28801",
        "paths" => %{
          "0" => %{"action" => "launch", "planet" => "earth"},
          "1" => %{"action" => "land", "planet" => "moon"},
          "2" => %{"action" => "launch", "planet" => "moon"},
          "3" => %{"action" => "land", "planet" => "earth"}
        },
        "paths_sort" => ["0", "1", "2", "3"],
        "paths_drop" => [""]
      }

      view
      |> element("#launch_plan-form")
      |> render_change(%{"plan" => params})

      # ✅ Assert from DOM (not assigns)
      assert has_element?(view, "p#equipment-mass", "28801 kg")
      assert has_element?(view, "p#total-fuel-required", "51898 kg")

      # Steps (order-sensitive presence)
      assert has_element?(view, "li", "launch earth")
      assert has_element?(view, "li", "land moon")
      assert has_element?(view, "li", "launch moon")
      assert has_element?(view, "li", "land earth")
    end

    test "Mars Mission", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/")

      params = %{
        "mass" => "14606",
        "paths" => %{
          "0" => %{"action" => "launch", "planet" => "earth"},
          "1" => %{"action" => "land", "planet" => "mars"},
          "2" => %{"action" => "launch", "planet" => "mars"},
          "3" => %{"action" => "land", "planet" => "earth"}
        },
        "paths_sort" => ["0", "1", "2", "3"],
        "paths_drop" => [""]
      }

      view
      |> element("#launch_plan-form")
      |> render_change(%{"plan" => params})

      assert has_element?(view, "li", "launch earth")
      assert has_element?(view, "li", "land mars")
      assert has_element?(view, "li", "launch mars")
      assert has_element?(view, "li", "land earth")

      assert has_element?(view, "p", "14606 kg")
      assert view |> element("p#total-fuel-required") |> render() =~ "33388 kg"

      assert view |> element("li#step-1>span") |> render() =~ "launch earth"
      assert view |> element("li#step-2>span") |> render() =~ "land mars"
      assert view |> element("li#step-3>span") |> render() =~ "launch mars"
      assert view |> element("li#step-4>span") |> render() =~ "land earth"
    end

    test "Passenger Ship Mission", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/")

      params = %{
        "mass" => "75432",
        "paths" => %{
          "0" => %{"action" => "launch", "planet" => "earth"},
          "1" => %{"action" => "land", "planet" => "moon"},
          "2" => %{"action" => "launch", "planet" => "moon"},
          "3" => %{"action" => "land", "planet" => "mars"},
          "4" => %{"action" => "launch", "planet" => "mars"},
          "5" => %{"action" => "land", "planet" => "earth"}
        },
        "paths_sort" => ["0", "1", "2", "3", "4", "5"],
        "paths_drop" => [""]
      }

      view
      |> element("#launch_plan-form")
      |> render_change(%{"plan" => params})

      assert has_element?(view, "p", "75432 kg")
      assert view |> element("p#total-fuel-required") |> render() =~ "212161 kg"

      assert view |> element("li#step-1>span") |> render() =~ "launch earth"
      assert view |> element("li#step-2>span") |> render() =~ "land moon"
      assert view |> element("li#step-3>span") |> render() =~ "launch moon"
      assert view |> element("li#step-4>span") |> render() =~ "land mars"
      assert view |> element("li#step-5>span") |> render() =~ "launch mars"
      assert view |> element("li#step-6>span") |> render() =~ "land earth"
    end
  end
end
