defmodule ZTD.Tests.Todo.Config do
  use ZTD.Tests.Support.Case
  alias ZTD.Todo.Config


  setup do
    configs = Application.get_env(:ztd, :mode)

    on_exit fn ->
      # Revert to default mode
      set_mode(configs[:default])
    end

    [configs: configs]
  end



  describe "get/0" do
    test "returns application config specified under :mode key", %{configs: configs} do
      assert Config.get == configs
    end
  end



  describe "get/2" do
    @key :env_var
    test "returns the nested config for given key", %{configs: configs} do
      assert Config.get(@key) == configs[@key]
    end


    @key :unknown_key
    test "returns the default value when nothing specified" do
      refute Config.get(@key)
      assert Config.get(@key, :default) == :default
    end
  end



  describe "mode/0" do
    test "returns default mode when not specified", %{configs: configs} do
      set_mode(nil)
      assert Config.mode == configs[:default]
    end


    test "returns the mode when specified" do
      set_mode(:engine)
      assert Config.mode == :engine

      set_mode(:worker)
      assert Config.mode == :worker
    end


    test "raises error for invalid modes" do
      assert_raise(RuntimeError, ~r/unknown application mode/i, fn ->
        set_mode(:invalid_mode)
        Config.mode
      end)
    end
  end



  describe "adapter/0" do
    test "returns the correct adapter when mode is specified", %{configs: configs} do
      set_mode(:engine)
      assert Config.adapter == configs[:adapters][:engine]

      set_mode(:worker)
      assert Config.adapter == configs[:adapters][:worker]
    end


    test "raises error for invalid modes" do
      assert_raise(RuntimeError, fn ->
        set_mode(:invalid_mode)
        Config.adapter
      end)
    end
  end




  # Private Helpers
  # ---------------

  defp set_mode(mode) do
    mode = String.upcase("#{mode}")

    :env_var
    |> Config.get
    |> System.put_env(mode)
  end


end
