defmodule Hound do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  @doc false
  def start(_type, options) do
    start(options)
  end


  @doc """
  Starts the Hound server.

      # Start Hound for localhost webdriver server (Selenium assumed at port 4444)
      Hound.start

      # Start Hound for remote webdriver server at port 5555
      Hound.start [host: "http://example.com", port: 5555]
  """
  def start(options \\ []) do
    :application.ensure_all_started(:ibrowse)
    Hound.Supervisor.start_link(options)
  end


  @doc false
  def driver_info do
    Hound.ConnectionServer.driver_info
  end


  @doc """
  Starts a Hound session.

  Use this in your test case's setup block to start a Hound session for each test case.

      defmodule HoundTest do
        use ExUnit.Case
        use Hound.Helpers

        setup do
          Hound.start_session
          :ok
        end

        teardown do
          :ok = Hound.end_session
        end

        test "the truth", meta do
          navigate_to("http://example.com/guestbook.html")

          find_element(:name, "message")
          |> fill_field("Happy Birthday ~!")
          |> submit_element()

          assert page_title() == "Thank you"
        end

      end
  """
  def start_session do
    Hound.SessionServer.session_for_pid(self)
  end


  @doc """
  Ends a Hound session. If you have multiple sessions, all of those sessions are killed.

  For an example, take a look at the documentation for `start_session`.
  """
  def end_session do
    Hound.SessionServer.destroy_sessions_for_pid(self)
  end


  @doc false
  def current_session_id do
    Hound.SessionServer.current_session_id(self)
  end
end
