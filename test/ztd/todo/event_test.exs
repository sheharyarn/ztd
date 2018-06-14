defmodule ZTD.Tests.Todo.Event do
  use ZTD.Tests.Support.Case, async: true
  alias ZTD.Todo.Event



  describe "new/2" do
    test "returns an Event struct for valid args" do
      assert %Event{type: :insert, data: %{}} = Event.new(:insert, %{})
    end


    test "raises error for invalid type" do
      assert_raise(Event.InvalidError, fn ->
        Event.new(:unknown_type, %{})
      end)
    end
  end



  describe "encode!/1" do
    setup do
      [event: Event.new(:insert, %{a: "X", b: "Y"})]
    end

    test "converts Event struct into json", %{event: event} do
      string = Event.encode!(event)

      assert string =~ ~r/"type":"insert"/
      assert string =~ ~r/"a":"X"/
      assert string =~ ~r/"b":"Y"/
    end
  end



  describe "decode!/1" do
    @string "1,2,3"
    test "raises error for invalidly formed json" do
      assert_raise(Event.InvalidError, fn ->
        Event.decode!(@string)
      end)
    end


    @string Event.encode!(%Event{type: :invalid, data: %{id: "123"}})
    test "raises error for invalid event json" do
      assert_raise(Event.InvalidError, fn ->
        Event.decode!(@string)
      end)
    end


    @string Event.encode!(%Event{type: :delete, data: %{id: "123"}})
    test "converts valid event json string back to event" do
      assert %{type: :delete, data: %{id: "123"}} = Event.decode!(@string)
    end
  end

end

