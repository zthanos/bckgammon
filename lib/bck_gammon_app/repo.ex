defmodule BckGammonApp.Repo do
  use Ecto.Repo,
    otp_app: :bck_gammon_app,
    adapter: Ecto.Adapters.SQLite3
end
