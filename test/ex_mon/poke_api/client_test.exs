defmodule ExMon.PokeApi.ClientTest do
  use ExUnit.Case
  import Tesla.Mock

  alias ExMon.PokeApi.Client

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  describe "get_pokemon/1" do
    test "when there is a pokemon with the given name, returns the pokemon" do
      body = %{"name" => "charmander", "weight" => 85, "types" => ["fire"]}

      mock(fn %{method: :get, url: @base_url <> "charmander"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      response = Client.get_pokemon("charmander")

      assert response == {:ok, body}
    end

    test "when there isn't a pokemon with the given name, returns the error" do
      mock(fn %{method: :get, url: @base_url <> "charmanderiel"} ->
        %Tesla.Env{status: 404}
      end)

      response = Client.get_pokemon("charmanderiel")

      assert response == {:error, "Pokemon not found!"}
    end

    test "when there is an unexpected error, returns the error" do
      mock(fn %{method: :get, url: @base_url <> "charmander"} ->
        {:error, :timeout}
      end)

      response = Client.get_pokemon("charmander")

      assert response == {:error, :timeout}
    end
  end
end
