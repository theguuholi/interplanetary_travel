defmodule InterplanetaryTravelWeb.FlightPlanLive.Index do
  use InterplanetaryTravelWeb, :live_view
  alias InterplanetaryTravel.LaunchPlan
  alias InterplanetaryTravel.LaunchPlan.Plan

  @impl true
  def mount(_params, _session, socket) do
    plan = %Plan{mass: 0}
    form = to_form(LaunchPlan.change_plan(plan))
    {:ok, assign_plan(socket, form, plan)}
  end

  @impl true
  def handle_event("validate", %{"plan" => plan_params}, socket) do
    {changeset, plan} = LaunchPlan.validate(socket.assigns.plan, plan_params)
    form = to_form(changeset, action: :validate)
    {:noreply, assign_plan(socket, form, plan)}
  end

  defp assign_plan(socket, form, plan) do
    assign(socket,
      form: form,
      plan: plan
    )
  end
end
