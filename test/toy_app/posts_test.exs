defmodule ToyApp.PostsTest do
  use ToyApp.DataCase

  alias ToyApp.Posts

  describe "microposts" do
    alias ToyApp.Posts.Micropost

    import ToyApp.PostsFixtures
    import ToyApp.AccountsFixtures

    @invalid_attrs %{content: nil, user_id: nil}

    test "list_microposts/0 returns all microposts" do
      micropost = micropost_fixture()
      assert Posts.list_microposts() == [micropost]
    end

    test "get_micropost!/1 returns the micropost with given id" do
      micropost = micropost_fixture()
      assert Posts.get_micropost!(micropost.id) == micropost
    end

    test "create_micropost/1 with valid data creates a micropost" do
      valid_attrs = %{content: "some content", user_id: 42}

      assert {:ok, %Micropost{} = micropost} = Posts.create_micropost(valid_attrs)
      assert micropost.content == "some content"
      assert micropost.user_id == 42
    end

    test "create_micropost/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_micropost(@invalid_attrs)
    end

    test "create_micropost/1 with content length greater than 280 returns error changeset" do
      long_content = String.duplicate("a", 281)
      invalid_attrs = %{content: long_content, user_id: 42}

      assert {:error, %Ecto.Changeset{}} = Posts.create_micropost(invalid_attrs)
    end

    test "update_micropost/2 with valid data updates the micropost" do
      micropost = micropost_fixture()
      update_attrs = %{content: "some updated content", user_id: 43}

      assert {:ok, %Micropost{} = micropost} = Posts.update_micropost(micropost, update_attrs)
      assert micropost.content == "some updated content"
      assert micropost.user_id == 43
    end

    test "update_micropost/2 with invalid data returns error changeset" do
      micropost = micropost_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_micropost(micropost, @invalid_attrs)
      assert micropost == Posts.get_micropost!(micropost.id)
    end

    test "delete_micropost/1 deletes the micropost" do
      micropost = micropost_fixture()
      assert {:ok, %Micropost{}} = Posts.delete_micropost(micropost)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_micropost!(micropost.id) end
    end

    test "change_micropost/1 returns a micropost changeset" do
      micropost = micropost_fixture()
      assert %Ecto.Changeset{} = Posts.change_micropost(micropost)
    end

    test "a user can have multiple microposts" do
      user = user_fixture()
      micropost1_attrs = %{content: "first post", user_id: user.id}
      micropost2_attrs = %{content: "second post", user_id: user.id}

      {:ok, _micropost1} = Posts.create_micropost(micropost1_attrs)
      {:ok, _micropost2} = Posts.create_micropost(micropost2_attrs)

      user = Repo.preload(user, :microposts)
      assert length(user.microposts) == 2
      assert Enum.any?(user.microposts, fn mp -> mp.content == "first post" end)
      assert Enum.any?(user.microposts, fn mp -> mp.content == "second post" end)
    end

  end
end
