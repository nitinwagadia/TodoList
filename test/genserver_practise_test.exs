defmodule GenserverPractiseTest do
  use ExUnit.Case
  doctest GenserverPractise

  test "greets the world" do
    assert GenserverPractise.hello() == :world
  end
end
