defmodule Participante do
  @moduledoc """
  Modulo que representa a un participante dentro de la hackathon
  """

  defstruct [:id, :nombre, :rol, :id_equipo]

  @type rol :: :developer | :diseñador | :mentor | :organizador

  @type t :: %__MODULE__{
          id: integer(),
          nombre: String.t(),
          rol: rol(),
          id_equipo: integer() | nil
        }

  @roles_validos [:developer, :diseñador, :mentor, :organizador]

  @spec crear(integer(), String.t(), rol()) :: {:ok, t()} | {:error, String.t()}
  def crear(id, nombre, rol) when rol in @roles_validos do
    participante = %__MODULE__{id: id, nombre: nombre, rol: rol, id_equipo: nil}
    {:ok, participante}
  end

  def crear(_, _, rol),
    do: {:error, "Rol invalido: #{inspect(rol)}. Roles validos: #{@roles_validos}"}
    

end
